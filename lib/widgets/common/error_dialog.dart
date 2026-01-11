import 'package:flutter/material.dart';

/// Simple error dialog widget
class ErrorDialog extends StatelessWidget {
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
      builder: (context) => ErrorDialog(message: message),
    ).then((_) => onClose());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
