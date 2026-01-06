import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/rom_item.dart';
import '../../models/media.dart';
import '../../services/media_service.dart';
import '../common/placeholder_image.dart';

/// Reusable ROM card widget for grid and carousel views
///
/// Displays a ROM with:
/// - Cover image
/// - Title
/// - Download status badge (if applicable)
/// - Selection state
class RomCard extends StatelessWidget {
  final RomItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final RomMedia? media;
  final MediaService mediaService;
  final Future<bool> Function(RomItem)? isRomDownloaded;
  final double? width;
  final double? height;

  const RomCard({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
    this.media,
    required this.mediaService,
    this.isRomDownloaded,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = media != null
        ? mediaService.getBestImagePath(media!)
        : null;

    final cardContent = Card(
      clipBehavior: Clip.antiAlias,
      elevation: isSelected ? 8 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 3)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            // Main content (image + title)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: imagePath != null
                      ? Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return PlaceholderImage(size: null);
                          },
                        )
                      : PlaceholderImage(size: null),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item.displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            // Download indicator badge
            if (item.downloadUrl != null &&
                item.downloadUrl!.isNotEmpty &&
                isRomDownloaded != null)
              _buildDownloadBadge(context),
          ],
        ),
      ),
    );

    // Wrap with size constraints if provided
    if (width != null || height != null) {
      return SizedBox(width: width, height: height, child: cardContent);
    }

    return cardContent;
  }

  Widget _buildDownloadBadge(BuildContext context) {
    return FutureBuilder<bool>(
      future: isRomDownloaded!(item),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.cloud_done,
                color: Colors.white,
                size: 20,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
