import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../mixins/dialog_controls_mixin.dart';
import '../../l10n/generated/app_localizations.dart';
import 'dialog_button_bar.dart';
import 'gamepad_button_indicator.dart';

/// Exit confirmation dialog
///
/// Displays a confirmation message with Cancel and Exit buttons.
/// Automatically handles:
/// - ESC/B button to cancel
/// - A button to confirm exit
/// - Gamepad connection indicators
/// - Blur background
class ExitDialog extends StatefulWidget {
  const ExitDialog({super.key});

  /// Show exit confirmation dialog
  ///
  /// Returns true if user confirmed exit, false if cancelled.
  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: const ExitDialog(),
      ),
    );
    return result ?? false;
  }

  @override
  State<ExitDialog> createState() => _ExitDialogState();
}

class _ExitDialogState extends State<ExitDialog>
    with DialogControlsMixin<ExitDialog> {
  late List<DialogButton> _buttons;

  @override
  void initState() {
    super.initState();
    final l10n = AppLocalizations.of(context)!;

    // Build buttons list
    _buttons = [
      DialogButton(
        label: l10n.cancel,
        gamepadButton: GamepadButton.b,
        onPressed: _handleDismiss,
      ),
      DialogButton(
        label: l10n.exit,
        primary: true,
        gamepadButton: GamepadButton.a,
        onPressed: _handleExit,
      ),
    ];

    // Start dialog controls with navigation
    // Default to Exit button (last button)
    startDialogControlsWithNavigation(
      onCancel: _handleDismiss,
      buttonCount: _buttons.length,
      defaultIndex: 1, // Exit button
      onButtonSelected: (index) {
        if (mounted) setState(() {});
      },
      onConfirm: _handleConfirm,
      layout: ButtonLayout.horizontal,
    );
  }

  void _handleDismiss() {
    if (mounted) {
      Navigator.pop(context, false);
    }
  }

  void _handleExit() {
    SystemNavigator.pop();
  }

  void _handleConfirm() {
    // Execute selected button action
    _buttons[selectedButtonIndex].onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return wrapWithKeyboardHandler(
      onEscape: _handleDismiss,
      child: Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text(
                l10n.exitApplication,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              // Content
              Text(l10n.exitConfirm),
              const SizedBox(height: 24),

              // Buttons
              DialogButtonBar(
                buttons: _buttons,
                selectedIndex: selectedButtonIndex,
                layout: ButtonLayout.horizontal,
                alignment: MainAxisAlignment.end,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
