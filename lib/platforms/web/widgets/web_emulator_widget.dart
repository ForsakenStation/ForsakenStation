import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../web_emulator_service.dart';
import '../../../models/rom_item.dart';
import '../../../models/launch_result.dart';
import '../../../services/debug_service.dart';

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

  @override
  void initState() {
    super.initState();
    _containerId =
        'emulator-${widget.rom.hashCode}-${DateTime.now().millisecondsSinceEpoch}';
    _initializeEmulator();
  }

  Future<void> _initializeEmulator() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _errorMessage = null;
      });

      // Register the HTML element for the emulator container
      if (kIsWeb) {
        _registerEmulatorContainer();
      }

      // Launch the ROM in the emulator
      final result = await _emulatorService.launchRom(
        widget.rom,
        containerId: _containerId,
      );

      setState(() {
        _launchResult = result;
        _isLoading = false;
        _hasError = !result.success;
        _errorMessage = result.error;
      });

      // Notify parent widget
      widget.onLaunchResult?.call(result);
    } catch (e) {
      _debug.error(
        'Failed to initialize emulator: $e',
        tag: 'WebEmulatorWidget',
      );
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Failed to initialize emulator: $e';
      });

      widget.onLaunchResult?.call(
        LaunchResult.failure('Failed to initialize emulator: $e'),
      );
    }
  }

  void _registerEmulatorContainer() {
    if (!kIsWeb) return;

    // For now, we'll use a placeholder approach
    // TODO: Implement proper HTML element registration with dart:js_interop
    _debug.info(
      'Registering emulator container: $_containerId',
      tag: 'WebEmulatorWidget',
    );

    // TODO: Replace with proper platform view registration
    // This would normally use:
    // - html.DivElement() to create the container
    // - ui_web.platformViewRegistry.registerViewFactory() to register it
    // For now, we'll simulate this with a Flutter container
  }

  @override
  void dispose() {
    // Stop the emulator when widget is disposed
    if (!_isLoading && _launchResult?.success == true) {
      _emulatorService.stopEmulator(_containerId);
    }
    super.dispose();
  }

  Widget _buildLoadingIndicator() {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 400,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            'Loading Emulator...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorIndicator() {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 400,
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
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
          ElevatedButton(
            onPressed: _initializeEmulator,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withValues(alpha: 0.1),
              foregroundColor: Colors.red,
              side: BorderSide(color: Colors.red.withValues(alpha: 0.3)),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmulatorContainer() {
    if (!kIsWeb) {
      return Container(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 400,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Web emulator only available in browser',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    // For now, show a placeholder that represents the emulator
    // TODO: Replace with actual HtmlElementView when dart:html is properly integrated
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 400,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.videogame_asset, color: Colors.white70, size: 64),
          const SizedBox(height: 16),
          Text(
            'Emulator Container',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ROM: ${widget.rom.name}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
          Text(
            'Platform: ${widget.rom.platform}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlButton(Icons.play_arrow, 'Start'),
              const SizedBox(width: 8),
              _buildControlButton(Icons.pause, 'Pause'),
              const SizedBox(width: 8),
              _buildControlButton(Icons.stop, 'Stop'),
              const SizedBox(width: 8),
              _buildControlButton(Icons.refresh, 'Reset'),
            ],
          ),
          if (widget.onClose != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.onClose,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withValues(alpha: 0.2),
                foregroundColor: Colors.white,
              ),
              child: const Text('Close Emulator'),
            ),
          ],
        ],
      ),
    );

    // TODO: When dart:html integration is complete, use:
    // return HtmlElementView(viewType: _containerId);
  }

  Widget _buildControlButton(IconData icon, String label) {
    return Tooltip(
      message: label,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: Colors.white70, size: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingIndicator();
    }

    if (_hasError) {
      return _buildErrorIndicator();
    }

    return _buildEmulatorContainer();
  }
}
