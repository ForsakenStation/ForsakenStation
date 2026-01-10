import 'package:flutter/material.dart';
import 'package:forsaken/services/torrent_service.dart';
import 'package:forsaken/services/debug_service.dart';

class TorrentDownloadScreen extends StatefulWidget {
  final String torrentFilePath;
  final String savePath;
  final String romName;

  const TorrentDownloadScreen({
    super.key,
    required this.torrentFilePath,
    required this.savePath,
    required this.romName,
  });

  @override
  State<TorrentDownloadScreen> createState() => _TorrentDownloadScreenState();
}

class _TorrentDownloadScreenState extends State<TorrentDownloadScreen> {
  late TorrentService _torrentService;
  TorrentDownloadProgress? _progress;
  String? _errorMessage;
  bool _isDownloading = false;
  final _debug = DebugService.instance;

  @override
  void initState() {
    super.initState();
    _debug.info(
      'TorrentDownloadScreen initialized',
      tag: 'TorrentDownloadScreen',
    );
    _debug.info(
      'Torrent file: ${widget.torrentFilePath}',
      tag: 'TorrentDownloadScreen',
    );
    _debug.info('Save path: ${widget.savePath}', tag: 'TorrentDownloadScreen');
    _debug.info('ROM name: ${widget.romName}', tag: 'TorrentDownloadScreen');

    _torrentService = TorrentService();
    _startDownload();
  }

  Future<void> _startDownload() async {
    _debug.info('Starting download...', tag: 'TorrentDownloadScreen');
    setState(() {
      _isDownloading = true;
      _errorMessage = null;
    });

    try {
      await _torrentService.downloadTorrent(
        torrentFilePath: widget.torrentFilePath,
        savePath: widget.savePath,
        onProgress: (progress) {
          if (mounted) {
            setState(() {
              _progress = progress;
            });
          }
        },
        onComplete: (filePath) {
          _debug.info(
            'Download completed: $filePath',
            tag: 'TorrentDownloadScreen',
          );
          if (mounted) {
            setState(() {
              _isDownloading = false;
            });
            _showCompletionDialog(filePath);
          }
        },
        onError: (error) {
          _debug.error('Download error: $error', tag: 'TorrentDownloadScreen');
          if (mounted) {
            setState(() {
              _isDownloading = false;
              _errorMessage = error;
            });
          }
        },
      );
    } catch (e, stackTrace) {
      _debug.error(
        'Exception starting download',
        tag: 'TorrentDownloadScreen',
        error: e,
        stackTrace: stackTrace,
      );
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _errorMessage = 'Exception: $e\n\nStack trace:\n$stackTrace';
        });
      }
    }
  }

  void _showCompletionDialog(String filePath) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 32),
            SizedBox(width: 12),
            Text('Download Complete'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Successfully downloaded: ${widget.romName}'),
            const SizedBox(height: 8),
            Text(
              'Saved to: $filePath',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(filePath); // Return to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _pauseResume() {
    if (_progress?.isPaused ?? false) {
      _torrentService.resumeDownload();
    } else {
      _torrentService.pauseDownload();
    }
  }

  void _cancelDownload() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Download?'),
        content: const Text(
          'Are you sure you want to cancel this torrent download?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              _torrentService.stopDownload();
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to previous screen
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Service cleanup is handled by the service itself
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isDownloading,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _isDownloading) {
          _cancelDownload();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Torrent Download'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _isDownloading
                ? _cancelDownload
                : () => Navigator.pop(context),
          ),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_errorMessage != null) {
      return _buildErrorView();
    }

    if (_progress == null) {
      return _buildLoadingView();
    }

    return _buildProgressView();
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'Initializing torrent download...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            widget.romName,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 24),
              Text(
                'Download Failed',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: SelectableText(
                  _errorMessage ?? 'Unknown error',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Go Back'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _startDownload,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressView() {
    final progress = _progress!;
    final percentage = (progress.progress * 100).toStringAsFixed(1);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ROM Name
          Text(
            widget.romName,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),

          // Progress Circle
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: progress.progress,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey.withValues(alpha: 0.2),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$percentage%',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        progress.isPaused ? 'Paused' : 'Downloading',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Statistics Cards
          _buildStatCard(
            'Downloaded',
            _formatBytes(progress.downloadedBytes),
            Icons.download,
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            'Total Size',
            _formatBytes(progress.totalBytes),
            Icons.storage,
            Colors.purple,
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            'Download Speed',
            '${_formatBytes(progress.downloadSpeed)}/s',
            Icons.speed,
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            'Upload Speed',
            '${_formatBytes(progress.uploadSpeed)}/s',
            Icons.upload,
            Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            'Peers',
            '${progress.connectedPeers}',
            Icons.people,
            Colors.teal,
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            'Time Remaining',
            progress.timeRemaining,
            Icons.timer,
            Colors.red,
          ),
          const SizedBox(height: 32),

          // Control Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isDownloading ? _pauseResume : null,
                  icon: Icon(
                    progress.isPaused ? Icons.play_arrow : Icons.pause,
                  ),
                  label: Text(progress.isPaused ? 'Resume' : 'Pause'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _cancelDownload,
                  icon: const Icon(Icons.close),
                  label: const Text('Cancel'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
