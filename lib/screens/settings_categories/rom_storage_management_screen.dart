import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/rom_storage_service.dart';
import '../../services/debug_service.dart';
import '../../services/keyboard_service.dart';
import '../../services/gamepad_service.dart';
import '../../mixins/gamepad_polling_mixin.dart';
import '../../mixins/screen_navigation_mixin.dart';
import '../../widgets/common/gamepad_button_indicator.dart';
import '../../widgets/common/controls_bottom_bar.dart';
import '../../widgets/common/dialog_button_bar.dart';

/// Type of navigable item
enum _NavigableItemType { appBarButton, platformCard, romItem }

/// Represents a navigable item in the screen
class _NavigableItem {
  final _NavigableItemType type;
  final String? id; // Unique identifier
  final VoidCallback? onActivate;
  final GlobalKey? key;

  // Platform-specific data
  final String? platformName;
  final bool? isForever;

  // ROM-specific data
  final File? romFile;

  _NavigableItem({
    required this.type,
    this.id,
    this.onActivate,
    this.key,
    this.platformName,
    this.isForever,
    this.romFile,
  });
}

/// Screen for managing downloaded ROMs (temporary and permanent storage)
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
  final _storageService = RomStorageService.instance;
  final _debug = DebugService.instance;
  final _keyboardService = KeyboardService.instance;
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();

  Map<String, dynamic> _storageStats = {};
  Map<String, List<FileSystemEntity>> _tempRoms = {};
  Map<String, List<FileSystemEntity>> _foreverRoms = {};
  bool _isLoading = true;

  // Navigation state
  int _selectedIndex = 0;
  List<_NavigableItem> _navigableItems = [];
  bool _isGamepadConnected = false;

  // Track expanded platforms
  final Set<String> _expandedPlatforms = {};

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    startGamepadPolling(_handleGamepadInput);
    _loadStorageData();
    _checkGamepadConnection();
  }

  void _checkGamepadConnection() {
    final gamepad = GamepadService.instance;
    setState(() {
      _isGamepadConnected = gamepad.isGamepadConnected;
    });
  }

  void _handleGamepadInput() {
    final gamepad = GamepadService.instance;

    // Update gamepad connection status
    final connected = gamepad.isGamepadConnected;
    if (connected != _isGamepadConnected) {
      setState(() => _isGamepadConnected = connected);
    }

    if (!connected) {
      gamepad.updatePreviousButtonStates();
      return;
    }

    // Navigation
    final direction = gamepad.getNavigationDirection();
    if (direction != null) {
      setState(() {
        if (direction == 'up') {
          _selectedIndex = (_selectedIndex - 1);
          if (_selectedIndex < 0) _selectedIndex = _navigableItems.length - 1;
        } else if (direction == 'down') {
          _selectedIndex = (_selectedIndex + 1) % _navigableItems.length;
        }
      });
      _scrollToSelected();
    }

    // Actions
    if (gamepad.isSelectPressed()) {
      _activateSelectedItem();
    } else if (gamepad.isBackPressed()) {
      safePop();
    }

    gamepad.updatePreviousButtonStates();
  }

  void _activateSelectedItem() {
    if (_selectedIndex < 0 || _selectedIndex >= _navigableItems.length) return;

    final item = _navigableItems[_selectedIndex];
    item.onActivate?.call();
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    // Handle navigation (arrow keys)
    if (key == LogicalKeyboardKey.arrowDown) {
      setState(() {
        _selectedIndex = (_selectedIndex + 1) % _navigableItems.length;
      });
      _scrollToSelected();
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.arrowUp) {
      setState(() {
        _selectedIndex = (_selectedIndex - 1);
        if (_selectedIndex < 0) _selectedIndex = _navigableItems.length - 1;
      });
      _scrollToSelected();
      return KeyEventResult.handled;
    }

    // Handle activation (Enter/Space)
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      _activateSelectedItem();
      return KeyEventResult.handled;
    }

    // Handle back key (ESC or Backspace)
    if (_keyboardService.isBackKey(key)) {
      safePop();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  void _scrollToSelected() {
    if (_selectedIndex < 0 || _selectedIndex >= _navigableItems.length) return;

    final item = _navigableItems[_selectedIndex];
    if (item.key?.currentContext != null) {
      Scrollable.ensureVisible(
        item.key!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
    }
  }

  Future<void> _loadStorageData() async {
    setState(() => _isLoading = true);

    try {
      // Get storage statistics
      final stats = await _storageService.getStorageStats();

      // List ROMs in temp storage
      final tempDir = await _storageService.getTempStorageDirectory();
      final tempRoms = await _listRomsByPlatform(tempDir);

      // List ROMs in forever storage
      final foreverDir = await _storageService.getForeverStorageDirectory();
      final foreverRoms = await _listRomsByPlatform(foreverDir);

      setState(() {
        _storageStats = stats;
        _tempRoms = tempRoms;
        _foreverRoms = foreverRoms;
        _isLoading = false;

        // Rebuild navigable items
        _rebuildNavigableItems();

        // Reset selection if out of bounds
        if (_selectedIndex >= _navigableItems.length) {
          _selectedIndex = _navigableItems.length - 1;
        }
        if (_selectedIndex < 0) _selectedIndex = 0;
      });
    } catch (e) {
      _debug.error(
        'Error loading storage data',
        tag: 'RomStorageMgmt',
        error: e,
      );
      setState(() => _isLoading = false);
    }
  }

  /// Rebuild the list of navigable items based on current state
  void _rebuildNavigableItems() {
    _navigableItems.clear();

    // Add AppBar buttons
    // Clear All button (if there are temp ROMs)
    final hasTempRoms = (_storageStats['tempCount'] ?? 0) > 0;
    if (hasTempRoms) {
      _navigableItems.add(
        _NavigableItem(
          type: _NavigableItemType.appBarButton,
          id: 'clear_all',
          onActivate: _clearAllTempRoms,
        ),
      );
    }

    // Refresh button (always present)
    _navigableItems.add(
      _NavigableItem(
        type: _NavigableItemType.appBarButton,
        id: 'refresh',
        onActivate: _loadStorageData,
      ),
    );

    // Add platform cards (Forever ROMs first, then Temp ROMs)
    // Forever ROMs
    for (final entry in _foreverRoms.entries) {
      final platformName = entry.key;
      final roms = entry.value;
      final key = GlobalKey();

      _navigableItems.add(
        _NavigableItem(
          type: _NavigableItemType.platformCard,
          id: 'platform_forever_$platformName',
          platformName: platformName,
          isForever: true,
          key: key,
          onActivate: () {
            setState(() {
              if (_expandedPlatforms.contains('forever_$platformName')) {
                _expandedPlatforms.remove('forever_$platformName');
              } else {
                _expandedPlatforms.add('forever_$platformName');
              }
              _rebuildNavigableItems();
            });
          },
        ),
      );

      // If expanded, add ROM items
      if (_expandedPlatforms.contains('forever_$platformName')) {
        for (final rom in roms) {
          if (rom is File) {
            final fileName = rom.path.split('/').last;
            final romKey = GlobalKey();

            _navigableItems.add(
              _NavigableItem(
                type: _NavigableItemType.romItem,
                id: 'rom_forever_${platformName}_$fileName',
                platformName: platformName,
                isForever: true,
                romFile: rom,
                key: romKey,
                onActivate: () => _deleteRom(platformName, fileName, true),
              ),
            );
          }
        }
      }
    }

    // Temp ROMs
    for (final entry in _tempRoms.entries) {
      final platformName = entry.key;
      final roms = entry.value;
      final key = GlobalKey();

      _navigableItems.add(
        _NavigableItem(
          type: _NavigableItemType.platformCard,
          id: 'platform_temp_$platformName',
          platformName: platformName,
          isForever: false,
          key: key,
          onActivate: () {
            setState(() {
              if (_expandedPlatforms.contains('temp_$platformName')) {
                _expandedPlatforms.remove('temp_$platformName');
              } else {
                _expandedPlatforms.add('temp_$platformName');
              }
              _rebuildNavigableItems();
            });
          },
        ),
      );

      // If expanded, add ROM items
      if (_expandedPlatforms.contains('temp_$platformName')) {
        for (final rom in roms) {
          if (rom is File) {
            final fileName = rom.path.split('/').last;
            final romKey = GlobalKey();

            _navigableItems.add(
              _NavigableItem(
                type: _NavigableItemType.romItem,
                id: 'rom_temp_${platformName}_$fileName',
                platformName: platformName,
                isForever: false,
                romFile: rom,
                key: romKey,
                onActivate: () => _deleteRom(platformName, fileName, false),
              ),
            );
          }
        }
      }
    }
  }

  /// Get index of navigable item by ID
  int _getItemIndex(String id) {
    return _navigableItems.indexWhere((item) => item.id == id);
  }

  /// Check if a navigable item is currently selected
  bool _isItemSelected(String id) {
    if (_selectedIndex < 0 || _selectedIndex >= _navigableItems.length) {
      return false;
    }
    return _navigableItems[_selectedIndex].id == id;
  }

  /// List ROMs grouped by platform
  Future<Map<String, List<FileSystemEntity>>> _listRomsByPlatform(
    Directory baseDir,
  ) async {
    final romsByPlatform = <String, List<FileSystemEntity>>{};

    if (!await baseDir.exists()) {
      return romsByPlatform;
    }

    // Iterate through platform directories
    await for (var entity in baseDir.list()) {
      if (entity is Directory) {
        final platformName = entity.path.split('/').last;
        final roms = <FileSystemEntity>[];

        // List ROMs in this platform directory
        await for (var romEntity in entity.list()) {
          if (romEntity is File) {
            roms.add(romEntity);
          }
        }

        if (roms.isNotEmpty) {
          romsByPlatform[platformName] = roms;
        }
      }
    }

    return romsByPlatform;
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  Future<void> _deleteRom(
    String platform,
    String fileName,
    bool isFromForever,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete ROM?'),
        content: Text(
          'Are you sure you want to delete:\n\n$fileName\n\nThis action cannot be undone.',
        ),
        actions: [
          DialogButtonBar(
            buttons: [
              DialogButton(
                label: 'Cancel',
                onPressed: () => Navigator.pop(context, false),
                gamepadButton: GamepadButton.b,
              ),
              DialogButton(
                label: 'Delete',
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
      setState(() => _isLoading = true);

      final success = isFromForever
          ? await _storageService.deleteFromForeverStorage(platform, fileName)
          : await _storageService.deleteFromTempStorage(platform, fileName);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Deleted: $fileName'),
              backgroundColor: Colors.green,
            ),
          );
          await _loadStorageData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete ROM'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _moveToForever(String platform, String fileName) async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save to Permanent Storage?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('This will move the ROM to permanent storage:'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.gamepad, size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          fileName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.folder, size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Text('Platform: ${platform.toUpperCase()}'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'The ROM will be kept permanently and won\'t be deleted automatically.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          DialogButtonBar(
            buttons: [
              DialogButton(
                label: 'Cancel',
                onPressed: () => Navigator.pop(context, false),
                gamepadButton: GamepadButton.b,
              ),
              DialogButton(
                label: 'Save',
                onPressed: () => Navigator.pop(context, true),
                primary: true,
                gamepadButton: GamepadButton.a,
              ),
            ],
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    setState(() => _isLoading = true);

    // Move from temp to forever storage
    final newPath = await _storageService.moveToForeverStorage(
      platform,
      fileName,
    );

    if (mounted) {
      if (newPath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved to permanent storage: $fileName'),
            backgroundColor: Colors.green,
          ),
        );
        await _loadStorageData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to move ROM to permanent storage'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _clearAllTempRoms() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Temporary ROMs?'),
        content: Text(
          'This will delete all ${_storageStats['tempCount']} temporary ROMs (${_formatBytes(_storageStats['tempSize'])}).\n\nThis action cannot be undone.',
        ),
        actions: [
          DialogButtonBar(
            buttons: [
              DialogButton(
                label: 'Cancel',
                onPressed: () => Navigator.pop(context, false),
                gamepadButton: GamepadButton.b,
              ),
              DialogButton(
                label: 'Clear All',
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
      setState(() => _isLoading = true);
      await _storageService.cleanupAllTempRoms();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All temporary ROMs deleted'),
            backgroundColor: Colors.green,
          ),
        );
        await _loadStorageData();
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
          title: const Text('ROM Storage Management'),
          actions: [
            if ((_storageStats['tempCount'] ?? 0) > 0)
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: _isItemSelected('clear_all')
                        ? BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          )
                        : null,
                    child: IconButton(
                      icon: const Icon(Icons.delete_sweep),
                      onPressed: _clearAllTempRoms,
                      tooltip: 'Clear all temporary ROMs',
                    ),
                  ),
                  if (_isGamepadConnected && _isItemSelected('clear_all'))
                    Positioned(
                      bottom: 0,
                      child: const GamepadButtonIndicator(
                        button: GamepadButton.a,
                        size: 16,
                      ),
                    ),
                ],
              ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: _isItemSelected('refresh')
                      ? BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        )
                      : null,
                  child: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _loadStorageData,
                    tooltip: 'Refresh',
                  ),
                ),
                if (_isGamepadConnected && _isItemSelected('refresh'))
                  Positioned(
                    bottom: 0,
                    child: const GamepadButtonIndicator(
                      button: GamepadButton.a,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Storage Statistics Card
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.storage,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Storage Overview',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    if ((_storageStats['tempCount'] ?? 0) > 0)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.cleaning_services,
                                        ),
                                        onPressed: _clearAllTempRoms,
                                        tooltip: 'Clear all temporary ROMs',
                                        iconSize: 20,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatCard(
                                        context,
                                        'Temporary Storage',
                                        Icons.access_time,
                                        _storageStats['tempCount'] ?? 0,
                                        _storageStats['tempSize'] ?? 0,
                                        Colors.orange,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildStatCard(
                                        context,
                                        'Permanent Storage',
                                        Icons.cloud_done,
                                        _storageStats['foreverCount'] ?? 0,
                                        _storageStats['foreverSize'] ?? 0,
                                        Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Temp path: ${_storageStats['tempPath'] ?? 'Unknown'}',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        fontFamily: 'monospace',
                                        color: Colors.grey,
                                      ),
                                ),
                                Text(
                                  'Forever path: ${_storageStats['foreverPath'] ?? 'Unknown'}',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        fontFamily: 'monospace',
                                        color: Colors.grey,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Permanent ROMs Section
                        if (_foreverRoms.isNotEmpty) ...[
                          Text(
                            'Permanent ROMs',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ..._foreverRoms.entries.map(
                            (entry) => _buildPlatformCard(
                              entry.key,
                              entry.value,
                              true,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Temporary ROMs Section
                        if (_tempRoms.isNotEmpty) ...[
                          Text(
                            'Temporary ROMs',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ..._tempRoms.entries.map(
                            (entry) => _buildPlatformCard(
                              entry.key,
                              entry.value,
                              false,
                            ),
                          ),
                        ],

                        // Empty state
                        if (_foreverRoms.isEmpty && _tempRoms.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(48),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.folder_open,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No downloaded ROMs',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'ROMs you download will appear here',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.grey[500]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
            ControlsBottomBar(
              actions: const [
                BottomBarAction(
                  label: 'Back',
                  keyboardKey: 'ESC',
                  gamepadButton: 'B',
                ),
                BottomBarAction(
                  label: 'Navigate',
                  keyboardKey: '↑↓',
                  gamepadButton: 'D-pad',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    IconData icon,
    int count,
    int bytes,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$count files',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            _formatBytes(bytes),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformCard(
    String platform,
    List<FileSystemEntity> roms,
    bool isForever,
  ) {
    // Calculate total size
    int totalSize = 0;
    for (var rom in roms) {
      if (rom is File) {
        totalSize += rom.lengthSync();
      }
    }

    final platformId = '${isForever ? "forever" : "temp"}_$platform';
    final isExpanded = _expandedPlatforms.contains(platformId);
    final isSelected = _isItemSelected(
      'platform_${isForever ? "forever" : "temp"}_$platform',
    );

    // Get the GlobalKey for this platform from navigable items
    final item = _navigableItems.firstWhere(
      (item) =>
          item.id == 'platform_${isForever ? "forever" : "temp"}_$platform',
      orElse: () => _NavigableItem(type: _NavigableItemType.platformCard),
    );

    return Container(
      key: item.key,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: isSelected
          ? BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            )
          : null,
      child: Card(
        margin: EdgeInsets.zero,
        child: ExpansionTile(
          key: Key(platformId),
          initiallyExpanded: isExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              if (expanded) {
                _expandedPlatforms.add(platformId);
              } else {
                _expandedPlatforms.remove(platformId);
              }
              _rebuildNavigableItems();
            });
          },
          leading: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                isForever ? Icons.cloud_done : Icons.access_time,
                color: isForever ? Colors.green : Colors.orange,
              ),
              if (_isGamepadConnected && isSelected)
                Positioned(
                  bottom: -4,
                  child: const GamepadButtonIndicator(
                    button: GamepadButton.a,
                    size: 12,
                  ),
                ),
            ],
          ),
          title: Text(
            platform.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
          subtitle: Text('${roms.length} ROMs • ${_formatBytes(totalSize)}'),
          children: roms.map((rom) {
            if (rom is File) {
              final fileName = rom.path.split('/').last;
              final fileSize = rom.lengthSync();
              final romId =
                  'rom_${isForever ? "forever" : "temp"}_${platform}_$fileName';
              final isRomSelected = _isItemSelected(romId);

              // Get the GlobalKey for this ROM from navigable items
              final romItem = _navigableItems.firstWhere(
                (item) => item.id == romId,
                orElse: () => _NavigableItem(type: _NavigableItemType.romItem),
              );

              return Container(
                key: romItem.key,
                decoration: isRomSelected
                    ? BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                        border: Border(
                          left: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 3,
                          ),
                        ),
                      )
                    : null,
                child: ListTile(
                  dense: true,
                  leading: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.insert_drive_file, size: 20),
                      if (_isGamepadConnected && isRomSelected)
                        Positioned(
                          bottom: -2,
                          child: const GamepadButtonIndicator(
                            button: GamepadButton.a,
                            size: 10,
                          ),
                        ),
                    ],
                  ),
                  title: Text(
                    fileName,
                    style: TextStyle(
                      fontSize: 14,
                      color: isRomSelected
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      fontWeight: isRomSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    _formatBytes(fileSize),
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Show "Save to Forever" button only for temp ROMs
                      if (!isForever)
                        IconButton(
                          icon: const Icon(Icons.save, size: 20),
                          onPressed: () => _moveToForever(platform, fileName),
                          tooltip: 'Save to permanent storage',
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        onPressed: () =>
                            _deleteRom(platform, fileName, isForever),
                        tooltip: 'Delete',
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }).toList(),
        ),
      ),
    );
  }
}
