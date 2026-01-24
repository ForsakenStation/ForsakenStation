import 'dart:async';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';

import 'package:forsaken/models/bios_download_mapping.dart';

/// Enhanced logging utility for BIOS download operations
class BiosDownloadLogger {
  static void logInfo(String message) {
    debugPrint('[BIOS_DOWNLOAD] INFO: $message');
  }

  static void logWarning(String message) {
    debugPrint('[BIOS_DOWNLOAD] WARNING: $message');
  }

  static void logError(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    debugPrint('[BIOS_DOWNLOAD] ERROR: $message');
    if (error != null) {
      debugPrint('[BIOS_DOWNLOAD] ERROR_DETAILS: $error');
    }
    if (stackTrace != null && kDebugMode) {
      debugPrint('[BIOS_DOWNLOAD] STACK_TRACE: $stackTrace');
    }
  }

  static void logDownloadStart(
    String filename,
    String url,
    String destination,
  ) {
    logInfo('Starting download of "$filename"');
    logInfo('  Source URL: $url');
    logInfo('  Destination: $destination');
  }

  static void logDownloadSuccess(
    String filename,
    int bytes,
    int? totalBytes,
    Duration elapsed,
  ) {
    final sizeInfo = totalBytes != null
        ? '${_formatBytes(bytes)}/${_formatBytes(totalBytes)}'
        : _formatBytes(bytes);
    logInfo(
      'Successfully downloaded "$filename" ($sizeInfo) in ${elapsed.inMilliseconds}ms',
    );
  }

  static void logDownloadError(
    String filename,
    String url,
    int attempt,
    int maxRetries,
    Object error,
  ) {
    logError(
      'Download failed for "$filename" (attempt $attempt/$maxRetries)',
      error: error,
    );
    logError('  Failed URL: $url');
    if (error is SocketException) {
      logError('  Network error: ${error.message} (${error.osError})');
    } else if (error is HttpException) {
      logError('  HTTP error: ${error.message}');
    } else if (error is TimeoutException) {
      logError('  Timeout error after ${error.duration}');
    }
  }

  static void logBatchStart(String platformId, int fileCount) {
    logInfo(
      'Starting batch download for platform "$platformId" ($fileCount files)',
    );
  }

  static void logBatchComplete(
    String platformId,
    int successful,
    int total,
    Duration elapsed,
  ) {
    logInfo(
      'Completed batch download for "$platformId": $successful/$total files in ${elapsed.inSeconds}s',
    );
    if (successful < total) {
      logWarning('Some files failed to download for platform "$platformId"');
    }
  }

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}

/// Represents the download progress for a single file
class DownloadProgress {
  final String filename;
  final int bytesDownloaded;
  final int? totalBytes;
  final DownloadStatus status;
  final String? errorMessage;

  DownloadProgress({
    required this.filename,
    required this.bytesDownloaded,
    this.totalBytes,
    required this.status,
    this.errorMessage,
  });

  double get progress {
    if (totalBytes == null || totalBytes == 0) return 0.0;
    return bytesDownloaded / totalBytes!;
  }

  String get progressText {
    if (totalBytes == null) return _formatBytes(bytesDownloaded);
    return '${_formatBytes(bytesDownloaded)} / ${_formatBytes(totalBytes!)}';
  }

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  DownloadProgress copyWith({
    int? bytesDownloaded,
    int? totalBytes,
    DownloadStatus? status,
    String? errorMessage,
  }) {
    return DownloadProgress(
      filename: filename,
      bytesDownloaded: bytesDownloaded ?? this.bytesDownloaded,
      totalBytes: totalBytes ?? this.totalBytes,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

enum DownloadStatus {
  pending,
  downloading,
  verifying,
  completed,
  failed,
  cancelled,
}

/// Represents the overall batch download progress
class BatchDownloadProgress {
  final int currentFileIndex;
  final int totalFiles;
  final List<DownloadProgress> fileProgresses;
  final BatchDownloadStatus status;
  final String? errorMessage;

  BatchDownloadProgress({
    required this.currentFileIndex,
    required this.totalFiles,
    required this.fileProgresses,
    required this.status,
    this.errorMessage,
  });

  double get overallProgress {
    if (totalFiles == 0) return 0.0;

    double totalProgress = 0.0;
    for (final progress in fileProgresses) {
      switch (progress.status) {
        case DownloadStatus.completed:
          totalProgress += 1.0;
          break;
        case DownloadStatus.downloading:
        case DownloadStatus.verifying:
          totalProgress += progress.progress;
          break;
        default:
          // pending, failed, cancelled don't contribute to progress
          break;
      }
    }
    return totalProgress / totalFiles;
  }

  int get completedFiles =>
      fileProgresses.where((p) => p.status == DownloadStatus.completed).length;
  int get failedFiles =>
      fileProgresses.where((p) => p.status == DownloadStatus.failed).length;
}

enum BatchDownloadStatus { pending, downloading, completed, failed, cancelled }

/// Service for downloading BIOS files from retroarch_system repository
class BiosDownloadService {
  static const int _maxRetries = 3;
  static const Duration _timeout = Duration(seconds: 30);

  final http.Client _client = http.Client();
  bool _isDisposed = false;

  /// Cancellation tokens for active downloads
  final Map<String, bool> _cancellationTokens = {};

  void dispose() {
    _isDisposed = true;
    _client.close();
    _cancellationTokens.clear();
  }

  /// Downloads a single BIOS file to the specified directory
  Future<bool> downloadFile({
    required DownloadableBiosFile file,
    required String repoFolder,
    required String destinationPath,
    void Function(DownloadProgress)? onProgress,
    String? cancellationToken,
  }) async {
    if (_isDisposed) throw StateError('Service has been disposed');

    final url = file.getDownloadUrl(repoFolder);
    final filename = file.filename;
    final fullPath = path.join(destinationPath, filename);
    final startTime = DateTime.now();

    BiosDownloadLogger.logDownloadStart(filename, url, fullPath);

    // Create destination directory if it doesn't exist
    try {
      final dir = Directory(destinationPath);
      if (!await dir.exists()) {
        BiosDownloadLogger.logInfo('Creating directory: $destinationPath');
        await dir.create(recursive: true);
      }
    } on PathAccessException catch (e) {
      BiosDownloadLogger.logError(
        'Failed to create directory "$destinationPath"',
        error: e,
      );
      onProgress?.call(
        DownloadProgress(
          filename: filename,
          bytesDownloaded: 0,
          status: DownloadStatus.failed,
          errorMessage: 'Cannot create directory: ${e.message}',
        ),
      );
      return false;
    } catch (e) {
      BiosDownloadLogger.logError(
        'Unexpected error creating directory "$destinationPath"',
        error: e,
      );
      onProgress?.call(
        DownloadProgress(
          filename: filename,
          bytesDownloaded: 0,
          status: DownloadStatus.failed,
          errorMessage: 'Cannot create directory: $e',
        ),
      );
      return false;
    }

    // Check if file already exists and has correct checksum
    final existingFile = File(fullPath);
    if (await existingFile.exists() && file.expectedMd5 != null) {
      BiosDownloadLogger.logInfo(
        'Checking existing file checksum for "$filename"',
      );
      try {
        final existingChecksum = await _calculateMd5(existingFile);
        if (existingChecksum.toLowerCase() == file.expectedMd5!.toLowerCase()) {
          final fileSize = await existingFile.length();
          onProgress?.call(
            DownloadProgress(
              filename: filename,
              bytesDownloaded: fileSize,
              totalBytes: fileSize,
              status: DownloadStatus.completed,
            ),
          );
          BiosDownloadLogger.logInfo(
            'File "$filename" already exists with correct checksum ($existingChecksum)',
          );
          return true;
        } else {
          BiosDownloadLogger.logWarning(
            'File "$filename" exists but has wrong checksum (expected: ${file.expectedMd5}, got: $existingChecksum)',
          );
        }
      } catch (e) {
        BiosDownloadLogger.logError(
          'Could not verify existing file "$filename"',
          error: e,
        );
      }
    } else if (await existingFile.exists()) {
      BiosDownloadLogger.logInfo(
        'File "$filename" exists but no checksum available for verification',
      );
    }

    int attempt = 0;
    while (attempt < _maxRetries) {
      if (_isCancelled(cancellationToken)) {
        BiosDownloadLogger.logWarning('Download cancelled for "$filename"');
        onProgress?.call(
          DownloadProgress(
            filename: filename,
            bytesDownloaded: 0,
            status: DownloadStatus.cancelled,
          ),
        );
        return false;
      }

      try {
        BiosDownloadLogger.logInfo(
          'Download attempt ${attempt + 1}/$_maxRetries for "$filename"',
        );

        final success = await _downloadFileAttempt(
          url: url,
          filename: filename,
          fullPath: fullPath,
          expectedMd5: file.expectedMd5,
          expectedSize: file.expectedSize,
          onProgress: onProgress,
          cancellationToken: cancellationToken,
        );

        if (success) {
          final elapsed = DateTime.now().difference(startTime);
          final fileSize = await File(fullPath).length();
          BiosDownloadLogger.logDownloadSuccess(
            filename,
            fileSize,
            file.expectedSize,
            elapsed,
          );

          // Handle ZIP extraction if required
          if (file.requiresExtraction && file.extractedFiles != null) {
            BiosDownloadLogger.logInfo('Starting extraction of "$filename"');
            try {
              final extractionSuccess = await _extractArchive(
                archivePath: fullPath,
                destinationPath: destinationPath,
                extractedFiles: file.extractedFiles!,
                extractionPath: file.extractionPath,
                onProgress: onProgress,
                filename: filename,
              );

              if (!extractionSuccess) {
                BiosDownloadLogger.logError('Failed to extract "$filename"');
                onProgress?.call(
                  DownloadProgress(
                    filename: filename,
                    bytesDownloaded: 0,
                    status: DownloadStatus.failed,
                    errorMessage: 'Archive extraction failed',
                  ),
                );
                // Clean up downloaded archive on extraction failure
                try {
                  await File(fullPath).delete();
                } catch (_) {}
                return false;
              }

              BiosDownloadLogger.logInfo(
                'Successfully extracted and kept archive "$filename"',
              );
            } catch (e) {
              BiosDownloadLogger.logError(
                'Error during extraction of "$filename"',
                error: e,
              );
              onProgress?.call(
                DownloadProgress(
                  filename: filename,
                  bytesDownloaded: 0,
                  status: DownloadStatus.failed,
                  errorMessage: 'Extraction error: $e',
                ),
              );
              return false;
            }
          }

          return true;
        }
      } catch (e) {
        BiosDownloadLogger.logDownloadError(
          filename,
          url,
          attempt + 1,
          _maxRetries,
          e,
        );

        // Provide detailed error message based on error type
        String detailedError = e.toString();
        if (e is SocketException) {
          detailedError = 'Network connection failed: ${e.message}';
        } else if (e is HttpException) {
          detailedError = 'HTTP request failed: ${e.message}';
        } else if (e is TimeoutException) {
          detailedError = 'Request timed out after ${e.duration}';
        } else if (e.toString().contains('Size mismatch')) {
          detailedError = 'Downloaded file size doesn\'t match expected size';
        } else if (e.toString().contains('MD5 mismatch')) {
          detailedError = 'Downloaded file checksum verification failed';
        }

        onProgress?.call(
          DownloadProgress(
            filename: filename,
            bytesDownloaded: 0,
            status: DownloadStatus.failed,
            errorMessage: 'Attempt ${attempt + 1}: $detailedError',
          ),
        );
      }

      attempt++;
      if (attempt < _maxRetries) {
        final waitTime = attempt * 2;
        BiosDownloadLogger.logInfo(
          'Waiting ${waitTime}s before retry for "$filename"',
        );
        await Future.delayed(Duration(seconds: waitTime));
      }
    }

    final elapsed = DateTime.now().difference(startTime);
    BiosDownloadLogger.logError(
      'Download permanently failed for "$filename" after $_maxRetries attempts (${elapsed.inSeconds}s)',
    );
    onProgress?.call(
      DownloadProgress(
        filename: filename,
        bytesDownloaded: 0,
        status: DownloadStatus.failed,
        errorMessage: 'Failed after $_maxRetries attempts',
      ),
    );
    return false;
  }

  /// Downloads all missing BIOS files for a specific platform
  Future<bool> downloadPlatformBios({
    required String platformId,
    required List<String> missingFiles,
    required String destinationPath,
    void Function(DownloadProgress)? onProgress,
    String? cancellationToken,
  }) async {
    final mapping = BiosDownloadMapping.getMapping(platformId);
    if (mapping == null || !mapping.available) {
      BiosDownloadLogger.logError(
        'No download mapping available for platform: $platformId',
      );
      return false;
    }

    final startTime = DateTime.now();
    BiosDownloadLogger.logBatchStart(platformId, missingFiles.length);

    bool allSuccessful = true;
    int successCount = 0;

    for (final filename in missingFiles) {
      if (_isCancelled(cancellationToken)) {
        BiosDownloadLogger.logWarning(
          'Batch download cancelled for platform "$platformId"',
        );
        break;
      }

      final file = mapping.getFile(filename);
      if (file == null) {
        BiosDownloadLogger.logWarning(
          'File "$filename" not found in mapping for platform "$platformId"',
        );
        allSuccessful = false;
        continue;
      }

      BiosDownloadLogger.logInfo(
        'Downloading file ${successCount + 1}/${missingFiles.length}: "$filename"',
      );

      final success = await downloadFile(
        file: file,
        repoFolder: mapping.repoFolder,
        destinationPath: destinationPath,
        onProgress: onProgress,
        cancellationToken: cancellationToken,
      );

      if (success) {
        successCount++;
      } else {
        allSuccessful = false;
      }
    }

    final elapsed = DateTime.now().difference(startTime);
    BiosDownloadLogger.logBatchComplete(
      platformId,
      successCount,
      missingFiles.length,
      elapsed,
    );

    return allSuccessful;
  }

  /// Downloads all missing BIOS files for multiple platforms
  Future<bool> downloadAllMissingBios({
    required Map<String, List<String>> missingByPlatform,
    required Map<String, String> destinationPaths,
    void Function(BatchDownloadProgress)? onProgress,
    String? cancellationToken,
  }) async {
    // Prepare file list
    final allDownloads = <_DownloadTask>[];
    for (final entry in missingByPlatform.entries) {
      final platformId = entry.key;
      final missingFiles = entry.value;
      final destinationPath = destinationPaths[platformId];

      if (destinationPath == null) continue;

      final mapping = BiosDownloadMapping.getMapping(platformId);
      if (mapping == null || !mapping.available) continue;

      for (final filename in missingFiles) {
        final file = mapping.getFile(filename);
        if (file != null) {
          allDownloads.add(
            _DownloadTask(
              file: file,
              repoFolder: mapping.repoFolder,
              destinationPath: destinationPath,
              platformId: platformId,
            ),
          );
        }
      }
    }

    if (allDownloads.isEmpty) return true;

    // Initialize progress tracking
    final fileProgresses = allDownloads
        .map(
          (task) => DownloadProgress(
            filename: task.file.filename,
            bytesDownloaded: 0,
            status: DownloadStatus.pending,
          ),
        )
        .toList();

    void updateProgress() {
      onProgress?.call(
        BatchDownloadProgress(
          currentFileIndex: fileProgresses.indexWhere(
            (p) =>
                p.status == DownloadStatus.downloading ||
                p.status == DownloadStatus.verifying,
          ),
          totalFiles: allDownloads.length,
          fileProgresses: List.from(fileProgresses),
          status: BatchDownloadStatus.downloading,
        ),
      );
    }

    // Download files sequentially to avoid overwhelming the server
    bool allSuccessful = true;
    for (int i = 0; i < allDownloads.length; i++) {
      if (_isCancelled(cancellationToken)) {
        onProgress?.call(
          BatchDownloadProgress(
            currentFileIndex: i,
            totalFiles: allDownloads.length,
            fileProgresses: List.from(fileProgresses),
            status: BatchDownloadStatus.cancelled,
          ),
        );
        return false;
      }

      final task = allDownloads[i];
      final success = await downloadFile(
        file: task.file,
        repoFolder: task.repoFolder,
        destinationPath: task.destinationPath,
        onProgress: (progress) {
          fileProgresses[i] = progress;
          updateProgress();
        },
        cancellationToken: cancellationToken,
      );

      if (!success) {
        allSuccessful = false;
      }
    }

    final finalStatus = _isCancelled(cancellationToken)
        ? BatchDownloadStatus.cancelled
        : (allSuccessful
              ? BatchDownloadStatus.completed
              : BatchDownloadStatus.failed);

    onProgress?.call(
      BatchDownloadProgress(
        currentFileIndex: allDownloads.length,
        totalFiles: allDownloads.length,
        fileProgresses: List.from(fileProgresses),
        status: finalStatus,
      ),
    );

    return allSuccessful;
  }

  /// Creates a cancellation token for download operations
  String createCancellationToken() {
    final token = DateTime.now().millisecondsSinceEpoch.toString();
    _cancellationTokens[token] = false;
    return token;
  }

  /// Cancels downloads associated with the given token
  void cancelDownloads(String token) {
    _cancellationTokens[token] = true;
  }

  bool _isCancelled(String? token) {
    if (token == null) return false;
    return _cancellationTokens[token] ?? false;
  }

  Future<bool> _downloadFileAttempt({
    required String url,
    required String filename,
    required String fullPath,
    String? expectedMd5,
    int? expectedSize,
    void Function(DownloadProgress)? onProgress,
    String? cancellationToken,
  }) async {
    late http.StreamedResponse response;

    try {
      final request = http.Request('GET', Uri.parse(url));
      request.headers['User-Agent'] = 'Forsaken-Emulator-BIOS-Downloader/1.0';

      BiosDownloadLogger.logInfo('Sending HTTP request to: $url');
      response = await _client.send(request).timeout(_timeout);

      BiosDownloadLogger.logInfo(
        'HTTP response: ${response.statusCode} ${response.reasonPhrase}',
      );

      if (response.statusCode != 200) {
        String errorDetails =
            'HTTP ${response.statusCode}: ${response.reasonPhrase}';

        // Add specific error details for common HTTP status codes
        switch (response.statusCode) {
          case 404:
            errorDetails += ' (File not found on server)';
            break;
          case 403:
            errorDetails += ' (Access forbidden)';
            break;
          case 500:
            errorDetails += ' (Server error)';
            break;
          case 502:
            errorDetails += ' (Bad gateway)';
            break;
          case 503:
            errorDetails += ' (Service unavailable)';
            break;
          case 429:
            errorDetails += ' (Too many requests)';
            break;
        }

        throw HttpException(errorDetails);
      }
    } on TimeoutException catch (e) {
      throw TimeoutException(
        'Request timed out after ${e.duration}',
        e.duration,
      );
    } on SocketException catch (e) {
      throw SocketException('Network connection failed: ${e.message}');
    }

    final contentLength = response.contentLength;
    if (contentLength != null) {
      BiosDownloadLogger.logInfo(
        'Content-Length: ${BiosDownloadLogger._formatBytes(contentLength)}',
      );
    }

    final file = File(fullPath);
    final sink = file.openWrite();

    int bytesDownloaded = 0;

    try {
      await for (final chunk in response.stream) {
        if (_isCancelled(cancellationToken)) {
          throw Exception('Download cancelled by user');
        }

        sink.add(chunk);
        bytesDownloaded += chunk.length;

        onProgress?.call(
          DownloadProgress(
            filename: filename,
            bytesDownloaded: bytesDownloaded,
            totalBytes: contentLength,
            status: DownloadStatus.downloading,
          ),
        );
      }

      await sink.close();

      // Verify file size if expected
      if (expectedSize != null) {
        final actualSize = await file.length();
        if (actualSize != expectedSize) {
          await file.delete();
          throw Exception(
            'Size mismatch: expected ${BiosDownloadLogger._formatBytes(expectedSize)}, got ${BiosDownloadLogger._formatBytes(actualSize)}',
          );
        }
        BiosDownloadLogger.logInfo(
          'File size verification passed: ${BiosDownloadLogger._formatBytes(actualSize)}',
        );
      }

      // Verify MD5 checksum if expected
      if (expectedMd5 != null) {
        BiosDownloadLogger.logInfo('Verifying MD5 checksum for "$filename"');
        onProgress?.call(
          DownloadProgress(
            filename: filename,
            bytesDownloaded: bytesDownloaded,
            totalBytes: contentLength,
            status: DownloadStatus.verifying,
          ),
        );

        final actualMd5 = await _calculateMd5(file);
        if (actualMd5.toLowerCase() != expectedMd5.toLowerCase()) {
          await file.delete();
          throw Exception(
            'MD5 checksum mismatch: expected $expectedMd5, got $actualMd5',
          );
        }
        BiosDownloadLogger.logInfo(
          'MD5 checksum verification passed: $actualMd5',
        );
      }

      onProgress?.call(
        DownloadProgress(
          filename: filename,
          bytesDownloaded: bytesDownloaded,
          totalBytes: contentLength ?? bytesDownloaded,
          status: DownloadStatus.completed,
        ),
      );

      return true;
    } catch (e) {
      await sink.close();
      if (await file.exists()) {
        await file.delete();
      }
      rethrow;
    }
  }

  Future<String> _calculateMd5(File file) async {
    final bytes = await file.readAsBytes();
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  /// Extracts files from a ZIP archive to the destination directory
  Future<bool> _extractArchive({
    required String archivePath,
    required String destinationPath,
    required List<String> extractedFiles,
    String? extractionPath,
    void Function(DownloadProgress)? onProgress,
    required String filename,
  }) async {
    try {
      BiosDownloadLogger.logInfo('Reading archive "$archivePath"');

      // Read the archive file
      final archiveFile = File(archivePath);
      final bytes = await archiveFile.readAsBytes();

      // Decode the archive
      Archive? archive;
      if (archivePath.toLowerCase().endsWith('.zip')) {
        archive = ZipDecoder().decodeBytes(bytes);
      } else {
        BiosDownloadLogger.logError(
          'Unsupported archive format for "$archivePath"',
        );
        return false;
      }

      BiosDownloadLogger.logInfo(
        'Archive contains ${archive.length} files, extracting platform-specific files',
      );

      // Determine which files to extract based on current platform
      final targetFiles = _getPlatformSpecificFiles(extractedFiles);

      if (targetFiles.isEmpty) {
        BiosDownloadLogger.logError(
          'No suitable files found for current platform in "$filename"',
        );
        return false;
      }

      int extractedCount = 0;

      // Extract each target file
      for (final targetFile in targetFiles) {
        ArchiveFile? fileToExtract;

        // Search for the file in the archive (handle nested paths)
        for (final archiveFile in archive) {
          if (archiveFile.isFile) {
            final archiveFileName = path.basename(archiveFile.name);
            if (archiveFileName == targetFile) {
              fileToExtract = archiveFile;
              break;
            }
          }
        }

        if (fileToExtract != null) {
          final outputPath = path.join(destinationPath, targetFile);
          BiosDownloadLogger.logInfo(
            'Extracting "${fileToExtract.name}" to "$outputPath"',
          );

          final outputFile = File(outputPath);
          await outputFile.writeAsBytes(fileToExtract.content as List<int>);

          extractedCount++;
          BiosDownloadLogger.logInfo(
            'Successfully extracted "$targetFile" (${fileToExtract.size} bytes)',
          );
        } else {
          BiosDownloadLogger.logWarning(
            'File "$targetFile" not found in archive "$filename"',
          );
        }
      }

      if (extractedCount > 0) {
        BiosDownloadLogger.logInfo(
          'Successfully extracted $extractedCount files from "$filename"',
        );

        onProgress?.call(
          DownloadProgress(
            filename: filename,
            bytesDownloaded: 0, // Extraction complete
            status: DownloadStatus.completed,
          ),
        );

        return true;
      } else {
        BiosDownloadLogger.logError('No files were extracted from "$filename"');
        return false;
      }
    } catch (e) {
      BiosDownloadLogger.logError(
        'Failed to extract archive "$archivePath"',
        error: e,
      );
      return false;
    }
  }

  /// Determines which files to extract based on the current platform
  List<String> _getPlatformSpecificFiles(List<String> extractedFiles) {
    if (Platform.isLinux) {
      return extractedFiles.where((file) => file.endsWith('.so')).toList();
    } else if (Platform.isWindows) {
      return extractedFiles.where((file) => file.endsWith('.dll')).toList();
    } else if (Platform.isMacOS) {
      return extractedFiles.where((file) => file.endsWith('.dylib')).toList();
    } else if (Platform.isAndroid) {
      // Android uses .so files
      return extractedFiles.where((file) => file.endsWith('.so')).toList();
    } else {
      // Fallback: try to extract all files
      BiosDownloadLogger.logWarning(
        'Unknown platform, attempting to extract all specified files',
      );
      return extractedFiles;
    }
  }
}

class _DownloadTask {
  final DownloadableBiosFile file;
  final String repoFolder;
  final String destinationPath;
  final String platformId;

  _DownloadTask({
    required this.file,
    required this.repoFolder,
    required this.destinationPath,
    required this.platformId,
  });
}
