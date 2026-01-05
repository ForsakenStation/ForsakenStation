import 'package:flutter/material.dart';
import '../../models/rom_item.dart';
import '../../models/media.dart';
import '../../models/game_info.dart';
import 'media_carousel.dart';
import '../common/placeholder_image.dart';
import '../common/info_row.dart';
import '../common/language_flags.dart';
import '../common/star_rating.dart';
import '../common/region_flags.dart';
import '../common/rom_tag_badges.dart';

class RomDetailPanel extends StatelessWidget {
  final RomItem item;
  final RomMedia? media;
  final GameInfo? gameInfo;
  final VoidCallback onLaunch;
  final VoidCallback? onLoadMedia;
  final VoidCallback? onLoadGameInfo;
  final bool showMediaCarousel;
  final double? mediaHeight;

  const RomDetailPanel({
    super.key,
    required this.item,
    required this.media,
    this.gameInfo,
    required this.onLaunch,
    this.onLoadMedia,
    this.onLoadGameInfo,
    this.showMediaCarousel = true,
    this.mediaHeight = 300,
  });

  @override
  Widget build(BuildContext context) {
    // Trigger media loading if callback provided and media not loaded
    if (media == null && onLoadMedia != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onLoadMedia!();
      });
    }

    // Trigger game info loading if callback provided and info not loaded
    if (gameInfo == null && onLoadGameInfo != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onLoadGameInfo!();
      });
    }

    return Column(
      key: ValueKey(item.path), // Force rebuild when ROM changes
      children: [
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Media carousel (optional)
                if (showMediaCarousel) ...[
                  if (media != null)
                    MediaCarousel(
                      key: ValueKey('${item.path}_carousel'),
                      media: media!,
                      height: mediaHeight!,
                    )
                  else
                    Center(child: PlaceholderImage(size: 200)),
                  const SizedBox(height: 24),
                ],

                // ROM Name
                Text(
                  gameInfo?.name ?? item.displayName,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Rating stars, Languages, Regions, and Tags
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Star rating
                    if (gameInfo?.rating != null)
                      StarRating(
                        rating: gameInfo!.rating,
                        size: 20,
                        showRatingText: true,
                      ),
                    // ROM tags (from ROM filename)
                    if (item.tags != null)
                      RomTagBadges(romTags: item.tags, fontSize: 11),
                  ],
                ),
                const SizedBox(height: 16),

                // Description
                InfoRow(
                  label: 'Description',
                  value:
                      gameInfo?.desc ??
                      'No description available for this ROM.',
                ),
                const SizedBox(height: 16),

                // Game info grid - always show fields even if empty

                // Row 1: Release Date, Developer
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InfoRow(
                        label: 'Release Date',
                        value:
                            gameInfo?.releaseDate?.toString().split(' ')[0] ??
                            '',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InfoRow(
                        label: 'Developer',
                        value: gameInfo?.developer ?? '',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Row 2: Publisher, Genre
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InfoRow(
                        label: 'Publisher',
                        value: gameInfo?.publisher ?? '',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InfoRow(
                        label: 'Genre',
                        value: gameInfo?.genre ?? '',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Row 3: Language and regions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Language flags (from ROM filename)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Language',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          LanguageFlags(languageInfo: item.languages, size: 24),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Region flags (from ROM filename)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Regions',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          RegionFlags(regionInfo: item.regions, size: 20),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Row 4: Players, Rating
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InfoRow(
                        label: 'Players',
                        value: gameInfo?.playersText ?? '',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InfoRow(
                        label: 'Rating',
                        value: gameInfo?.ratingPercentage ?? '--',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Fixed Play button at bottom
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onLaunch,
                icon: const Icon(Icons.gamepad),
                label: const Text('Play'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
