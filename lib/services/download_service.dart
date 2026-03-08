import 'dart:io';
import 'dart:async';
import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import '../models/rom.dart';
import '../models/emulator_config.dart';
import '../models/download_result.dart';
import 'config_service.dart';
import 'debug_service.dart';
import 'download_resolver_service.dart';
import 'rom_storage_service.dart';

class DownloadService {
  static DownloadService? _instance;

  final String romsBasePath; // Legacy field, kept for compatibility
  final _debug = DebugService.instance;
  final _resolver = DownloadResolverService();
  final _storage = RomStorageService.instance;
  bool _isCancelled = false;

  DownloadService._({required this.romsBasePath});

  /// Get the singleton instance
  static DownloadService get instance {
    if (_instance == null) {
      final romsPath = ConfigService.instance.romsPath;
      _instance = DownloadService._(romsBasePath: romsPath);
    }
    return _instance!;
  }

  /// Initialize the service with custom path (for testing)
  static void initialize({required String romsBasePath}) {
    _instance = DownloadService._(romsBasePath: romsBasePath);
  }

  /// Cancel the current download
  void cancelDownload() {
    _isCancelled = true;
    _debug.info('Download cancellation requested', tag: 'DownloadService');
  }

  /// Download and optionally extract a ROM.
  ///
  /// When [emulatorConfig] is provided and its [acceptZipFiles] is false,
  /// the downloaded zip will be extracted to forever storage and the zip
  /// deleted. The returned path will be the launch file inside the
  /// extracted directory.
  ///
  /// Returns a [DownloadResult] indicating success (with file path) or
  /// failure (with error type so callers can handle auth errors, etc.).
  Future<DownloadResult> downloadRom(
    Rom rom, {
    Function(double progress, int received, int total)? onProgress,
    bool saveForever = false,
    EmulatorConfig? emulatorConfig,
  }) async {
    // Reset cancellation flag
    _isCancelled = false;

    try {
      if (rom.downloadUrl == null || rom.downloadUrl!.isEmpty) {
        _debug.warning(
          'No download URL for ROM: ${rom.displayName}',
          tag: 'DownloadService',
        );
        return DownloadResult.error(
          DownloadErrorType.generic,
          message: 'No download URL',
        );
      }

      final fileName = rom.fileName;
      final isZip = fileName.toLowerCase().endsWith('.zip');
      final needsExtraction =
          isZip && emulatorConfig != null && emulatorConfig.requiresExtraction;

      // If extraction is needed, always use forever storage and check for
      // existing extracted directory first
      if (needsExtraction) {
        final existingExtracted = await _storage
            .findExtractedRomInForeverStorage(rom.platform, fileName);
        if (existingExtracted != null) {
          _debug.info(
            'Extracted ROM already exists: $existingExtracted',
            tag: 'DownloadService',
          );

          // Find the launch file inside the extracted directory
          final launchPath = await _findLaunchFile(
            existingExtracted,
            emulatorConfig.launchFile,
          );
          if (launchPath != null) {
            rom.localPath = launchPath;
            return DownloadResult.ok(launchPath);
          }

          // If launch file not found, return the directory itself
          rom.localPath = existingExtracted;
          return DownloadResult.ok(existingExtracted);
        }
      }

      // Check if ROM already exists in forever storage (non-extracted)
      final existingForever = await _storage.findRomInForeverStorage(
        rom.platform,
        fileName,
      );
      if (existingForever != null && !needsExtraction) {
        _debug.info(
          'ROM already exists in forever storage: $existingForever',
          tag: 'DownloadService',
        );
        rom.localPath = existingForever;
        return DownloadResult.ok(existingForever);
      }

      // Check if ROM already exists in temp storage
      if (!needsExtraction) {
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
          return DownloadResult.ok(existingTemp);
        }
      }

      // For extraction, always save to forever storage
      final effectiveSaveForever = saveForever || needsExtraction;

      // Cleanup old temp ROMs for this platform before downloading new one
      if (!effectiveSaveForever) {
        _debug.info(
          'Cleaning up old temp ROMs for platform: ${rom.platform}',
          tag: 'DownloadService',
        );
        await _storage.cleanupPlatformTempRoms(rom.platform);
      }

      // Determine destination directory
      final Directory destDir;
      if (effectiveSaveForever) {
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
        'Save mode: ${effectiveSaveForever ? 'forever' : 'temp'}'
        '${needsExtraction ? ' (will extract)' : ''}',
        tag: 'DownloadService',
      );

      // Resolve URL (handles MediaFire, Google Drive, Dropbox, etc.)
      final resolvedUrl = await _resolver.resolveDownloadUrl(rom.downloadUrl!);

      if (resolvedUrl == null) {
        _debug.error(
          'Failed to resolve download URL for ${rom.displayName}',
          tag: 'DownloadService',
        );
        return DownloadResult.error(
          DownloadErrorType.notFound,
          message: 'Failed to resolve download URL',
        );
      }

      if (resolvedUrl != rom.downloadUrl) {
        _debug.info('Resolved URL: $resolvedUrl', tag: 'DownloadService');
      }

      // Start download with resolved URL
      final isArchiveOrg = _isArchiveOrgUrl(resolvedUrl);
      final configService = ConfigService.instance;
      final hasArchiveAuth =
          isArchiveOrg && configService.hasArchiveOrgCredentials;

      // For archive.org we handle redirects manually to preserve the
      // Authorization header across cross-host redirects (archive.org
      // redirects to ia*.us.archive.org CDN servers and Dart's HTTP
      // client strips Authorization on host changes).
      final client = http.Client();
      http.StreamedResponse response;
      try {
        response = await _sendWithArchiveAuth(
          client,
          Uri.parse(resolvedUrl),
          hasArchiveAuth,
        );
      } catch (e) {
        client.close();
        rethrow;
      }

      if (response.statusCode != 200) {
        client.close();
        _debug.error(
          'Download failed with status: ${response.statusCode}',
          tag: 'DownloadService',
        );

        // Detect auth errors for archive.org URLs
        if (response.statusCode == 401 && isArchiveOrg) {
          return DownloadResult.error(
            DownloadErrorType.authRequired,
            message: 'Archive.org authentication required',
            httpStatusCode: 401,
          );
        }
        if (response.statusCode == 403) {
          return DownloadResult.error(
            DownloadErrorType.accessDenied,
            message: 'Access denied (HTTP 403)',
            httpStatusCode: 403,
          );
        }
        if (response.statusCode == 404) {
          return DownloadResult.error(
            DownloadErrorType.notFound,
            message: 'File not found (HTTP 404)',
            httpStatusCode: 404,
          );
        }
        return DownloadResult.error(
          DownloadErrorType.generic,
          message: 'HTTP ${response.statusCode}',
          httpStatusCode: response.statusCode,
        );
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
            return DownloadResult.error(
              DownloadErrorType.cancelled,
              message: 'Download cancelled',
            );
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
        client.close();
        // Delete partial file on error
        if (await file.exists()) {
          await file.delete();
        }
        rethrow;
      }

      await sink.close();
      client.close();

      _debug.info('Download completed: $filePath', tag: 'DownloadService');

      // If extraction is needed, extract and delete the zip
      if (needsExtraction) {
        final extractedPath = await _extractZipAndCleanup(
          filePath,
          destDir.path,
          emulatorConfig.launchFile,
        );
        if (extractedPath != null) {
          rom.localPath = extractedPath;
          return DownloadResult.ok(extractedPath);
        }
        // Extraction failed
        _debug.error('Failed to extract ROM zip', tag: 'DownloadService');
        return DownloadResult.error(
          DownloadErrorType.generic,
          message: 'Failed to extract ZIP archive',
        );
      }

      rom.localPath = filePath;
      return DownloadResult.ok(filePath);
    } catch (e) {
      _debug.error(
        'Error downloading ROM ${rom.displayName}',
        tag: 'DownloadService',
        error: e,
      );
      return DownloadResult.error(
        DownloadErrorType.generic,
        message: e.toString(),
      );
    }
  }

  /// Check if a URL belongs to archive.org
  bool _isArchiveOrgUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    final host = uri.host.toLowerCase();
    return host == 'archive.org' || host.endsWith('.archive.org');
  }

  /// Send an HTTP GET request, manually following redirects so that the
  /// Archive.org Authorization header is preserved across cross-host
  /// redirects (e.g. archive.org -> ia804.us.archive.org).
  Future<http.StreamedResponse> _sendWithArchiveAuth(
    http.Client client,
    Uri url,
    bool addAuth,
  ) async {
    const maxRedirects = 10;
    var currentUrl = url;

    for (var i = 0; i <= maxRedirects; i++) {
      final request = http.Request('GET', currentUrl);
      request.followRedirects = false;

      if (addAuth && _isArchiveOrgUrl(currentUrl.toString())) {
        final cs = ConfigService.instance;
        request.headers['Authorization'] =
            'LOW ${cs.archiveOrgAccessKey}:${cs.archiveOrgSecretKey}';
        _debug.debug(
          'Added Archive.org auth header for ${currentUrl.host}',
          tag: 'DownloadService',
        );
      }

      final response = await client.send(request);

      if (response.isRedirect ||
          response.statusCode == 301 ||
          response.statusCode == 302 ||
          response.statusCode == 303 ||
          response.statusCode == 307 ||
          response.statusCode == 308) {
        final location = response.headers['location'];
        if (location == null) return response;

        // Drain the redirect response body
        await response.stream.drain<void>();

        currentUrl = currentUrl.resolve(location);
        _debug.debug(
          'Following redirect to: $currentUrl',
          tag: 'DownloadService',
        );
        continue;
      }

      return response;
    }

    throw Exception('Too many redirects (max $maxRedirects)');
  }

  /// Extract a zip file into a directory named after the zip (without .zip),
  /// delete the zip, and return the path to the launch file.
  Future<String?> _extractZipAndCleanup(
    String zipFilePath,
    String destDirPath,
    String? launchFile,
  ) async {
    try {
      final zipFile = File(zipFilePath);
      final zipName = path.basenameWithoutExtension(zipFilePath);
      final extractDir = Directory(path.join(destDirPath, zipName));

      _debug.info(
        'Extracting zip to: ${extractDir.path}',
        tag: 'DownloadService',
      );

      // Read and decode the zip
      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      // Extract all files
      int extractedCount = 0;
      for (final archiveFile in archive) {
        final filePath = path.join(extractDir.path, archiveFile.name);

        if (archiveFile.isFile) {
          final outFile = File(filePath);
          await outFile.create(recursive: true);
          await outFile.writeAsBytes(archiveFile.content as List<int>);
          extractedCount++;
        } else {
          // Directory entry
          await Directory(filePath).create(recursive: true);
        }
      }

      _debug.info(
        'Extracted $extractedCount files to ${extractDir.path}',
        tag: 'DownloadService',
      );

      // Delete the zip file to save space
      await zipFile.delete();
      _debug.info('Deleted zip file: $zipFilePath', tag: 'DownloadService');

      // Find the launch file inside the extracted directory
      final launchPath = await _findLaunchFile(extractDir.path, launchFile);

      if (launchPath != null) {
        _debug.info('Found launch file: $launchPath', tag: 'DownloadService');
        return launchPath;
      }

      // No specific launch file found, return the directory path
      _debug.warning(
        'No launch file found in extracted directory, '
        'returning directory path',
        tag: 'DownloadService',
      );
      return extractDir.path;
    } catch (e) {
      _debug.error('Error extracting zip', tag: 'DownloadService', error: e);
      return null;
    }
  }

  /// Search recursively for a specific file inside a directory.
  ///
  /// If [launchFileName] is provided, searches for that exact filename.
  /// Returns the full path to the found file, or null.
  Future<String?> _findLaunchFile(
    String directoryPath,
    String? launchFileName,
  ) async {
    if (launchFileName == null || launchFileName.isEmpty) {
      return null;
    }

    try {
      final dir = Directory(directoryPath);
      if (!await dir.exists()) return null;

      final normalizedTarget = launchFileName.toLowerCase();

      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) {
          final name = path.basename(entity.path).toLowerCase();
          if (name == normalizedTarget) {
            return entity.path;
          }
        }
      }
    } catch (e) {
      _debug.error(
        'Error searching for launch file: $launchFileName',
        tag: 'DownloadService',
        error: e,
      );
    }
    return null;
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
