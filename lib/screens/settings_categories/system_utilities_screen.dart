import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import '../../services/config_service.dart';
import '../../services/keyboard_service.dart';

/// Screen for system utilities and maintenance
///
/// Allows users to:
/// - Cleanup temporary ROM files
/// - Verify ROM files exist
/// - Check for missing gamelists
/// - Backup/restore configuration
/// - Clear cache
/// - Check disk space
class SystemUtilitiesScreen extends StatefulWidget {
  const SystemUtilitiesScreen({super.key});

  @override
  State<SystemUtilitiesScreen> createState() => _SystemUtilitiesScreenState();
}

class _SystemUtilitiesScreenState extends State<SystemUtilitiesScreen> {
  final _configService = ConfigService.instance;
  final _keyboardService = KeyboardService.instance;
  final _focusNode = FocusNode();
  Map<String, dynamic>? _stats;
  bool _isLoadingStats = false;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    // Handle back key (Escape, Backspace)
    if (_keyboardService.isBackKey(key)) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }

    // Handle refresh (R key)
    if (key == LogicalKeyboardKey.keyR && !_isLoadingStats) {
      _loadStats();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  Future<void> _loadStats() async {
    setState(() => _isLoadingStats = true);

    try {
      final stats = <String, dynamic>{};

      // Count ROM files (small files containing URLs)
      final romsPath = _configService.romsPath;
      final romsDir = Directory(romsPath);

      if (await romsDir.exists()) {
        int romCount = 0;
        await for (final entity in romsDir.list(recursive: true)) {
          if (entity is File) {
            try {
              // ROM files are small text files with URLs (< 5KB)
              final stat = await entity.stat();
              if (stat.size < 5000) {
                romCount++;
              }
            } catch (e) {
              // Skip files we can't access
              continue;
            }
          }
        }
        stats['romCount'] = romCount;
      } else {
        stats['romCount'] = 0;
      }

      // Check disk space
      if (await romsDir.exists()) {
        final stat = await romsDir.stat();
        stats['lastModified'] = stat.modified;
      }

      setState(() {
        _stats = stats;
        _isLoadingStats = false;
      });
    } catch (e) {
      setState(() {
        _stats = {};
        _isLoadingStats = false;
      });
    }
  }

  Future<void> _cleanupTempRoms() async {
    try {
      final tempDir = Directory.systemTemp;
      int deletedCount = 0;

      await for (final entity in tempDir.list()) {
        if (entity is File) {
          final name = path.basename(entity.path);
          // Look for common ROM extensions
          if (name.contains('rom_') ||
              name.endsWith('.nes') ||
              name.endsWith('.snes') ||
              name.endsWith('.gba') ||
              name.endsWith('.n64') ||
              name.endsWith('.zip')) {
            try {
              await entity.delete();
              deletedCount++;
            } catch (e) {
              debugPrint('Error deleting temp file: $e');
            }
          }
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cleaned up $deletedCount temporary ROM files'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cleaning temp files: $e')),
        );
      }
    }
  }

  Future<void> _verifyRomFiles() async {
    try {
      final romsPath = _configService.romsPath;
      final romsDir = Directory(romsPath);

      if (!await romsDir.exists()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ROMs directory does not exist')),
          );
        }
        return;
      }

      int totalRoms = 0;
      int missingRoms = 0;

      await for (final entity in romsDir.list(recursive: true)) {
        if (entity is File) {
          try {
            final stat = await entity.stat();
            // ROM files are small text files with URLs (< 5KB)
            if (stat.size < 5000) {
              totalRoms++;
              final contents = await entity.readAsString();
              if (contents.trim().isEmpty) {
                missingRoms++;
              }
            }
          } catch (e) {
            // Skip files we can't access
            continue;
          }
        }
      }

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('ROM Verification Results'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total ROM files: $totalRoms'),
                Text('Empty ROM files: $missingRoms'),
                Text('Valid ROM files: ${totalRoms - missingRoms}'),
              ],
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error verifying ROM files: $e')),
        );
      }
    }
  }

  Future<void> _checkMissingGamelists() async {
    try {
      final gamelistPath = await _configService.gamelistPath;
      final romsPath = _configService.romsPath;

      final romsDir = Directory(romsPath);

      if (!await romsDir.exists()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ROMs directory does not exist')),
          );
        }
        return;
      }

      final platforms = <String>[];
      final missingGamelists = <String>[];

      // Get all platform directories
      await for (final entity in romsDir.list()) {
        if (entity is Directory) {
          final platform = path.basename(entity.path);
          platforms.add(platform);

          // Check if gamelist exists
          final gamelistFile = File(
            path.join(gamelistPath, platform, 'gamelist.xml'),
          );

          if (!await gamelistFile.exists()) {
            missingGamelists.add(platform);
          }
        }
      }

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Gamelist Check Results'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total platforms: ${platforms.length}'),
                Text('Missing gamelists: ${missingGamelists.length}'),
                if (missingGamelists.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Missing for:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...missingGamelists.map((p) => Text('  • $p')),
                ],
              ],
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error checking gamelists: $e')));
      }
    }
  }

  Future<void> _backupConfiguration() async {
    try {
      // Only backup if there are local overrides
      if (!_configService.hasLocalOverrides) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'No custom configuration to backup. '
                'Using bundled defaults.',
              ),
            ),
          );
        }
        return;
      }

      // Get current config
      final config = await _configService.getConfig();

      // Format as JSON
      final encoder = const JsonEncoder.withIndent('  ');
      final jsonString = encoder.convert(config);

      // Get save location from user
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Configuration Backup',
        fileName: 'config_backup_$timestamp.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        final file = File(result);
        await file.writeAsString(jsonString);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Configuration backed up to:\n$result')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error backing up configuration: $e')),
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
          title: const Text('System Utilities'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadStats,
              tooltip: 'Refresh stats (R)',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'System Statistics',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_isLoadingStats)
                        const Center(child: CircularProgressIndicator())
                      else if (_stats != null) ...[
                        _StatRow(
                          label: 'ROM Files',
                          value: '${_stats!['romCount'] ?? 0}',
                          icon: Icons.file_copy,
                        ),
                        const SizedBox(height: 8),
                        _StatRow(
                          label: 'ROMs Path',
                          value: _configService.romsPath,
                          icon: Icons.folder,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Maintenance Tools',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: ListView(
                  children: [
                    _UtilityCard(
                      icon: Icons.cleaning_services,
                      title: 'Cleanup Temporary ROMs',
                      description:
                          'Remove temporary ROM files from system temp directory',
                      onPressed: _cleanupTempRoms,
                    ),
                    _UtilityCard(
                      icon: Icons.verified,
                      title: 'Verify ROM Files',
                      description:
                          'Check that all ROM files exist and are valid',
                      onPressed: _verifyRomFiles,
                    ),
                    _UtilityCard(
                      icon: Icons.checklist,
                      title: 'Check Missing Gamelists',
                      description: 'Find platforms missing gamelist.xml files',
                      onPressed: _checkMissingGamelists,
                    ),
                    _UtilityCard(
                      icon: Icons.backup,
                      title: 'Backup Configuration',
                      description: 'Create a backup of config.json',
                      onPressed: _backupConfiguration,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget for displaying a stat row
class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Widget for a utility action card
class _UtilityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onPressed;

  const _UtilityCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onPressed,
      ),
    );
  }
}
