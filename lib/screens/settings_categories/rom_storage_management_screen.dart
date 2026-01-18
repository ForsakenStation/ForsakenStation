import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/rom_storage_service.dart';
import '../../services/debug_service.dart';
import '../../services/keyboard_service.dart';
import '../../services/gamepad_service.dart';
import '../../mixins/gamepad_polling_mixin.dart';
import '../../widgets/common/gamepad_button_indicator.dart';

/// Screen for managing downloaded ROMs (temporary and permanent storage)
class RomStorageManagementScreen extends StatefulWidget {
  const RomStorageManagementScreen({super.key});

  @override
  State<RomStorageManagementScreen> createState() =>
      _RomStorageManagementScreenState();
}

class _RomStorageManagementScreenState extends State<RomStorageManagementScreen>
    with GamepadPollingMixin<RomStorageManagementScreen> {
  final _storageService = RomStorageService.instance;
  final _debug = DebugService.instance;
  final _keyboardService = KeyboardService.instance;
  final _focusNode = FocusNode();

  Map<String, dynamic> _storageStats = {};
  Map<String, List<FileSystemEntity>> _tempRoms = {};
  Map<String, List<FileSystemEntity>> _foreverRoms = {};
  bool _isLoading = true;

  // Navigation state
  int _selectedIndex = 0;
  int _totalItems = 2; // Default: Clear All + Refresh buttons
  bool _isGamepadConnected = false;

  @override
  void dispose() {
    _focusNode.dispose();
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
          _selectedIndex = (_selectedIndex - 1) % _totalItems;
          if (_selectedIndex < 0) _selectedIndex = _totalItems - 1;
        } else if (direction == 'down') {
          _selectedIndex = (_selectedIndex + 1) % _totalItems;
        }
      });
    }

    // Actions
    if (gamepad.isSelectPressed()) {
      _activateSelectedItem();
    } else if (gamepad.isBackPressed()) {
      Navigator.pop(context);
    }

    gamepad.updatePreviousButtonStates();
  }

  void _activateSelectedItem() {
    // Index 0: Clear All button (if visible)
    // Index 1: Refresh button
    final hasClearButton =
        _storageStats['tempCount'] != null && _storageStats['tempCount'] > 0;

    if (_selectedIndex == 0 && hasClearButton) {
      _clearAllTempRoms();
    } else if (_selectedIndex == 1 ||
        (_selectedIndex == 0 && !hasClearButton)) {
      _loadStorageData();
    }
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    // Handle navigation (arrow keys)
    if (key == LogicalKeyboardKey.arrowDown) {
      setState(() {
        _selectedIndex = (_selectedIndex + 1) % _totalItems;
      });
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.arrowUp) {
      setState(() {
        _selectedIndex = (_selectedIndex - 1) % _totalItems;
        if (_selectedIndex < 0) _selectedIndex = _totalItems - 1;
      });
      return KeyEventResult.handled;
    }

    // Handle activation (Enter/Space)
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      _activateSelectedItem();
      return KeyEventResult.handled;
    }

    // Handle back key (ESC or Backspace)
    if (_keyboardService.isBackKey(key)) {
      Navigator.pop(context);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
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
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
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
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            child: const Text('Save'),
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
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
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
            if (_storageStats['tempCount'] != null &&
                _storageStats['tempCount'] > 0)
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: _selectedIndex == 0
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
                  if (_isGamepadConnected && _selectedIndex == 0)
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
                  decoration:
                      (_selectedIndex == 1 ||
                          (_selectedIndex == 0 &&
                              !(_storageStats['tempCount'] != null &&
                                  _storageStats['tempCount'] > 0)))
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
                if (_isGamepadConnected &&
                    (_selectedIndex == 1 ||
                        (_selectedIndex == 0 &&
                            !(_storageStats['tempCount'] != null &&
                                _storageStats['tempCount'] > 0))))
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
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
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
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Storage Overview',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              if ((_storageStats['tempCount'] ?? 0) > 0)
                                IconButton(
                                  icon: const Icon(Icons.cleaning_services),
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
                      (entry) =>
                          _buildPlatformCard(entry.key, entry.value, true),
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
                      (entry) =>
                          _buildPlatformCard(entry.key, entry.value, false),
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
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'ROMs you download will appear here',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
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

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(
          isForever ? Icons.cloud_done : Icons.access_time,
          color: isForever ? Colors.green : Colors.orange,
        ),
        title: Text(
          platform.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${roms.length} ROMs • ${_formatBytes(totalSize)}'),
        children: roms.map((rom) {
          if (rom is File) {
            final fileName = rom.path.split('/').last;
            final fileSize = rom.lengthSync();

            return ListTile(
              dense: true,
              leading: const Icon(Icons.insert_drive_file, size: 20),
              title: Text(fileName, style: const TextStyle(fontSize: 14)),
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
                    onPressed: () => _deleteRom(platform, fileName, isForever),
                    tooltip: 'Delete',
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }).toList(),
      ),
    );
  }
}
