// IO implementation for RomlistDownloadService (desktop/mobile)
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:archive/archive.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'debug_service.dart';

final _debug = DebugService.instance;

const String _repoUrl =
    'https://github.com/ForsakenStation/romList/archive/refs/heads/main.zip';
const String _romlistFolderName = 'romlists';
const String _extractedFolderName = 'romList-main';

/// Get the directory where romlists are stored
Future<Directory> getRomlistDirectory() async {
  final appDir = await getApplicationSupportDirectory();
  final romlistDir = Directory(path.join(appDir.path, _romlistFolderName));

  if (!await romlistDir.exists()) {
    await romlistDir.create(recursive: true);
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

    final files = await jsonlDir
        .list()
        .where((f) => f.path.endsWith('.jsonl'))
        .toList();
    return files.isNotEmpty;
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
Future<bool> downloadAndExtract({
  void Function(double progress, int received, int total)? onProgress,
}) async {
  try {
    _debug.info(
      'Starting romlist download from $_repoUrl',
      tag: 'RomlistDownloadService',
    );

    final romlistDir = await getRomlistDirectory();
    final zipPath = path.join(romlistDir.path, 'romList.zip');
    final zipFile = File(zipPath);

    // Delete old data if exists
    if (await zipFile.exists()) {
      await zipFile.delete();
    }

    final jsonlDir = Directory(await getJsonlPath());
    if (await jsonlDir.exists()) {
      await jsonlDir.delete(recursive: true);
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
    }

    // Verify extraction
    final downloaded = await isDownloaded();
    if (downloaded) {
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
