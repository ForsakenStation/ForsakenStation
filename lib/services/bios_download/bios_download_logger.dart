import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:forsaken/services/debug_service.dart';
import 'package:forsaken/utils/format_utils.dart';

/// Enhanced logging utility for BIOS download operations
class BiosDownloadLogger {
  static const String _tag = 'BiosDownload';

  static void logInfo(String message) {
    DebugService.instance.info(message, tag: _tag);
  }

  static void logWarning(String message) {
    DebugService.instance.warning(message, tag: _tag);
  }

  static void logError(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    DebugService.instance.error(message, tag: _tag);
    if (error != null) {
      DebugService.instance.error('Details: $error', tag: _tag);
    }
    if (stackTrace != null && kDebugMode) {
      DebugService.instance.error('Stack trace: $stackTrace', tag: _tag);
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

  static String _formatBytes(int bytes) => formatBytes(bytes, compact: true);
}
