import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/config_service.dart';
import '../../services/keyboard_service.dart';
import '../../services/gamepad_service.dart';
import '../../services/debug_service.dart';
import '../../mixins/gamepad_polling_mixin.dart';
import '../../mixins/screen_navigation_mixin.dart';
import '../../widgets/common/controls_bottom_bar.dart';
import '../../l10n/generated/app_localizations.dart';

/// Screen for configuring Archive.org S3 API credentials.
///
/// Allows users to enter their Archive.org access key and secret key
/// for authenticated downloads from archive.org.
class ArchiveOrgSettingsScreen extends StatefulWidget {
  const ArchiveOrgSettingsScreen({super.key});

  @override
  State<ArchiveOrgSettingsScreen> createState() =>
      _ArchiveOrgSettingsScreenState();
}

class _ArchiveOrgSettingsScreenState extends State<ArchiveOrgSettingsScreen>
    with
        GamepadPollingMixin<ArchiveOrgSettingsScreen>,
        ScreenNavigationMixin<ArchiveOrgSettingsScreen> {
  final _configService = ConfigService.instance;
  final _keyboardService = KeyboardService.instance;
  final _debug = DebugService.instance;
  final _focusNode = FocusNode();
  late final TextEditingController _accessKeyController;
  late final TextEditingController _secretKeyController;

  bool _isSaving = false;

  // Navigation state
  int _selectedIndex = 0;
  static const int _totalItems = 3; // Access key, Secret key, Save button

  @override
  void initState() {
    super.initState();
    _accessKeyController = TextEditingController();
    _secretKeyController = TextEditingController();
    _loadSettings();
    startGamepadPolling(_handleGamepadInput);
  }

  void _loadSettings() {
    final accessKey = _configService.archiveOrgAccessKey;
    final secretKey = _configService.archiveOrgSecretKey;
    setState(() {
      _accessKeyController.text = accessKey;
      _secretKeyController.text = secretKey;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _accessKeyController.dispose();
    _secretKeyController.dispose();
    super.dispose();
  }

  void _handleGamepadInput() {
    final gamepad = GamepadService.instance;

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

    if (gamepad.isSelectPressed()) {
      _activateSelectedItem();
    } else if (gamepad.isBackPressed()) {
      safePop();
    }

    gamepad.updatePreviousButtonStates();
  }

  void _activateSelectedItem() {
    switch (_selectedIndex) {
      case 0: // Access key field
        _focusNode.unfocus();
        break;
      case 1: // Secret key field
        _focusNode.unfocus();
        break;
      case 2: // Save button
        if (!_isSaving) _saveSettings();
        break;
    }
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    if (_keyboardService.isBackKey(key)) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }

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

    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      _activateSelectedItem();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);

    try {
      final accessKey = _accessKeyController.text.trim();
      final secretKey = _secretKeyController.text.trim();

      await _configService.setArchiveOrgAccessKey(accessKey);
      await _configService.setArchiveOrgSecretKey(secretKey);

      _debug.info('Archive.org credentials saved', tag: 'ArchiveOrgSettings');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.archiveOrgSettingsSaved,
            ),
          ),
        );
      }
    } catch (e) {
      _debug.error(
        'Error saving Archive.org credentials: $e',
        tag: 'ArchiveOrgSettings',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.errorSavingSettings} $e',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) => _handleKeyEvent(event),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.archiveOrgSettings), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      l10n.archiveOrgSettingsDescription,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    // Info card
                    Card(
                      color: Colors.blue.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue.shade700,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.archiveOrgWhyNeeded,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade900,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    l10n.archiveOrgExplanation,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.blue.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Access Key field
                    Card(
                      elevation: _selectedIndex == 0 ? 8 : 2,
                      color: _selectedIndex == 0
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.archiveOrgAccessKey,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _accessKeyController,
                              decoration: InputDecoration(
                                hintText: l10n.archiveOrgAccessKeyHint,
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Secret Key field
                    Card(
                      elevation: _selectedIndex == 1 ? 8 : 2,
                      color: _selectedIndex == 1
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.archiveOrgSecretKey,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _secretKeyController,
                              decoration: InputDecoration(
                                hintText: l10n.archiveOrgSecretKeyHint,
                                border: const OutlineInputBorder(),
                              ),
                              obscureText: true,
                              keyboardType: TextInputType.text,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Save button
              const SizedBox(height: 16),
              Container(
                decoration: _selectedIndex == 2
                    ? BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      )
                    : null,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveSettings,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: _selectedIndex == 2
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                    ),
                    child: _isSaving
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
                              Text(l10n.saving),
                            ],
                          )
                        : Text(l10n.saveSettings),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: ControlsBottomBar(
          actions: [
            BottomBarAction(
              label: l10n.back,
              keyboardKey: 'ESC',
              gamepadButton: 'B',
            ),
            BottomBarAction(
              label: l10n.navigate,
              keyboardKey: '\u2191\u2193',
              gamepadButton: 'D-pad',
            ),
            BottomBarAction(
              label: l10n.select,
              keyboardKey: 'Enter',
              gamepadButton: 'A',
            ),
          ],
        ),
      ),
    );
  }
}
