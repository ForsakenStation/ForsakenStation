import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/gamepad_service.dart';

/// Simple error dialog widget
class ErrorDialog extends StatefulWidget {
  final String message;

  const ErrorDialog({super.key, required this.message});

  /// Show error dialog
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

class _ErrorDialogState extends State<ErrorDialog> {
  Timer? _gamepadPollTimer;
  final FocusNode _okFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _startGamepadPolling();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _okFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _stopGamepadPolling();
    _okFocusNode.dispose();
    super.dispose();
  }

  void _startGamepadPolling() {
    _gamepadPollTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!mounted) return;
      final gamepad = GamepadService.instance;

      if (gamepad.isSelectPressed() || gamepad.isBackPressed()) {
        Navigator.pop(context);
      }

      gamepad.updatePreviousButtonStates();
    });
  }

  void _stopGamepadPolling() {
    _gamepadPollTimer?.cancel();
    _gamepadPollTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          Navigator.pop(context);
        }
      },
      child: Focus(
        autofocus: true,
        child: AlertDialog(
          title: const Text('Error'),
          content: Text(widget.message),
          actions: [
            TextButton(
              focusNode: _okFocusNode,
              onPressed: () => Navigator.pop(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('OK'),
                  if (GamepadService.instance.isGamepadConnected) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        'Ⓐ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
