import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/config_service.dart';
import '../../services/keyboard_service.dart';
import '../../widgets/common/platform_logo.dart';

/// Screen for managing emulator configurations
///
/// Allows users to:
/// - View all configured emulators
/// - Add new emulator configurations
/// - Edit existing emulator configurations
/// - Delete emulator configurations
class EmulatorManagementScreen extends StatefulWidget {
  const EmulatorManagementScreen({super.key});

  @override
  State<EmulatorManagementScreen> createState() =>
      _EmulatorManagementScreenState();
}

class _EmulatorManagementScreenState extends State<EmulatorManagementScreen> {
  final _configService = ConfigService.instance;
  final _keyboardService = KeyboardService.instance;
  final _focusNode = FocusNode();
  List<Map<String, dynamic>> _emulators = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEmulators();
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
    if (key == LogicalKeyboardKey.keyR && !_isLoading) {
      _loadEmulators();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  Future<void> _loadEmulators() async {
    setState(() => _isLoading = true);
    try {
      final emulators = await _configService.getEmulators();
      setState(() {
        _emulators = emulators;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading emulators: $e')));
      }
    }
  }

  void _addEmulator() {
    showDialog(
      context: context,
      builder: (context) => EmulatorEditDialog(
        onSave: (emulator) async {
          try {
            await _configService.addEmulator(emulator);
            await _loadEmulators();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Emulator added successfully')),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error adding emulator: $e')),
              );
            }
          }
        },
      ),
    );
  }

  void _editEmulator(Map<String, dynamic> emulator) {
    showDialog(
      context: context,
      builder: (context) => EmulatorEditDialog(
        emulator: emulator,
        onSave: (updatedEmulator) async {
          try {
            await _configService.updateEmulator(
              emulator['system'] as String,
              updatedEmulator,
            );
            await _loadEmulators();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Emulator updated successfully')),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error updating emulator: $e')),
              );
            }
          }
        },
      ),
    );
  }

  void _deleteEmulator(String system) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Emulator'),
        content: Text(
          'Are you sure you want to delete the emulator configuration for $system?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _configService.removeEmulator(system);
                await _loadEmulators();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Emulator deleted')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting emulator: $e')),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _getCommandPreview(dynamic command) {
    if (command is String) {
      return command.length > 80 ? '${command.substring(0, 80)}...' : command;
    } else if (command is List) {
      final count = command.length;
      return '$count command${count == 1 ? '' : 's'} configured';
    }
    return 'No command';
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) => _handleKeyEvent(event),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Emulator Management'),
          actions: [
            // Reload button
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Reload Configuration (R)',
              onPressed: _isLoading ? null : _loadEmulators,
            ),
            // Info button showing config source
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'Configuration Info',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Configuration Source'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Config location:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(_configService.configPath),
                        const SizedBox(height: 16),
                        Text(
                          'Has local overrides: ${_configService.hasLocalOverrides ? 'Yes' : 'No'}',
                        ),
                        if (_configService.hasLocalOverrides) ...[
                          const SizedBox(height: 8),
                          const Text(
                            'Your changes are saved to device storage.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ] else ...[
                          const SizedBox(height: 8),
                          const Text(
                            'Using bundled config. Edit to create local overrides.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _emulators.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.videogame_asset_off,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No emulators configured',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add your first emulator to get started',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _addEmulator,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Emulator'),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _emulators.length,
                itemBuilder: (context, index) {
                  final emulator = _emulators[index];
                  final system = emulator['system'] as String;
                  final command = emulator['command'];
                  final acceptZip = emulator['acceptZipFiles'];
                  final todo = emulator['todo'] == true;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: PlatformLogo(platformName: system, size: 96),
                      title: Row(
                        children: [
                          Text(
                            system.toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (todo) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'TODO',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          if (acceptZip == true) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.folder_zip,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ],
                        ],
                      ),
                      subtitle: Text(
                        _getCommandPreview(command),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editEmulator(emulator),
                            tooltip: 'Edit',
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red[300]),
                            onPressed: () => _deleteEmulator(system),
                            tooltip: 'Delete',
                          ),
                        ],
                      ),
                      onTap: () => _editEmulator(emulator),
                    ),
                  );
                },
              ),
        floatingActionButton: _emulators.isNotEmpty
            ? FloatingActionButton(
                onPressed: _addEmulator,
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}

/// Dialog for adding/editing emulator configurations
class EmulatorEditDialog extends StatefulWidget {
  final Map<String, dynamic>? emulator;
  final Function(Map<String, dynamic>) onSave;

  const EmulatorEditDialog({super.key, this.emulator, required this.onSave});

  @override
  State<EmulatorEditDialog> createState() => _EmulatorEditDialogState();
}

class _EmulatorEditDialogState extends State<EmulatorEditDialog> {
  late final TextEditingController _systemController;
  final List<TextEditingController> _commandControllers = [];
  late bool _acceptZipFiles;
  late bool _useForeverMode;
  late bool _todo;

  @override
  void initState() {
    super.initState();

    final system = widget.emulator?['system'] as String? ?? '';
    _systemController = TextEditingController(text: system);

    _acceptZipFiles = widget.emulator?['acceptZipFiles'] == true;
    _useForeverMode = widget.emulator?['useForeverMode'] == true;
    _todo = widget.emulator?['todo'] == true;

    // Load existing commands if editing
    if (widget.emulator != null) {
      final command = widget.emulator!['command'];
      if (command is String) {
        _commandControllers.add(TextEditingController(text: command));
      } else if (command is List) {
        for (final cmd in command) {
          _commandControllers.add(TextEditingController(text: cmd as String));
        }
      }
    }

    // Add at least one empty command entry
    if (_commandControllers.isEmpty) {
      _commandControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _systemController.dispose();
    for (final controller in _commandControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addCommand() {
    setState(() {
      _commandControllers.add(TextEditingController());
    });
  }

  void _removeCommand(int index) {
    setState(() {
      _commandControllers[index].dispose();
      _commandControllers.removeAt(index);
    });
  }

  void _save() {
    final system = _systemController.text.trim();

    if (system.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('System name is required')));
      return;
    }

    final commands = _commandControllers
        .map((c) => c.text.trim())
        .where((cmd) => cmd.isNotEmpty)
        .toList();

    if (commands.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least one command is required')),
      );
      return;
    }

    // If only one command, store as string, otherwise as array
    final commandValue = commands.length == 1 ? commands.first : commands;

    final emulator = {
      'system': system,
      'command': commandValue,
      'useForeverMode': _useForeverMode,
      'acceptZipFiles': _acceptZipFiles,
      'corePreferences': {},
    };

    if (_todo) {
      emulator['todo'] = true;
    }

    widget.onSave(emulator);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.emulator == null ? 'Add Emulator' : 'Edit Emulator'),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _systemController,
                decoration: const InputDecoration(
                  labelText: 'System',
                  hintText: 'e.g., nes, snes, ps1',
                ),
                enabled: widget.emulator == null,
              ),
              const SizedBox(height: 16),

              // Commands section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Commands',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: _addCommand,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Command'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              ..._commandControllers.asMap().entries.map((entry) {
                final index = entry.key;
                final controller = entry.value;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              labelText: 'Command ${index + 1}',
                              hintText:
                                  'e.g., ../retroarch.AppImage -f -L core.so',
                              isDense: true,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        if (_commandControllers.length > 1) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeCommand(index),
                            tooltip: 'Remove',
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Options
              const Text(
                'Options',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              CheckboxListTile(
                title: const Text('Accept ZIP files'),
                subtitle: const Text('Allow launching ROMs from ZIP archives'),
                value: _acceptZipFiles,
                onChanged: (value) =>
                    setState(() => _acceptZipFiles = value ?? false),
                dense: true,
              ),

              CheckboxListTile(
                title: const Text('Use Forever Mode'),
                subtitle: const Text('Keep emulator running'),
                value: _useForeverMode,
                onChanged: (value) =>
                    setState(() => _useForeverMode = value ?? false),
                dense: true,
              ),

              CheckboxListTile(
                title: const Text('TODO'),
                subtitle: const Text('Mark as pending implementation'),
                value: _todo,
                onChanged: (value) => setState(() => _todo = value ?? false),
                dense: true,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
