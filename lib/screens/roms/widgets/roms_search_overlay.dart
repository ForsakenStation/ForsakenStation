import 'package:flutter/material.dart';
import '../../../widgets/common/virtual_keyboard.dart';
import '../../../l10n/generated/app_localizations.dart';

class RomsSearchOverlay extends StatelessWidget {
  final bool isSearchMode;
  final bool showVirtualKeyboard;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final Function(String) onSearchChanged;
  final VoidCallback onCancelSearch;
  final VoidCallback onToggleVirtualKeyboard;

  const RomsSearchOverlay({
    super.key,
    required this.isSearchMode,
    required this.showVirtualKeyboard,
    required this.searchController,
    required this.searchFocusNode,
    required this.onSearchChanged,
    required this.onCancelSearch,
    required this.onToggleVirtualKeyboard,
  });

  @override
  Widget build(BuildContext context) {
    if (!isSearchMode) return const SizedBox.shrink();

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.9),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.search, color: Colors.cyan),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    focusNode: searchFocusNode,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.searchGamesHint,
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    onChanged: onSearchChanged,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    showVirtualKeyboard ? Icons.keyboard_hide : Icons.keyboard,
                    color: Colors.grey,
                  ),
                  onPressed: onToggleVirtualKeyboard,
                  tooltip: AppLocalizations.of(context)!.virtualKeyboard,
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: onCancelSearch,
                  tooltip: AppLocalizations.of(context)!.cancelSearch,
                ),
              ],
            ),
            if (showVirtualKeyboard) ...[
              const Divider(color: Colors.grey),
              const SizedBox(height: 8),
              VirtualKeyboard(
                controller: searchController,
                onClose: onToggleVirtualKeyboard,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
