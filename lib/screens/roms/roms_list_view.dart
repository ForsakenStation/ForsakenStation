import 'package:forsaken/models/game_info.dart';
import 'package:flutter/material.dart';
import '../../models/rom_item.dart';
import '../../models/media.dart';
import '../../services/media_service.dart';
import '../../widgets/roms/folder_widget.dart';
import '../../widgets/roms/rom_list_card.dart';
import '../../widgets/roms/rom_detail_panel.dart';

class RomsListView extends StatelessWidget {
  final List<RomItem> items;
  final int selectedIndex;
  final ScrollController scrollController;
  final FocusNode focusNode;
  final Function(int index) onItemTap;
  final Function(KeyEvent) onKeyEvent;
  final Map<String, RomMedia> mediaCache;
  final MediaService mediaService;
  final Function(RomItem) loadMediaForItem;
  final Function(RomItem) onRomLaunch;
  final Function(RomItem) showRomDetailDialog;
  final Future<void> Function(RomItem item) loadGameInfoForItem;
  final Map<String, GameInfo> gameInfoCache;
  final Future<bool> Function(RomItem)? isRomDownloaded;
  final bool isCollection; // Show platform info for collection views

  const RomsListView({
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
    required this.onRomLaunch,
    required this.showRomDetailDialog,
    required this.loadGameInfoForItem,
    required this.gameInfoCache,
    this.isRomDownloaded,
    this.isCollection = false,
  });

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 800;
    RomItem? selectedRom = items[selectedIndex];

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Focus(
            focusNode: focusNode,
            autofocus: true,
            onKeyEvent: (node, event) => onKeyEvent(event),
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: items.length,
              itemExtent: 56.0,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = index == selectedIndex;
                return _buildListItem(
                  context,
                  index,
                  item,
                  isSelected,
                  isWideScreen,
                );
              },
            ),
          ),
        ),
        isWideScreen
            ? const VerticalDivider(width: 1)
            : const SizedBox.shrink(),
        isWideScreen
            ? Expanded(flex: 2, child: _buildDetailPanel(selectedRom, context))
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildListItem(
    BuildContext context,
    int index,
    RomItem item,
    bool isSelected,
    bool isWideScreen,
  ) {
    // Handle folder items separately
    if (item.isFolder) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        elevation: isSelected ? 8 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isSelected
              ? BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                )
              : BorderSide.none,
        ),
        color: isSelected
            ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
            : null,
        child: ListTile(
          leading: FolderWidget(
            width: 60,
            height: 60,
            iconSize: 60,
            borderRadius: 4,
          ),
          title: Text(
            item.displayName,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
          onTap: () =>
              isWideScreen ? onItemTap(index) : showRomDetailDialog(item),
        ),
      );
    }

    // Use RomListCard for ROM items
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: RomListCard(
        item: item,
        isSelected: isSelected,
        onTap: () =>
            isWideScreen ? onItemTap(index) : showRomDetailDialog(item),
        media: mediaCache[item.name],
        mediaService: mediaService,
        isRomDownloaded: isRomDownloaded,
        isLoading: false,
        showPlatform: isCollection,
      ),
    );
  }

  Widget _buildDetailPanel(RomItem item, BuildContext context) {
    return RomDetailPanel(
      key: ValueKey(item.path), // Force rebuild when item changes
      item: item,
      media: mediaCache[item.name],
      gameInfo: gameInfoCache[item.name],
      onLaunch: () => onRomLaunch(item),
      onLoadMedia: () => loadMediaForItem(item),
      onLoadGameInfo: () => loadGameInfoForItem(item),
      showMediaCarousel: true,
      mediaHeight: 300,
    );
  }
}
