import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/rom_item.dart';
import '../../models/media.dart';
import '../../services/media_service.dart';
import '../../widgets/common/info_row.dart';
import '../../widgets/common/placeholder_image.dart';
import '../../widgets/roms/media_carousel.dart';
import '../../widgets/roms/folder_widget.dart';

class RomsCarouselView extends StatelessWidget {
  final List<RomItem> items;
  final int currentIndex;
  final ScrollController scrollController;
  final FocusNode focusNode;
  final Function(RomItem) onFolderTap;
  final Function(RomItem) onRomLaunch;
  final Function(KeyEvent) onKeyEvent;
  final Map<String, RomMedia> mediaCache;
  final MediaService mediaService;
  final Function(RomItem) onLoadMedia;
  final Function(int) onCardTap;
  final bool showNavigationHint;

  const RomsCarouselView({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.scrollController,
    required this.focusNode,
    required this.onFolderTap,
    required this.onRomLaunch,
    required this.onKeyEvent,
    required this.mediaCache,
    required this.mediaService,
    required this.onLoadMedia,
    required this.onCardTap,
    required this.showNavigationHint,
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
    final item = items[currentIndex];

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
      onLoadMedia(item);
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

    final media = mediaCache[item.name];
    final isLocalFile = item.downloadUrl == null || item.downloadUrl!.isEmpty;

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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.displayName,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      InfoRow(label: 'Description', value: 'No description available for this ROM.'),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => onRomLaunch(item),
                          icon: Icon(
                            isLocalFile ? Icons.play_arrow : Icons.download,
                          ),
                          label: Text(
                            isLocalFile ? 'Launch' : 'Download & Launch',
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
              final isSelected = index == currentIndex;
              return _buildCarouselCard(context, item, isSelected, index);
            },
          ),
          // Position indicator
          Positioned(
            bottom: 8,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${currentIndex + 1} / ${items.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
      onLoadMedia(item);
    }

    final media = mediaCache[item.name];
    final imagePath = media != null
        ? mediaService.getBestImagePath(media)
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Card(
          clipBehavior: Clip.antiAlias,
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
            onTap: () => onCardTap(index),
            child: Column(
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
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
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
