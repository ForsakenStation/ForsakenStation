import 'package:flutter/material.dart';
import 'package:forsaken/models/emulator_config.dart';

/// Dialog for selecting an emulator when multiple commands are available
class EmulatorSelectionDialog extends StatelessWidget {
  final EmulatorConfig config;

  const EmulatorSelectionDialog({super.key, required this.config});

  /// Show emulator selection dialog
  static Future<EmulatorCommand?> show({
    required BuildContext context,
    required EmulatorConfig config,
    required VoidCallback onClose,
  }) async {
    final result = await showDialog<EmulatorCommand>(
      context: context,
      builder: (context) => EmulatorSelectionDialog(config: config),
    );

    onClose();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Emulator'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: config.commands.map((command) {
          return ListTile(
            leading: const Icon(Icons.videogame_asset),
            title: Text(command.name),
            subtitle: Text(command.command),
            onTap: () => Navigator.pop(context, command),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
