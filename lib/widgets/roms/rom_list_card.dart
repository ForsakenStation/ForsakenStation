import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/rom_item.dart';
import '../../models/media.dart';
import '../../services/media_service.dart';

/// ROM card widget for list view (horizontal layout)
///
/// Displays a ROM with:
/// - Thumbnail on left
/// - Title and platform info in center
/// - Media indicators (if available)
/// - Play/folder icon on right
/// - Download status badge (if applicable)
class RomListCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 8 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isSelected
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 3)
            : BorderSide.none,
      ),
      color: isSelected
          ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
          : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      item.displayName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (showPlatform && item.platform != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.platform!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                    ],
                  ],
                ),
              ),
              if (!item.isFolder && !showPlatform) ...[
                const SizedBox(width: 8),
                _buildMediaIndicators(),
              ],
              Icon(
                item.isFolder ? Icons.chevron_right : Icons.play_arrow,
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    // Show loading spinner
    if (isLoading) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[300],
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

    final imagePath = media != null
        ? mediaService.getBestImagePath(media!)
        : null;

    // Stack for image + download badge
    return Stack(
      children: [
        // Thumbnail image or placeholder
        if (imagePath != null && File(imagePath).existsSync())
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.file(
              File(imagePath),
              width: 60,
              height: 60,
              cacheWidth: 120, // 2x for retina displays
              cacheHeight: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _defaultThumbnail();
              },
            ),
          )
        else
          _defaultThumbnail(),

        // Download badge
        if (!item.isFolder &&
            item.downloadUrl != null &&
            item.downloadUrl!.isNotEmpty &&
            isRomDownloaded != null)
          Positioned(
            top: 0,
            right: 0,
            child: FutureBuilder<bool>(
              future: isRomDownloaded!(item),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == true) {
                  return Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.cloud_done,
                      color: Colors.white,
                      size: 14,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
      ],
    );
  }

  Widget _defaultThumbnail() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Icon(Icons.games, size: 30, color: Colors.grey),
    );
  }

  Widget _buildMediaIndicators() {
    if (media == null || !media!.hasAnyMedia) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (media!.box3d?.exists ?? false)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(Icons.view_in_ar, size: 16, color: Colors.purple),
          ),
        if (media!.cover?.exists ?? false)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(Icons.image, size: 16, color: Colors.blue),
          ),
        if (media!.marquee?.exists ?? false)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(Icons.rectangle, size: 16, color: Colors.indigo),
          ),
        if (media!.screenshot?.exists ?? false)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(Icons.photo_camera, size: 16, color: Colors.green),
          ),
        if (media!.mixImage?.exists ?? false)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(Icons.collections, size: 16, color: Colors.teal),
          ),
        if (media!.video?.exists ?? false)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(Icons.videocam, size: 16, color: Colors.orange),
          ),
      ],
    );
  }
}
