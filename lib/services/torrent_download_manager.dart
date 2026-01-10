import 'dart:async';
import 'package:dtorrent_parser/dtorrent_parser.dart';
import 'package:dtorrent_task/dtorrent_task.dart';
import 'package:flutter/material.dart';
import 'package:forsaken/services/debug_service.dart';
import 'package:forsaken/models/torrent_download.dart';
import 'package:uuid/uuid.dart';

/// Service to manage multiple torrent downloads
class TorrentDownloadManager extends ChangeNotifier {
  static TorrentDownloadManager? _instance;
  static TorrentDownloadManager get instance {
    _instance ??= TorrentDownloadManager._();
    return _instance!;
  }

  TorrentDownloadManager._();

  final _debug = DebugService.instance;
  final _uuid = const Uuid();

  final Map<String, TorrentDownload> _downloads = {};
  final Map<String, Timer> _progressTimers = {};
  final Map<String, StreamSubscription> _eventListeners = {};

  /// Get all downloads
  List<TorrentDownload> get downloads => _downloads.values.toList();

  /// Get active downloads
  List<TorrentDownload> get activeDownloads =>
      _downloads.values.where((d) => d.isActive).toList();

  /// Get completed downloads
  List<TorrentDownload> get completedDownloads => _downloads.values
      .where((d) => d.status == TorrentDownloadStatus.completed)
      .toList();

  /// Get download by ID
  TorrentDownload? getDownload(String id) => _downloads[id];

  /// Add a new torrent download
  Future<String> addDownload({
    required String romName,
    required String torrentFilePath,
    required String savePath,
  }) async {
    final id = _uuid.v4();
    final download = TorrentDownload(
      id: id,
      romName: romName,
      torrentFilePath: torrentFilePath,
      savePath: savePath,
      startTime: DateTime.now(),
    );

    _downloads[id] = download;
    notifyListeners();

    _debug.info(
      'Added download: $id - $romName',
      tag: 'TorrentDownloadManager',
    );

    // Start the download
    await _startDownload(id);

    return id;
  }

  /// Start a torrent download
  Future<void> _startDownload(String id) async {
    final download = _downloads[id];
    if (download == null) return;

    try {
      _debug.info('Starting download: $id', tag: 'TorrentDownloadManager');

      // Parse the torrent file
      _debug.info('Parsing torrent file...', tag: 'TorrentDownloadManager');
      final torrent = await Torrent.parseFromFile(download.torrentFilePath);
      _debug.info('Torrent parsed successfully', tag: 'TorrentDownloadManager');

      // Calculate total bytes
      int totalBytes = 0;
      for (var file in torrent.files) {
        totalBytes += file.length;
      }

      download.totalBytes = totalBytes;
      download.status = TorrentDownloadStatus.downloading;
      notifyListeners();

      // Create the torrent task
      final task = TorrentTask.newTask(torrent, download.savePath);
      download.task = task;

      // Create event listener
      final listener = task.createListener();

      // Listen for task start
      listener.on<TaskStarted>((event) {
        _debug.info('Task started: $id', tag: 'TorrentDownloadManager');
        download.status = TorrentDownloadStatus.downloading;
        notifyListeners();
      });

      // Listen for task completion
      listener.on<TaskCompleted>((event) {
        _debug.info('Task completed: $id', tag: 'TorrentDownloadManager');
        _onDownloadComplete(id, torrent);
      });

      // Listen for pause events
      listener.on<TaskPaused>((event) {
        _debug.info('Task paused: $id', tag: 'TorrentDownloadManager');
        download.status = TorrentDownloadStatus.paused;
        notifyListeners();
      });

      // Listen for resume events
      listener.on<TaskResumed>((event) {
        _debug.info('Task resumed: $id', tag: 'TorrentDownloadManager');
        download.status = TorrentDownloadStatus.downloading;
        notifyListeners();
      });

      // Listen for stop events
      listener.on<TaskStopped>((event) {
        _debug.info('Task stopped: $id', tag: 'TorrentDownloadManager');
        _cleanupDownload(id);
      });

      // Start periodic progress updates
      _progressTimers[id] = Timer.periodic(const Duration(seconds: 1), (_) {
        _updateProgress(id);
      });

      // Start the download
      await task.start();
      _debug.info(
        'Task started successfully: $id',
        tag: 'TorrentDownloadManager',
      );
    } catch (e, stackTrace) {
      _debug.error(
        'Failed to start download: $id',
        tag: 'TorrentDownloadManager',
        error: e,
        stackTrace: stackTrace,
      );
      download.status = TorrentDownloadStatus.failed;
      download.errorMessage = e.toString();
      _cleanupDownload(id);
      notifyListeners();
    }
  }

  /// Update progress for a download
  void _updateProgress(String id) {
    final download = _downloads[id];
    if (download == null || download.task == null) return;

    try {
      final task = download.task!;
      download.downloadedBytes = task.downloaded ?? 0;
      download.progress = task.progress;
      download.downloadSpeed = task.currentDownloadSpeed.toInt();
      download.uploadSpeed = task.uploadSpeed.toInt();
      download.connectedPeers = task.connectedPeersNumber;
      notifyListeners();
    } catch (e) {
      _debug.error(
        'Error updating progress: $id',
        tag: 'TorrentDownloadManager',
        error: e,
      );
    }
  }

  /// Handle download completion
  void _onDownloadComplete(String id, Torrent torrent) {
    final download = _downloads[id];
    if (download == null) return;

    // Get the first file path
    final files = torrent.files;
    final firstFile = files.isNotEmpty ? files.first : null;
    if (firstFile != null) {
      download.completedFilePath = '${download.savePath}/${firstFile.path}';
    } else {
      download.completedFilePath = download.savePath;
    }

    download.status = TorrentDownloadStatus.completed;
    download.progress = 1.0;
    _cleanupDownload(id);
    notifyListeners();

    _debug.info('Download completed: $id', tag: 'TorrentDownloadManager');

    // Trigger completion callback for notifications
    onDownloadCompleted?.call(download);
  }

  /// Callback for when a download completes (for notifications)
  void Function(TorrentDownload)? onDownloadCompleted;

  /// Pause a download
  Future<void> pauseDownload(String id) async {
    final download = _downloads[id];
    if (download == null || !download.canPause) return;

    _debug.info('Pausing download: $id', tag: 'TorrentDownloadManager');
    download.task?.pause();
    download.status = TorrentDownloadStatus.paused;
    notifyListeners();
  }

  /// Resume a download
  Future<void> resumeDownload(String id) async {
    final download = _downloads[id];
    if (download == null || !download.canResume) return;

    _debug.info('Resuming download: $id', tag: 'TorrentDownloadManager');
    download.task?.resume();
    download.status = TorrentDownloadStatus.downloading;
    notifyListeners();
  }

  /// Cancel a download
  Future<void> cancelDownload(String id) async {
    final download = _downloads[id];
    if (download == null || !download.canCancel) return;

    _debug.info('Cancelling download: $id', tag: 'TorrentDownloadManager');
    await download.task?.stop();
    download.status = TorrentDownloadStatus.cancelled;
    _cleanupDownload(id);
    notifyListeners();
  }

  /// Remove a download from the list
  Future<void> removeDownload(String id) async {
    final download = _downloads[id];
    if (download == null || !download.canRemove) return;

    _debug.info('Removing download: $id', tag: 'TorrentDownloadManager');
    _downloads.remove(id);
    notifyListeners();
  }

  /// Cleanup download resources
  void _cleanupDownload(String id) {
    _progressTimers[id]?.cancel();
    _progressTimers.remove(id);
    _eventListeners[id]?.cancel();
    _eventListeners.remove(id);
  }

  /// Cleanup all resources
  @override
  void dispose() {
    for (var timer in _progressTimers.values) {
      timer.cancel();
    }
    for (var listener in _eventListeners.values) {
      listener.cancel();
    }
    _progressTimers.clear();
    _eventListeners.clear();
    super.dispose();
  }
}
