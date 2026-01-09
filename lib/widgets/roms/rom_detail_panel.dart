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

class RomDetailPanel extends StatefulWidget {
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
  State<RomDetailPanel> createState() => _RomDetailPanelState();
}

class _RomDetailPanelState extends State<RomDetailPanel> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(RomDetailPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload data if the item changed
    if (oldWidget.item.path != widget.item.path) {
      _loadData();
    }
  }

  void _loadData() {
    // Trigger media loading if callback provided and media not loaded
    if (widget.media == null && widget.onLoadMedia != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onLoadMedia!();
        }
      });
    }

    // Trigger game info loading if callback provided and info not loaded
    if (widget.gameInfo == null && widget.onLoadGameInfo != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onLoadGameInfo!();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // If item is a folder, show simplified view
    if (widget.item.isFolder) {
      return _buildFolderDetailPanel(context);
    }

    // Otherwise, show full ROM details
    return _buildRomDetailPanel(context);
  }

  Widget _buildFolderDetailPanel(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder,
                  size: 100,
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.item.displayName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                if (widget.item.romCount != null) ...[
                  Text(
                    '${widget.item.romCount} ROM${widget.item.romCount == 1 ? '' : 's'}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        // Fixed Open button at bottom
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
                onPressed: widget.onLaunch,
                icon: const Icon(Icons.folder_open),
                label: const Text('Open Folder'),
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

  Widget _buildRomDetailPanel(BuildContext context) {
    return Column(
      children: [
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Media carousel (optional)
                if (widget.showMediaCarousel) ...[
                  if (widget.media != null)
                    MediaCarousel(
                      key: ValueKey(
                        '${widget.item.name}_${widget.media!.romName}_carousel',
                      ),
                      media: widget.media!,
                      height: widget.mediaHeight!,
                    )
                  else
                    Center(child: PlaceholderImage(size: 200)),
                  const SizedBox(height: 24),
                ],

                // ROM Name
                Text(
                  widget.gameInfo?.name ?? widget.item.displayName,
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
                    if (widget.gameInfo?.rating != null)
                      StarRating(
                        rating: widget.gameInfo!.rating,
                        size: 20,
                        showRatingText: true,
                      ),
                    // ROM tags (from ROM filename)
                    if (widget.item.tags != null)
                      RomTagBadges(romTags: widget.item.tags, fontSize: 11),
                  ],
                ),
                const SizedBox(height: 16),

                // Description
                InfoRow(
                  label: 'Description',
                  value:
                      widget.gameInfo?.desc ??
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
                            widget.gameInfo?.releaseDate?.toString().split(
                              ' ',
                            )[0] ??
                            '',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InfoRow(
                        label: 'Developer',
                        value: widget.gameInfo?.developer ?? '',
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
                        value: widget.gameInfo?.publisher ?? '',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InfoRow(
                        label: 'Genre',
                        value: widget.gameInfo?.genre ?? '',
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
                          LanguageFlags(
                            languageInfo: widget.item.languages,
                            size: 24,
                          ),
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
                          RegionFlags(
                            regionInfo: widget.item.regions,
                            size: 20,
                          ),
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
                        value: widget.gameInfo?.playersText ?? '',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InfoRow(
                        label: 'Rating',
                        value: widget.gameInfo?.ratingPercentage ?? '--',
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
                onPressed: widget.onLaunch,
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
