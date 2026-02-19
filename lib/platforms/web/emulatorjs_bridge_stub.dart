import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'emulatorjs_bridge.dart';

/// Stub implementation for non-web platforms
class EmulatorJSBridgeStub implements EmulatorJSBridge {
  @override
  final String containerId;

  @override
  final EmulatorCallbacks callbacks;

  EmulatorJSBridgeStub({
    required this.containerId,
    this.callbacks = const EmulatorCallbacks(),
  });

  @override
  Future<void> loadCore(String coreUrl, String platform) async {
    throw UnsupportedError('Emulator not available on this platform');
  }

  @override
  Future<void> loadRom(Uint8List romData, String fileName) async {
    throw UnsupportedError('Emulator not available on this platform');
  }

  @override
  Future<void> loadRomFromUrl(String romUrl, String fileName) async {
    throw UnsupportedError('Emulator not available on this platform');
  }

  @override
  void start() {
    throw UnsupportedError('Emulator not available on this platform');
  }

  @override
  void pause() {
    throw UnsupportedError('Emulator not available on this platform');
  }

  @override
  void resume() {
    throw UnsupportedError('Emulator not available on this platform');
  }

  @override
  void reset() {
    throw UnsupportedError('Emulator not available on this platform');
  }

  @override
  void stop() {
    throw UnsupportedError('Emulator not available on this platform');
  }

  @override
  Future<Uint8List> createSaveState() async {
    throw UnsupportedError('Emulator not available on this platform');
  }

  @override
  Future<void> loadSaveState(Uint8List saveData) async {
    throw UnsupportedError('Emulator not available on this platform');
  }

  @override
  Future<String?> getScreenshot() async {
    throw UnsupportedError('Emulator not available on this platform');
  }

  @override
  EmulatorStatus getStatus() {
    throw UnsupportedError('Emulator not available on this platform');
  }
}

/// Factory function for creating emulator bridge
EmulatorJSBridge createEmulatorBridge({
  required String containerId,
  required EmulatorCallbacks callbacks,
}) {
  return EmulatorJSBridgeStub(containerId: containerId, callbacks: callbacks);
}

/// Get existing emulator instance (stub)
EmulatorJSBridge? getEmulatorInstance(String containerId) {
  return null;
}
