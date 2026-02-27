import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/rom_item.dart';
import '../../models/media.dart';
import '../../services/media_service.dart';
import '../common/download_badge.dart';
import '../common/placeholder_image.dart';

/// Reusable ROM card widget for grid and carousel views
class RomGridCard extends StatefulWidget {
  final RomItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final RomMedia? media;
  final MediaService mediaService;
  final Future<bool> Function(RomItem)? isRomDownloaded;
  final double? width;
  final double? height;
  final bool showPlatform; // Show platform info for collection views

  const RomGridCard({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
    this.media,
    required this.mediaService,
    this.isRomDownloaded,
    this.width,
    this.height,
    this.showPlatform = false,
  });

  @override
  State<RomGridCard> createState() => _RomGridCardState();
}

class _RomGridCardState extends State<RomGridCard> {
  Future<bool>? _downloadFuture;

  @override
  void initState() {
    super.initState();
    _updateDownloadFuture();
  }

  @override
  void didUpdateWidget(RomGridCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item != widget.item ||
        oldWidget.isRomDownloaded != widget.isRomDownloaded) {
      _updateDownloadFuture();
    }
  }

  void _updateDownloadFuture() {
    if (widget.isRomDownloaded != null &&
        widget.item.downloadUrl != null &&
        widget.item.downloadUrl!.isNotEmpty) {
      _downloadFuture = widget.isRomDownloaded!(widget.item);
    } else {
      _downloadFuture = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imagePath = widget.media != null
        ? widget.mediaService.getBestImagePath(widget.media!)
        : null;

    final cardContent = Card(
      clipBehavior: Clip.antiAlias,
      elevation: widget.isSelected ? 8 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: widget.isSelected
            ? BorderSide(color: theme.colorScheme.primary, width: 3)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: widget.onTap,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: imagePath != null
                      ? Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                          cacheWidth: 300,
                          cacheHeight: 400,
                          errorBuilder: (context, error, stackTrace) {
                            return const PlaceholderImage(size: null);
                          },
                        )
                      : const PlaceholderImage(size: null),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        widget.item.displayName,
                        maxLines:
                            widget.showPlatform && widget.item.platform != null
                            ? 1
                            : 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      if (widget.showPlatform &&
                          widget.item.platform != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.item.platform!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                            color: theme.textTheme.bodySmall?.color?.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (_downloadFuture != null)
              Positioned(
                top: 8,
                right: 8,
                child: DownloadBadge(future: _downloadFuture!),
              ),
          ],
        ),
      ),
    );

    if (widget.width != null || widget.height != null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: cardContent,
      );
    }

    return cardContent;
  }
}
