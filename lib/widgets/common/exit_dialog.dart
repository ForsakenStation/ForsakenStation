import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forsaken/widgets/common/navigable_dialog.dart';
import 'package:forsaken/widgets/common/dialog_button_bar.dart';
import 'package:forsaken/widgets/common/gamepad_button_indicator.dart';

/// Exit confirmation dialog using NavigableDialog
///
/// Displays a confirmation message with Cancel and Exit buttons.
/// Automatically handles:
/// - ESC/B button to cancel
/// - A button to confirm exit
/// - Gamepad connection indicators
/// - Blur background
class ExitDialog extends NavigableDialog {
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
  String? getTitle(BuildContext context) => 'Exit Application';

  @override
  Widget buildContent(BuildContext context) {
    return const Text('Are you sure you want to exit?');
  }

  @override
  List<DialogButton> buildButtons(BuildContext context) {
    return [
      DialogButton(
        label: 'Cancel',
        primary: false,
        gamepadButton: GamepadButton.b,
        onPressed: () => Navigator.pop(context, false),
      ),
      DialogButton(
        label: 'Exit',
        primary: true,
        gamepadButton: GamepadButton.a,
        onPressed: () {
          SystemNavigator.pop();
        },
      ),
    ];
  }

  @override
  double getMaxWidth() => 400;
}
