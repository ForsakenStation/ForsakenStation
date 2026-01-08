import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:archive/archive.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'debug_service.dart';

/// Service for downloading and managing AndroidRoms JSONL database
///
/// Downloads from: https://github.com/Arley4d/AndroidRoms
/// License: See repository for license information
class RomlistDownloadService {
  static const String _repoUrl =
      'https://github.com/Arley4d/AndroidRoms/archive/refs/heads/main.zip';
  static const String _romlistFolderName = 'romlists';
  static const String _extractedFolderName = 'AndroidRoms-main';

  final _debug = DebugService.instance;

  // Singleton pattern
  static final RomlistDownloadService _instance =
      RomlistDownloadService._internal();
  static RomlistDownloadService get instance => _instance;
  RomlistDownloadService._internal();

  /// Get the directory where romlists are stored
  Future<Directory> getRomlistDirectory() async {
    final appDir = await getApplicationSupportDirectory();
    final romlistDir = Directory(path.join(appDir.path, _romlistFolderName));

    if (!await romlistDir.exists()) {
      await romlistDir.create(recursive: true);
      _debug.info(
        'Created romlist directory: ${romlistDir.path}',
        tag: 'RomlistDownloadService',
      );
    }

    return romlistDir;
  }

  /// Get the path to the extracted JSONL files
  Future<String> getJsonlPath() async {
    final romlistDir = await getRomlistDirectory();
    return path.join(romlistDir.path, _extractedFolderName);
  }

  /// Check if romlists are already downloaded
  Future<bool> isDownloaded() async {
    try {
      final jsonlPath = await getJsonlPath();
      final jsonlDir = Directory(jsonlPath);

      if (!await jsonlDir.exists()) {
        return false;
      }

      // Check if there are any .jsonl files
      final files = await jsonlDir
          .list()
          .where((f) => f.path.endsWith('.jsonl'))
          .toList();
      final hasFiles = files.isNotEmpty;

      _debug.info(
        'Romlist check: ${hasFiles ? "found ${files.length} files" : "no files found"}',
        tag: 'RomlistDownloadService',
      );

      return hasFiles;
    } catch (e) {
      _debug.error(
        'Error checking if romlists are downloaded',
        tag: 'RomlistDownloadService',
        error: e,
      );
      return false;
    }
  }

  /// Download and extract romlists from GitHub
  ///
  /// [onProgress] - Optional callback for download progress (0.0 to 1.0)
  /// Returns true if successful, false otherwise
  Future<bool> downloadAndExtract({
    void Function(double progress, int received, int total)? onProgress,
  }) async {
    try {
      _debug.info(
        'Starting romlist download from $_repoUrl',
        tag: 'RomlistDownloadService',
      );

      // Get download directory
      final romlistDir = await getRomlistDirectory();
      final zipPath = path.join(romlistDir.path, 'AndroidRoms.zip');
      final zipFile = File(zipPath);

      // Delete old data if exists
      if (await zipFile.exists()) {
        await zipFile.delete();
        _debug.info('Deleted old zip file', tag: 'RomlistDownloadService');
      }

      final jsonlDir = Directory(await getJsonlPath());
      if (await jsonlDir.exists()) {
        await jsonlDir.delete(recursive: true);
        _debug.info('Deleted old romlist data', tag: 'RomlistDownloadService');
      }

      // Download the zip file
      final client = http.Client();
      try {
        final request = http.Request('GET', Uri.parse(_repoUrl));
        final response = await client.send(request);

        if (response.statusCode != 200) {
          _debug.error(
            'Failed to download romlists: HTTP ${response.statusCode}',
            tag: 'RomlistDownloadService',
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
          tag: 'RomlistDownloadService',
        );
      } finally {
        client.close();
      }

      // Extract the zip file
      _debug.info('Extracting zip file...', tag: 'RomlistDownloadService');

      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      int extractedCount = 0;
      for (final file in archive) {
        final filename = file.name;

        if (file.isFile) {
          final data = file.content as List<int>;
          final extractPath = path.join(romlistDir.path, filename);
          final extractFile = File(extractPath);

          await extractFile.create(recursive: true);
          await extractFile.writeAsBytes(data);
          extractedCount++;
        } else {
          // Create directory
          final extractPath = path.join(romlistDir.path, filename);
          final extractDir = Directory(extractPath);
          await extractDir.create(recursive: true);
        }
      }

      _debug.info(
        'Extracted $extractedCount files',
        tag: 'RomlistDownloadService',
      );

      // Delete the zip file to save space
      if (await zipFile.exists()) {
        await zipFile.delete();
        _debug.info('Deleted zip file', tag: 'RomlistDownloadService');
      }

      // Verify extraction
      final isDownloaded = await this.isDownloaded();
      if (isDownloaded) {
        _debug.info(
          'Romlist download and extraction completed successfully',
          tag: 'RomlistDownloadService',
        );
        return true;
      } else {
        _debug.error(
          'Extraction completed but no JSONL files found',
          tag: 'RomlistDownloadService',
        );
        return false;
      }
    } catch (e) {
      _debug.error(
        'Error downloading/extracting romlists',
        tag: 'RomlistDownloadService',
        error: e,
      );
      return false;
    }
  }

  /// Delete all downloaded romlists
  Future<bool> deleteRomlists() async {
    try {
      final romlistDir = await getRomlistDirectory();

      if (await romlistDir.exists()) {
        await romlistDir.delete(recursive: true);
        _debug.info('Deleted all romlists', tag: 'RomlistDownloadService');
        return true;
      }

      return false;
    } catch (e) {
      _debug.error(
        'Error deleting romlists',
        tag: 'RomlistDownloadService',
        error: e,
      );
      return false;
    }
  }

  /// Get download size information
  Future<Map<String, dynamic>> getDownloadInfo() async {
    try {
      final jsonlPath = await getJsonlPath();
      final jsonlDir = Directory(jsonlPath);

      if (!await jsonlDir.exists()) {
        return {'isDownloaded': false, 'fileCount': 0, 'totalSize': 0};
      }

      int fileCount = 0;
      int totalSize = 0;

      await for (final entity in jsonlDir.list(recursive: true)) {
        if (entity is File && entity.path.endsWith('.jsonl')) {
          fileCount++;
          final stat = await entity.stat();
          totalSize += stat.size;
        }
      }

      return {
        'isDownloaded': true,
        'fileCount': fileCount,
        'totalSize': totalSize,
        'totalSizeMB': (totalSize / 1024 / 1024).toStringAsFixed(2),
      };
    } catch (e) {
      _debug.error(
        'Error getting download info',
        tag: 'RomlistDownloadService',
        error: e,
      );
      return {'isDownloaded': false, 'fileCount': 0, 'totalSize': 0};
    }
  }

  // Legacy methods for backward compatibility (not implemented)
  Future<bool> isGameListsDownloaded() async => isDownloaded();
  Future<bool> isRomsGenerated() async => false;
  Future<void> downloadGameLists({
    Function(double)? onProgress,
    Function(String)? onStatus,
  }) async {
    onStatus?.call('Downloading...');
    await downloadAndExtract(
      onProgress: (progress, received, total) {
        onProgress?.call(progress);
      },
    );
    onStatus?.call('Completed');
  }
  Future<void> generateFakeRoms({
    Function(String)? onPlatform,
    Function(double)? onProgress,
    Function(String)? onStatus,
  }) async {}
  Future<void> copyGameListsToESDE({Function(String)? onStatus}) async {}
}

// Legacy alias for backward compatibility
typedef RomListDownloadService = RomlistDownloadService;
