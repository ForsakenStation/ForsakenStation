import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/config_service.dart';
import '../../services/keyboard_service.dart';
import '../../services/emulator_download_service.dart';
import '../../models/emulator_download_info.dart';
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
  final _downloadService = EmulatorDownloadService.instance;
  final _keyboardService = KeyboardService.instance;
  final _focusNode = FocusNode();
  List<Map<String, dynamic>> _emulators = [];
  bool _isLoading = true;

  // Download state
  bool _isDownloading = false;
  final Map<String, _EmulatorDownloadTask> _downloadTasks = {};

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

  // ---------------------------------------------------------------------------
  // Emulator download functionality
  // ---------------------------------------------------------------------------

  void _showDownloadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.downloadEmulatorsAndGameLists,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DownloadCategoryTile(
              icon: Icons.download,
              title: AppLocalizations.of(context)!.downloadAll,
              onTap: () {
                Navigator.pop(context);
                _downloadCategory('all');
              },
            ),
            _DownloadCategoryTile(
              icon: Icons.videogame_asset,
              title: AppLocalizations.of(context)!.categorySony,
              onTap: () {
                Navigator.pop(context);
                _downloadCategory('sony');
              },
            ),
            _DownloadCategoryTile(
              icon: Icons.sports_esports,
              title: AppLocalizations.of(context)!.categoryNintendo,
              onTap: () {
                Navigator.pop(context);
                _downloadCategory('nintendo');
              },
            ),
            _DownloadCategoryTile(
              icon: Icons.gamepad,
              title: AppLocalizations.of(context)!.categoryMicrosoft,
              onTap: () {
                Navigator.pop(context);
                _downloadCategory('microsoft');
              },
            ),
            _DownloadCategoryTile(
              icon: Icons.apps,
              title: AppLocalizations.of(context)!.categoryMultiPlatform,
              onTap: () {
                Navigator.pop(context);
                _downloadCategory('multi');
              },
            ),
            _DownloadCategoryTile(
              icon: Icons.more_horiz,
              title: AppLocalizations.of(context)!.categoryOtherEmulators,
              onTap: () {
                Navigator.pop(context);
                _downloadCategory('other');
              },
            ),
            _DownloadCategoryTile(
              icon: Icons.build,
              title: AppLocalizations.of(context)!.categoryUtilities,
              onTap: () {
                Navigator.pop(context);
                _downloadCategory('utilities');
              },
            ),
          ],
        ),
        actions: [
          DialogButtonBar(
            buttons: [
              DialogButton(
                label: AppLocalizations.of(context)!.cancel,
                onPressed: () => Navigator.pop(context),
                primary: true,
                gamepadButton: GamepadButton.b,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _downloadCategory(String category) async {
    setState(() => _isDownloading = true);

    try {
      final List<EmulatorDownloadInfo> emulators;
      if (category == 'all') {
        emulators = await EmulatorCatalog.getAvailableForCurrentPlatform();
      } else {
        final allInCategory = await EmulatorCatalog.getByCategory(category);
        emulators = allInCategory
            .where((e) => e.isAvailableForCurrentPlatform())
            .toList();
      }

      if (emulators.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.noEmulatorsAvailable),
          ),
        );
        return;
      }

      final totalSizeMB = _downloadService.getTotalDownloadSize(emulators);

      if (!mounted) return;
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmDownload),
          content: Text(
            AppLocalizations.of(context)!.confirmDownloadDescription(
              '${emulators.length}',
              '$totalSizeMB',
            ),
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
                  label: AppLocalizations.of(context)!.download,
                  onPressed: () => Navigator.pop(context, true),
                  primary: true,
                  gamepadButton: GamepadButton.a,
                ),
              ],
            ),
          ],
        ),
      );

      if (confirm != true) return;

      for (final emulator in emulators) {
        final isInstalled = await _downloadService.isEmulatorInstalled(
          emulator,
        );
        if (isInstalled) {
          setState(() {
            _downloadTasks[emulator.name] = _EmulatorDownloadTask(
              name: emulator.displayName,
              status: _DownloadStatus.completed,
              progress: 1.0,
              statusMessage: AppLocalizations.of(context)!.alreadyInstalled,
            );
          });
          continue;
        }

        setState(() {
          _downloadTasks[emulator.name] = _EmulatorDownloadTask(
            name: emulator.displayName,
            status: _DownloadStatus.pending,
          );
        });
      }

      for (final emulator in emulators) {
        final task = _downloadTasks[emulator.name];
        if (task == null || task.status == _DownloadStatus.completed) continue;

        setState(() {
          task.status = _DownloadStatus.downloading;
          task.statusMessage = AppLocalizations.of(context)!.starting;
        });

        await _downloadService.downloadEmulator(
          emulator,
          onProgress: (progress) {
            if (mounted) {
              setState(() {
                task.progress = progress;
              });
            }
          },
          onStatus: (status) {
            if (mounted) {
              setState(() {
                task.statusMessage = status;
              });
            }
          },
        );

        setState(() {
          task.status = _DownloadStatus.completed;
          task.progress = 1.0;
          task.statusMessage = AppLocalizations.of(context)!.completed;
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.allDownloads)),
        );
      }
      _downloadService.makeAppImagesExecutable(
        Directory(ConfigService.instance.emulatorsPath).path,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.error}: $e')),
        );
      }
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  void _clearDownloadTasks() {
    setState(() {
      _downloadTasks.removeWhere(
        (key, task) =>
            task.status == _DownloadStatus.completed ||
            task.status == _DownloadStatus.failed,
      );
    });
  }

  Widget _buildDownloadTaskRow(_EmulatorDownloadTask task) {
    final IconData icon;
    final Color color;
    switch (task.status) {
      case _DownloadStatus.pending:
        icon = Icons.hourglass_empty;
        color = Colors.grey;
      case _DownloadStatus.downloading:
        icon = Icons.downloading;
        color = Colors.blue;
      case _DownloadStatus.completed:
        icon = Icons.check_circle;
        color = Colors.green;
      case _DownloadStatus.failed:
        icon = Icons.error;
        color = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.name, style: const TextStyle(fontSize: 13)),
                if (task.statusMessage != null)
                  Text(
                    task.statusMessage!,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
              ],
            ),
          ),
          if (task.status == _DownloadStatus.downloading) ...[
            SizedBox(
              width: 60,
              child: LinearProgressIndicator(
                value: task.progress > 0 ? task.progress : null,
              ),
            ),
            if (task.progress > 0)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  '${(task.progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ),
          ],
        ],
      ),
    );
  }

  void _addEmulator() {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => EmulatorEditDialog(
        onSave: (emulator) async {
          try {
            await _configService.addEmulator(emulator);
            await _loadEmulators();
            if (mounted) {
              scaffoldMessenger.showSnackBar(
                SnackBar(content: Text(l10n.emulatorAdded)),
              );
            }
          } catch (e) {
            if (mounted) {
              scaffoldMessenger.showSnackBar(
                SnackBar(content: Text('${l10n.errorAddingEmulator} $e')),
              );
            }
          }
        },
      ),
    );
  }

  void _editEmulator(Map<String, dynamic> emulator) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
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
                SnackBar(content: Text(l10n.emulatorUpdated)),
              );
            }
          } catch (e) {
            if (mounted) {
              scaffoldMessenger.showSnackBar(
                SnackBar(content: Text('${l10n.errorUpdatingEmulator} $e')),
              );
            }
          }
        },
      ),
    );
  }

  void _deleteEmulator(String system) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteEmulator),
        content: Text(l10n.confirmDeleteEmulator(system)),
        actions: [
          DialogButtonBar(
            buttons: [
              DialogButton(
                label: l10n.cancel,
                onPressed: () => Navigator.pop(context),
                gamepadButton: GamepadButton.b,
              ),
              DialogButton(
                label: l10n.delete,
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await _configService.removeEmulator(system);
                    await _loadEmulators();
                    if (mounted) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text(l10n.emulatorDeleted)),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text('${l10n.errorDeletingEmulator} $e'),
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
                  : ListView(
                      children: [
                        // Download emulators section
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.download, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.downloadAll,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      ElevatedButton.icon(
                                        onPressed: _isDownloading
                                            ? null
                                            : _showDownloadDialog,
                                        icon: const Icon(Icons.download),
                                        label: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.download,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Active download tasks
                                  if (_downloadTasks.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    const Divider(),
                                    const SizedBox(height: 8),
                                    ..._downloadTasks.values.map(
                                      (task) => _buildDownloadTaskRow(task),
                                    ),
                                    const SizedBox(height: 8),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: _clearDownloadTasks,
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.clearCompleted,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Emulators list or empty state
                        if (_emulators.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Center(
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
                                    AppLocalizations.of(
                                      context,
                                    )!.noEmulatorsConfigured,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.addFirstEmulator,
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
                            ),
                          )
                        else
                          ..._emulators.map((emulator) {
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
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
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
                                      tooltip: AppLocalizations.of(
                                        context,
                                      )!.edit,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red[300],
                                      ),
                                      onPressed: () => _deleteEmulator(system),
                                      tooltip: AppLocalizations.of(
                                        context,
                                      )!.delete,
                                    ),
                                  ],
                                ),
                                onTap: () => _editEmulator(emulator),
                              ),
                            );
                          }),
                      ],
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
  late final TextEditingController _launchFileController;
  final List<TextEditingController> _commandControllers = [];
  late bool _acceptZipFiles;
  late bool _useForeverMode;
  late bool _todo;

  @override
  void initState() {
    super.initState();

    final system = widget.emulator?['system'] as String? ?? '';
    _systemController = TextEditingController(text: system);
    _launchFileController = TextEditingController(
      text: widget.emulator?['launchFile'] as String? ?? '',
    );

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
    _launchFileController.dispose();
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

    final launchFile = _launchFileController.text.trim();
    if (launchFile.isNotEmpty) {
      emulator['launchFile'] = launchFile;
    }

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

              // Launch file field (only relevant when acceptZipFiles is false)
              if (!_acceptZipFiles)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _launchFileController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.launchFile,
                      hintText: AppLocalizations.of(context)!.launchFileHint,
                      helperText: AppLocalizations.of(
                        context,
                      )!.launchFileSubtitle,
                      helperMaxLines: 2,
                    ),
                  ),
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

// -----------------------------------------------------------------------------
// Emulator download helper classes
// -----------------------------------------------------------------------------

class _DownloadCategoryTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DownloadCategoryTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

enum _DownloadStatus { pending, downloading, completed, failed }

class _EmulatorDownloadTask {
  final String name;
  _DownloadStatus status;
  double progress;
  String? statusMessage;

  _EmulatorDownloadTask({
    required this.name,
    this.status = _DownloadStatus.pending,
    this.progress = 0.0,
    this.statusMessage,
  });
}
