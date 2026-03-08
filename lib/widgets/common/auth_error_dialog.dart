import 'dart:ui';
import 'package:flutter/material.dart';
import '../../mixins/dialog_controls_mixin.dart';
import '../../l10n/generated/app_localizations.dart';
import 'dialog_button_bar.dart';
import 'gamepad_button_indicator.dart';

/// Dialog shown when a download fails due to missing Archive.org
/// authentication credentials.
///
/// Displays two buttons:
/// - Cancel (close dialog)
/// - Go to Settings (navigate to Archive.org settings)
class AuthErrorDialog extends StatefulWidget {
  const AuthErrorDialog({super.key});

  /// Show auth error dialog.
  ///
  /// Returns `true` if the user chose "Go to Settings", `false` otherwise.
  static Future<bool> show({
    required BuildContext context,
    required VoidCallback onClose,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: const AuthErrorDialog(),
      ),
    );
    onClose();
    return result ?? false;
  }

  @override
  State<AuthErrorDialog> createState() => _AuthErrorDialogState();
}

class _AuthErrorDialogState extends State<AuthErrorDialog>
    with DialogControlsMixin<AuthErrorDialog> {
  late List<DialogButton> _buttons;

  @override
  void initState() {
    super.initState();

    _buttons = [
      DialogButton(
        label: 'Cancel',
        gamepadButton: GamepadButton.b,
        onPressed: _handleCancel,
      ),
      DialogButton(
        label: 'Go to Settings',
        primary: true,
        gamepadButton: GamepadButton.a,
        onPressed: _handleGoToSettings,
      ),
    ];

    startDialogControlsWithNavigation(
      onCancel: _handleCancel,
      buttonCount: _buttons.length,
      defaultIndex: 1, // Default to "Go to Settings"
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
    final l10n = AppLocalizations.of(context)!;
    _buttons = [
      DialogButton(
        label: l10n.cancel,
        gamepadButton: GamepadButton.b,
        onPressed: _handleCancel,
      ),
      DialogButton(
        label: l10n.goToSettings,
        primary: true,
        gamepadButton: GamepadButton.a,
        onPressed: _handleGoToSettings,
      ),
    ];
  }

  void _handleCancel() {
    if (mounted) {
      Navigator.pop(context, false);
    }
  }

  void _handleGoToSettings() {
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  void _handleConfirm() {
    _buttons[selectedButtonIndex].onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return wrapWithKeyboardHandler(
      onEscape: _handleCancel,
      child: Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Row(
                children: [
                  Icon(Icons.lock_outline, color: Colors.orange.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.archiveOrgAuthRequired,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Message
              Text(l10n.archiveOrgAuthRequiredMessage),
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
