import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/rom_item.dart';
import '../../models/media.dart';
import '../../services/media_service.dart';
import '../../widgets/roms/folder_widget.dart';

class RomsGridView extends StatelessWidget {
  final List<RomItem> items;
  final int selectedIndex;
  final ScrollController scrollController;
  final FocusNode focusNode;
  final Function(int index, RomItem) onItemTap;
  final Function(KeyEvent) onKeyEvent;
  final Map<String, RomMedia> mediaCache;
  final MediaService mediaService;
  final Function(RomItem) loadMediaForItem;
  final Future<bool> Function(RomItem)? isRomDownloaded;
  final String platformName;

  const RomsGridView({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.scrollController,
    required this.focusNode,
    required this.onItemTap,
    required this.onKeyEvent,
    required this.mediaCache,
    required this.mediaService,
    required this.loadMediaForItem,
    this.isRomDownloaded,
    required this.platformName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Focus(
        focusNode: focusNode,
        autofocus: true,
        onKeyEvent: (node, event) => onKeyEvent(event),
        child: GridView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _calculateCrossAxisCount(context),
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _buildGridCard(context, index, item);
          },
        ),
      ),
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 6;
    if (width > 900) return 5;
    if (width > 600) return 4;
    if (width > 400) return 3;
    return 2;
  }

  Widget _buildGridCard(BuildContext context, int index, RomItem item) {
    if (item.isFolder) {
      return _buildFolderCard(context, index, item);
    }
    if (!mediaCache.containsKey(item.name)) {
      loadMediaForItem(item);
    }
    RomItem? selectedRom = items[selectedIndex];

    final media = mediaCache[item.name];
    final imagePath = media != null
        ? mediaService.getBestImagePath(media)
        : null;
    final isSelected = selectedRom == item;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: isSelected ? 8 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 3)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => onItemTap(index, item),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: imagePath != null
                      ? Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholderImage(context, null);
                          },
                        )
                      : _buildPlaceholderImage(context, null),
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
              FutureBuilder<bool>(
                future: isRomDownloaded!(item),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data == true) {
                    return Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
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
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFolderCard(BuildContext context, index, RomItem item) {
    RomItem? selectedRom = items[selectedIndex];
    final isSelected = selectedRom == item;

    return Card(
      elevation: isSelected ? 8 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 3)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => onItemTap(index, item),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FolderWidget(width: 64, height: 64, iconSize: 64),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                item.displayName,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(BuildContext context, double? size) {
    return Container(
      width: size,
      height: size,
      color: Colors.grey[300],
      child: Icon(
        Icons.videogame_asset,
        size: size != null ? size * 0.5 : 48,
        color: Colors.grey[600],
      ),
    );
  }
}
