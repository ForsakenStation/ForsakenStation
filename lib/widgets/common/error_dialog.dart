import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:forsaken/widgets/common/navigable_dialog.dart';
import 'package:forsaken/widgets/common/dialog_button_bar.dart';
import 'package:forsaken/widgets/common/gamepad_button_indicator.dart';

/// Simple error dialog widget using NavigableDialog
///
/// Displays an error message with a single OK button.
/// Automatically handles:
/// - ESC/B button to close
/// - A button to confirm
/// - Gamepad connection indicators
/// - Blur background
class ErrorDialog extends NavigableDialog {
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
  String? getTitle(BuildContext context) => 'Error';

  @override
  Widget buildContent(BuildContext context) {
    return Text(message);
  }

  @override
  List<DialogButton> buildButtons(BuildContext context) {
    return [
      DialogButton(
        label: 'OK',
        primary: true,
        gamepadButton: GamepadButton.a,
        onPressed: () => Navigator.pop(context),
      ),
    ];
  }

  @override
  double getMaxWidth() => 400;
}
