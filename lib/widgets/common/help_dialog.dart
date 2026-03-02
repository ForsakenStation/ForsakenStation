import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../mixins/dialog_controls_mixin.dart';
import '../../services/gamepad_service.dart';
import '../../l10n/generated/app_localizations.dart';
import 'gamepad_button_indicator.dart';

/// Help dialog that shows keyboard and gamepad controls for the application
/// Can be configured for different screens (Platforms or ROMs)
class HelpDialog extends StatefulWidget {
  final bool showSearchShortcut;
  final bool showPlatformInfoShortcut;

  const HelpDialog({
    super.key,
    this.showSearchShortcut = false,
    this.showPlatformInfoShortcut = false,
  });

  @override
  State<HelpDialog> createState() => _HelpDialogState();

  /// Show help dialog
  static Future<void> show(
    BuildContext context, {
    bool showSearchShortcut = false,
    bool showPlatformInfoShortcut = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by clicking outside
      barrierColor: Colors.black.withValues(alpha: 0.7), // Darker barrier
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur background
        child: HelpDialog(
          showSearchShortcut: showSearchShortcut,
          showPlatformInfoShortcut: showPlatformInfoShortcut,
        ),
      ),
    );
  }
}

class _HelpDialogState extends State<HelpDialog>
    with DialogControlsMixin<HelpDialog> {
  final _closeButtonFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Request focus on close button after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _closeButtonFocusNode.requestFocus();
      }
    });
    startDialogControls(
      onCancel: () => Navigator.pop(context),
      customHandler: _handleCustomGamepadInput,
    );
  }

  void _handleCustomGamepadInput() {
    final gamepad = GamepadService.instance;

    // A button = Close dialog (same as "Got it!")
    if (gamepad.isSelectPressed()) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _closeButtonFocusNode.dispose();
    super.dispose(); // DialogControlsMixin handles cleanup
  }

  @override
  Widget build(BuildContext context) {
    final hasGamepad = GamepadService.instance.isGamepadConnected;
    final l10n = AppLocalizations.of(context)!;

    return wrapWithKeyboardHandler(
      onEscape: () => Navigator.pop(context),
      child: Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.help_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.keyboardAndGamepadControls,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: l10n.close,
                    ),
                  ],
                ),
              ),
              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        context,
                        l10n.navigation,
                        Icons.navigation,
                        [
                          _ShortcutItem('Arrow Keys', l10n.helpNavigateItems),
                          _ShortcutItem(
                            'D-Pad / Left Stick',
                            l10n.helpGamepadNavigation,
                          ),
                          _ShortcutItem(
                            'Page Up / Page Down',
                            l10n.helpQuickNavigation,
                          ),
                          _ShortcutItem(
                            'LB / RB Buttons',
                            l10n.helpGamepadPageNavigation,
                          ),
                          _ShortcutItem('Home', l10n.helpGoToFirst),
                          _ShortcutItem('End', l10n.helpGoToLast),
                          _ShortcutItem(
                            'Shift + Letter',
                            l10n.helpJumpToLetter,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSection(context, l10n.actions, Icons.touch_app, [
                        _ShortcutItem('Enter / Space', l10n.helpSelectItem),
                        _ShortcutItem('A Button', l10n.helpGamepadSelect),
                        _ShortcutItem(
                          'Escape',
                          widget.showSearchShortcut
                              ? l10n.helpGoBackCloseDialogs
                              : l10n.helpExitApplication,
                        ),
                        _ShortcutItem('B Button', l10n.helpGamepadBackClose),
                      ]),
                      const SizedBox(height: 24),
                      _buildSection(
                        context,
                        l10n.viewControls,
                        Icons.view_module,
                        [
                          _ShortcutItem('V', l10n.helpToggleViewMode),
                          _ShortcutItem(
                            'Right Stick Click',
                            l10n.helpGamepadViewToggle,
                          ),
                          _ShortcutItem('R', l10n.helpRefreshView),
                          if (widget.showPlatformInfoShortcut)
                            _ShortcutItem('I', l10n.helpShowPlatformInfo),
                          if (widget.showSearchShortcut)
                            _ShortcutItem('S', l10n.helpActivateSearch),
                          if (widget.showSearchShortcut)
                            _ShortcutItem('X Button', l10n.helpGamepadSearch),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSection(context, l10n.help, Icons.info_outline, [
                        _ShortcutItem('?', l10n.helpShowHelpDialog),
                        _ShortcutItem('Y Button', l10n.helpGamepadHelp),
                      ]),
                      const SizedBox(height: 24),
                      // Tips section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  color: Theme.of(context).primaryColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.tips,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildTip(l10n.tipUseKeyboardOrGamepad),
                            _buildTip(l10n.tipAlphabeticalJump),
                            _buildTip(l10n.tipPressQuestionMark),
                            _buildTip(l10n.tipGamepadAlongside),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Footer
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: Focus(
                    focusNode: _closeButtonFocusNode,
                    onKeyEvent: (node, event) {
                      // Handle Enter and Space keys
                      if (event is KeyDownEvent &&
                          (event.logicalKey == LogicalKeyboardKey.enter ||
                              event.logicalKey == LogicalKeyboardKey.space ||
                              event.logicalKey == LogicalKeyboardKey.escape)) {
                        Navigator.of(context).pop();
                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (hasGamepad) ...[
                            GamepadButtonIndicator(button: GamepadButton.b),
                            const SizedBox(width: 8),
                          ],
                          Text(l10n.gotIt),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    List<_ShortcutItem> shortcuts,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...shortcuts.map((shortcut) => _buildShortcutRow(context, shortcut)),
      ],
    );
  }

  Widget _buildShortcutRow(BuildContext context, _ShortcutItem shortcut) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              shortcut.key,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              shortcut.description,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 14)),
          Expanded(child: Text(tip, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}

class _ShortcutItem {
  final String key;
  final String description;

  _ShortcutItem(this.key, this.description);
}
