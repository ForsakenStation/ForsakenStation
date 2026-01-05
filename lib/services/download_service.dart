import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import '../models/rom.dart';
import 'debug_service.dart';

class DownloadService {
  final String romsBasePath;
  final _debug = DebugService.instance;

  DownloadService({required this.romsBasePath});

  Future<String?> downloadRom(Rom rom, {Function(double)? onProgress}) async {
    try {
      if (rom.downloadUrl == null || rom.downloadUrl!.isEmpty) {
        _debug.warning(
          'No download URL for ROM: ${rom.displayName}',
          tag: 'DownloadService',
        );
        return null;
      }

      // Create temp directory: ROMS_PATH/_temp/PLATFORM/
      final tempDir = Directory(path.join(romsBasePath, '_temp', rom.platform));
      await tempDir.create(recursive: true);

      // Use the original filename (which already has correct extension)
      // This preserves the exact name as it appears in the ROM folder
      final fileName = rom.fileName;
      final filePath = path.join(tempDir.path, fileName);

      // Check if file already exists and skip download
      final existingFile = File(filePath);
      if (await existingFile.exists()) {
        _debug.info(
          'ROM already downloaded: $filePath',
          tag: 'DownloadService',
        );
        rom.localPath = filePath;
        return filePath;
      }

      _debug.info(
        'Downloading ROM: ${rom.displayName}',
        tag: 'DownloadService',
      );
      _debug.debug('URL: ${rom.downloadUrl}', tag: 'DownloadService');
      _debug.debug('Destination: $filePath', tag: 'DownloadService');

      // Start download
      final request = http.Request('GET', Uri.parse(rom.downloadUrl!));
      final response = await request.send();

      if (response.statusCode != 200) {
        _debug.error(
          'Download failed with status: ${response.statusCode}',
          tag: 'DownloadService',
        );
        return null;
      }

      // Get total size for progress
      final totalBytes = response.contentLength ?? 0;
      var receivedBytes = 0;

      // Create file and write chunks
      final file = File(filePath);
      final sink = file.openWrite();

      await for (var chunk in response.stream) {
        sink.add(chunk);
        receivedBytes += chunk.length;

        if (totalBytes > 0 && onProgress != null) {
          final progress = receivedBytes / totalBytes;
          onProgress(progress);
        }
      }

      await sink.close();

      _debug.info('Download completed: $filePath', tag: 'DownloadService');
      rom.localPath = filePath;
      return filePath;
    } catch (e) {
      _debug.error(
        'Error downloading ROM ${rom.displayName}',
        tag: 'DownloadService',
        error: e,
      );
      return null;
    }
  }

  Future<void> deleteTemporaryRom(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        _debug.debug(
          'Deleted temporary ROM: $filePath',
          tag: 'DownloadService',
        );
      }
    } catch (e) {
      _debug.error(
        'Error deleting temporary ROM',
        tag: 'DownloadService',
        error: e,
      );
    }
  }

  Future<void> cleanupAllTemporaryRoms() async {
    try {
      final tempDir = Directory(path.join(romsBasePath, '_temp'));

      if (!await tempDir.exists()) {
        _debug.debug('Temp directory does not exist', tag: 'DownloadService');
        return;
      }

      await tempDir.delete(recursive: true);
      _debug.info('Cleaned up all temporary ROMs', tag: 'DownloadService');
    } catch (e) {
      _debug.error(
        'Error cleaning up temporary ROMs',
        tag: 'DownloadService',
        error: e,
      );
    }
  }

  Future<void> cleanupPlatformTemporaryRoms(String platform) async {
    try {
      final platformTempDir = Directory(
        path.join(romsBasePath, '_temp', platform),
      );

      if (!await platformTempDir.exists()) {
        _debug.debug(
          'Platform temp directory does not exist: $platform',
          tag: 'DownloadService',
        );
        return;
      }

      await platformTempDir.delete(recursive: true);
      _debug.info(
        'Cleaned up temporary ROMs for platform: $platform',
        tag: 'DownloadService',
      );
    } catch (e) {
      _debug.error(
        'Error cleaning up temporary ROMs for $platform',
        tag: 'DownloadService',
        error: e,
      );
    }
  }
}
