import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forsaken/models/rom_item.dart';
import 'package:forsaken/models/media.dart';
import 'package:forsaken/models/game_info.dart';
import 'package:forsaken/screens/pdf_viewer_screen.dart';
import 'package:forsaken/services/gamepad_service.dart';
import 'package:forsaken/widgets/roms/media_carousel.dart';
import 'package:forsaken/widgets/common/placeholder_image.dart';
import 'package:forsaken/widgets/common/info_row.dart';

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
      builder: (context) => RomDetailDialog(
        item: item,
        media: media,
        gameInfo: gameInfo,
        onPlay: onPlay,
      ),
    ).then((_) => onClose());
  }

  @override
  State<RomDetailDialog> createState() => _RomDetailDialogState();
}

class _RomDetailDialogState extends State<RomDetailDialog> {
  final _gamepadService = GamepadService.instance;
  final _playButtonFocusNode = FocusNode();
  Timer? _gamepadPollTimer;

  @override
  void initState() {
    super.initState();
    // Request focus on Play button after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _playButtonFocusNode.requestFocus();
      }
    });
    // Start gamepad polling
    _startGamepadPolling();
  }

  @override
  void dispose() {
    _stopGamepadPolling();
    _playButtonFocusNode.dispose();
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

    // A button = Play
    if (_gamepadService.isSelectPressed()) {
      _playRom();
      _gamepadService.updatePreviousButtonStates();
      return;
    }

    // B button = Close dialog
    if (_gamepadService.isBackPressed()) {
      Navigator.pop(context);
      _gamepadService.updatePreviousButtonStates();
      return;
    }

    _gamepadService.updatePreviousButtonStates();
  }

  void _playRom() {
    Navigator.pop(context);
    widget.onPlay();
  }

  @override
  Widget build(BuildContext context) {
    final hasGamepad = _gamepadService.isGamepadConnected;

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 700),
        child: Column(
          children: [
            // Header
            AppBar(
              title: Text(widget.gameInfo?.name ?? widget.item.displayName),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
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
                      MediaCarousel(media: widget.media!, height: 400)
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
                                widget.gameInfo?.releaseDate?.toString().split(
                                  ' ',
                                )[0] ??
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
            // Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Manual button (if manual PDF exists)
                  if (widget.media?.manualPath != null &&
                      widget.media!.manualPath!.toLowerCase().endsWith('.pdf'))
                    ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfViewerScreen(
                              pdfPath: widget.media!.manualPath!,
                              title: '${widget.item.displayName} - Manual',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.menu_book),
                      label: const Text('View Manual'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  // Right side buttons
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 16),
                      Focus(
                        focusNode: _playButtonFocusNode,
                        onKeyEvent: (node, event) {
                          // Handle Enter and Space keys
                          if (event is KeyDownEvent &&
                              (event.logicalKey == LogicalKeyboardKey.enter ||
                                  event.logicalKey ==
                                      LogicalKeyboardKey.space)) {
                            _playRom();
                            return KeyEventResult.handled;
                          }
                          return KeyEventResult.ignored;
                        },
                        child: ElevatedButton(
                          onPressed: _playRom,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Show gamepad button icon if gamepad connected
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
                              const Icon(Icons.gamepad),
                              const SizedBox(width: 8),
                              const Text('Play'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
