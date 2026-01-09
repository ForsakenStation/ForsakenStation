import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'settings_categories/emulator_management_screen.dart';
import 'settings_categories/system_paths_screen.dart';
import 'settings_categories/rom_database_screen.dart';
import 'settings_categories/rom_storage_management_screen.dart';
import 'settings_categories/download_manager_screen.dart';
import 'settings_categories/system_check_screen.dart';
import '../../services/debug_service.dart';
import '../services/keyboard_service.dart';

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

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    // Handle back key (ESC or Backspace)
    if (_keyboardService.isBackKey(key)) {
      Navigator.pop(context);
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
              icon: Icons.videogame_asset,
              title: 'Emulator Management',
              description: 'Add, edit, and configure emulator commands',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmulatorManagementScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            _buildCategoryCard(
              context,
              icon: Icons.folder,
              title: 'System Paths',
              description: 'Configure ROMs, media, and emulator paths',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SystemPathsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            _buildCategoryCard(
              context,
              icon: Icons.storage,
              title: 'ROM Database',
              description: 'Download and manage ROM lists from GitHub',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RomDatabaseScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            _buildCategoryCard(
              context,
              icon: Icons.folder_special,
              title: 'ROM Storage',
              description:
                  'Manage downloaded ROMs, storage, and temp files cleanup',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RomStorageManagementScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            _buildCategoryCard(
              context,
              icon: Icons.download,
              title: 'Download Manager',
              description: 'Download emulators, ROMs lists, and game data',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DownloadManagerScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            _buildCategoryCard(
              context,
              icon: Icons.check_circle_outline,
              title: 'System Requirements',
              description: 'Check required tools and dependencies',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SystemCheckScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            _buildCategoryCard(
              context,
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
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
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
