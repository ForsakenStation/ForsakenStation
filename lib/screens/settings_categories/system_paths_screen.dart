import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import '../../services/config_service.dart';
import '../../services/debug_service.dart';
import '../../services/keyboard_service.dart';
import '../../services/gamepad_service.dart';
import '../../services/rom_storage_service.dart';
import '../../mixins/gamepad_polling_mixin.dart';
import '../../mixins/screen_navigation_mixin.dart';
import '../../widgets/common/gamepad_button_indicator.dart';
import '../../widgets/common/controls_bottom_bar.dart';
import '../../widgets/common/app_snackbar.dart';
import '../../widgets/common/dialog_button_bar.dart';
import '../../l10n/generated/app_localizations.dart';

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

class _SystemPathsScreenState extends State<SystemPathsScreen>
    with GamepadPollingMixin<SystemPathsScreen>, ScreenNavigationMixin {
  final _configService = ConfigService.instance;
  final _storageService = RomStorageService.instance;
  final _keyboardService = KeyboardService.instance;
  final _focusNode = FocusNode();
  late final TextEditingController _romsPathController;
  late final TextEditingController _mediaPathController;
  late final TextEditingController _emulatorsPathController;
  late final TextEditingController _gamelistPathController;
  late final TextEditingController _romTempPathController;
  late final TextEditingController _romForeverPathController;

  bool _isSaving = false;
  bool _isMigrating = false;
  String _tempPathDisplay = '';
  String _foreverPathDisplay = '';

  // Navigation state
  int _selectedIndex = 0;
  static const int _totalItems = 6;
  bool _isGamepadConnected = false;
  String _gamelistPathDisplay = '';

  @override
  void initState() {
    super.initState();
    startGamepadPolling(_handleGamepadInput);
    _romsPathController = TextEditingController(text: _configService.romsPath);
    _mediaPathController = TextEditingController(
      text: _configService.mediaPath,
    );
    _emulatorsPathController = TextEditingController(
      text: _configService.emulatorsPath,
    );
    _gamelistPathController = TextEditingController(); // No longer editable
    _romTempPathController = TextEditingController(
      text: _configService.romTempPath,
    );
    _romForeverPathController = TextEditingController(
      text: _configService.romForeverPath,
    );

    _loadGamelistPath();
    _loadStorageInfo();
    _checkGamepadConnection();
  }

  /// Load gamelist path (read-only, managed automatically)
  Future<void> _loadGamelistPath() async {
    final gamelistPath = await _configService.gamelistPath;
    setState(() {
      _gamelistPathDisplay = gamelistPath;
    });
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
      safePop();
    }

    gamepad.updatePreviousButtonStates();
  }

  void _activateSelectedItem() {
    switch (_selectedIndex) {
      case 0: // Media path
        _pickDirectory(_mediaPathController);
        break;
      case 1: // Emulators path
        _pickDirectory(_emulatorsPathController);
        break;
      case 2: // Temp ROM path
        _pickDirectory(_romTempPathController);
        break;
      case 3: // Forever ROM path
        _pickDirectory(_romForeverPathController);
        break;
      case 4: // Reset button
        _resetToDefaults();
        break;
      case 5: // Save button
        if (!_isSaving && !_isMigrating) {
          _savePaths();
        }
        break;
    }
  }

  /// Load current storage paths and statistics
  Future<void> _loadStorageInfo() async {
    try {
      final tempDir = await _storageService.getTempStorageDirectory();
      final foreverDir = await _storageService.getForeverStorageDirectory();

      setState(() {
        _tempPathDisplay = tempDir.path;
        _foreverPathDisplay = foreverDir.path;
      });
    } catch (e) {
      DebugService.instance.error(
        'Error loading storage info: $e',
        tag: 'SystemPaths',
      );
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _romsPathController.dispose();
    _mediaPathController.dispose();
    _emulatorsPathController.dispose();
    _gamelistPathController.dispose();
    _romTempPathController.dispose();
    _romForeverPathController.dispose();
    super.dispose();
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

    // Handle back key (Escape, Backspace)
    if (_keyboardService.isBackKey(key)) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }

    // Handle save (Ctrl+S)
    if (event.logicalKey == LogicalKeyboardKey.keyS &&
        HardwareKeyboard.instance.isControlPressed) {
      if (!_isSaving) {
        _savePaths();
      }
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  Future<void> _pickDirectory(TextEditingController controller) async {
    final result = await FilePicker.getDirectoryPath();
    if (result != null) {
      setState(() {
        controller.text = result;
      });
    }
  }

  Future<void> _savePaths() async {
    setState(() => _isSaving = true);

    try {
      // Check if forever path changed and needs migration
      final oldForeverPath = _configService.romForeverPath;
      final newForeverPath = _romForeverPathController.text.trim();

      if (newForeverPath.isNotEmpty &&
          oldForeverPath.isNotEmpty &&
          oldForeverPath != newForeverPath) {
        // Confirm migration
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.migrateRoms),
            content: Text(
              AppLocalizations.of(context)!.migrateRomsDescription
                  .replaceAll('\$oldPath', oldForeverPath)
                  .replaceAll('\$newPath', newForeverPath),
            ),
            actions: [
              DialogButtonBar(
                buttons: [
                  DialogButton(
                    label: AppLocalizations.of(context)!.noKeepThem,
                    onPressed: () => Navigator.of(context).pop(false),
                    gamepadButton: GamepadButton.b,
                  ),
                  DialogButton(
                    label: AppLocalizations.of(context)!.yesMigrateRoms,
                    onPressed: () => Navigator.of(context).pop(true),
                    primary: true,
                    gamepadButton: GamepadButton.a,
                  ),
                ],
              ),
            ],
          ),
        );

        if (confirm == true) {
          setState(() => _isMigrating = true);
          final success = await _storageService.migrateForeverStorage(
            newForeverPath,
          );
          setState(() => _isMigrating = false);

          if (!success && mounted) {
            ScaffoldMessenger.of(context).clearSnackBars();
            AppSnackBar.warning(
              context,
              AppLocalizations.of(context)!.romMigrationFailed,
            );
          }
        }
      }

      // Save path settings to SharedPreferences
      await _configService.setPathSetting(
        'MEDIA_PATH',
        _mediaPathController.text,
      );
      await _configService.setPathSetting(
        'EMULATORS_PATH',
        _emulatorsPathController.text,
      );
      // Note: GAMELIST_PATH is now managed automatically, not configurable

      // Update ROM storage paths
      if (_romTempPathController.text.trim().isNotEmpty) {
        await _configService.setPathSetting(
          'ROM_TEMP_PATH',
          _romTempPathController.text.trim(),
        );
        _storageService.setCustomTempPath(_romTempPathController.text.trim());
      }

      if (_romForeverPathController.text.trim().isNotEmpty) {
        await _configService.setPathSetting(
          'ROM_FOREVER_PATH',
          _romForeverPathController.text.trim(),
        );
        _storageService.setCustomForeverPath(
          _romForeverPathController.text.trim(),
        );
      }

      // Reload storage info
      await _loadStorageInfo();

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        AppSnackBar.success(
          context,
          AppLocalizations.of(context)!.pathsSaved,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(
          context,
          '${AppLocalizations.of(context)!.errorSavingPaths} $e',
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _resetToDefaults() async {
    setState(() {
      _mediaPathController.text = '/path/to/media';
      _emulatorsPathController.text = '/path/to/emulators';
      // Gamelist path is now automatic, no need to reset
    });
  }

  Future<void> _resetConfigToDefaults() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.resetConfiguration),
        content: Text(AppLocalizations.of(context)!.resetConfigDescription),
        actions: [
          DialogButtonBar(
            buttons: [
              DialogButton(
                label: AppLocalizations.of(context)!.cancel,
                onPressed: () => Navigator.of(context).pop(false),
                gamepadButton: GamepadButton.b,
              ),
              DialogButton(
                label: AppLocalizations.of(context)!.reset,
                onPressed: () => Navigator.of(context).pop(true),
                primary: true,
                gamepadButton: GamepadButton.a,
              ),
            ],
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _configService.resetToDefaults();
        if (mounted) {
          AppSnackBar.success(
            context,
            AppLocalizations.of(context)!.configurationReset,
          );
          setState(() {}); // Refresh to show updated config path
        }
      } catch (e) {
        if (mounted) {
          AppSnackBar.error(
            context,
            '${AppLocalizations.of(context)!.errorResettingConfiguration} $e',
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
          title: Text(AppLocalizations.of(context)!.systemPathsConfiguration),
          actions: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: _selectedIndex == 4
                      ? BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        )
                      : null,
                  child: IconButton(
                    icon: const Icon(Icons.restore),
                    onPressed: _resetToDefaults,
                    tooltip: AppLocalizations.of(context)!.resetToDefaults,
                  ),
                ),
                if (_isGamepadConnected && _selectedIndex == 4)
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
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 880),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.configurePathsDescription,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.65),
                                    ),
                              ),
                              const SizedBox(height: 16),
                              // Info card about ROM database
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.08),
                                  ),
                                ),
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline_rounded,
                                      size: 20,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.7),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.romListsAutoManaged,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withValues(alpha: 0.8),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              _PathField(
                                label: AppLocalizations.of(
                                  context,
                                )!.mediaPathLabel,
                                hint: AppLocalizations.of(
                                  context,
                                )!.mediaPathHint,
                                controller: _mediaPathController,
                                onBrowse: () =>
                                    _pickDirectory(_mediaPathController),
                                isSelected: _selectedIndex == 0,
                                showGamepadIndicator: _isGamepadConnected,
                              ),
                              const SizedBox(height: 14),
                              _PathField(
                                label: AppLocalizations.of(
                                  context,
                                )!.emulatorsPathLabel,
                                hint: AppLocalizations.of(
                                  context,
                                )!.emulatorsPathHint,
                                controller: _emulatorsPathController,
                                onBrowse: () =>
                                    _pickDirectory(_emulatorsPathController),
                                isSelected: _selectedIndex == 1,
                                showGamepadIndicator: _isGamepadConnected,
                              ),
                              const SizedBox(height: 14),
                              // Gamelist path (read-only, informational)
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.08),
                                  ),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.playlist_play_rounded,
                                          size: 20,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.75),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.gamelistPathAutomatic,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _gamelistPathDisplay,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'monospace',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.85),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.gamelistAutoDescription,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.6),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 28),
                              Divider(
                                color: Theme.of(
                                  context,
                                ).colorScheme.outline.withValues(alpha: 0.14),
                              ),
                              const SizedBox(height: 16),
                              // ROM Storage section
                              Text(
                                AppLocalizations.of(context)!.romStorage,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.configureRomStorageDescription,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.65),
                                    ),
                              ),
                              const SizedBox(height: 14),
                              _PathField(
                                label: AppLocalizations.of(
                                  context,
                                )!.tempRomStorageLabel,
                                hint: _tempPathDisplay.isEmpty
                                    ? AppLocalizations.of(
                                        context,
                                      )!.defaultAppSupportDir
                                    : AppLocalizations.of(
                                        context,
                                      )!.currentPathDisplay(_tempPathDisplay),
                                controller: _romTempPathController,
                                onBrowse: () =>
                                    _pickDirectory(_romTempPathController),
                                isSelected: _selectedIndex == 2,
                                showGamepadIndicator: _isGamepadConnected,
                              ),
                              const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.tempRomStorageDescription,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    _PathField(
                      label: AppLocalizations.of(
                        context,
                      )!.permanentRomStorageLabel,
                      hint: _foreverPathDisplay.isEmpty
                          ? AppLocalizations.of(context)!.defaultAppSupportDir
                          : AppLocalizations.of(
                              context,
                            )!.currentPathDisplay(_foreverPathDisplay),
                      controller: _romForeverPathController,
                      onBrowse: () => _pickDirectory(_romForeverPathController),
                      isSelected: _selectedIndex == 3,
                      showGamepadIndicator: _isGamepadConnected,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.permanentRomStorageDescription,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    // Config source display (read-only)
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.settings_applications,
                                size: 20,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.75),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.configurationFile,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.source,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.6),
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _configService.configPath,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'monospace',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.85),
                                      ),
                                    ),
                                    if (_configService.hasLocalOverrides) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.customConfigActive,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.75),
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
                                  tooltip: AppLocalizations.of(
                                    context,
                                  )!.resetToDefaults,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Divider(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.14),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 20,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.75),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                AppLocalizations.of(context)!.pathStructure,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.pathStructureDescription,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                decoration: _selectedIndex == 5
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      )
                    : null,
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: (_isSaving || _isMigrating) ? null : _savePaths,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: (_isSaving || _isMigrating)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _isMigrating
                                    ? AppLocalizations.of(
                                        context,
                                      )!.migratingRoms
                                    : AppLocalizations.of(context)!.saving,
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(AppLocalizations.of(context)!.savePaths),
                              if (_isGamepadConnected &&
                                  _selectedIndex == 5) ...[
                                const SizedBox(width: 8),
                                const GamepadButtonIndicator(
                                  button: GamepadButton.a,
                                  size: 20,
                                ),
                              ],
                            ],
                          ),
                  ),
                ),
              ),
                      ],
                    ),
                  ),
                ),
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
                  label: AppLocalizations.of(context)!.navigate,
                  keyboardKey: '↑↓',
                  gamepadButton: 'D-pad',
                ),
                BottomBarAction(
                  label: AppLocalizations.of(context)!.select,
                  keyboardKey: 'Enter',
                  gamepadButton: 'A',
                ),
              ],
            ),
          ],
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
  final bool isSelected;
  final bool showGamepadIndicator;

  const _PathField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.onBrowse,
    this.isSelected = false,
    this.showGamepadIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.38)
              : Colors.white.withValues(alpha: 0.08),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
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
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.folder_open),
                onPressed: onBrowse,
                tooltip: AppLocalizations.of(context)!.browse,
                style: IconButton.styleFrom(
                  backgroundColor: isSelected
                      ? Colors.white.withValues(alpha: 0.16)
                      : Colors.white.withValues(alpha: 0.06),
                  foregroundColor: theme.colorScheme.onSurface,
                ),
              ),
              if (showGamepadIndicator && isSelected) ...[
                const SizedBox(height: 4),
                const GamepadButtonIndicator(
                  button: GamepadButton.a,
                  size: 20,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
