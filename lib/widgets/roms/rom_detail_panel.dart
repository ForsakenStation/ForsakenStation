import 'package:flutter/material.dart';
import '../../models/rom_item.dart';
import '../../models/media.dart';
import 'media_carousel.dart';
import '../common/placeholder_image.dart';
import '../common/info_row.dart';

/// A detailed panel showing ROM information with media carousel and launch button
class RomDetailPanel extends StatelessWidget {
  final RomItem item;
  final RomMedia? media;
  final VoidCallback onLaunch;
  final VoidCallback? onLoadMedia;

  const RomDetailPanel({
    super.key,
    required this.item,
    required this.media,
    required this.onLaunch,
    this.onLoadMedia,
  });

  @override
  Widget build(BuildContext context) {
    // Trigger media loading if callback provided and media not loaded
    if (media == null && onLoadMedia != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onLoadMedia!();
      });
    }

    final isLocalFile = item.downloadUrl == null || item.downloadUrl!.isEmpty;

    return SingleChildScrollView(
      key: ValueKey(item.path), // Force rebuild when ROM changes
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Media carousel
          if (media != null)
            MediaCarousel(
              key: ValueKey('${item.path}_carousel'),
              media: media!,
              height: 300,
            )
          else
            Center(child: PlaceholderImage(size: 200)),
          const SizedBox(height: 24),
          // ROM Name
          Text(
            item.displayName,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Type
          InfoRow(
            label: 'Type',
            value: isLocalFile ? 'Local File' : 'Download URL',
          ),
          const SizedBox(height: 8),
          // Path/URL
          InfoRow(
            label: isLocalFile ? 'Path' : 'Download URL',
            value: isLocalFile ? item.path : item.downloadUrl!,
          ),
          const SizedBox(height: 24),
          // Launch button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onLaunch,
              icon: Icon(isLocalFile ? Icons.play_arrow : Icons.download),
              label: Text(isLocalFile ? 'Launch' : 'Download & Launch'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
