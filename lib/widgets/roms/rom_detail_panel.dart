import 'package:flutter/material.dart';
import 'package:forsaken/widgets/roms/folder_widget.dart';
import 'package:forsaken/models/rom_item.dart';
import 'package:forsaken/models/media.dart';
import 'package:forsaken/models/game_info.dart';
import 'package:forsaken/widgets/roms/media_carousel.dart';
import 'package:forsaken/widgets/common/placeholder_image.dart';
import 'package:forsaken/widgets/common/language_flags.dart';
import 'package:forsaken/widgets/common/star_rating.dart';
import 'package:forsaken/widgets/common/region_flags.dart';
import 'package:forsaken/widgets/common/rom_tag_badges.dart';
import 'package:forsaken/widgets/roms/rom_info_section.dart';

class RomDetailPanel extends StatefulWidget {
  final RomItem item;
  final RomMedia? media;
  final GameInfo? gameInfo;
  final VoidCallback onLaunch;
  final VoidCallback? onFolderTap;
  final VoidCallback? onLoadMedia;
  final VoidCallback? onLoadGameInfo;
  final bool showMediaCarousel;
  final double? mediaHeight;
  final bool showPlayButton;

  const RomDetailPanel({
    super.key,
    required this.item,
    required this.media,
    this.gameInfo,
    required this.onLaunch,
    this.onFolderTap,
    this.onLoadMedia,
    this.onLoadGameInfo,
    this.showMediaCarousel = true,
    this.mediaHeight = 300,
    this.showPlayButton = true,
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
    if (widget.item.isFolder) {
      return _buildFolderDetailPanel(context);
    }

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
                FolderWidget(width: 200, height: 200, iconSize: 200),
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        // Fixed Open button at bottom
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: widget.onFolderTap ?? widget.onLaunch,
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
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    Center(child: PlaceholderImage(size: 100)),
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

                // Game info section (Description, Release Date, Developer, etc.)
                RomInfoSection(gameInfo: widget.gameInfo),
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
              ],
            ),
          ),
        ),

        // Fixed Play button at bottom (only if showPlayButton is true)
        if (widget.showPlayButton)
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
