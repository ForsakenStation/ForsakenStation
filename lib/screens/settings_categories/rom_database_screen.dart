import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/romlist_download_service.dart';
import '../../services/keyboard_service.dart';

/// Screen for managing ROM database (romLists JSONL lists)
///
/// Allows users to:
/// - View database status
/// - Re-download ROM lists
/// - Clear database
class RomDatabaseScreen extends StatefulWidget {
  const RomDatabaseScreen({super.key});

  @override
  State<RomDatabaseScreen> createState() => _RomDatabaseScreenState();
}

class _RomDatabaseScreenState extends State<RomDatabaseScreen> {
  final _romlistService = RomlistDownloadService.instance;
  final _keyboardService = KeyboardService.instance;
  final _focusNode = FocusNode();

  bool _isLoading = true;
  bool _isDownloaded = false;
  Map<String, dynamic>? _downloadInfo;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  int _downloadReceived = 0;
  int _downloadTotal = 0;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadStatus() async {
    setState(() => _isLoading = true);

    final isDownloaded = await _romlistService.isDownloaded();
    final info = await _romlistService.getDownloadInfo();

    if (mounted) {
      setState(() {
        _isDownloaded = isDownloaded;
        _downloadInfo = info;
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadDatabase() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download ROM Database'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This will download ROM lists from the Forsaken romList repository on GitHub.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Size: ~7 MB\nPlatforms: 138\nTotal ROMs: ~240,000',
              style: TextStyle(fontFamily: 'monospace'),
            ),
            const SizedBox(height: 16),
            if (_isDownloaded)
              const Text(
                'Note: This will overwrite existing data.',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(_isDownloaded ? 'Re-download' : 'Download'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    try {
      final success = await _romlistService.downloadAndExtract(
        onProgress: (progress, received, total) {
          if (mounted) {
            setState(() {
              _downloadProgress = progress;
              _downloadReceived = received;
              _downloadTotal = total;
            });
          }
        },
      );

      if (mounted) {
        setState(() => _isDownloading = false);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('ROM database downloaded successfully'),
              backgroundColor: Colors.green,
            ),
          );
          await _loadStatus();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to download ROM database'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isDownloading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _clearDatabase() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear ROM Database'),
        content: const Text(
          'This will delete all downloaded ROM lists. '
          'You will need to download them again to browse ROMs.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await _romlistService.deleteRomlists();

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ROM database cleared'),
            backgroundColor: Colors.orange,
          ),
        );
        await _loadStatus();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to clear database'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    // Handle back key (Escape, Backspace)
    if (_keyboardService.isBackKey(key)) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) => _handleKeyEvent(event),
      child: Scaffold(
        appBar: AppBar(title: const Text('ROM Database'), centerTitle: true),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _isDownloading
            ? _buildDownloadingView()
            : _buildContentView(),
      ),
    );
  }

  Widget _buildDownloadingView() {
    final progressPercent = (_downloadProgress * 100).toStringAsFixed(1);
    final receivedMB = (_downloadReceived / 1024 / 1024).toStringAsFixed(2);
    final totalMB = (_downloadTotal / 1024 / 1024).toStringAsFixed(2);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              'Downloading ROM Database...',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(value: _downloadProgress),
            const SizedBox(height: 8),
            Text(
              '$progressPercent% - $receivedMB MB / $totalMB MB',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            const Text(
              'This may take a few minutes depending on your connection...',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Status Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _isDownloaded ? Icons.check_circle : Icons.cloud_download,
                      color: _isDownloaded ? Colors.green : Colors.orange,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Database Status',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            _isDownloaded ? 'Downloaded' : 'Not Downloaded',
                            style: TextStyle(
                              color: _isDownloaded
                                  ? Colors.green
                                  : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (_isDownloaded && _downloadInfo != null) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildInfoRow('Platforms', '${_downloadInfo!['fileCount']}'),
                  _buildInfoRow(
                    'Total Size',
                    '${_downloadInfo!['totalSizeMB']} MB',
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Info Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About ROM Database',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                const Text(
                  'The ROM database contains lists of available ROMs organized by platform. '
                  'This data is sourced from the Forsaken romList repository on GitHub.',
                ),
                const SizedBox(height: 12),
                const Text(
                  'Source: github.com/ForsakenStation/romList',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Actions
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _downloadDatabase,
            icon: Icon(_isDownloaded ? Icons.refresh : Icons.download),
            label: Text(
              _isDownloaded ? 'Re-download Database' : 'Download Database',
            ),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
        ),
        if (_isDownloaded) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _clearDatabase,
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              label: const Text(
                'Clear Database',
                style: TextStyle(color: Colors.red),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
