import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'settings_categories/emulator_management_screen.dart';
import 'settings_categories/system_paths_screen.dart';
import 'settings_categories/rom_database_screen.dart';
import 'settings_categories/rom_storage_management_screen.dart';
import 'settings_categories/download_manager_screen.dart';
import 'settings_categories/system_check_screen.dart';
import 'settings_categories/gamepad_test_screen.dart';
import 'package:forsaken/services/debug_service.dart';
import 'package:forsaken/services/keyboard_service.dart';
import 'package:forsaken/services/gamepad_service.dart';

/// Main settings screen with categorized configuration options
/// Replaces bash scripts with native Flutter UI
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _keyboardService = KeyboardService.instance;
  final _focusNode = FocusNode();
  Timer? _gamepadPollTimer;
  int _selectedIndex = 0;
  final int _categoryCount = 8;
  bool _isGamepadNavigating = false;

  @override
  void initState() {
    super.initState();
    _startGamepadPolling();
  }

  @override
  void dispose() {
    _stopGamepadPolling();
    _focusNode.dispose();
    super.dispose();
  }

  void _startGamepadPolling() {
    _gamepadPollTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!mounted) return;
      final gamepad = GamepadService.instance;

      // Navegación
      final direction = gamepad.getNavigationDirection();
      if (direction != null) {
        setState(() {
          _isGamepadNavigating = true;
          if (direction == 'up') {
            _selectedIndex = (_selectedIndex - 1) % _categoryCount;
            if (_selectedIndex < 0) _selectedIndex = _categoryCount - 1;
          } else if (direction == 'down') {
            _selectedIndex = (_selectedIndex + 1) % _categoryCount;
          }
        });
      }

      // Botones
      if (gamepad.isSelectPressed()) {
        _navigateToCategory(_selectedIndex);
      } else if (gamepad.isBackPressed()) {
        Navigator.pop(context);
      }

      gamepad.updatePreviousButtonStates();
    });
  }

  void _stopGamepadPolling() {
    _gamepadPollTimer?.cancel();
    _gamepadPollTimer = null;
  }

  void _navigateToCategory(int index) {
    _stopGamepadPolling();

    if (index == 7) {
      _showAboutDialog(context);
      if (mounted) _startGamepadPolling();
      return;
    }

    late final Widget screen;
    switch (index) {
      case 0:
        screen = const EmulatorManagementScreen();
        break;
      case 1:
        screen = const SystemPathsScreen();
        break;
      case 2:
        screen = const RomDatabaseScreen();
        break;
      case 3:
        screen = const RomStorageManagementScreen();
        break;
      case 4:
        screen = const DownloadManagerScreen();
        break;
      case 5:
        screen = const SystemCheckScreen();
        break;
      case 6:
        screen = const GamepadTestScreen();
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    ).then((_) {
      if (mounted) _startGamepadPolling();
    });
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    // Handle back key (ESC or Backspace)
    if (_keyboardService.isBackKey(key)) {
      Navigator.pop(context);
      return KeyEventResult.handled;
    }

    // Handle arrow keys
    if (key == LogicalKeyboardKey.arrowUp) {
      setState(() {
        _isGamepadNavigating = true;
        _selectedIndex = (_selectedIndex - 1) % _categoryCount;
        if (_selectedIndex < 0) _selectedIndex = _categoryCount - 1;
      });
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown) {
      setState(() {
        _isGamepadNavigating = true;
        _selectedIndex = (_selectedIndex + 1) % _categoryCount;
      });
      return KeyEventResult.handled;
    }

    // Handle Enter/Space to select
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      _navigateToCategory(_selectedIndex);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) => _handleKeyEvent(event),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings & Configuration'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.settings,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Forsaken Emulator Configuration',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Configure emulators, paths, and download content',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Configuration Categories
            _buildCategoryCard(
              context,
              index: 0,
              icon: Icons.videogame_asset,
              title: 'Emulator Management',
              description: 'Add, edit, and configure emulator commands',
              onTap: () => _navigateToCategory(0),
            ),
            const SizedBox(height: 12),

            _buildCategoryCard(
              context,
              index: 1,
              icon: Icons.folder,
              title: 'System Paths',
              description: 'Configure ROMs, media, and emulator paths',
              onTap: () => _navigateToCategory(1),
            ),
            const SizedBox(height: 12),

            _buildCategoryCard(
              context,
              index: 2,
              icon: Icons.storage,
              title: 'ROM Database',
              description: 'Download and manage ROM lists from GitHub',
              onTap: () => _navigateToCategory(2),
            ),
            const SizedBox(height: 12),

            _buildCategoryCard(
              context,
              index: 3,
              icon: Icons.folder_special,
              title: 'ROM Storage',
              description:
                  'Manage downloaded ROMs, storage, and temp files cleanup',
              onTap: () => _navigateToCategory(3),
            ),
            const SizedBox(height: 12),

            _buildCategoryCard(
              context,
              index: 4,
              icon: Icons.download,
              title: 'Download Manager',
              description: 'Download emulators, ROMs lists, and game data',
              onTap: () => _navigateToCategory(4),
            ),
            const SizedBox(height: 12),

            _buildCategoryCard(
              context,
              index: 5,
              icon: Icons.check_circle_outline,
              title: 'System Requirements',
              description: 'Check required tools and dependencies',
              onTap: () => _navigateToCategory(5),
            ),
            const SizedBox(height: 12),

            _buildCategoryCard(
              context,
              index: 6,
              icon: Icons.gamepad,
              title: 'Gamepad Test & Debug',
              description:
                  'Test gamepad buttons, axes, and troubleshoot issues',
              onTap: () => _navigateToCategory(6),
            ),
            const SizedBox(height: 12),

            _buildCategoryCard(
              context,
              index: 7,
              icon: Icons.info_outline,
              title: 'About & Debug',
              description: 'App information and debug settings',
              onTap: () => _showAboutDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    final isSelected = _isGamepadNavigating && _selectedIndex == index;

    return Card(
      elevation: isSelected ? 8 : 2,
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: () {
          setState(() => _isGamepadNavigating = false);
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Forsaken Emulator'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Version 1.0.0',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'A modern multi-platform emulator frontend built with Flutter.',
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'ROM Database',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'ROM lists are sourced from the AndroidRoms repository by Arley4d:',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 8),
              const SelectableText(
                'https://github.com/Arley4d/AndroidRoms',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Special thanks to the AndroidRoms project for maintaining comprehensive ROM databases for preservation purposes.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Debug Mode: '),
                  Text(
                    DebugService.instance.isDebugEnabled
                        ? 'Enabled'
                        : 'Disabled',
                    style: TextStyle(
                      color: DebugService.instance.isDebugEnabled
                          ? Colors.green
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  DebugService.instance.toggleDebug();
                  Navigator.pop(context);
                  _showAboutDialog(context);
                },
                child: const Text('Toggle Debug Mode'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
