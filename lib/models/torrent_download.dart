import 'package:dtorrent_task/dtorrent_task.dart';

/// Status of a torrent download
enum TorrentDownloadStatus {
  initializing,
  downloading,
  paused,
  completed,
  failed,
  cancelled,
}

/// Model representing a torrent download
class TorrentDownload {
  final String id; // Unique identifier
  final String romName;
  final String torrentFilePath;
  final String savePath;
  final DateTime startTime;

  TorrentDownloadStatus status;
  double progress;
  int downloadedBytes;
  int totalBytes;
  int downloadSpeed;
  int uploadSpeed;
  int connectedPeers;
  String? errorMessage;
  String? completedFilePath;
  TorrentTask? task;

  TorrentDownload({
    required this.id,
    required this.romName,
    required this.torrentFilePath,
    required this.savePath,
    required this.startTime,
    this.status = TorrentDownloadStatus.initializing,
    this.progress = 0.0,
    this.downloadedBytes = 0,
    this.totalBytes = 0,
    this.downloadSpeed = 0,
    this.uploadSpeed = 0,
    this.connectedPeers = 0,
    this.errorMessage,
    this.completedFilePath,
    this.task,
  });

  /// Get display text for status
  String get statusText {
    switch (status) {
      case TorrentDownloadStatus.initializing:
        return 'Initializing...';
      case TorrentDownloadStatus.downloading:
        return 'Downloading';
      case TorrentDownloadStatus.paused:
        return 'Paused';
      case TorrentDownloadStatus.completed:
        return 'Completed';
      case TorrentDownloadStatus.failed:
        return 'Failed';
      case TorrentDownloadStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// Get time remaining estimate
  String get timeRemaining {
    if (status == TorrentDownloadStatus.completed) {
      return 'Complete';
    }
    if (status == TorrentDownloadStatus.paused) {
      return 'Paused';
    }
    if (status == TorrentDownloadStatus.failed) {
      return 'Failed';
    }
    if (downloadSpeed > 0 && progress < 1.0) {
      final remainingBytes = totalBytes - downloadedBytes;
      final secondsRemaining = remainingBytes / downloadSpeed;
      return _formatDuration(secondsRemaining.toInt());
    }
    return 'Calculating...';
  }

  /// Format duration in seconds to human-readable string
  String _formatDuration(int seconds) {
    if (seconds < 60) {
      return '${seconds}s';
    } else if (seconds < 3600) {
      final minutes = seconds ~/ 60;
      final secs = seconds % 60;
      return '${minutes}m ${secs}s';
    } else {
      final hours = seconds ~/ 3600;
      final minutes = (seconds % 3600) ~/ 60;
      return '${hours}h ${minutes}m';
    }
  }

  /// Check if download is active
  bool get isActive =>
      status == TorrentDownloadStatus.downloading ||
      status == TorrentDownloadStatus.initializing;

  /// Check if download can be paused
  bool get canPause => status == TorrentDownloadStatus.downloading;

  /// Check if download can be resumed
  bool get canResume => status == TorrentDownloadStatus.paused;

  /// Check if download can be cancelled
  bool get canCancel =>
      status == TorrentDownloadStatus.downloading ||
      status == TorrentDownloadStatus.paused ||
      status == TorrentDownloadStatus.initializing;

  /// Check if download can be removed
  bool get canRemove =>
      status == TorrentDownloadStatus.completed ||
      status == TorrentDownloadStatus.failed ||
      status == TorrentDownloadStatus.cancelled;
}
