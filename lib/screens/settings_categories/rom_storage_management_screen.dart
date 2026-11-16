import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../services/keyboard_service.dart';
import '../../../services/gamepad_service.dart';
import '../../../mixins/gamepad_polling_mixin.dart';
import '../../../mixins/screen_navigation_mixin.dart';
import '../../../widgets/common/gamepad_button_indicator.dart';
import '../../../widgets/common/controls_bottom_bar.dart';
import '../../../widgets/common/app_snackbar.dart';
import '../../../widgets/common/dialog_button_bar.dart';
import '../../../l10n/generated/app_localizations.dart';

import 'rom_storage/rom_storage_controller.dart';
import 'rom_storage/widgets/storage_statistics_card.dart';
import 'rom_storage/widgets/platform_storage_tile.dart';
import 'rom_storage/widgets/rom_storage_tile.dart';

/// Type of navigable item
enum _NavigableItemType { appBarButton, platformCard, romItem }

/// Represents a navigable item in the screen
class _NavigableItem {
  final _NavigableItemType type;
  final String id;
  final VoidCallback onActivate;
  final GlobalKey key = GlobalKey();

  _NavigableItem({
    required this.type,
    required this.id,
    required this.onActivate,
  });
}

/// Screen for managing downloaded ROMs
class RomStorageManagementScreen extends StatefulWidget {
  const RomStorageManagementScreen({super.key});

  @override
  State<RomStorageManagementScreen> createState() =>
      _RomStorageManagementScreenState();
}

class _RomStorageManagementScreenState extends State<RomStorageManagementScreen>
    with
        GamepadPollingMixin<RomStorageManagementScreen>,
        ScreenNavigationMixin {
  late RomStorageController _controller;
  final _keyboardService = KeyboardService.instance;
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();

  // Navigation state
  int _selectedIndex = 0;
  final List<_NavigableItem> _navigableItems = [];
  bool _isGamepadConnected = false;
  final Set<String> _expandedPlatforms = {};

  @override
  void initState() {
    super.initState();
    _controller = RomStorageController();
    _controller.addListener(_onControllerUpdate);
    _controller.loadData();

    startGamepadPolling(_handleGamepadInput);
    _checkGamepadConnection();
  }

  void _onControllerUpdate() {
    if (mounted) {
      _rebuildNavigableItems();
      setState(() {});
    }
  }

  void _checkGamepadConnection() {
    setState(() {
      _isGamepadConnected = GamepadService.instance.isGamepadConnected;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleGamepadInput() {
    final gamepad = GamepadService.instance;
    final connected = gamepad.isGamepadConnected;

    if (connected != _isGamepadConnected) {
      setState(() => _isGamepadConnected = connected);
    }

    if (!connected) {
      gamepad.updatePreviousButtonStates();
      return;
    }

    final direction = gamepad.getNavigationDirection();
    if (direction != null) {
      if (direction == 'up') {
        _moveSelection(-1);
      } else if (direction == 'down') {
        _moveSelection(1);
      }
    }

    if (gamepad.isSelectPressed()) {
      _activateSelectedItem();
    } else if (gamepad.isBackPressed()) {
      safePop();
    }

    gamepad.updatePreviousButtonStates();
  }

  void _moveSelection(int delta) {
    if (_navigableItems.isEmpty) return;
    setState(() {
      _selectedIndex = (_selectedIndex + delta);
      if (_selectedIndex < 0) _selectedIndex = _navigableItems.length - 1;
      if (_selectedIndex >= _navigableItems.length) _selectedIndex = 0;
    });
    _scrollToSelected();
  }

  void _activateSelectedItem() {
    if (_selectedIndex >= 0 && _selectedIndex < _navigableItems.length) {
      _navigableItems[_selectedIndex].onActivate();
    }
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.arrowDown) {
      _moveSelection(1);
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.arrowUp) {
      _moveSelection(-1);
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.space) {
      _activateSelectedItem();
      return KeyEventResult.handled;
    } else if (_keyboardService.isBackKey(key)) {
      safePop();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  void _scrollToSelected() {
    if (_selectedIndex < 0 || _selectedIndex >= _navigableItems.length) return;
    final item = _navigableItems[_selectedIndex];
    if (item.key.currentContext != null) {
      Scrollable.ensureVisible(
        item.key.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
    }
  }

  void _rebuildNavigableItems() {
    _navigableItems.clear();

    // 1. App Bar buttons
    if ((_controller.storageStats['tempCount'] ?? 0) > 0) {
      _navigableItems.add(
        _NavigableItem(
          type: _NavigableItemType.appBarButton,
          id: 'clear_all',
          onActivate: _clearAllTempRoms,
        ),
      );
    }

    _navigableItems.add(
      _NavigableItem(
        type: _NavigableItemType.appBarButton,
        id: 'refresh',
        onActivate: _controller.loadData,
      ),
    );

    // 2. Forever platforms
    for (final entry in _controller.foreverRoms.entries) {
      final platform = entry.key;
      final id = 'forever_$platform';

      _navigableItems.add(
        _NavigableItem(
          type: _NavigableItemType.platformCard,
          id: id,
          onActivate: () => _togglePlatform(id),
        ),
      );

      if (_expandedPlatforms.contains(id)) {
        for (final file in entry.value) {
          final fileName = file.path.split('/').last;
          _navigableItems.add(
            _NavigableItem(
              type: _NavigableItemType.romItem,
              id: 'rom_forever_${platform}_$fileName',
              onActivate: () => _confirmDelete(platform, fileName, true),
            ),
          );
        }
      }
    }

    // 3. Temp platforms
    for (final entry in _controller.tempRoms.entries) {
      final platform = entry.key;
      final id = 'temp_$platform';

      _navigableItems.add(
        _NavigableItem(
          type: _NavigableItemType.platformCard,
          id: id,
          onActivate: () => _togglePlatform(id),
        ),
      );

      if (_expandedPlatforms.contains(id)) {
        for (final file in entry.value) {
          final fileName = file.path.split('/').last;
          _navigableItems.add(
            _NavigableItem(
              type: _NavigableItemType.romItem,
              id: 'rom_temp_${platform}_$fileName',
              onActivate: () => _confirmDelete(platform, fileName, false),
            ),
          );
        }
      }
    }

    if (_selectedIndex >= _navigableItems.length) {
      _selectedIndex = _navigableItems.isEmpty ? 0 : _navigableItems.length - 1;
    }
  }

  void _togglePlatform(String id) {
    setState(() {
      if (_expandedPlatforms.contains(id)) {
        _expandedPlatforms.remove(id);
      } else {
        _expandedPlatforms.add(id);
      }
      _rebuildNavigableItems();
    });
  }

  bool _isItemSelected(String id) {
    if (_selectedIndex >= 0 && _selectedIndex < _navigableItems.length) {
      return _navigableItems[_selectedIndex].id == id;
    }
    return false;
  }

  GlobalKey? _getItemKey(String id) {
    try {
      return _navigableItems.firstWhere((item) => item.id == id).key;
    } catch (_) {
      return null;
    }
  }

  Future<void> _confirmDelete(
    String platform,
    String fileName,
    bool isForever,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteRom),
        content: Text(
          '${AppLocalizations.of(context)!.deleteRomConfirm}\n${AppLocalizations.of(context)!.actionCannotBeUndone}',
        ),
        actions: [
          DialogButtonBar(
            buttons: [
              DialogButton(
                label: AppLocalizations.of(context)!.cancel,
                onPressed: () => Navigator.pop(context, false),
                gamepadButton: GamepadButton.b,
              ),
              DialogButton(
                label: AppLocalizations.of(context)!.delete,
                onPressed: () => Navigator.pop(context, true),
                primary: true,
                gamepadButton: GamepadButton.a,
              ),
            ],
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _controller.deleteRom(
        platform,
        fileName,
        isForever,
      );
      if (mounted && success) {
        ScaffoldMessenger.of(context).clearSnackBars();
        AppSnackBar.success(
          context,
          '${AppLocalizations.of(context)!.deleted} $fileName',
          icon: Icons.delete_outline,
          duration: const Duration(seconds: 5),
        );
      }
    }
  }

  Future<void> _confirmSave(String platform, String fileName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.savePermanently),
        content: Text(
          '${AppLocalizations.of(context)!.moveRomConfirm}\n$fileName',
        ),
        actions: [
          DialogButtonBar(
            buttons: [
              DialogButton(
                label: AppLocalizations.of(context)!.cancel,
                onPressed: () => Navigator.pop(context, false),
                gamepadButton: GamepadButton.b,
              ),
              DialogButton(
                label: AppLocalizations.of(context)!.save,
                onPressed: () => Navigator.pop(context, true),
                primary: true,
                gamepadButton: GamepadButton.a,
              ),
            ],
          ),
        ],
      ),
    );

    if (confirm == true) {
      final newPath = await _controller.moveToForever(platform, fileName);
      if (mounted && newPath != null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        AppSnackBar.success(
          context,
          '${AppLocalizations.of(context)!.saved} $fileName',
          icon: Icons.save_alt,
          duration: const Duration(seconds: 5),
        );
      }
    }
  }

  Future<void> _clearAllTempRoms() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.clearAll),
        content: Text(AppLocalizations.of(context)!.clearAllConfirm),
        actions: [
          DialogButtonBar(
            buttons: [
              DialogButton(
                label: AppLocalizations.of(context)!.cancel,
                onPressed: () => Navigator.pop(context, false),
                gamepadButton: GamepadButton.b,
              ),
              DialogButton(
                label: AppLocalizations.of(context)!.clear,
                onPressed: () => Navigator.pop(context, true),
                primary: true,
                gamepadButton: GamepadButton.a,
              ),
            ],
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _controller.clearAllTempRoms();
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        AppSnackBar.success(
          context,
          AppLocalizations.of(context)!.allCleared,
          icon: Icons.cleaning_services_outlined,
          duration: const Duration(seconds: 5),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) => _handleKeyEvent(event),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.romStorageManagement),
          actions: _buildAppBarActions(),
        ),
        body: Column(
          children: [
            Expanded(
              child: _controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1080),
                        child: ListView(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          children: [
                            StorageStatisticsCard(
                              stats: _controller.storageStats,
                              onClearTemp: _clearAllTempRoms,
                            ),
                            const SizedBox(height: 24),
                            if (_controller.foreverRoms.isNotEmpty) ...[
                              _buildSectionHeader(
                                AppLocalizations.of(context)!.permanentStorage,
                              ),
                              ..._buildPlatformList(
                                _controller.foreverRoms,
                                true,
                              ),
                              const SizedBox(height: 16),
                            ],
                            if (_controller.tempRoms.isNotEmpty) ...[
                              _buildSectionHeader(
                                AppLocalizations.of(context)!.temporaryStorage,
                              ),
                              ..._buildPlatformList(
                                _controller.tempRoms,
                                false,
                              ),
                            ],
                            if (_controller.foreverRoms.isEmpty &&
                                _controller.tempRoms.isEmpty)
                              _buildEmptyState(),
                          ],
                        ),
                      ),
                    ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      if ((_controller.storageStats['tempCount'] ?? 0) > 0)
        _buildActionIconButton(
          'clear_all',
          Icons.delete_sweep,
          _clearAllTempRoms,
        ),
      _buildActionIconButton('refresh', Icons.refresh, _controller.loadData),
    ];
  }

  Widget _buildActionIconButton(
    String id,
    IconData icon,
    VoidCallback onPressed,
  ) {
    final isSelected = _isItemSelected(id);
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: isSelected
              ? BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                )
              : null,
          child: IconButton(icon: Icon(icon), onPressed: onPressed),
        ),
        if (_isGamepadConnected && isSelected)
          const Positioned(
            bottom: 0,
            child: GamepadButtonIndicator(button: GamepadButton.a, size: 16),
          ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  List<Widget> _buildPlatformList(
    Map<String, List<File>> data,
    bool isForever,
  ) {
    return data.entries.map((entry) {
      final platform = entry.key;
      final id = '${isForever ? "forever" : "temp"}_$platform';

      return PlatformStorageTile(
        key: _getItemKey(id),
        platform: platform,
        roms: entry.value,
        isForever: isForever,
        isExpanded: _expandedPlatforms.contains(id),
        isSelected: _isItemSelected(id),
        isGamepadConnected: _isGamepadConnected,
        onExpansionChanged: (_) => _togglePlatform(id),
        romBuilder: (file) {
          final fileName = file.path.split('/').last;
          final romId =
              'rom_${isForever ? "forever" : "temp"}_${platform}_$fileName';
          return RomStorageTile(
            key: _getItemKey(romId),
            file: file,
            isForever: isForever,
            isSelected: _isItemSelected(romId),
            isGamepadConnected: _isGamepadConnected,
            onDelete: () => _confirmDelete(platform, fileName, isForever),
            onSave: isForever ? null : () => _confirmSave(platform, fileName),
          );
        },
      );
    }).toList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            const Icon(Icons.folder_open, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noDownloadedRoms,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return ControlsBottomBar(
      actions: [
        BottomBarAction(
          label: AppLocalizations.of(context)!.back,
          keyboardKey: 'ESC',
          gamepadButton: 'B',
        ),
        BottomBarAction(
          label: AppLocalizations.of(context)!.navigate,
          keyboardKey: '↑↓',
          gamepadButton: 'D-pad',
        ),
      ],
    );
  }
}
