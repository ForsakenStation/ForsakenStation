import 'package:forsaken/utils/format_utils.dart';

enum DownloadStatus {
  pending,
  downloading,
  verifying,
  completed,
  failed,
  cancelled,
}

enum BatchDownloadStatus { pending, downloading, completed, failed, cancelled }

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

  static String _formatBytes(int bytes) => formatBytes(bytes, compact: true);

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
