import 'dart:async';
import 'package:flutter/material.dart';
import 'package:forsaken/models/emulator_config.dart';
import 'package:forsaken/services/gamepad_service.dart';

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
      builder: (context) => EmulatorSelectionDialog(config: config),
    );

    onClose();
    return result;
  }

  @override
  State<EmulatorSelectionDialog> createState() =>
      _EmulatorSelectionDialogState();
}

class _EmulatorSelectionDialogState extends State<EmulatorSelectionDialog> {
  final _gamepadService = GamepadService.instance;
  Timer? _gamepadPollTimer;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _startGamepadPolling();
  }

  @override
  void dispose() {
    _stopGamepadPolling();
    super.dispose();
  }

  void _startGamepadPolling() {
    _gamepadPollTimer = Timer.periodic(
      const Duration(milliseconds: 50),
      (_) => _handleGamepadInput(),
    );
  }

  void _stopGamepadPolling() {
    _gamepadPollTimer?.cancel();
    _gamepadPollTimer = null;
  }

  void _handleGamepadInput() {
    if (!_gamepadService.isGamepadConnected) return;

    // A button = Select emulator
    if (_gamepadService.isSelectPressed()) {
      final selectedCommand = widget.config.commands[_selectedIndex];
      Navigator.pop(context, selectedCommand);
      _gamepadService.updatePreviousButtonStates();
      return;
    }

    // B button = Cancel
    if (_gamepadService.isBackPressed()) {
      Navigator.pop(context);
      _gamepadService.updatePreviousButtonStates();
      return;
    }

    // Navigation
    final direction = _gamepadService.getNavigationDirection();
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

    _gamepadService.updatePreviousButtonStates();
  }

  @override
  Widget build(BuildContext context) {
    final hasGamepad = _gamepadService.isGamepadConnected;

    return AlertDialog(
      title: const Text('Select Emulator'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.config.commands.asMap().entries.map((entry) {
          final index = entry.key;
          final command = entry.value;
          final isSelected = index == _selectedIndex;

          return Container(
            decoration: isSelected && hasGamepad
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
              if (hasGamepad) ...[
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade700,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    'B',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              const Text('Cancel'),
            ],
          ),
        ),
      ],
    );
  }
}
