import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/config_service.dart';
import '../../services/keyboard_service.dart';
import '../../services/gamepad_service.dart';
import '../../services/debug_service.dart';
import '../../mixins/gamepad_polling_mixin.dart';
import '../../mixins/screen_navigation_mixin.dart';
import '../../widgets/common/controls_bottom_bar.dart';
import '../../widgets/common/app_snackbar.dart';
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
        AppSnackBar.success(
          context,
          AppLocalizations.of(context)!.archiveOrgSettingsSaved,
        );
      }
    } catch (e) {
      _debug.error(
        'Error saving Archive.org credentials: $e',
        tag: 'ArchiveOrgSettings',
      );
      if (mounted) {
        AppSnackBar.error(
          context,
          '${AppLocalizations.of(context)!.errorSavingSettings} $e',
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
        body: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              Text(
                                l10n.archiveOrgSettingsDescription,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.65),
                                    ),
                              ),
                              const SizedBox(height: 20),

                              // Info card
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF0A84FF,
                                  ).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF0A84FF,
                                    ).withValues(alpha: 0.3),
                                  ),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.info_outline_rounded,
                                      color: Color(0xFF0A84FF),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            l10n.archiveOrgWhyNeeded,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(
                                                    0xFF0A84FF,
                                                  ),
                                                ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            l10n.archiveOrgExplanation,
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
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Access Key field
                              _buildKeyCard(
                                context,
                                isSelected: _selectedIndex == 0,
                                label: l10n.archiveOrgAccessKey,
                                hint: l10n.archiveOrgAccessKeyHint,
                                controller: _accessKeyController,
                                obscureText: false,
                              ),
                              const SizedBox(height: 14),

                              // Secret Key field
                              _buildKeyCard(
                                context,
                                isSelected: _selectedIndex == 1,
                                label: l10n.archiveOrgSecretKey,
                                hint: l10n.archiveOrgSecretKeyHint,
                                controller: _secretKeyController,
                                obscureText: true,
                              ),
                            ],
                          ),
                        ),

                        // Save button
                        const SizedBox(height: 16),
                        Container(
                          decoration: _selectedIndex == 2
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    width: 2,
                                  ),
                                )
                              : null,
                          child: SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: _isSaving ? null : _saveSettings,
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: _isSaving
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                ),
              ),
            ),
            ControlsBottomBar(
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
          ],
        ),
      ),
    );
  }

  Widget _buildKeyCard(
    BuildContext context, {
    required bool isSelected,
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool obscureText,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.outline.withValues(alpha: 0.14),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: const OutlineInputBorder(),
            ),
            obscureText: obscureText,
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }
}
