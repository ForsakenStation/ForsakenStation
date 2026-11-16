import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/rom_item.dart';
import '../../models/media.dart';
import '../../services/media_service.dart';
import '../common/download_badge.dart';
import '../common/placeholder_image.dart';
import '../common/platform_badge.dart';

/// ROM card widget for list view (horizontal layout)
///
/// Displays a ROM with:
/// - Thumbnail on left
/// - Title and platform info in center
/// - Media indicators (if available)
/// - Play/folder icon on right
/// - Download status badge (if applicable)
class RomListCard extends StatefulWidget {
  final RomItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final RomMedia? media;
  final MediaService mediaService;
  final Future<bool> Function(RomItem)? isRomDownloaded;
  final bool isLoading;
  final bool showPlatform; // Show platform name for collection views

  const RomListCard({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
    this.media,
    required this.mediaService,
    this.isRomDownloaded,
    this.isLoading = false,
    this.showPlatform = false,
  });

  @override
  State<RomListCard> createState() => _RomListCardState();
}

class _RomListCardState extends State<RomListCard> {
  Future<bool>? _downloadFuture;

  @override
  void initState() {
    super.initState();
    _updateDownloadFuture();
  }

  @override
  void didUpdateWidget(RomListCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item != widget.item ||
        oldWidget.isRomDownloaded != widget.isRomDownloaded) {
      _updateDownloadFuture();
    }
  }

  void _updateDownloadFuture() {
    if (!widget.item.isFolder &&
        widget.isRomDownloaded != null &&
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
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: widget.isSelected
            ? BorderSide(color: Colors.white.withValues(alpha: 0.9), width: 2)
            : BorderSide(color: Colors.white.withValues(alpha: 0.06), width: 1),
      ),
      color: widget.isSelected
          ? Colors.white.withValues(alpha: 0.12)
          : Colors.white.withValues(alpha: 0.03),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            children: [
              _buildThumbnail(context),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.item.displayName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.showPlatform &&
                        widget.item.platform != null) ...[
                      const SizedBox(height: 4),
                      PlatformBadge(
                        platformId: widget.item.platform!,
                        compact: true,
                      ),
                    ],
                  ],
                ),
              ),
              if (!widget.item.isFolder && !widget.showPlatform) ...[
                const SizedBox(width: 8),
                _buildMediaIndicators(),
              ],
              Icon(
                widget.item.isFolder ? Icons.chevron_right : Icons.play_arrow,
                color: theme.iconTheme.color?.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Show loading spinner
    if (widget.isLoading) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    final imagePath = widget.media != null
        ? widget.mediaService.getBestImagePath(widget.media!)
        : null;

    // Stack for image + download badge
    return Stack(
      children: [
        // Thumbnail image or placeholder
        if (imagePath != null && File(imagePath).existsSync())
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(imagePath),
              width: 60,
              height: 60,
              cacheWidth: 120, // 2x for retina displays
              cacheHeight: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _defaultThumbnail(context);
              },
            ),
          )
        else
          _defaultThumbnail(context),

        // Download badge
        if (_downloadFuture != null)
          Positioned(
            top: 0,
            right: 0,
            child: DownloadBadge(future: _downloadFuture!, compact: true),
          ),
      ],
    );
  }

  Widget _defaultThumbnail(BuildContext context) {
    return const PlaceholderImage(size: 60, borderRadius: 8);
  }

  Widget _buildMediaIndicators() {
    if (widget.media == null || !widget.media!.hasAnyMedia) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.media!.box3d?.exists ?? false)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(Icons.view_in_ar, size: 16, color: Colors.purple),
          ),
        if (widget.media!.cover?.exists ?? false)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(Icons.image, size: 16, color: Colors.blue),
          ),
        if (widget.media!.marquee?.exists ?? false)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(Icons.rectangle, size: 16, color: Colors.indigo),
          ),
        if (widget.media!.screenshot?.exists ?? false)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(Icons.photo_camera, size: 16, color: Colors.green),
          ),
        if (widget.media!.mixImage?.exists ?? false)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(Icons.collections, size: 16, color: Colors.teal),
          ),
        if (widget.media!.video?.exists ?? false)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(Icons.videocam, size: 16, color: Colors.orange),
          ),
        if (widget.media!.manual?.exists ?? false)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Icon(
              Icons.picture_as_pdf,
              size: 16,
              color: Colors.red.shade400,
            ),
          ),
      ],
    );
  }
}
