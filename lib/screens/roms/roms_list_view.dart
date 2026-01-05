import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/rom_item.dart';
import '../../models/media.dart';
import '../../services/media_service.dart';
import '../../widgets/roms/folder_widget.dart';
import '../../widgets/common/placeholder_image.dart';
import '../../widgets/roms/media_carousel.dart';

class RomsListView extends StatelessWidget {
  final List<RomItem> items;
  final int selectedIndex;
  final ScrollController scrollController;
  final FocusNode focusNode;
  final Function(int index) onItemTap;
  final Function(KeyEvent) onKeyEvent;
  final Map<String, RomMedia> mediaCache;
  final MediaService mediaService;
  final Function(RomItem) onLoadMedia;
  final Function(RomItem) onRomLaunch;
  final Function(RomItem) showRomDetailDialog;

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
    required this.onLoadMedia,
    required this.onRomLaunch,
    required this.showRomDetailDialog,
  });

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 800;
    RomItem? selectedRom = items[selectedIndex];

    return Padding(
      padding: EdgeInsets.only(top: 48),
      child: Row(
        children: [
          Expanded(
            flex: isWideScreen ? 3 : 5,
            child: Focus(
              focusNode: focusNode,
              autofocus: true,
              onKeyEvent: (node, event) => onKeyEvent(event),
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(8),
                itemCount: items.length,
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
              ? Expanded(
                  flex: 2,
                  child: _buildDetailPanel(selectedRom, context),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildListItem(
    BuildContext context,
    int index,
    RomItem item,
    bool isSelected,
    bool isWideScreen,
  ) {
    if (item.isRom && !mediaCache.containsKey(item.name)) {
      onLoadMedia(item);
    }

    final media = mediaCache[item.name];
    final imagePath = media != null
        ? mediaService.getBestImagePath(media)
        : null;
    final isLocalFile = item.downloadUrl == null || item.downloadUrl!.isEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: isSelected ? 8 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isSelected
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 3)
            : BorderSide.none,
      ),
      color: isSelected
          ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
          : null,
      child: ListTile(
        leading: item.isFolder
            ? FolderWidget(width: 60, height: 60, iconSize: 60, borderRadius: 4)
            : _buildThumbnail(context, imagePath),
        title: Text(
          item.displayName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: Icon(
          item.isFolder
              ? Icons.chevron_right
              : (isLocalFile ? Icons.play_arrow : Icons.download),
          color: Colors.grey[600],
        ),
        onTap: () =>
            isWideScreen ? onItemTap(index) : showRomDetailDialog(item),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context, String? imagePath) {
    if (imagePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.file(
          File(imagePath),
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return PlaceholderImage(size: 60);
          },
        ),
      );
    }
    return PlaceholderImage(size: 60);
  }

  Widget _buildDetailPanel(RomItem item, BuildContext context) {
    // Trigger media loading if not loaded
    if (!mediaCache.containsKey(item.name)) {
      onLoadMedia(item);
    }

    final media = mediaCache[item.name];
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
              media: media,
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
          _buildInfoRow('Type', isLocalFile ? 'Local File' : 'Download URL'),
          const SizedBox(height: 8),
          // Path/URL
          _buildInfoRow(
            isLocalFile ? 'Path' : 'Download URL',
            isLocalFile ? item.path : item.downloadUrl!,
          ),
          const SizedBox(height: 24),
          // Launch button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => onRomLaunch(item),
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

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
