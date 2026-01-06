import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import '../../services/config_service.dart';
import '../../services/keyboard_service.dart';

/// Screen for configuring system paths
///
/// Allows users to:
/// - Configure ROMs path
/// - Configure media path
/// - Configure emulators path
/// - Configure gamelists path
/// - Update environment variables
/// - View config source and reset to defaults
class SystemPathsScreen extends StatefulWidget {
  const SystemPathsScreen({super.key});

  @override
  State<SystemPathsScreen> createState() => _SystemPathsScreenState();
}

class _SystemPathsScreenState extends State<SystemPathsScreen> {
  final _configService = ConfigService.instance;
  final _keyboardService = KeyboardService.instance;
  final _focusNode = FocusNode();
  late final TextEditingController _romsPathController;
  late final TextEditingController _mediaPathController;
  late final TextEditingController _emulatorsPathController;
  late final TextEditingController _gamelistPathController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _romsPathController = TextEditingController(text: _configService.romsPath);
    _mediaPathController = TextEditingController(
      text: _configService.mediaPath,
    );
    _emulatorsPathController = TextEditingController(
      text: _configService.emulatorsPath,
    );
    _gamelistPathController = TextEditingController(
      text: _configService.gamelistPath,
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _romsPathController.dispose();
    _mediaPathController.dispose();
    _emulatorsPathController.dispose();
    _gamelistPathController.dispose();
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

    // Handle save (Ctrl+S)
    if ((event.logicalKey == LogicalKeyboardKey.keyS) &&
        (event.logicalKey == LogicalKeyboardKey.controlLeft ||
            event.logicalKey == LogicalKeyboardKey.controlRight)) {
      if (!_isSaving) {
        _savePaths();
      }
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  Future<void> _pickDirectory(TextEditingController controller) async {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      setState(() {
        controller.text = result;
      });
    }
  }

  Future<void> _savePaths() async {
    setState(() => _isSaving = true);

    try {
      // Update environment variables
      _configService.setEnvVariable('ROMS_PATH', _romsPathController.text);
      _configService.setEnvVariable('MEDIA_PATH', _mediaPathController.text);
      _configService.setEnvVariable(
        'EMULATORS_PATH',
        _emulatorsPathController.text,
      );
      _configService.setEnvVariable(
        'GAMELIST_PATH',
        _gamelistPathController.text,
      );

      // Save to .env file
      await _configService.saveEnvFile();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Paths saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving paths: $e')));
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _resetToDefaults() async {
    setState(() {
      _romsPathController.text = '/path/to/roms';
      _mediaPathController.text = '/path/to/media';
      _emulatorsPathController.text = '/path/to/emulators';
      _gamelistPathController.text = '/path/to/gamelists';
    });
  }

  Future<void> _resetConfigToDefaults() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Configuration'),
        content: const Text(
          'This will reset the emulator configuration to bundled defaults. '
          'Any custom emulator settings will be lost. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _configService.resetToDefaults();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Configuration reset to defaults')),
          );
          setState(() {}); // Refresh to show updated config path
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error resetting configuration: $e')),
          );
        }
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
          title: const Text('System Paths Configuration'),
          actions: [
            IconButton(
              icon: const Icon(Icons.restore),
              onPressed: _resetToDefaults,
              tooltip: 'Reset to defaults',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const Text(
                      'Configure paths for ROMs, media, and emulators',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    _PathField(
                      label: 'ROMs Path',
                      hint: 'Directory containing ROM folders',
                      controller: _romsPathController,
                      onBrowse: () => _pickDirectory(_romsPathController),
                    ),
                    const SizedBox(height: 16),
                    _PathField(
                      label: 'Media Path',
                      hint: 'Directory containing media (images, videos)',
                      controller: _mediaPathController,
                      onBrowse: () => _pickDirectory(_mediaPathController),
                    ),
                    const SizedBox(height: 16),
                    _PathField(
                      label: 'Emulators Path',
                      hint: 'Directory containing emulator binaries',
                      controller: _emulatorsPathController,
                      onBrowse: () => _pickDirectory(_emulatorsPathController),
                    ),
                    const SizedBox(height: 16),
                    _PathField(
                      label: 'Gamelist Path',
                      hint: 'Directory containing gamelist.xml files',
                      controller: _gamelistPathController,
                      onBrowse: () => _pickDirectory(_gamelistPathController),
                    ),
                    const SizedBox(height: 16),
                    // Config source display (read-only)
                    Card(
                      color: Colors.green.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.settings_applications,
                                  color: Colors.green.shade700,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Configuration File',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Source:',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        _configService.configPath,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                      if (_configService.hasLocalOverrides) ...[
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Custom configuration active',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.orange,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                if (_configService.hasLocalOverrides)
                                  IconButton(
                                    icon: const Icon(Icons.restore),
                                    onPressed: _resetConfigToDefaults,
                                    tooltip: 'Reset to defaults',
                                    color: Colors.orange.shade700,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 16),
                    Card(
                      color: Colors.blue.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.blue.shade700,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Path Structure',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'ROMs Path: ROMS_PATH/platform/rom.txt\n'
                              'Media Path: MEDIA_PATH/platform/boxart|screenshots|videos/rom.png\n'
                              'Gamelist Path: GAMELIST_PATH/platform/gamelist.xml',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _savePaths,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save Paths'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget for displaying and editing a path field
class _PathField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final VoidCallback onBrowse;

  const _PathField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.onBrowse,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.folder_open),
          onPressed: onBrowse,
          tooltip: 'Browse',
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
