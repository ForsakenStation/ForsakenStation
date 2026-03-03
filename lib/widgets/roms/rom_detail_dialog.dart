import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../models/rom_item.dart';
import '../../models/media.dart';
import '../../models/game_info.dart';
import '../../screens/pdf_viewer_screen.dart';
import '../../services/debug_service.dart';
import '../../mixins/dialog_controls_mixin.dart';
import '../../l10n/generated/app_localizations.dart';
import 'media_carousel.dart';
import '../common/placeholder_image.dart';
import '../common/dialog_button_bar.dart';
import '../common/gamepad_button_indicator.dart';
import 'rom_info_section.dart';
import '../../platforms/web/web_emulator_launcher.dart';

/// Dialog showing detailed information about a ROM
class RomDetailDialog extends StatefulWidget {
  final RomItem item;
  final RomMedia? media;
  final GameInfo? gameInfo;
  final VoidCallback onPlay;

  const RomDetailDialog({
    super.key,
    required this.item,
    required this.media,
    required this.gameInfo,
    required this.onPlay,
  });

  /// Show ROM detail dialog
  static Future<void> show({
    required BuildContext context,
    required RomItem item,
    required RomMedia? media,
    required GameInfo? gameInfo,
    required VoidCallback onPlay,
    required VoidCallback onClose,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: RomDetailDialog(
          item: item,
          media: media,
          gameInfo: gameInfo,
          onPlay: onPlay,
        ),
      ),
    ).then((_) => onClose());
  }

  @override
  State<RomDetailDialog> createState() => _RomDetailDialogState();
}

class _RomDetailDialogState extends State<RomDetailDialog>
    with DialogControlsMixin<RomDetailDialog> {
  late List<DialogButton> _buttons;
  bool _hasManual = false;

  @override
  void initState() {
    super.initState();

    // Check if manual exists
    _hasManual =
        widget.media?.manualPath != null &&
        widget.media!.manualPath!.toLowerCase().endsWith('.pdf');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Build buttons list (needs context for l10n)
    _buttons = _buildButtonsList();

    // Start dialog controls with navigation
    // Default to Play button (last button)
    startDialogControlsWithNavigation(
      onCancel: _handleDismiss,
      buttonCount: _buttons.length,
      defaultIndex: _buttons.length - 1, // Play button
      onButtonSelected: (index) {
        if (mounted) setState(() {});
      },
      onConfirm: _handleConfirm,
      layout: ButtonLayout.horizontal,
    );
  }

  List<DialogButton> _buildButtonsList() {
    final l10n = AppLocalizations.of(context)!;
    final buttons = <DialogButton>[];

    // Cancel button
    buttons.add(DialogButton(label: l10n.cancel, onPressed: _handleDismiss));

    // View Manual button (if manual exists)
    if (_hasManual) {
      buttons.add(
        DialogButton(
          label: l10n.viewManual,
          icon: Icons.menu_book,
          onPressed: _viewManual,
        ),
      );
    }

    // Play in Browser button (if web platform and supported)
    if (kIsWeb && WebEmulatorLauncher.isAvailableForRom(widget.item)) {
      buttons.add(
        DialogButton(
          label: l10n.playInBrowser,
          icon: Icons.web,
          onPressed: _playInBrowser,
        ),
      );
    }

    // Play button (primary)
    buttons.add(
      DialogButton(
        label: l10n.play,
        icon: Icons.gamepad,
        primary: true,
        gamepadButton: GamepadButton.a,
        onPressed: _playRom,
      ),
    );

    return buttons;
  }

  void _handleDismiss() {
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _handleConfirm() {
    // Execute action of selected button
    _buttons[selectedButtonIndex].onPressed();
  }

  void _restartDialogControls() {
    // Helper to restart dialog controls (used by MediaCarousel)
    if (mounted) {
      startDialogControlsWithNavigation(
        onCancel: _handleDismiss,
        buttonCount: _buttons.length,
        defaultIndex: selectedButtonIndex, // Keep same selection
        onButtonSelected: (index) {
          if (mounted) setState(() {});
        },
        onConfirm: _handleConfirm,
        layout: ButtonLayout.horizontal,
      );
    }
  }

  void _playRom() {
    Navigator.pop(context);
    widget.onPlay();
  }

  void _playInBrowser() async {
    // Stop dialog controls
    stopDialogControls();

    try {
      // Close the detail dialog first
      if (mounted) {
        Navigator.pop(context);
      }

      // Launch web emulator fullscreen
      await WebEmulatorLauncher.launchFullscreen(context, widget.item);
    } catch (e) {
      DebugService.instance.error(
        'Failed to launch web emulator: $e',
        tag: 'RomDetail',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)!.failedToLaunch} $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _viewManual() {
    // Stop dialog controls while viewing manual
    stopDialogControls();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerScreen(
          pdfPath: widget.media!.manualPath!,
          title: AppLocalizations.of(
            context,
          )!.manualTitle(widget.item.displayName),
        ),
      ),
    ).then((_) {
      // Restart dialog controls when returning
      if (mounted) {
        startDialogControlsWithNavigation(
          onCancel: _handleDismiss,
          buttonCount: _buttons.length,
          defaultIndex: selectedButtonIndex, // Keep same selection
          onButtonSelected: (index) {
            if (mounted) setState(() {});
          },
          onConfirm: _handleConfirm,
          layout: ButtonLayout.horizontal,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return wrapWithKeyboardHandler(
      onEscape: _handleDismiss,
      child: Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800, maxHeight: 700),
          child: Column(
            children: [
              // Header
              AppBar(
                title: Text(widget.gameInfo?.name ?? widget.item.displayName),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _handleDismiss,
                ),
                automaticallyImplyLeading: false,
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Media carousel or placeholder
                      if (widget.media != null)
                        MediaCarousel(
                          media: widget.media!,
                          height: 400,
                          onBeforeNavigation: stopDialogControls,
                          onAfterNavigation: _restartDialogControls,
                        )
                      else
                        const Center(child: PlaceholderImage(size: 300)),
                      const SizedBox(height: 16),

                      // Game info section
                      RomInfoSection(gameInfo: widget.gameInfo, columnGap: 8),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Actions with DialogButtonBar
              Padding(
                padding: const EdgeInsets.all(16),
                child: DialogButtonBar(
                  buttons: _buttons,
                  selectedIndex: selectedButtonIndex,
                  layout: ButtonLayout.horizontal,
                  alignment: MainAxisAlignment.spaceBetween,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
