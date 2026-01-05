import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/rom_item.dart';
import '../../models/emulator_config.dart';
import '../common/placeholder_image.dart';

/// Dialog shown while downloading and launching a ROM
class LaunchProgressDialog extends StatefulWidget {
  final RomItem item;
  final EmulatorCommand command;
  final String? imagePath;
  final bool isDownloading;

  const LaunchProgressDialog({
    super.key,
    required this.item,
    required this.command,
    this.imagePath,
    required this.isDownloading,
  });

  @override
  State<LaunchProgressDialog> createState() => LaunchProgressDialogState();
}

class LaunchProgressDialogState extends State<LaunchProgressDialog> {
  double _progress = 0.0;
  int _receivedBytes = 0;
  int _totalBytes = 0;
  DateTime? _downloadStartTime;
  double _downloadSpeed = 0.0; // bytes per second

  void updateProgress(double progress, int received, int total) {
    setState(() {
      _progress = progress;
      _receivedBytes = received;
      _totalBytes = total;

      // Calculate download speed
      if (_downloadStartTime == null) {
        _downloadStartTime = DateTime.now();
      } else {
        final elapsed = DateTime.now().difference(_downloadStartTime!);
        if (elapsed.inMilliseconds > 0) {
          _downloadSpeed = received / (elapsed.inMilliseconds / 1000.0);
        }
      }
    });
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  String _formatSpeed(double bytesPerSecond) {
    if (bytesPerSecond < 1024) {
      return '${bytesPerSecond.toStringAsFixed(0)} B/s';
    }
    if (bytesPerSecond < 1024 * 1024) {
      return '${(bytesPerSecond / 1024).toStringAsFixed(1)} KB/s';
    }
    return '${(bytesPerSecond / (1024 * 1024)).toStringAsFixed(2)} MB/s';
  }

  String _formatTimeRemaining(int remainingBytes, double bytesPerSecond) {
    if (bytesPerSecond <= 0) return 'Calculating...';

    final seconds = (remainingBytes / bytesPerSecond).ceil();
    if (seconds < 60) return '$seconds seconds';
    if (seconds < 3600) {
      final minutes = (seconds / 60).ceil();
      return '$minutes minute${minutes > 1 ? 's' : ''}';
    }
    final hours = (seconds / 3600).ceil();
    return '$hours hour${hours > 1 ? 's' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth * 0.4; // 40% of screen width
    final minWidth = 400.0;
    final maxWidth = 600.0;
    final width = dialogWidth.clamp(minWidth, maxWidth);

    return Dialog(
      child: Container(
        width: width,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              widget.item.displayName,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),

            // Image
            if (widget.imagePath != null)
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 200,
                  maxWidth: 200,
                ),
                margin: const EdgeInsets.only(bottom: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(widget.imagePath!),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return PlaceholderImage(size: 150);
                    },
                  ),
                ),
              )
            else
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: PlaceholderImage(size: 150),
              ),

            // Progress bar (only for downloads)
            if (widget.isDownloading) ...[
              LinearProgressIndicator(
                value: _progress > 0 ? _progress : null,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 16),

              // Download stats
              if (_totalBytes > 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(_progress * 100).toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_formatBytes(_receivedBytes)} / ${_formatBytes(_totalBytes)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.speed, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          _formatSpeed(_downloadSpeed),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTimeRemaining(
                            _totalBytes - _receivedBytes,
                            _downloadSpeed,
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Status text
              Text(
                'Downloading & Launching...',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ] else ...[
              // No download, just launching
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Launching...',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],

            const SizedBox(height: 16),

            // Emulator info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.videogame_asset, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Emulator: ${widget.command.name}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
