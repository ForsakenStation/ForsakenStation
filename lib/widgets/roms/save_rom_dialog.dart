import 'dart:io';
import 'package:flutter/material.dart';
import '../../mixins/dialog_controls_mixin.dart';
import '../../models/rom_item.dart';
import '../common/placeholder_image.dart';
import '../common/dialog_button_bar.dart';
import '../common/gamepad_button_indicator.dart';

/// Dialog asking if user wants to save the ROM permanently
class SaveRomDialog extends StatefulWidget {
  final RomItem item;
  final String? imagePath;

  const SaveRomDialog({super.key, required this.item, this.imagePath});

  @override
  State<SaveRomDialog> createState() => _SaveRomDialogState();
}

class _SaveRomDialogState extends State<SaveRomDialog>
    with DialogControlsMixin<SaveRomDialog> {
  late List<DialogButton> _buttons;

  @override
  void initState() {
    super.initState();

    // Build buttons
    _buttons = [
      DialogButton(
        label: 'Not Now',
        icon: Icons.close,
        gamepadButton: GamepadButton.b,
        onPressed: () => Navigator.pop(context, false),
      ),
      DialogButton(
        label: 'Save',
        icon: Icons.save,
        primary: true,
        gamepadButton: GamepadButton.a,
        onPressed: () => Navigator.pop(context, true),
      ),
    ];

    // Start dialog controls with navigation
    // Default to Save button (index 1)
    startDialogControlsWithNavigation(
      onCancel: () => Navigator.pop(context, false),
      buttonCount: _buttons.length,
      defaultIndex: 1, // Save button
      onButtonSelected: (index) {
        if (mounted) setState(() {});
      },
      onConfirm: () => _buttons[selectedButtonIndex].onPressed(),
      layout: ButtonLayout.horizontal,
    );
  }

  @override
  Widget build(BuildContext context) {
    return wrapWithKeyboardHandler(
      onEscape: () => Navigator.pop(context, false),
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
                        return const PlaceholderImage(size: 100);
                      },
                    ),
                  ),
                )
              else
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: const PlaceholderImage(size: 100),
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

              // Buttons with DialogButtonBar
              DialogButtonBar(
                buttons: _buttons,
                selectedIndex: selectedButtonIndex,
                layout: ButtonLayout.horizontal,
                alignment: MainAxisAlignment.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
