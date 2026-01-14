import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forsaken/services/gamepad_service.dart';
import '../../models/rom_item.dart';
import '../common/placeholder_image.dart';

/// Dialog asking if user wants to save the ROM permanently
class SaveRomDialog extends StatefulWidget {
  final RomItem item;
  final String? imagePath;

  const SaveRomDialog({super.key, required this.item, this.imagePath});

  @override
  State<SaveRomDialog> createState() => _SaveRomDialogState();
}

class _SaveRomDialogState extends State<SaveRomDialog> {
  final _gamepadService = GamepadService.instance;
  final _saveButtonFocusNode = FocusNode();
  Timer? _gamepadPollTimer;

  @override
  void initState() {
    super.initState();
    // Request focus on Save button after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _saveButtonFocusNode.requestFocus();
      }
    });
    _startGamepadPolling();
  }

  @override
  void dispose() {
    _stopGamepadPolling();
    _saveButtonFocusNode.dispose();
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

    // A button = Save
    if (_gamepadService.isSelectPressed()) {
      Navigator.pop(context, true);
      _gamepadService.updatePreviousButtonStates();
      return;
    }

    // B button = Not Now (close dialog)
    if (_gamepadService.isBackPressed()) {
      Navigator.pop(context, false);
      _gamepadService.updatePreviousButtonStates();
      return;
    }

    _gamepadService.updatePreviousButtonStates();
  }

  @override
  Widget build(BuildContext context) {
    final hasGamepad = _gamepadService.isGamepadConnected;

    return Focus(
      autofocus: true, // Trap focus in dialog
      child: Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Icon(
                Icons.save_alt,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                'Save ROM Permanently?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // ROM Image (if available)
              if (widget.imagePath != null)
                Container(
                  constraints: const BoxConstraints(
                    maxHeight: 150,
                    maxWidth: 150,
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(widget.imagePath!),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return PlaceholderImage(size: 100);
                      },
                    ),
                  ),
                )
              else
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: PlaceholderImage(size: 100),
                ),

              // ROM Name
              Text(
                widget.item.displayName,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),

              // Description
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Would you like to keep this ROM downloaded for offline play?',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'If not, it will be deleted later to save space.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
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
                          const Icon(Icons.close),
                          const SizedBox(width: 8),
                          const Text('Not Now'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Focus(
                      focusNode: _saveButtonFocusNode,
                      onKeyEvent: (node, event) {
                        // Handle Enter and Space keys
                        if (event is KeyDownEvent &&
                            (event.logicalKey == LogicalKeyboardKey.enter ||
                                event.logicalKey == LogicalKeyboardKey.space)) {
                          Navigator.pop(context, true);
                          return KeyEventResult.handled;
                        }
                        return KeyEventResult.ignored;
                      },
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (hasGamepad) ...[
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade700,
                                  shape: BoxShape.circle,
                                ),
                                child: const Text(
                                  'A',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            const Icon(Icons.save),
                            const SizedBox(width: 8),
                            const Text('Save'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ), // Close Dialog
    ); // Close Focus
  }
}
