import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forsaken/models/emulator_config.dart';
import 'package:forsaken/mixins/dialog_controls_mixin.dart';
import 'package:forsaken/services/gamepad_service.dart';
import 'package:forsaken/widgets/common/gamepad_button_indicator.dart';

/// Dialog for selecting an emulator when multiple commands are available
class EmulatorSelectionDialog extends StatefulWidget {
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
      barrierDismissible: false, // Prevent dismissing by clicking outside
      barrierColor: Colors.black.withValues(alpha: 0.7), // Darker barrier
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur background
        child: EmulatorSelectionDialog(config: config),
      ),
    );

    onClose();
    return result;
  }

  @override
  State<EmulatorSelectionDialog> createState() =>
      _EmulatorSelectionDialogState();
}

class _EmulatorSelectionDialogState extends State<EmulatorSelectionDialog>
    with DialogControlsMixin<EmulatorSelectionDialog> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    startDialogControls(
      onCancel: () => Navigator.pop(context),
      customHandler: _handleCustomGamepadInput,
    );
  }

  void _handleCustomGamepadInput() {
    final gamepad = GamepadService.instance;

    // A button = Select emulator
    if (gamepad.isSelectPressed()) {
      final selectedCommand = widget.config.commands[_selectedIndex];
      Navigator.pop(context, selectedCommand);
      return;
    }

    // Navigation (Up/Down for list)
    final direction = gamepad.getNavigationDirection();
    if (direction != null) {
      setState(() {
        if (direction == 'up' && _selectedIndex > 0) {
          _selectedIndex--;
        } else if (direction == 'down' &&
            _selectedIndex < widget.config.commands.length - 1) {
          _selectedIndex++;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasGamepad = GamepadService.instance.isGamepadConnected;

    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      autofocus: true,
      onKeyEvent: (event) {
        if (event is! KeyDownEvent) return;

        final key = event.logicalKey;

        // Enter/Space = Select emulator
        if (key == LogicalKeyboardKey.enter ||
            key == LogicalKeyboardKey.space) {
          final selectedCommand = widget.config.commands[_selectedIndex];
          Navigator.pop(context, selectedCommand);
          return;
        }

        // ESC = Cancel
        if (key == LogicalKeyboardKey.escape) {
          Navigator.pop(context);
          return;
        }

        // Arrow navigation
        if (key == LogicalKeyboardKey.arrowUp && _selectedIndex > 0) {
          setState(() => _selectedIndex--);
        } else if (key == LogicalKeyboardKey.arrowDown &&
            _selectedIndex < widget.config.commands.length - 1) {
          setState(() => _selectedIndex++);
        }
      },
      child: AlertDialog(
        title: const Text('Select Emulator'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.config.commands.asMap().entries.map((entry) {
            final index = entry.key;
            final command = entry.value;
            final isSelected = index == _selectedIndex;

            return Container(
              decoration: isSelected
                  ? BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    )
                  : null,
              child: ListTile(
                leading: const Icon(Icons.videogame_asset),
                title: Text(command.name),
                subtitle: Text(command.command),
                selected: isSelected,
                onTap: () => Navigator.pop(context, command),
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasGamepad) GamepadButtonIndicator(button: GamepadButton.b),
                const SizedBox(width: 8),
                const Text('Cancel'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
