import 'package:forsaken/models/game_info.dart';
import 'package:flutter/material.dart';
import '../../models/rom_item.dart';
import '../../models/media.dart';
import '../../services/media_service.dart';
import '../../widgets/common/placeholder_image.dart';
import '../../widgets/roms/media_carousel.dart';
import '../../widgets/roms/folder_widget.dart';
import '../../widgets/roms/rom_detail_panel.dart';
import '../../widgets/roms/rom_card.dart';

class RomsCarouselView extends StatelessWidget {
  final List<RomItem> items;
  final int selectedIndex;
  final ScrollController scrollController;
  final FocusNode focusNode;
  final Function(RomItem) onFolderTap;
  final Function(RomItem) onRomLaunch;
  final Function(KeyEvent) onKeyEvent;
  final Map<String, RomMedia> mediaCache;
  final MediaService mediaService;
  final Function(RomItem) loadMediaForItem;
  final Function(int) onCardTap;
  final bool showNavigationHint;
  final Future<void> Function(RomItem item) loadGameInfoForItem;
  final Map<String, GameInfo> gameInfoCache;
  final Future<bool> Function(RomItem)? isRomDownloaded;

  const RomsCarouselView({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.scrollController,
    required this.focusNode,
    required this.onFolderTap,
    required this.onRomLaunch,
    required this.onKeyEvent,
    required this.mediaCache,
    required this.mediaService,
    required this.loadMediaForItem,
    required this.onCardTap,
    required this.showNavigationHint,
    required this.loadGameInfoForItem,
    required this.gameInfoCache,
    this.isRomDownloaded,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Focus(
        focusNode: focusNode,
        autofocus: true,
        onKeyEvent: (node, event) => onKeyEvent(event),
        child: Column(
          children: [
            Expanded(flex: 2, child: _buildDetailPanel(context)),
            SizedBox(height: 280, child: _buildCarouselCards(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailPanel(BuildContext context) {
    final item = items[selectedIndex];
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (item.isFolder) {
      return Center(
        key: ValueKey('folder_${item.path}'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FolderWidget(
              width: 128,
              height: 128,
              iconSize: 128,
              borderRadius: 16,
            ),
            const SizedBox(height: 24),
            Text(
              item.displayName,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => onFolderTap(item),
              icon: const Icon(Icons.folder_open),
              label: const Text('Open Folder'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Trigger lazy loading of media
    if (!mediaCache.containsKey(item.name)) {
      loadMediaForItem(item);
      return Center(
        key: ValueKey('loading_${item.path}'),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading media...'),
          ],
        ),
      );
    }
    loadGameInfoForItem(item);
    final media = mediaCache[item.name];
    final gameInfo = gameInfoCache[item.name];

    // Mobile layout: vertical (image, details, play button)
    if (isMobile) {
      return _buildMobileDetailPanel(context, item, media, gameInfo);
    }

    // Desktop layout: horizontal (media left, details right)
    return LayoutBuilder(
      key: ValueKey('detail_${item.path}'),
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight - 128;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: media != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MediaCarousel(
                          key: ValueKey('carousel_${item.path}'),
                          media: media,
                          height: availableHeight,
                        ),
                      )
                    : Center(child: PlaceholderImage(size: 300)),
              ),
              Expanded(
                flex: 2,
                child: RomDetailPanel(
                  item: item,
                  media: media,
                  gameInfo: gameInfo,
                  onLaunch: () => onRomLaunch(item),
                  onLoadMedia: () => loadMediaForItem(item),
                  onLoadGameInfo: () => loadGameInfoForItem(item),
                  showMediaCarousel: false, // Media shows on left side
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobileDetailPanel(
    BuildContext context,
    RomItem item,
    RomMedia? media,
    GameInfo? gameInfo,
  ) {
    return Column(
      key: ValueKey('mobile_detail_${item.path}'),
      children: [
        // Media carousel at top
        Expanded(
          flex: 3,
          child: media != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MediaCarousel(
                    key: ValueKey('carousel_${item.path}'),
                    media: media,
                    height: double.infinity,
                  ),
                )
              : Center(child: PlaceholderImage(size: 200)),
        ),

        // Scrollable details in middle (without Play button)
        Expanded(
          flex: 2,
          child: RomDetailPanel(
            item: item,
            media: media,
            gameInfo: gameInfo,
            onLaunch: () => onRomLaunch(item),
            onLoadMedia: () => loadMediaForItem(item),
            onLoadGameInfo: () => loadGameInfoForItem(item),
            showMediaCarousel: false, // Media shows above
            showPlayButton: false, // Hide Play button, we'll show it below
          ),
        ),

        // Centered Play button at bottom
        SafeArea(
          top: false,
          child: Center(
            child: SizedBox(
              width: 200, // Fixed width for centered appearance
              child: ElevatedButton.icon(
                onPressed: () => onRomLaunch(item),
                icon: const Icon(Icons.gamepad),
                label: const Text('Play'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselCards(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Stack(
        children: [
          ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = index == selectedIndex;
              return _buildCarouselCard(context, item, isSelected, index);
            },
          ),
          // Navigation hint
          if (showNavigationHint)
            Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Use arrow keys or swipe to navigate',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCarouselCard(
    BuildContext context,
    RomItem item,
    bool isSelected,
    int index,
  ) {
    const cardWidth = 180.0;
    const cardHeight = cardWidth / 0.7;

    if (item.isFolder) {
      return _buildFolderCard(context, item, isSelected, cardWidth, cardHeight);
    }

    // Trigger lazy loading of media
    if (!mediaCache.containsKey(item.name)) {
      loadMediaForItem(item);
    }

    final media = mediaCache[item.name];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: RomCard(
        item: item,
        isSelected: isSelected,
        onTap: () => onCardTap(index),
        media: media,
        mediaService: mediaService,
        isRomDownloaded: isRomDownloaded,
        width: cardWidth,
        height: cardHeight,
      ),
    );
  }

  Widget _buildFolderCard(
    BuildContext context,
    RomItem item,
    bool isSelected,
    double cardWidth,
    double cardHeight,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Card(
          elevation: isSelected ? 8 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isSelected
                ? BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3,
                  )
                : BorderSide.none,
          ),
          child: InkWell(
            onTap: () => onFolderTap(item),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FolderWidget(width: 64, height: 64, iconSize: 64),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      item.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
