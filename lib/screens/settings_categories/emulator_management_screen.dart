import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/config_service.dart';
import '../../services/keyboard_service.dart';
import '../../widgets/common/platform_logo.dart';
import '../../widgets/common/controls_bottom_bar.dart';
import '../../widgets/common/dialog_button_bar.dart';
import '../../widgets/common/gamepad_button_indicator.dart';
import '../../l10n/generated/app_localizations.dart';

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
      // Force reload config from source (assets or shared_preferences)
      await _configService.reloadConfig();

      final emulators = await _configService.getEmulators();
      setState(() {
        _emulators = emulators;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.configurationReloaded),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.errorLoadingEmulators} $e',
            ),
          ),
        );
      }
    }
  }

  void _addEmulator() {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (context) => EmulatorEditDialog(
        onSave: (emulator) async {
          try {
            await _configService.addEmulator(emulator);
            await _loadEmulators();
            if (mounted) {
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.emulatorAdded),
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text(
                    '${AppLocalizations.of(context)!.errorAddingEmulator} $e',
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _editEmulator(Map<String, dynamic> emulator) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
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
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.emulatorUpdated),
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text(
                    '${AppLocalizations.of(context)!.errorUpdatingEmulator} $e',
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _deleteEmulator(String system) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteEmulator),
        content: Text(
          AppLocalizations.of(context)!.confirmDeleteEmulator(system),
        ),
        actions: [
          DialogButtonBar(
            buttons: [
              DialogButton(
                label: AppLocalizations.of(context)!.cancel,
                onPressed: () => Navigator.pop(context),
                gamepadButton: GamepadButton.b,
              ),
              DialogButton(
                label: AppLocalizations.of(context)!.delete,
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await _configService.removeEmulator(system);
                    await _loadEmulators();
                    if (mounted) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.emulatorDeleted,
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            '${AppLocalizations.of(context)!.errorDeletingEmulator} $e',
                          ),
                        ),
                      );
                    }
                  }
                },
                primary: true,
                gamepadButton: GamepadButton.a,
              ),
            ],
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
      return AppLocalizations.of(context)!.commandsConfigured(count);
    }
    return AppLocalizations.of(context)!.noCommand;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) => _handleKeyEvent(event),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.emulatorManagement),
          actions: [
            // Reload button
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: AppLocalizations.of(context)!.reloadConfigTooltip,
              onPressed: _isLoading ? null : _loadEmulators,
            ),
            // Info button showing config source
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: AppLocalizations.of(context)!.configurationInfo,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      AppLocalizations.of(context)!.configurationSource,
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.configLocation,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(_configService.configPath),
                        const SizedBox(height: 16),
                        Text(
                          _configService.hasLocalOverrides
                              ? AppLocalizations.of(
                                  context,
                                )!.hasLocalOverridesYes
                              : AppLocalizations.of(
                                  context,
                                )!.hasLocalOverridesNo,
                        ),
                        if (_configService.hasLocalOverrides) ...[
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.changesSavedToDevice,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ] else ...[
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.usingBundledConfig,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                    actions: [
                      DialogButtonBar(
                        buttons: [
                          DialogButton(
                            label: AppLocalizations.of(context)!.ok,
                            onPressed: () => Navigator.pop(context),
                            primary: true,
                            gamepadButton: GamepadButton.b,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: _isLoading
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
                          Text(
                            AppLocalizations.of(context)!.noEmulatorsConfigured,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.addFirstEmulator,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _addEmulator,
                            icon: const Icon(Icons.add),
                            label: Text(
                              AppLocalizations.of(context)!.addEmulator,
                            ),
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
                            leading: PlatformLogo(
                              platformName: system,
                              size: 96,
                            ),
                            title: Row(
                              children: [
                                Text(
                                  system.toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                      'WIP',
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
                                  tooltip: AppLocalizations.of(context)!.edit,
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red[300],
                                  ),
                                  onPressed: () => _deleteEmulator(system),
                                  tooltip: AppLocalizations.of(context)!.delete,
                                ),
                              ],
                            ),
                            onTap: () => _editEmulator(emulator),
                          ),
                        );
                      },
                    ),
            ),
            ControlsBottomBar(
              actions: [
                BottomBarAction(
                  label: AppLocalizations.of(context)!.back,
                  keyboardKey: 'ESC',
                  gamepadButton: 'B',
                ),
                BottomBarAction(
                  label: AppLocalizations.of(context)!.refresh,
                  keyboardKey: 'R',
                  gamepadButton: 'Start',
                ),
              ],
            ),
          ],
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
          if (cmd is String) {
            _commandControllers.add(TextEditingController(text: cmd));
          } else if (cmd is Map<String, dynamic>) {
            _commandControllers.add(
              TextEditingController(text: cmd['command'] as String),
            );
          }
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.systemNameRequired),
        ),
      );
      return;
    }

    final commandStrings = _commandControllers
        .map((c) => c.text.trim())
        .where((cmd) => cmd.isNotEmpty)
        .toList();

    if (commandStrings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.commandRequired)),
      );
      return;
    }

    // Helper to extract name from command string (replicates Python script logic)
    String extractName(String cmd) {
      if (cmd.contains("retroarch.AppImage")) {
        final regExp = RegExp(r'/([^/]+)_libretro\.so');
        final match = regExp.firstMatch(cmd);
        if (match != null) {
          return match.group(1)!;
        }
        return "RetroArch";
      }
      final exePart = cmd.split(' ').first;
      var exeName = exePart.split(RegExp(r'[\\/]')).last;
      for (final ext in ['.AppImage', '.exe', '.EXE']) {
        if (exeName.endsWith(ext)) {
          exeName = exeName.substring(0, exeName.length - ext.length);
          break;
        }
      }
      return exeName;
    }

    final List<Map<String, dynamic>> commands = commandStrings.map((cmd) {
      return {'name': extractName(cmd), 'command': cmd};
    }).toList();

    final emulator = {
      'system': system,
      'command': commands,
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
      title: Text(
        widget.emulator == null
            ? AppLocalizations.of(context)!.addEmulator
            : AppLocalizations.of(context)!.editEmulator,
      ),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _systemController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.system,
                  hintText: AppLocalizations.of(context)!.systemHint,
                ),
                enabled: widget.emulator == null,
              ),
              const SizedBox(height: 16),

              // Commands section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.commands,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _addCommand,
                    icon: const Icon(Icons.add),
                    label: Text(AppLocalizations.of(context)!.addCommand),
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
                              labelText: AppLocalizations.of(
                                context,
                              )!.commandNumber(index + 1),
                              hintText: AppLocalizations.of(
                                context,
                              )!.commandHint,
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
                            tooltip: AppLocalizations.of(context)!.remove,
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
              Text(
                AppLocalizations.of(context)!.options,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              CheckboxListTile(
                title: Text(AppLocalizations.of(context)!.acceptZipFiles),
                subtitle: Text(AppLocalizations.of(context)!.acceptZipSubtitle),
                value: _acceptZipFiles,
                onChanged: (value) =>
                    setState(() => _acceptZipFiles = value ?? false),
                dense: true,
              ),

              CheckboxListTile(
                title: Text(AppLocalizations.of(context)!.useForeverMode),
                subtitle: Text(
                  AppLocalizations.of(context)!.useForeverSubtitle,
                ),
                value: _useForeverMode,
                onChanged: (value) =>
                    setState(() => _useForeverMode = value ?? false),
                dense: true,
              ),

              CheckboxListTile(
                title: Text(AppLocalizations.of(context)!.workInProgress),
                subtitle: Text(AppLocalizations.of(context)!.wipSubtitle),
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
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(AppLocalizations.of(context)!.save),
        ),
      ],
    );
  }
}
