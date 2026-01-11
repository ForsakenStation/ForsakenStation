import 'package:flutter/material.dart';
import '../../models/rom_item.dart';
import '../../models/media.dart';
import '../../services/media_service.dart';
import '../../widgets/roms/folder_widget.dart';
import '../../widgets/roms/rom_card.dart';

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
  final bool isCollection; // Show platform info for collection views

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
    this.isCollection = false,
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

    // Don't load media eagerly - let the debouncing system handle it
    // Only use cache if it exists
    RomItem? selectedRom = items[selectedIndex];

    final media = mediaCache[item.name];
    final isSelected = selectedRom == item;

    return RomCard(
      item: item,
      isSelected: index == selectedIndex,
      onTap: () => onItemTap(index, item),
      media: mediaCache[item.name],
      mediaService: mediaService,
      isRomDownloaded: isRomDownloaded,
      showPlatform: isCollection,
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
}
