import 'package:flutter/material.dart';
import 'package:forsaken/services/torrent_download_manager.dart';
import 'package:forsaken/models/torrent_download.dart';

class TorrentDownloadManagerScreen extends StatefulWidget {
  const TorrentDownloadManagerScreen({super.key});

  @override
  State<TorrentDownloadManagerScreen> createState() =>
      _TorrentDownloadManagerScreenState();
}

class _TorrentDownloadManagerScreenState
    extends State<TorrentDownloadManagerScreen> {
  final _manager = TorrentDownloadManager.instance;

  @override
  void initState() {
    super.initState();
    _manager.addListener(_onManagerUpdate);
  }

  @override
  void dispose() {
    _manager.removeListener(_onManagerUpdate);
    super.dispose();
  }

  void _onManagerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final downloads = _manager.downloads;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Torrent Downloads'),
        actions: [
          // Clear completed button
          if (_manager.completedDownloads.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              tooltip: 'Clear completed',
              onPressed: () => _clearCompleted(),
            ),
        ],
      ),
      body: downloads.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: downloads.length,
              itemBuilder: (context, index) {
                return _buildDownloadCard(downloads[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_download_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'No torrent downloads',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Downloads will appear here',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadCard(TorrentDownload download) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and status
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        download.romName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildStatusChip(download),
                          const SizedBox(width: 8),
                          Text(
                            _formatBytes(download.downloadedBytes) +
                                ' / ' +
                                _formatBytes(download.totalBytes),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildActionButtons(download),
              ],
            ),
            const SizedBox(height: 12),

            // Progress bar
            if (download.status == TorrentDownloadStatus.downloading ||
                download.status == TorrentDownloadStatus.paused)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: download.progress,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(download.progress * 100).toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        download.timeRemaining,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),

            // Download/Upload speeds
            if (download.status == TorrentDownloadStatus.downloading)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(Icons.download, size: 16, color: Colors.green[700]),
                    const SizedBox(width: 4),
                    Text(
                      '${_formatBytes(download.downloadSpeed)}/s',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.upload, size: 16, color: Colors.blue[700]),
                    const SizedBox(width: 4),
                    Text(
                      '${_formatBytes(download.uploadSpeed)}/s',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.people, size: 16, color: Colors.orange[700]),
                    const SizedBox(width: 4),
                    Text(
                      '${download.connectedPeers} peers',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

            // Error message
            if (download.status == TorrentDownloadStatus.failed &&
                download.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Text(
                    download.errorMessage!,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.red[900]),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(TorrentDownload download) {
    Color color;
    IconData icon;

    switch (download.status) {
      case TorrentDownloadStatus.initializing:
        color = Colors.blue;
        icon = Icons.hourglass_empty;
        break;
      case TorrentDownloadStatus.downloading:
        color = Colors.green;
        icon = Icons.download;
        break;
      case TorrentDownloadStatus.paused:
        color = Colors.orange;
        icon = Icons.pause;
        break;
      case TorrentDownloadStatus.completed:
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case TorrentDownloadStatus.failed:
        color = Colors.red;
        icon = Icons.error;
        break;
      case TorrentDownloadStatus.cancelled:
        color = Colors.grey;
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            download.statusText,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(TorrentDownload download) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Pause/Resume button
        if (download.canPause)
          IconButton(
            icon: const Icon(Icons.pause),
            tooltip: 'Pause',
            onPressed: () => _manager.pauseDownload(download.id),
          ),
        if (download.canResume)
          IconButton(
            icon: const Icon(Icons.play_arrow),
            tooltip: 'Resume',
            onPressed: () => _manager.resumeDownload(download.id),
          ),

        // Cancel button
        if (download.canCancel)
          IconButton(
            icon: const Icon(Icons.stop),
            tooltip: 'Cancel',
            onPressed: () => _confirmCancel(download),
          ),

        // Remove button
        if (download.canRemove)
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Remove',
            onPressed: () => _manager.removeDownload(download.id),
          ),
      ],
    );
  }

  void _confirmCancel(TorrentDownload download) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Download?'),
        content: Text('Are you sure you want to cancel "${download.romName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              _manager.cancelDownload(download.id);
              Navigator.pop(context);
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _clearCompleted() {
    final completed = _manager.completedDownloads;
    for (var download in completed) {
      _manager.removeDownload(download.id);
    }
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
