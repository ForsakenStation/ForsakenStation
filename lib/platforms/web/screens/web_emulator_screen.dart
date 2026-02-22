import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../models/rom_item.dart';
import '../../../models/launch_result.dart';
import '../../../services/debug_service.dart';
import '../../../widgets/common/controls_bottom_bar.dart';
import '../widgets/web_emulator_widget.dart';

/// Full-screen web emulator interface
class WebEmulatorScreen extends StatefulWidget {
  final RomItem rom;

  const WebEmulatorScreen({super.key, required this.rom});

  @override
  State<WebEmulatorScreen> createState() => _WebEmulatorScreenState();
}

class _WebEmulatorScreenState extends State<WebEmulatorScreen> {
  final DebugService _debug = DebugService.instance;

  bool _isFullscreen = false;
  bool _showControls = true;
  LaunchResult? _launchResult;

  @override
  void initState() {
    super.initState();
    _debug.info(
      'Opening web emulator for: ${widget.rom.displayName}',
      tag: 'WebEmulatorScreen',
    );
  }

  void _onLaunchResult(LaunchResult result) {
    setState(() {
      _launchResult = result;
    });

    if (!result.success) {
      _debug.error(
        'Failed to launch ROM: ${result.error}',
        tag: 'WebEmulatorScreen',
      );
    }
  }

  void _closeEmulator() {
    Navigator.of(context).pop(_launchResult?.success ?? false);
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isFullscreen) {
      return _buildFullscreenView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.rom.displayName),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          if (_launchResult?.success == true)
            IconButton(
              onPressed: _toggleFullscreen,
              icon: const Icon(Icons.fullscreen),
              tooltip: 'Fullscreen',
            ),
          if (_launchResult?.success == true)
            IconButton(
              onPressed: _toggleControls,
              icon: Icon(_showControls ? Icons.keyboard_hide : Icons.keyboard),
              tooltip: _showControls ? 'Hide Controls' : 'Show Controls',
            ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Main emulator area
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: WebEmulatorWidget(
                rom: widget.rom,
                onLaunchResult: _onLaunchResult,
                onClose: _closeEmulator,
              ),
            ),
          ),

          // Controls bottom bar
          if (_showControls)
            ControlsBottomBar(
              actions: [
                const BottomBarAction(
                  label: 'Back',
                  keyboardKey: 'ESC',
                  gamepadButton: 'B',
                ),
                if (_launchResult?.success == true)
                  const BottomBarAction(
                    label: 'Fullscreen',
                    keyboardKey: 'F11',
                    gamepadButton: 'Start',
                  ),
                if (_launchResult?.success == true)
                  const BottomBarAction(
                    label: 'Toggle Controls',
                    keyboardKey: 'H',
                    gamepadButton: 'Select',
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildFullscreenView() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full-screen emulator
          Positioned.fill(
            child: WebEmulatorWidget(
              rom: widget.rom,
              onLaunchResult: _onLaunchResult,
            ),
          ),

          // Exit fullscreen button (top-right)
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: _toggleFullscreen,
                icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
                tooltip: 'Exit Fullscreen',
              ),
            ),
          ),

          // Close button (top-left)
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: _closeEmulator,
                icon: const Icon(Icons.close, color: Colors.white),
                tooltip: 'Close Emulator',
              ),
            ),
          ),

          // Game info overlay (bottom-left, auto-hide after 3 seconds)
          if (_launchResult?.success == true)
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.rom.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (widget.rom.platform != null)
                      Text(
                        widget.rom.platform!.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Modal dialog version for smaller/embedded use
class WebEmulatorDialog extends StatelessWidget {
  final RomItem rom;

  const WebEmulatorDialog({super.key, required this.rom});

  static Future<void> show(BuildContext context, RomItem rom) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WebEmulatorDialog(rom: rom),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade700),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dialog header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade700)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rom.displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        if (rom.platform != null)
                          Text(
                            rom.platform!.toUpperCase(),
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Emulator area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: WebEmulatorWidget(
                  rom: rom,
                  onClose: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
