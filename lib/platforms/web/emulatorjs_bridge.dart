import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

// Conditional import for web-only JS interop
// Use dart.library.js_interop to detect web platform
import 'emulatorjs_bridge_stub.dart'
    if (dart.library.js_interop) 'emulatorjs_bridge_web.dart';

/// Loading progress data
class EmulatorLoadingProgress {
  final String stage;
  final double progress;
  final String message;

  const EmulatorLoadingProgress({
    required this.stage,
    required this.progress,
    required this.message,
  });
}

/// Emulator status information
class EmulatorStatus {
  final bool isLoaded;
  final String? currentCore;
  final String? currentRom;
  final bool isLoading;
  final String container;

  const EmulatorStatus({
    required this.isLoaded,
    this.currentCore,
    this.currentRom,
    required this.isLoading,
    required this.container,
  });
}

/// Callbacks for emulator events
class EmulatorCallbacks {
  final void Function()? onReady;
  final void Function(String error)? onError;
  final void Function(EmulatorLoadingProgress progress)? onLoadingProgress;
  final void Function()? onCoreLoaded;
  final void Function()? onRomLoaded;
  final void Function()? onPause;
  final void Function()? onResume;

  const EmulatorCallbacks({
    this.onReady,
    this.onError,
    this.onLoadingProgress,
    this.onCoreLoaded,
    this.onRomLoaded,
    this.onPause,
    this.onResume,
  });
}

/// Bridge interface for emulator functionality
/// This abstract class is implemented by platform-specific versions
abstract class EmulatorJSBridge {
  String get containerId;
  EmulatorCallbacks get callbacks;

  /// Create a platform-appropriate emulator bridge
  factory EmulatorJSBridge({
    required String containerId,
    EmulatorCallbacks callbacks = const EmulatorCallbacks(),
  }) {
    return createEmulatorBridge(containerId: containerId, callbacks: callbacks);
  }

  /// Load a RetroArch core
  Future<void> loadCore(String coreUrl, String platform);

  /// Load a ROM into the emulator
  Future<void> loadRom(Uint8List romData, String fileName);

  /// Load a ROM from a URL (EmulatorJS downloads it directly)
  Future<void> loadRomFromUrl(String romUrl, String fileName);

  /// Start the emulator
  void start();

  /// Pause the emulator
  void pause();

  /// Resume the emulator
  void resume();

  /// Reset the emulator
  void reset();

  /// Stop and cleanup the emulator
  void stop();

  /// Create a save state
  Future<Uint8List> createSaveState();

  /// Load a save state
  Future<void> loadSaveState(Uint8List saveData);

  /// Take a screenshot
  Future<String?> getScreenshot();

  /// Get emulator status
  EmulatorStatus getStatus();

  /// Get an existing emulator instance
  static EmulatorJSBridge? getInstance(String containerId) {
    return getEmulatorInstance(containerId);
  }
}
