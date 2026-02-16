import 'dart:async';
import 'dart:io';
import 'dart:collection';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';

import 'package:forsaken/models/bios_download_mapping.dart';
import 'package:forsaken/services/bios_size_correction_service.dart';

/// Report for individual BIOS file checksum verification
class BiosFileChecksumReport {
  final String filename;
  final bool exists;
  final bool hasChecksum;
  final String? expectedMd5;
  final String? actualMd5;
  final String? expectedSha1;
  final String? actualSha1;
  final bool? md5Match;
  final bool? sha1Match;
  final bool? verificationPassed;
  final int? fileSize;
  final int? expectedSize;
  final String? error;

  const BiosFileChecksumReport({
    required this.filename,
    required this.exists,
    required this.hasChecksum,
    this.expectedMd5,
    this.actualMd5,
    this.expectedSha1,
    this.actualSha1,
    this.md5Match,
    this.sha1Match,
    this.verificationPassed,
    this.fileSize,
    this.expectedSize,
    this.error,
  });
}

/// Report for platform checksum verification
class PlatformChecksumReport {
  final String platformId;
  final List<BiosFileChecksumReport> files;

  const PlatformChecksumReport({required this.platformId, required this.files});

  int get totalFiles => files.length;
  int get verifiedFiles =>
      files.where((f) => f.verificationPassed == true).length;
  int get failedFiles =>
      files.where((f) => f.verificationPassed == false).length;
  int get missingFiles => files.where((f) => !f.exists).length;
}

/// Comprehensive BIOS checksum verification report
class BiosChecksumReport {
  final int totalFiles;
  final int verifiedFiles;
  final int missingChecksums;
  final int failedVerifications;
  final Map<String, PlatformChecksumReport> platformReports;
  final DateTime generatedAt;

  const BiosChecksumReport({
    required this.totalFiles,
    required this.verifiedFiles,
    required this.missingChecksums,
    required this.failedVerifications,
    required this.platformReports,
    required this.generatedAt,
  });

  double get verificationCoverage {
    if (totalFiles == 0) return 0.0;
    return (totalFiles - missingChecksums) / totalFiles;
  }

  double get verificationSuccessRate {
    final filesWithChecksums = totalFiles - missingChecksums;
    if (filesWithChecksums == 0) return 0.0;
    return verifiedFiles / filesWithChecksums;
  }
}

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
  final DateTime? startTime;
  final Duration? elapsedTime;

  DownloadProgress({
    required this.filename,
    required this.bytesDownloaded,
    this.totalBytes,
    required this.status,
    this.errorMessage,
    this.startTime,
    this.elapsedTime,
  });

  double get progress {
    if (totalBytes == null || totalBytes == 0) return 0.0;
    return bytesDownloaded / totalBytes!;
  }

  String get progressText {
    if (totalBytes == null) return _formatBytes(bytesDownloaded);
    return '${_formatBytes(bytesDownloaded)} / ${_formatBytes(totalBytes!)}';
  }

  /// Calculate download speed in bytes per second
  double? get downloadSpeed {
    if (elapsedTime == null || elapsedTime!.inMilliseconds == 0) return null;
    return bytesDownloaded / (elapsedTime!.inMilliseconds / 1000.0);
  }

  /// Get formatted download speed text
  String? get speedText {
    final speed = downloadSpeed;
    if (speed == null) return null;
    return '${_formatBytes(speed.round())}/s';
  }

  /// Calculate estimated time to completion
  Duration? get estimatedTimeRemaining {
    if (totalBytes == null || downloadSpeed == null || downloadSpeed! <= 0) {
      return null;
    }
    final remainingBytes = totalBytes! - bytesDownloaded;
    if (remainingBytes <= 0) return const Duration(seconds: 0);
    return Duration(seconds: (remainingBytes / downloadSpeed!).round());
  }

  /// Get formatted ETA text
  String? get etaText {
    final eta = estimatedTimeRemaining;
    if (eta == null) return null;

    if (eta.inHours > 0) {
      return '${eta.inHours}h ${eta.inMinutes % 60}m remaining';
    } else if (eta.inMinutes > 0) {
      return '${eta.inMinutes}m ${eta.inSeconds % 60}s remaining';
    } else {
      return '${eta.inSeconds}s remaining';
    }
  }

  /// Get comprehensive progress text with speed and ETA
  String get detailedProgressText {
    final buffer = StringBuffer(progressText);

    if (speedText != null) {
      buffer.write(' (${speedText!}');

      if (etaText != null) {
        buffer.write(', $etaText');
      }

      buffer.write(')');
    }

    return buffer.toString();
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
    DateTime? startTime,
    Duration? elapsedTime,
  }) {
    return DownloadProgress(
      filename: filename,
      bytesDownloaded: bytesDownloaded ?? this.bytesDownloaded,
      totalBytes: totalBytes ?? this.totalBytes,
      status: status ?? this.status,
      errorMessage: errorMessage,
      startTime: startTime ?? this.startTime,
      elapsedTime: elapsedTime ?? this.elapsedTime,
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
    if (await existingFile.exists() &&
        (file.expectedMd5 != null || file.expectedSha1 != null)) {
      BiosDownloadLogger.logInfo(
        'Checking existing file checksum for "$filename"',
      );
      try {
        bool checksumMatches = false;

        // Check MD5 if available
        if (file.expectedMd5 != null) {
          final existingMd5 = await _calculateMd5(existingFile);
          if (existingMd5.toLowerCase() == file.expectedMd5!.toLowerCase()) {
            BiosDownloadLogger.logInfo(
              'File "$filename" already exists with correct MD5 checksum ($existingMd5)',
            );
            checksumMatches = true;
          } else {
            BiosDownloadLogger.logWarning(
              'File "$filename" exists but has wrong MD5 checksum (expected: ${file.expectedMd5}, got: $existingMd5)',
            );
          }
        }

        // Check SHA1 if available and MD5 didn't match (or wasn't available)
        if (!checksumMatches && file.expectedSha1 != null) {
          final existingSha1 = await _calculateSha1(existingFile);
          if (existingSha1.toLowerCase() == file.expectedSha1!.toLowerCase()) {
            BiosDownloadLogger.logInfo(
              'File "$filename" already exists with correct SHA1 checksum ($existingSha1)',
            );
            checksumMatches = true;
          } else {
            BiosDownloadLogger.logWarning(
              'File "$filename" exists but has wrong SHA1 checksum (expected: ${file.expectedSha1}, got: $existingSha1)',
            );
          }
        }

        if (checksumMatches) {
          final fileSize = await existingFile.length();
          onProgress?.call(
            DownloadProgress(
              filename: filename,
              bytesDownloaded: fileSize,
              totalBytes: fileSize,
              status: DownloadStatus.completed,
            ),
          );
          return true;
        }
      } catch (e) {
        BiosDownloadLogger.logError(
          'Could not verify existing file "$filename"',
          error: e,
        );
      }
    } else if (await existingFile.exists()) {
      BiosDownloadLogger.logWarning(
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
          expectedSha1: file.expectedSha1,
          expectedSize: file.expectedSize,
          sizeTolerance: file.sizeTolerance,
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
    String? expectedSha1,
    int? expectedSize,
    double sizeTolerance = 0.0, // Size variance tolerance (0.0 to 1.0)
    void Function(DownloadProgress)? onProgress,
    String? cancellationToken,
  }) async {
    late http.StreamedResponse response;
    final startTime = DateTime.now();

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
            startTime: startTime,
            elapsedTime: DateTime.now().difference(startTime),
          ),
        );
      }

      await sink.close();

      // Verify file size if expected
      if (expectedSize != null) {
        final actualSize = await file.length();

        // Calculate allowed size range based on tolerance
        final toleranceBytes = (expectedSize * sizeTolerance).round();
        final minSize = expectedSize - toleranceBytes;
        final maxSize = expectedSize + toleranceBytes;

        if (actualSize < minSize || actualSize > maxSize) {
          // Use size correction service for better error analysis
          BiosSizeCorrectionService.logSizeAnalysis(
            filename,
            url,
            expectedSize,
            actualSize,
          );

          final suggestedSize = BiosSizeCorrectionService.suggestSizeCorrection(
            url,
            filename,
            actualSize,
          );
          final areCompatible = BiosSizeCorrectionService.areCompatibleSizes(
            expectedSize,
            actualSize,
          );

          await file.delete();

          String errorMessage;
          if (suggestedSize != null) {
            errorMessage =
                'Size mismatch: expected ${BiosDownloadLogger._formatBytes(expectedSize)}, got ${BiosDownloadLogger._formatBytes(actualSize)}. '
                'This appears to be a known size difference for this repository. '
                'The downloaded file size (${BiosDownloadLogger._formatBytes(actualSize)}) may be correct for this source.';
          } else if (areCompatible) {
            errorMessage =
                'Size mismatch: expected ${BiosDownloadLogger._formatBytes(expectedSize)}, got ${BiosDownloadLogger._formatBytes(actualSize)}. '
                'Sizes are close but outside tolerance. This may indicate a different version of the same file.';
          } else {
            if (sizeTolerance > 0.0) {
              errorMessage =
                  'Size mismatch: expected ${BiosDownloadLogger._formatBytes(expectedSize)} ±${(sizeTolerance * 100).round()}%, got ${BiosDownloadLogger._formatBytes(actualSize)}';
            } else {
              errorMessage =
                  'Size mismatch: expected ${BiosDownloadLogger._formatBytes(expectedSize)}, got ${BiosDownloadLogger._formatBytes(actualSize)}';
            }
          }

          throw Exception(errorMessage);
        }

        BiosDownloadLogger.logInfo(
          'File size verification passed: ${BiosDownloadLogger._formatBytes(actualSize)}',
        );
      }

      // Verify checksums if expected
      bool checksumVerified = false;

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
        checksumVerified = true;
      }

      if (expectedSha1 != null) {
        BiosDownloadLogger.logInfo('Verifying SHA1 checksum for "$filename"');
        if (!checksumVerified) {
          onProgress?.call(
            DownloadProgress(
              filename: filename,
              bytesDownloaded: bytesDownloaded,
              totalBytes: contentLength,
              status: DownloadStatus.verifying,
            ),
          );
        }

        final actualSha1 = await _calculateSha1(file);
        if (actualSha1.toLowerCase() != expectedSha1.toLowerCase()) {
          await file.delete();
          throw Exception(
            'SHA1 checksum mismatch: expected $expectedSha1, got $actualSha1',
          );
        }
        BiosDownloadLogger.logInfo(
          'SHA1 checksum verification passed: $actualSha1',
        );
        checksumVerified = true;
      }

      if (expectedMd5 == null && expectedSha1 == null) {
        BiosDownloadLogger.logWarning(
          'No checksum verification available for "$filename" - file integrity cannot be guaranteed',
        );
      }

      onProgress?.call(
        DownloadProgress(
          filename: filename,
          bytesDownloaded: bytesDownloaded,
          totalBytes: contentLength ?? bytesDownloaded,
          status: DownloadStatus.completed,
          startTime: startTime,
          elapsedTime: DateTime.now().difference(startTime),
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

  Future<String> _calculateSha1(File file) async {
    final bytes = await file.readAsBytes();
    final digest = sha1.convert(bytes);
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

            // Check if this file matches the target file
            bool isMatch = false;

            if (extractionPath != null) {
              // If extraction path is specified, look for files within that path
              final normalizedArchivePath = archiveFile.name.replaceAll(
                '\\',
                '/',
              );
              final normalizedExtractionPath = extractionPath.replaceAll(
                '\\',
                '/',
              );

              if (normalizedArchivePath.contains(normalizedExtractionPath) &&
                  archiveFileName == targetFile) {
                isMatch = true;
              }
            } else {
              // Default behavior: match by filename only
              if (archiveFileName == targetFile) {
                isMatch = true;
              }
            }

            if (isMatch) {
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
    if (kIsWeb) {
      // Web platform doesn't need platform-specific library files
      return [];
    }

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

  /// Generate comprehensive checksum verification report for all BIOS files
  Future<BiosChecksumReport> generateChecksumReport({
    required Map<String, String> platformPaths,
    List<String>? platformFilter,
  }) async {
    final platformReports = <String, PlatformChecksumReport>{};
    int totalFiles = 0;
    int verifiedFiles = 0;
    int missingChecksums = 0;
    int failedVerifications = 0;

    for (final mapping in BiosDownloadMapping.allMappings) {
      // Apply platform filter if specified
      if (platformFilter != null &&
          !platformFilter.contains(mapping.platformId)) {
        continue;
      }

      final platformPath = platformPaths[mapping.platformId];
      if (platformPath == null) continue;

      final fileReports = <BiosFileChecksumReport>[];
      final directory = Directory(platformPath);

      if (!await directory.exists()) {
        continue;
      }

      for (final biosFile in mapping.files) {
        totalFiles++;
        final filePath = path.join(platformPath, biosFile.filename);
        final file = File(filePath);

        if (!await file.exists()) {
          fileReports.add(
            BiosFileChecksumReport(
              filename: biosFile.filename,
              exists: false,
              hasChecksum:
                  biosFile.expectedMd5 != null || biosFile.expectedSha1 != null,
            ),
          );
          continue;
        }

        final hasChecksum =
            biosFile.expectedMd5 != null || biosFile.expectedSha1 != null;
        if (!hasChecksum) {
          missingChecksums++;
        }

        try {
          String? actualMd5;
          String? actualSha1;
          bool md5Match = true;
          bool sha1Match = true;

          // Calculate checksums if expected
          if (biosFile.expectedMd5 != null) {
            actualMd5 = await _calculateMd5(file);
            md5Match =
                actualMd5.toLowerCase() == biosFile.expectedMd5!.toLowerCase();
          }

          if (biosFile.expectedSha1 != null) {
            actualSha1 = await _calculateSha1(file);
            sha1Match =
                actualSha1.toLowerCase() ==
                biosFile.expectedSha1!.toLowerCase();
          }

          final verificationPassed = md5Match && sha1Match;
          if (verificationPassed && hasChecksum) {
            verifiedFiles++;
          } else if (!verificationPassed) {
            failedVerifications++;
          }

          fileReports.add(
            BiosFileChecksumReport(
              filename: biosFile.filename,
              exists: true,
              hasChecksum: hasChecksum,
              expectedMd5: biosFile.expectedMd5,
              actualMd5: actualMd5,
              expectedSha1: biosFile.expectedSha1,
              actualSha1: actualSha1,
              md5Match: md5Match,
              sha1Match: sha1Match,
              verificationPassed: verificationPassed,
              fileSize: await file.length(),
              expectedSize: biosFile.expectedSize,
            ),
          );
        } catch (e) {
          failedVerifications++;
          fileReports.add(
            BiosFileChecksumReport(
              filename: biosFile.filename,
              exists: true,
              hasChecksum: hasChecksum,
              error: e.toString(),
            ),
          );
        }
      }

      if (fileReports.isNotEmpty) {
        platformReports[mapping.platformId] = PlatformChecksumReport(
          platformId: mapping.platformId,
          files: fileReports,
        );
      }
    }

    return BiosChecksumReport(
      totalFiles: totalFiles,
      verifiedFiles: verifiedFiles,
      missingChecksums: missingChecksums,
      failedVerifications: failedVerifications,
      platformReports: platformReports,
      generatedAt: DateTime.now(),
    );
  }

  /// Downloads BIOS files in parallel for improved performance
  ///
  /// Downloads multiple files concurrently with configurable parallelism.
  /// Useful for platforms with many BIOS files or when downloading from multiple platforms.
  Future<bool> downloadPlatformBiosParallel({
    required String platformId,
    required List<String> missingFiles,
    required String destinationPath,
    void Function(DownloadProgress)? onProgress,
    String? cancellationToken,
    int maxConcurrency =
        3, // Limit concurrent downloads to avoid overwhelming servers
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
    BiosDownloadLogger.logInfo(
      'Starting parallel download with max concurrency: $maxConcurrency',
    );

    // Prepare download tasks
    final tasks = <Future<bool>>[];
    final semaphore = Semaphore(maxConcurrency);

    int completedCount = 0;
    final totalFiles = missingFiles.length;

    for (final filename in missingFiles) {
      if (_isCancelled(cancellationToken)) {
        BiosDownloadLogger.logWarning(
          'Parallel download cancelled for platform "$platformId"',
        );
        break;
      }

      final file = mapping.getFile(filename);
      if (file == null) {
        BiosDownloadLogger.logWarning(
          'File "$filename" not found in mapping for platform "$platformId"',
        );
        continue;
      }

      // Create parallel download task with semaphore
      final task = semaphore.acquire().then((_) async {
        try {
          BiosDownloadLogger.logInfo(
            'Starting parallel download: "$filename" (${++completedCount}/$totalFiles)',
          );

          final success = await downloadFile(
            file: file,
            repoFolder: mapping.repoFolder,
            destinationPath: destinationPath,
            onProgress: onProgress, // Pass through progress as-is
            cancellationToken: cancellationToken,
          );

          if (success) {
            BiosDownloadLogger.logInfo(
              'Parallel download completed: "$filename"',
            );
          } else {
            BiosDownloadLogger.logError(
              'Parallel download failed: "$filename"',
            );
          }

          return success;
        } finally {
          semaphore.release();
        }
      });

      tasks.add(task);
    }

    // Wait for all downloads to complete
    final results = await Future.wait(tasks);
    final successCount = results.where((success) => success).length;
    final allSuccessful = successCount == missingFiles.length;

    final duration = DateTime.now().difference(startTime);
    BiosDownloadLogger.logBatchComplete(
      platformId,
      successCount,
      missingFiles.length,
      duration,
    );

    return allSuccessful;
  }
}

/// Simple semaphore implementation for controlling concurrent downloads
class Semaphore {
  final int maxCount;
  int _currentCount;
  final Queue<Completer<void>> _waitQueue = Queue<Completer<void>>();

  Semaphore(this.maxCount) : _currentCount = maxCount;

  Future<void> acquire() async {
    if (_currentCount > 0) {
      _currentCount--;
      return;
    }

    final completer = Completer<void>();
    _waitQueue.add(completer);
    return completer.future;
  }

  void release() {
    if (_waitQueue.isNotEmpty) {
      final completer = _waitQueue.removeFirst();
      completer.complete();
    } else {
      _currentCount++;
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
