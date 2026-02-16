import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:forsaken/models/rom_item.dart';
import 'package:forsaken/models/media.dart';
import 'package:forsaken/models/game_info.dart';
import 'package:forsaken/screens/pdf_viewer_screen.dart';
import 'package:forsaken/mixins/dialog_controls_mixin.dart';
import 'package:forsaken/widgets/roms/media_carousel.dart';
import 'package:forsaken/widgets/common/placeholder_image.dart';
import 'package:forsaken/widgets/common/info_row.dart';
import 'package:forsaken/widgets/common/dialog_button_bar.dart';
import 'package:forsaken/widgets/common/gamepad_button_indicator.dart';
import 'package:forsaken/platforms/web/web_emulator_launcher.dart';

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

    // Build buttons list
    _buttons = _buildButtonsList();

    // Start dialog controls with navigation
    // Default to Play button (last button)
    startDialogControlsWithNavigation(
      onCancel: _handleCancel,
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
    final buttons = <DialogButton>[];

    // Cancel button
    buttons.add(DialogButton(label: 'Cancel', onPressed: _handleCancel));

    // View Manual button (if manual exists)
    if (_hasManual) {
      buttons.add(
        DialogButton(
          label: 'View Manual',
          icon: Icons.menu_book,
          onPressed: _viewManual,
        ),
      );
    }

    // Play in Browser button (if web platform and supported)
    if (kIsWeb && WebEmulatorLauncher.isAvailableForRom(widget.item)) {
      buttons.add(
        DialogButton(
          label: 'Play in Browser',
          icon: Icons.web,
          onPressed: _playInBrowser,
        ),
      );
    }

    // Play button (primary)
    buttons.add(
      DialogButton(
        label: 'Play',
        icon: Icons.gamepad,
        primary: true,
        gamepadButton: GamepadButton.a,
        onPressed: _playRom,
      ),
    );

    return buttons;
  }

  void _handleCancel() {
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
        onCancel: _handleCancel,
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
      debugPrint('Failed to launch web emulator: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to launch web emulator: $e'),
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
          title: '${widget.item.displayName} - Manual',
        ),
      ),
    ).then((_) {
      // Restart dialog controls when returning
      if (mounted) {
        startDialogControlsWithNavigation(
          onCancel: _handleCancel,
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
      onEscape: _handleCancel,
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
                  onPressed: _handleCancel,
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

                      // Description
                      InfoRow(
                        label: 'Description',
                        value:
                            widget.gameInfo?.desc ??
                            'No description available for this ROM.',
                      ),
                      const SizedBox(height: 16),

                      // Release date and developer
                      Row(
                        children: [
                          Expanded(
                            child: InfoRow(
                              label: 'Release Date',
                              value:
                                  widget.gameInfo?.releaseDate
                                      ?.toString()
                                      .split(' ')[0] ??
                                  '',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InfoRow(
                              label: 'Developer',
                              value: widget.gameInfo?.developer ?? '',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Publisher and genre
                      Row(
                        children: [
                          Expanded(
                            child: InfoRow(
                              label: 'Publisher',
                              value: widget.gameInfo?.publisher ?? '',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InfoRow(
                              label: 'Genre',
                              value: widget.gameInfo?.genre ?? '',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Players and rating
                      Row(
                        children: [
                          Expanded(
                            child: InfoRow(
                              label: 'Players',
                              value: widget.gameInfo?.playersText ?? '',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InfoRow(
                              label: 'Rating',
                              value: widget.gameInfo?.ratingPercentage ?? '--',
                            ),
                          ),
                        ],
                      ),
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
