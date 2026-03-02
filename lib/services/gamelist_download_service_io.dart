// IO implementation for GamelistDownloadService (desktop/mobile)
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:archive/archive.dart';
import 'package:path/path.dart' as path;
import 'debug_service.dart';
import 'config_service.dart';

final _debug = DebugService.instance;

const String _repoUrl =
    'https://github.com/ForsakenStation/gamelists/archive/refs/heads/main.zip';
const String _extractedFolderPrefix = 'gamelists-main';

/// Get the gamelist base directory from ConfigService
Future<String> _getGamelistBasePath() async {
  return await ConfigService.instance.gamelistPath;
}

/// Check if gamelists are already downloaded
/// We check if there are any platform subdirectories containing gamelist.xml
Future<bool> isGamelistsDownloaded() async {
  try {
    final gamelistBase = await _getGamelistBasePath();
    final dir = Directory(gamelistBase);

    if (!await dir.exists()) return false;

    int count = 0;
    await for (final entity in dir.list()) {
      if (entity is Directory) {
        final gamelistFile = File(path.join(entity.path, 'gamelist.xml'));
        if (await gamelistFile.exists()) {
          count++;
          if (count >= 1) return true;
        }
      }
    }
    return false;
  } catch (e) {
    _debug.error(
      'Error checking if gamelists are downloaded',
      tag: 'GamelistDownloadService',
      error: e,
    );
    return false;
  }
}

/// Download and extract gamelists from GitHub into the gamelist base path.
///
/// The zip contains `gamelists-main/{platform}/gamelist.xml`.
/// We extract each platform's gamelist.xml directly into
/// `<gamelistBasePath>/{platform}/gamelist.xml`.
Future<bool> downloadAndExtractGamelists({
  void Function(double progress, int received, int total)? onProgress,
}) async {
  try {
    _debug.info(
      'Starting gamelist download from $_repoUrl',
      tag: 'GamelistDownloadService',
    );

    final gamelistBase = await _getGamelistBasePath();
    final gamelistDir = Directory(gamelistBase);
    if (!await gamelistDir.exists()) {
      await gamelistDir.create(recursive: true);
    }

    // Use a temp directory for the zip and extraction
    final tempDir = await Directory.systemTemp.createTemp('gamelists_');
    final zipPath = path.join(tempDir.path, 'gamelists.zip');
    final zipFile = File(zipPath);

    try {
      // Download the zip file
      final client = http.Client();
      try {
        final request = http.Request('GET', Uri.parse(_repoUrl));
        final response = await client.send(request);

        if (response.statusCode != 200) {
          _debug.error(
            'Failed to download gamelists: HTTP ${response.statusCode}',
            tag: 'GamelistDownloadService',
          );
          return false;
        }

        final contentLength = response.contentLength ?? 0;
        int received = 0;

        final sink = zipFile.openWrite();
        await for (final chunk in response.stream) {
          sink.add(chunk);
          received += chunk.length;

          if (onProgress != null && contentLength > 0) {
            onProgress(received / contentLength, received, contentLength);
          }
        }
        await sink.close();

        _debug.info(
          'Downloaded ${(received / 1024 / 1024).toStringAsFixed(2)} MB',
          tag: 'GamelistDownloadService',
        );
      } finally {
        client.close();
      }

      // Extract the zip file
      _debug.info('Extracting gamelists...', tag: 'GamelistDownloadService');

      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      int extractedCount = 0;
      for (final file in archive) {
        if (!file.isFile) continue;

        final filename = file.name;

        // Files in the archive are like:
        // gamelists-main/{platform}/gamelist.xml
        // We strip the prefix and write to gamelistBase/{platform}/gamelist.xml
        String relativePath = filename;
        if (relativePath.startsWith('$_extractedFolderPrefix/')) {
          relativePath = relativePath.substring(
            _extractedFolderPrefix.length + 1,
          );
        }

        // Skip empty relative paths (the root directory entry)
        if (relativePath.isEmpty) continue;

        // Only extract gamelist.xml files (skip README, LICENSE, etc.)
        if (!relativePath.endsWith('gamelist.xml')) continue;

        final data = file.content as List<int>;
        final extractPath = path.join(gamelistBase, relativePath);
        final extractFile = File(extractPath);

        await extractFile.create(recursive: true);
        await extractFile.writeAsBytes(data);
        extractedCount++;
      }

      _debug.info(
        'Extracted $extractedCount gamelist files',
        tag: 'GamelistDownloadService',
      );

      // Verify extraction
      final downloaded = await isGamelistsDownloaded();
      if (downloaded) {
        _debug.info(
          'Gamelist download and extraction completed successfully',
          tag: 'GamelistDownloadService',
        );
        return true;
      } else {
        _debug.error(
          'Extraction completed but no gamelist.xml files found',
          tag: 'GamelistDownloadService',
        );
        return false;
      }
    } finally {
      // Clean up temp directory
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    }
  } catch (e) {
    _debug.error(
      'Error downloading/extracting gamelists',
      tag: 'GamelistDownloadService',
      error: e,
    );
    return false;
  }
}

/// Delete all downloaded gamelists
Future<bool> deleteGamelists() async {
  try {
    final gamelistBase = await _getGamelistBasePath();
    final dir = Directory(gamelistBase);

    if (await dir.exists()) {
      await dir.delete(recursive: true);
      _debug.info('Deleted all gamelists', tag: 'GamelistDownloadService');
      return true;
    }

    return false;
  } catch (e) {
    _debug.error(
      'Error deleting gamelists',
      tag: 'GamelistDownloadService',
      error: e,
    );
    return false;
  }
}

/// Get download info (count of gamelist.xml files, total size)
Future<Map<String, dynamic>> getGamelistDownloadInfo() async {
  try {
    final gamelistBase = await _getGamelistBasePath();
    final dir = Directory(gamelistBase);

    if (!await dir.exists()) {
      return {'isDownloaded': false, 'fileCount': 0, 'totalSize': 0};
    }

    int fileCount = 0;
    int totalSize = 0;

    await for (final entity in dir.list()) {
      if (entity is Directory) {
        final gamelistFile = File(path.join(entity.path, 'gamelist.xml'));
        if (await gamelistFile.exists()) {
          fileCount++;
          final stat = await gamelistFile.stat();
          totalSize += stat.size;
        }
      }
    }

    return {
      'isDownloaded': fileCount > 0,
      'fileCount': fileCount,
      'totalSize': totalSize,
      'totalSizeMB': (totalSize / 1024 / 1024).toStringAsFixed(2),
    };
  } catch (e) {
    _debug.error(
      'Error getting gamelist download info',
      tag: 'GamelistDownloadService',
      error: e,
    );
    return {'isDownloaded': false, 'fileCount': 0, 'totalSize': 0};
  }
}
