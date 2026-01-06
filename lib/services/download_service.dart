import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import '../models/rom.dart';
import 'debug_service.dart';
import 'download_resolver_service.dart';
import 'rom_storage_service.dart';

class DownloadService {
  final String romsBasePath; // Legacy field, kept for compatibility
  final _debug = DebugService.instance;
  final _resolver = DownloadResolverService();
  final _storage = RomStorageService.instance;
  bool _isCancelled = false;

  DownloadService({required this.romsBasePath});

  /// Cancel the current download
  void cancelDownload() {
    _isCancelled = true;
    _debug.info('Download cancellation requested', tag: 'DownloadService');
  }

  Future<String?> downloadRom(
    Rom rom, {
    Function(double progress, int received, int total)? onProgress,
    bool saveForever = false, // New parameter: save to permanent storage
  }) async {
    // Reset cancellation flag
    _isCancelled = false;

    try {
      if (rom.downloadUrl == null || rom.downloadUrl!.isEmpty) {
        _debug.warning(
          'No download URL for ROM: ${rom.displayName}',
          tag: 'DownloadService',
        );
        return null;
      }

      // Use the original filename (which already has correct extension)
      final fileName = rom.fileName;

      // Check if ROM already exists in forever storage
      final existingForever = await _storage.findRomInForeverStorage(
        rom.platform,
        fileName,
      );
      if (existingForever != null) {
        _debug.info(
          'ROM already exists in forever storage: $existingForever',
          tag: 'DownloadService',
        );
        rom.localPath = existingForever;
        return existingForever;
      }

      // Check if ROM already exists in temp storage
      final existingTemp = await _storage.findRomInTempStorage(
        rom.platform,
        fileName,
      );
      if (existingTemp != null && !saveForever) {
        _debug.info(
          'ROM already exists in temp storage: $existingTemp',
          tag: 'DownloadService',
        );
        rom.localPath = existingTemp;
        return existingTemp;
      }

      // Cleanup old temp ROMs for this platform before downloading new one
      if (!saveForever) {
        _debug.info(
          'Cleaning up old temp ROMs for platform: ${rom.platform}',
          tag: 'DownloadService',
        );
        await _storage.cleanupPlatformTempRoms(rom.platform);
      }

      // Determine destination directory
      final Directory destDir;
      if (saveForever) {
        destDir = await _storage.getPlatformForeverDirectory(rom.platform);
      } else {
        destDir = await _storage.getPlatformTempDirectory(rom.platform);
      }

      await destDir.create(recursive: true);

      final filePath = path.join(destDir.path, fileName);

      _debug.info(
        'Downloading ROM: ${rom.displayName}',
        tag: 'DownloadService',
      );
      _debug.debug('URL: ${rom.downloadUrl}', tag: 'DownloadService');
      _debug.debug('Destination: $filePath', tag: 'DownloadService');
      _debug.debug(
        'Save mode: ${saveForever ? 'forever' : 'temp'}',
        tag: 'DownloadService',
      );

      // Resolve URL (handles MediaFire, Google Drive, Dropbox, etc.)
      final resolvedUrl = await _resolver.resolveDownloadUrl(rom.downloadUrl!);

      if (resolvedUrl == null) {
        _debug.error(
          'Failed to resolve download URL for ${rom.displayName}',
          tag: 'DownloadService',
        );
        return null;
      }

      if (resolvedUrl != rom.downloadUrl) {
        _debug.info('Resolved URL: $resolvedUrl', tag: 'DownloadService');
      }

      // Start download with resolved URL
      final request = http.Request('GET', Uri.parse(resolvedUrl));
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

      try {
        await for (var chunk in response.stream) {
          // Check if download was cancelled
          if (_isCancelled) {
            _debug.info('Download cancelled by user', tag: 'DownloadService');
            await sink.close();
            // Delete partial file
            if (await file.exists()) {
              await file.delete();
            }
            return null;
          }

          sink.add(chunk);
          receivedBytes += chunk.length;

          if (totalBytes > 0 && onProgress != null) {
            final progress = receivedBytes / totalBytes;
            onProgress(progress, receivedBytes, totalBytes);
          }
        }
      } catch (e) {
        await sink.close();
        // Delete partial file on error
        if (await file.exists()) {
          await file.delete();
        }
        rethrow;
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
      await _storage.cleanupAllTempRoms();
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
      await _storage.cleanupPlatformTempRoms(platform);
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
