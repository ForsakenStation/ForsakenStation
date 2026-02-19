import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../web_emulator_service.dart';
import '../../../models/rom_item.dart';
import '../../../models/launch_result.dart';
import '../../../services/debug_service.dart';
import 'web_emulator_view.dart';

/// Web-specific emulator widget that embeds EmulatorJS
class WebEmulatorWidget extends StatefulWidget {
  final RomItem rom;
  final Function(LaunchResult result)? onLaunchResult;
  final Function()? onClose;
  final double? width;
  final double? height;

  const WebEmulatorWidget({
    super.key,
    required this.rom,
    this.onLaunchResult,
    this.onClose,
    this.width,
    this.height,
  });

  @override
  State<WebEmulatorWidget> createState() => _WebEmulatorWidgetState();
}

class _WebEmulatorWidgetState extends State<WebEmulatorWidget> {
  final DebugService _debug = DebugService.instance;
  final WebEmulatorService _emulatorService = WebEmulatorService.instance;

  late final String _containerId;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  LaunchResult? _launchResult;
  bool _viewRegistered = false;
  bool _htmlViewRendered = false;
  bool _emulatorLaunched = false;

  @override
  void initState() {
    super.initState();
    // Use a simpler ID that's valid for HTML
    _containerId = 'emu-${DateTime.now().millisecondsSinceEpoch}';
    _registerContainer();
  }

  void _registerContainer() {
    if (kIsWeb) {
      registerEmulatorContainer(_containerId);
      _viewRegistered = true;
      _debug.info(
        'Registered emulator container: $_containerId',
        tag: 'WebEmulatorWidget',
      );
    }
  }

  /// Called after HtmlElementView is rendered
  void _onHtmlViewRendered() {
    if (_htmlViewRendered || !mounted) return;

    _htmlViewRendered = true;
    _debug.info(
      'HTML view rendered, launching emulator...',
      tag: 'WebEmulatorWidget',
    );

    // Launch emulator after a short delay to ensure DOM is ready
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted && !_emulatorLaunched) {
        _launchEmulator();
      }
    });
  }

  Future<void> _launchEmulator() async {
    if (_emulatorLaunched) return;
    _emulatorLaunched = true;

    try {
      _debug.info(
        'Launching ROM: ${widget.rom.name}',
        tag: 'WebEmulatorWidget',
      );

      // Launch the ROM in the emulator
      final result = await _emulatorService.launchRom(
        widget.rom,
        containerId: _containerId,
      );

      if (mounted) {
        setState(() {
          _launchResult = result;
          _isLoading = false;
          _hasError = !result.success;
          _errorMessage = result.error;
        });

        // Notify parent widget
        widget.onLaunchResult?.call(result);
      }
    } catch (e) {
      _debug.error('Failed to launch emulator: $e', tag: 'WebEmulatorWidget');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Failed to launch emulator: $e';
          _emulatorLaunched = false; // Allow retry
        });

        widget.onLaunchResult?.call(
          LaunchResult.failure('Failed to launch emulator: $e'),
        );
      }
    }
  }

  void _retryLaunch() {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
      _emulatorLaunched = false;
    });
    _launchEmulator();
  }

  @override
  void dispose() {
    // Stop the emulator when widget is disposed
    if (_launchResult?.success == true) {
      _emulatorService.stopEmulator(_containerId);
    }
    super.dispose();
  }

  Widget _buildErrorOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.withValues(alpha: 0.8),
            size: 48,
          ),
          const SizedBox(height: 16),
          const Text(
            'Emulator Error',
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _errorMessage ?? 'Unknown error occurred',
              style: TextStyle(
                color: Colors.red.withValues(alpha: 0.8),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _retryLaunch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                  foregroundColor: Colors.red,
                  side: BorderSide(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: const Text('Retry'),
              ),
              if (widget.onClose != null) ...[
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: widget.onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.withValues(alpha: 0.1),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Close'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading ${widget.rom.platform?.toUpperCase() ?? "ROM"}...',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            widget.rom.displayName,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 400,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        child: Stack(
          children: [
            // HTML Element View for the emulator - always render this
            if (kIsWeb && _viewRegistered)
              Positioned.fill(
                child: _EmulatorHtmlViewWithCallback(
                  containerId: _containerId,
                  width: widget.width,
                  height: widget.height,
                  onRendered: _onHtmlViewRendered,
                ),
              )
            else
              Positioned.fill(
                child: createEmulatorHtmlView(
                  containerId: _containerId,
                  width: widget.width,
                  height: widget.height,
                ),
              ),

            // Loading overlay
            if (_isLoading) Positioned.fill(child: _buildLoadingOverlay()),

            // Error overlay
            if (_hasError) Positioned.fill(child: _buildErrorOverlay()),

            // Close button overlay (only when successfully loaded)
            if (!_isLoading && !_hasError && widget.onClose != null)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    onPressed: widget.onClose,
                    icon: const Icon(Icons.close, color: Colors.white),
                    tooltip: 'Close Emulator',
                    iconSize: 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Helper widget that calls back when rendered
class _EmulatorHtmlViewWithCallback extends StatefulWidget {
  final String containerId;
  final double? width;
  final double? height;
  final VoidCallback onRendered;

  const _EmulatorHtmlViewWithCallback({
    required this.containerId,
    required this.onRendered,
    this.width,
    this.height,
  });

  @override
  State<_EmulatorHtmlViewWithCallback> createState() =>
      _EmulatorHtmlViewWithCallbackState();
}

class _EmulatorHtmlViewWithCallbackState
    extends State<_EmulatorHtmlViewWithCallback> {
  bool _notified = false;

  @override
  void initState() {
    super.initState();
    // Notify after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_notified) {
        _notified = true;
        widget.onRendered();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return createEmulatorHtmlView(
      containerId: widget.containerId,
      width: widget.width,
      height: widget.height,
    );
  }
}
