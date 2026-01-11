import 'package:flutter/material.dart';
import 'package:forsaken/models/rom_item.dart';
import 'package:forsaken/models/media.dart';
import 'package:forsaken/models/game_info.dart';
import 'package:forsaken/screens/pdf_viewer_screen.dart';
import 'package:forsaken/widgets/roms/media_carousel.dart';
import 'package:forsaken/widgets/common/placeholder_image.dart';
import 'package:forsaken/widgets/common/info_row.dart';

/// Dialog showing detailed information about a ROM
class RomDetailDialog extends StatelessWidget {
  final RomItem item;
  final RomMedia? media;
  final GameInfo? gameInfo;
  final VoidCallback onPlay;

  const RomDetailDialog({
    super.key,
    required this.item,
    required this.media,
    required this.gameInfo,
    required this.onPlay,
  });

  /// Show ROM detail dialog
  static Future<void> show({
    required BuildContext context,
    required RomItem item,
    required RomMedia? media,
    required GameInfo? gameInfo,
    required VoidCallback onPlay,
    required VoidCallback onClose,
  }) {
    return showDialog(
      context: context,
      builder: (context) => RomDetailDialog(
        item: item,
        media: media,
        gameInfo: gameInfo,
        onPlay: onPlay,
      ),
    ).then((_) => onClose());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 700),
        child: Column(
          children: [
            // Header
            AppBar(
              title: Text(gameInfo?.name ?? item.displayName),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
              automaticallyImplyLeading: false,
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Media carousel or placeholder
                    if (media != null)
                      MediaCarousel(media: media!, height: 400)
                    else
                      const Center(child: PlaceholderImage(size: 300)),
                    const SizedBox(height: 16),

                    // Description
                    InfoRow(
                      label: 'Description',
                      value:
                          gameInfo?.desc ??
                          'No description available for this ROM.',
                    ),
                    const SizedBox(height: 16),

                    // Release date and developer
                    Row(
                      children: [
                        Expanded(
                          child: InfoRow(
                            label: 'Release Date',
                            value:
                                gameInfo?.releaseDate?.toString().split(
                                  ' ',
                                )[0] ??
                                '',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InfoRow(
                            label: 'Developer',
                            value: gameInfo?.developer ?? '',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Publisher and genre
                    Row(
                      children: [
                        Expanded(
                          child: InfoRow(
                            label: 'Publisher',
                            value: gameInfo?.publisher ?? '',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InfoRow(
                            label: 'Genre',
                            value: gameInfo?.genre ?? '',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Players and rating
                    Row(
                      children: [
                        Expanded(
                          child: InfoRow(
                            label: 'Players',
                            value: gameInfo?.playersText ?? '',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InfoRow(
                            label: 'Rating',
                            value: gameInfo?.ratingPercentage ?? '--',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Manual button (if manual PDF exists)
                  if (media?.manualPath != null &&
                      media!.manualPath!.toLowerCase().endsWith('.pdf'))
                    ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfViewerScreen(
                              pdfPath: media!.manualPath!,
                              title: '${item.displayName} - Manual',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.menu_book),
                      label: const Text('View Manual'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  // Right side buttons
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          onPlay();
                        },
                        icon: const Icon(Icons.gamepad),
                        label: const Text('Play'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ],
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
