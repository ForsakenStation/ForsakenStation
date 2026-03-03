import 'dart:ui';
import 'package:flutter/material.dart';
import '../../mixins/dialog_controls_mixin.dart';
import '../../l10n/generated/app_localizations.dart';
import 'dialog_button_bar.dart';
import 'gamepad_button_indicator.dart';

/// Simple error dialog widget
///
/// Displays an error message with a single OK button.
/// Automatically handles:
/// - ESC/B button to close
/// - A button to confirm
/// - Gamepad connection indicators
/// - Blur background
class ErrorDialog extends StatefulWidget {
  final String message;

  const ErrorDialog({super.key, required this.message});

  /// Show error dialog
  ///
  /// Helper method for showing error dialog with blur background.
  /// Calls onClose callback after dialog is dismissed.
  static Future<void> show({
    required BuildContext context,
    required String message,
    required VoidCallback onClose,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: ErrorDialog(message: message),
      ),
    ).then((_) => onClose());
  }

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog>
    with DialogControlsMixin<ErrorDialog> {
  late List<DialogButton> _buttons;

  @override
  void initState() {
    super.initState();

    // Build buttons list (using placeholder, updated in didChangeDependencies)
    _buttons = [
      DialogButton(
        label: 'OK',
        primary: true,
        gamepadButton: GamepadButton.a,
        onPressed: _handleClose,
      ),
    ];

    // Start dialog controls with navigation
    startDialogControlsWithNavigation(
      onCancel: _handleClose,
      buttonCount: _buttons.length,
      defaultIndex: 0, // OK button
      onButtonSelected: (index) {
        if (mounted) setState(() {});
      },
      onConfirm: _handleConfirm,
      layout: ButtonLayout.horizontal,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _buttons = [
      DialogButton(
        label: AppLocalizations.of(context)!.ok,
        primary: true,
        gamepadButton: GamepadButton.a,
        onPressed: _handleClose,
      ),
    ];
  }

  void _handleClose() {
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _handleConfirm() {
    // Execute selected button action
    _buttons[selectedButtonIndex].onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return wrapWithKeyboardHandler(
      onEscape: _handleClose,
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
                AppLocalizations.of(context)!.error,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              // Content
              Text(widget.message),
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
