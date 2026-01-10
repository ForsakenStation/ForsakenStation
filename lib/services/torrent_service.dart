import 'dart:async';
import 'package:dtorrent_parser/dtorrent_parser.dart';
import 'package:dtorrent_task/dtorrent_task.dart';
import 'package:forsaken/services/debug_service.dart';

/// Progress information for torrent downloads
class TorrentDownloadProgress {
  final double progress; // 0.0 to 1.0
  final int downloadedBytes;
  final int totalBytes;
  final int downloadSpeed; // bytes per second
  final int uploadSpeed; // bytes per second
  final int connectedPeers;
  final bool isPaused;
  final String timeRemaining;

  TorrentDownloadProgress({
    required this.progress,
    required this.downloadedBytes,
    required this.totalBytes,
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.connectedPeers,
    required this.isPaused,
    required this.timeRemaining,
  });
}

/// Service to manage torrent downloads
class TorrentService {
  TorrentTask? _currentTask;
  Timer? _progressTimer;
  bool _isPaused = false;
  int _totalBytes = 0;
  final _debug = DebugService.instance;

  /// Download a torrent file
  Future<void> downloadTorrent({
    required String torrentFilePath,
    required String savePath,
    required void Function(TorrentDownloadProgress) onProgress,
    required void Function(String filePath) onComplete,
    required void Function(String error) onError,
  }) async {
    try {
      _debug.info('Starting torrent download', tag: 'TorrentService');
      _debug.info('Torrent file: $torrentFilePath', tag: 'TorrentService');
      _debug.info('Save path: $savePath', tag: 'TorrentService');

      // Parse the torrent file
      _debug.info('Parsing torrent file...', tag: 'TorrentService');
      final torrent = await Torrent.parseFromFile(torrentFilePath);
      _debug.info('Torrent parsed successfully', tag: 'TorrentService');
      _debug.info('Torrent name: ${torrent.name}', tag: 'TorrentService');
      _debug.info(
        'Number of files: ${torrent.files.length}',
        tag: 'TorrentService',
      );

      // Calculate total bytes
      _totalBytes = 0;
      for (var file in torrent.files) {
        _totalBytes += file.length;
        _debug.info(
          '  File: ${file.path} (${file.length} bytes)',
          tag: 'TorrentService',
        );
      }
      _debug.info('Total size: $_totalBytes bytes', tag: 'TorrentService');

      // Create the torrent task
      _debug.info('Creating torrent task...', tag: 'TorrentService');
      _currentTask = TorrentTask.newTask(torrent, savePath);
      _debug.info('Torrent task created', tag: 'TorrentService');

      // Create event listener
      final listener = _currentTask!.createListener();
      _debug.info('Event listener created', tag: 'TorrentService');

      // Listen for task start
      listener.on<TaskStarted>((event) {
        _debug.info('Task started!', tag: 'TorrentService');
      });

      // Listen for task completion
      listener.on<TaskCompleted>((event) {
        _debug.info('Task completed!', tag: 'TorrentService');
        _progressTimer?.cancel();
        // Get the first file path (or handle multiple files)
        final files = torrent.files;
        final firstFile = files.isNotEmpty ? files.first : null;
        if (firstFile != null) {
          final filePath = '$savePath/${firstFile.path}';
          _debug.info('Completed file path: $filePath', tag: 'TorrentService');
          onComplete(filePath);
        } else {
          _debug.info('Completed save path: $savePath', tag: 'TorrentService');
          onComplete(savePath);
        }
      });

      // Listen for file completion (multi-file torrents)
      listener.on<TaskFileCompleted>((event) {
        _debug.info('Individual file completed', tag: 'TorrentService');
      });

      // Listen for pause events
      listener.on<TaskPaused>((event) {
        _debug.info('Task paused', tag: 'TorrentService');
        _isPaused = true;
      });

      // Listen for resume events
      listener.on<TaskResumed>((event) {
        _debug.info('Task resumed', tag: 'TorrentService');
        _isPaused = false;
      });

      // Listen for stop events
      listener.on<TaskStopped>((event) {
        _debug.info('Task stopped', tag: 'TorrentService');
        _progressTimer?.cancel();
      });

      // Start periodic progress updates
      _progressTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_currentTask != null) {
          final progress = _calculateProgress();
          onProgress(progress);
        }
      });

      // Start the download
      _debug.info('Starting torrent task...', tag: 'TorrentService');
      await _currentTask!.start();
      _debug.info('Torrent task started successfully', tag: 'TorrentService');
    } catch (e, stackTrace) {
      _debug.error(
        'Failed to start torrent download',
        tag: 'TorrentService',
        error: e,
        stackTrace: stackTrace,
      );
      _progressTimer?.cancel();
      onError(
        'Failed to start torrent download: $e\n\nStack trace:\n$stackTrace',
      );
    }
  }

  /// Calculate current progress
  TorrentDownloadProgress _calculateProgress() {
    if (_currentTask == null) {
      return TorrentDownloadProgress(
        progress: 0.0,
        downloadedBytes: 0,
        totalBytes: _totalBytes,
        downloadSpeed: 0,
        uploadSpeed: 0,
        connectedPeers: 0,
        isPaused: _isPaused,
        timeRemaining: 'Unknown',
      );
    }

    try {
      // Get torrent statistics
      final downloaded = _currentTask!.downloaded ?? 0;
      final progress = _currentTask!.progress;
      final downloadSpeed = _currentTask!.currentDownloadSpeed.toInt();
      final uploadSpeed = _currentTask!.uploadSpeed.toInt();
      final peers = _currentTask!.connectedPeersNumber;

      // Calculate time remaining
      String timeRemaining = 'Calculating...';
      if (downloadSpeed > 0 && progress < 1.0) {
        final remainingBytes = _totalBytes - downloaded;
        final secondsRemaining = remainingBytes / downloadSpeed;
        timeRemaining = _formatDuration(secondsRemaining.toInt());
      } else if (progress >= 1.0) {
        timeRemaining = 'Complete';
      } else if (_isPaused) {
        timeRemaining = 'Paused';
      }

      return TorrentDownloadProgress(
        progress: progress.clamp(0.0, 1.0),
        downloadedBytes: downloaded,
        totalBytes: _totalBytes,
        downloadSpeed: downloadSpeed,
        uploadSpeed: uploadSpeed,
        connectedPeers: peers,
        isPaused: _isPaused,
        timeRemaining: timeRemaining,
      );
    } catch (e) {
      _debug.error(
        'Error calculating progress',
        tag: 'TorrentService',
        error: e,
      );
      return TorrentDownloadProgress(
        progress: 0.0,
        downloadedBytes: 0,
        totalBytes: _totalBytes,
        downloadSpeed: 0,
        uploadSpeed: 0,
        connectedPeers: 0,
        isPaused: _isPaused,
        timeRemaining: 'Error',
      );
    }
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

  /// Pause the current download
  void pauseDownload() {
    _currentTask?.pause();
    _isPaused = true;
  }

  /// Resume the current download
  void resumeDownload() {
    _currentTask?.resume();
    _isPaused = false;
  }

  /// Stop the current download
  Future<void> stopDownload() async {
    await _currentTask?.stop();
    _progressTimer?.cancel();
    _currentTask = null;
  }

  /// Dispose resources
  void dispose() {
    stopDownload();
  }
}
