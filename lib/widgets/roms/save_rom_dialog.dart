import 'dart:io';
import 'package:flutter/material.dart';
import '../../mixins/dialog_controls_mixin.dart';
import '../../models/rom_item.dart';
import '../../l10n/generated/app_localizations.dart';
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

    // Build buttons (using placeholder labels, updated in didChangeDependencies)
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;
    _buttons = [
      DialogButton(
        label: l10n.notNow,
        icon: Icons.close,
        gamepadButton: GamepadButton.b,
        onPressed: () => Navigator.pop(context, false),
      ),
      DialogButton(
        label: l10n.save,
        icon: Icons.save,
        primary: true,
        gamepadButton: GamepadButton.a,
        onPressed: () => Navigator.pop(context, true),
      ),
    ];
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
                AppLocalizations.of(context)!.saveRomPermanently,
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
                    maxHeight: 200,
                    maxWidth: 200,
                  ),
                  margin: const EdgeInsets.only(bottom: 24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(widget.imagePath!),
                      fit: BoxFit.contain,
                      cacheWidth: 400, // Max 200px displayed, 2x for retina
                      cacheHeight: 400,
                      errorBuilder: (context, error, stackTrace) {
                        return PlaceholderImage(size: 150);
                      },
                    ),
                  ),
                )
              else
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: PlaceholderImage(size: 150),
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
                      AppLocalizations.of(context)!.keepRomOfflineQuestion,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.deletedToSaveSpace,
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
