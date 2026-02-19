import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/foundation.dart';

import 'emulatorjs_bridge.dart';

// --- JS interop bindings ---

/// Binding for window.createForsakenEmulator(containerId, callbacks)
@JS('createForsakenEmulator')
external JSObject? _createForsakenEmulator(
  JSString containerId,
  JSObject callbacks,
);

/// Access window.ForsakenEmulators[containerId]
@JS('ForsakenEmulators')
external JSObject? get _forsakenEmulators;

/// Web implementation of EmulatorJSBridge using dart:js_interop
class EmulatorJSBridgeWeb implements EmulatorJSBridge {
  @override
  final String containerId;

  @override
  final EmulatorCallbacks callbacks;

  JSObject? _jsEmulator;
  bool _initialized = false;

  EmulatorJSBridgeWeb({
    required this.containerId,
    this.callbacks = const EmulatorCallbacks(),
  }); // Lazy initialization - only when first method is called

  /// Ensure the JS emulator is initialized
  void _ensureInitialized() {
    if (_initialized || _jsEmulator != null) return;
    _initializeJSEmulator();
  }

  void _initializeJSEmulator() {
    if (!kIsWeb) return;

    try {
      debugPrint(
        '[EmulatorJS] Starting initialization for container: $containerId',
      );

      // Create JavaScript callbacks object
      final jsCallbacks =
          {
                'onReady': (() {
                  debugPrint('[EmulatorJS] Ready');
                  callbacks.onReady?.call();
                }).toJS,
                'onError': ((JSString error) {
                  final errorMsg = error.toDart;
                  debugPrint('[EmulatorJS] Error: $errorMsg');
                  callbacks.onError?.call(errorMsg);
                }).toJS,
                'onLoadingProgress': ((JSObject progress) {
                  try {
                    final stage =
                        (progress.getProperty('stage'.toJS) as JSString?)
                            ?.toDart ??
                        'unknown';
                    final progressValue =
                        (progress.getProperty('progress'.toJS) as JSNumber?)
                            ?.toDartDouble ??
                        0.0;
                    final message =
                        (progress.getProperty('message'.toJS) as JSString?)
                            ?.toDart ??
                        '';

                    callbacks.onLoadingProgress?.call(
                      EmulatorLoadingProgress(
                        stage: stage,
                        progress: progressValue,
                        message: message,
                      ),
                    );
                  } catch (e) {
                    debugPrint('[EmulatorJS] Progress callback error: $e');
                  }
                }).toJS,
                'onCoreLoaded': (() {
                  debugPrint('[EmulatorJS] Core loaded');
                  callbacks.onCoreLoaded?.call();
                }).toJS,
                'onRomLoaded': (() {
                  debugPrint('[EmulatorJS] ROM loaded');
                  callbacks.onRomLoaded?.call();
                }).toJS,
                'onPause': (() {
                  debugPrint('[EmulatorJS] Paused');
                  callbacks.onPause?.call();
                }).toJS,
                'onResume': (() {
                  debugPrint('[EmulatorJS] Resumed');
                  callbacks.onResume?.call();
                }).toJS,
              }.jsify()
              as JSObject;

      debugPrint(
        '[EmulatorJS] Callbacks created, attempting to instantiate...',
      );

      try {
        // Call window.createForsakenEmulator(containerId, callbacks)
        _jsEmulator = _createForsakenEmulator(containerId.toJS, jsCallbacks);

        if (_jsEmulator != null) {
          _initialized = true;
          debugPrint(
            '[EmulatorJS] Bridge initialized successfully for container: $containerId',
          );
        } else {
          throw Exception('createForsakenEmulator returned null');
        }
      } catch (e) {
        debugPrint('[EmulatorJS] Failed to create instance: $e');

        // Fallback: Try direct access to window.ForsakenEmulators
        try {
          debugPrint('[EmulatorJS] Trying fallback method...');
          final emulators = _forsakenEmulators;
          if (emulators != null) {
            final instance =
                emulators.getProperty(containerId.toJS) as JSObject?;
            if (instance != null) {
              _jsEmulator = instance;
              _initialized = true;
              debugPrint(
                '[EmulatorJS] Retrieved existing instance from ForsakenEmulators',
              );
            }
          }
        } catch (e2) {
          debugPrint('[EmulatorJS] Fallback also failed: $e2');
        }

        if (!_initialized) {
          rethrow;
        }
      }
    } catch (e, stackTrace) {
      debugPrint('[EmulatorJS] Initialization error: $e');
      debugPrint('[EmulatorJS] Stack trace: $stackTrace');
      callbacks.onError?.call('Failed to initialize emulator: $e');
      rethrow;
    }
  }

  /// Call a method on the JS emulator object, handling Promises.
  /// Supports 0-2 arguments (covers all current use cases).
  Future<T> _callAsyncMethod<T>(
    String method, [
    JSAny? arg1,
    JSAny? arg2,
  ]) async {
    _ensureInitialized();

    if (_jsEmulator == null) {
      throw Exception('Emulator not initialized');
    }

    final JSAny? result;
    if (arg2 != null) {
      result = _jsEmulator!.callMethod(method.toJS, arg1, arg2);
    } else if (arg1 != null) {
      result = _jsEmulator!.callMethod(method.toJS, arg1);
    } else {
      result = _jsEmulator!.callMethod(method.toJS);
    }

    // Check if result is a Promise (has a .then property)
    if (result != null && result.isA<JSPromise>()) {
      final future = (result as JSPromise).toDart;
      final value = await future;
      return value as T;
    }

    return result as T;
  }

  /// Call a void method (no return value)
  void _callVoidMethod(String method, [JSAny? arg1, JSAny? arg2]) {
    if (_jsEmulator == null) return;
    if (arg2 != null) {
      _jsEmulator!.callMethod(method.toJS, arg1, arg2);
    } else if (arg1 != null) {
      _jsEmulator!.callMethod(method.toJS, arg1);
    } else {
      _jsEmulator!.callMethod(method.toJS);
    }
  }

  @override
  Future<void> loadCore(String coreUrl, String platform) async {
    _ensureInitialized();

    if (!_initialized || _jsEmulator == null) {
      throw Exception('Emulator not initialized');
    }

    try {
      debugPrint('[EmulatorJS] Loading core: $platform from $coreUrl');

      await _callAsyncMethod<void>('loadCore', coreUrl.toJS, platform.toJS);

      debugPrint('[EmulatorJS] Core loaded successfully: $platform');
    } catch (e) {
      debugPrint('[EmulatorJS] Core loading error: $e');
      callbacks.onError?.call('Failed to load core: $e');
      rethrow;
    }
  }

  @override
  Future<void> loadRom(Uint8List romData, String fileName) async {
    _ensureInitialized();

    if (!_initialized || _jsEmulator == null) {
      throw Exception('Emulator not initialized');
    }

    try {
      debugPrint(
        '[EmulatorJS] Loading ROM: $fileName (${romData.length} bytes)',
      );

      // Convert Uint8List to JS Uint8Array
      final jsArray = romData.toJS;

      await _callAsyncMethod<void>('loadRom', jsArray, fileName.toJS);

      debugPrint('[EmulatorJS] ROM loaded successfully: $fileName');
    } catch (e) {
      debugPrint('[EmulatorJS] ROM loading error: $e');
      callbacks.onError?.call('Failed to load ROM: $e');
      rethrow;
    }
  }

  @override
  Future<void> loadRomFromUrl(String romUrl, String fileName) async {
    _ensureInitialized();

    if (!_initialized || _jsEmulator == null) {
      throw Exception('Emulator not initialized');
    }

    try {
      debugPrint('[EmulatorJS] Loading ROM from URL: $romUrl ($fileName)');

      await _callAsyncMethod<void>(
        'loadRomFromUrl',
        romUrl.toJS,
        fileName.toJS,
      );

      debugPrint('[EmulatorJS] ROM loaded from URL successfully: $fileName');
    } catch (e) {
      debugPrint('[EmulatorJS] ROM URL loading error: $e');
      callbacks.onError?.call('Failed to load ROM from URL: $e');
      rethrow;
    }
  }

  @override
  void start() {
    _ensureInitialized();

    if (!_initialized || _jsEmulator == null) {
      throw Exception('Emulator not initialized');
    }

    try {
      debugPrint('[EmulatorJS] Starting emulator');
      _callVoidMethod('start');
    } catch (e) {
      debugPrint('[EmulatorJS] Start error: $e');
      callbacks.onError?.call('Failed to start emulator: $e');
      rethrow;
    }
  }

  @override
  void pause() {
    if (!_initialized || _jsEmulator == null) return;

    try {
      debugPrint('[EmulatorJS] Pausing emulator');
      _callVoidMethod('pause');
    } catch (e) {
      debugPrint('[EmulatorJS] Pause error: $e');
    }
  }

  @override
  void resume() {
    if (!_initialized || _jsEmulator == null) return;

    try {
      debugPrint('[EmulatorJS] Resuming emulator');
      _callVoidMethod('resume');
    } catch (e) {
      debugPrint('[EmulatorJS] Resume error: $e');
    }
  }

  @override
  void reset() {
    if (!_initialized || _jsEmulator == null) return;

    try {
      debugPrint('[EmulatorJS] Resetting emulator');
      _callVoidMethod('reset');
    } catch (e) {
      debugPrint('[EmulatorJS] Reset error: $e');
    }
  }

  @override
  void stop() {
    if (!_initialized || _jsEmulator == null) return;

    try {
      debugPrint('[EmulatorJS] Stopping emulator');
      _callVoidMethod('stop');
    } catch (e) {
      debugPrint('[EmulatorJS] Stop error: $e');
    }
  }

  @override
  Future<Uint8List> createSaveState() async {
    _ensureInitialized();

    if (!_initialized || _jsEmulator == null) {
      throw Exception('Emulator not initialized');
    }

    try {
      debugPrint('[EmulatorJS] Creating save state');

      final result = await _callAsyncMethod<JSAny?>('createSaveState');

      if (result == null) {
        debugPrint('[EmulatorJS] Save state returned null');
        return Uint8List(0);
      }

      // If the JS side returns a Uint8Array, convert directly
      if (result.isA<JSUint8Array>()) {
        final jsBytes = result as JSUint8Array;
        final bytes = jsBytes.toDart;
        debugPrint('[EmulatorJS] Save state created: ${bytes.length} bytes');
        return bytes;
      }

      // If it's an ArrayBuffer, wrap in Uint8Array first
      if (result.isA<JSArrayBuffer>()) {
        final jsBytes = JSUint8Array(result as JSArrayBuffer);
        final bytes = jsBytes.toDart;
        debugPrint('[EmulatorJS] Save state created: ${bytes.length} bytes');
        return bytes;
      }

      debugPrint('[EmulatorJS] Save state returned unexpected type');
      return Uint8List(0);
    } catch (e) {
      debugPrint('[EmulatorJS] Save state error: $e');
      rethrow;
    }
  }

  @override
  Future<void> loadSaveState(Uint8List saveData) async {
    _ensureInitialized();

    if (!_initialized || _jsEmulator == null) {
      throw Exception('Emulator not initialized');
    }

    try {
      debugPrint('[EmulatorJS] Loading save state: ${saveData.length} bytes');

      await _callAsyncMethod<void>('loadSaveState', saveData.toJS);

      debugPrint('[EmulatorJS] Save state loaded successfully');
    } catch (e) {
      debugPrint('[EmulatorJS] Load save state error: $e');
      rethrow;
    }
  }

  @override
  Future<String?> getScreenshot() async {
    _ensureInitialized();

    if (!_initialized || _jsEmulator == null) {
      throw Exception('Emulator not initialized');
    }

    try {
      debugPrint('[EmulatorJS] Taking screenshot');

      final result = await _callAsyncMethod<JSAny?>('getScreenshot');

      if (result != null && result.isA<JSString>()) {
        final screenshot = (result as JSString).toDart;
        debugPrint('[EmulatorJS] Screenshot captured');
        return screenshot;
      }

      return null;
    } catch (e) {
      debugPrint('[EmulatorJS] Screenshot error: $e');
      return null;
    }
  }

  @override
  EmulatorStatus getStatus() {
    // Don't auto-initialize for status check
    if (!_initialized || _jsEmulator == null) {
      return EmulatorStatus(
        isLoaded: false,
        isLoading: false,
        container: containerId,
      );
    }

    try {
      final jsStatus = _jsEmulator!.callMethod('getStatus'.toJS) as JSObject;

      final isLoaded =
          (jsStatus.getProperty('isLoaded'.toJS) as JSBoolean?)?.toDart ??
          false;
      final currentCore =
          (jsStatus.getProperty('currentCore'.toJS) as JSString?)?.toDart;
      final currentRom =
          (jsStatus.getProperty('currentRom'.toJS) as JSString?)?.toDart;
      final isLoading =
          (jsStatus.getProperty('isLoading'.toJS) as JSBoolean?)?.toDart ??
          false;
      final container =
          (jsStatus.getProperty('container'.toJS) as JSString?)?.toDart ??
          containerId;

      return EmulatorStatus(
        isLoaded: isLoaded,
        currentCore: currentCore,
        currentRom: currentRom,
        isLoading: isLoading,
        container: container,
      );
    } catch (e) {
      debugPrint('[EmulatorJS] Get status error: $e');
      return EmulatorStatus(
        isLoaded: false,
        isLoading: false,
        container: containerId,
      );
    }
  }
}

/// Global instance registry for web emulators
final Map<String, EmulatorJSBridgeWeb> _instances = {};

/// Factory function for creating web emulator bridge
EmulatorJSBridge createEmulatorBridge({
  required String containerId,
  required EmulatorCallbacks callbacks,
}) {
  final bridge = EmulatorJSBridgeWeb(
    containerId: containerId,
    callbacks: callbacks,
  );

  // Store instance for retrieval
  _instances[containerId] = bridge;

  return bridge;
}

/// Get existing emulator instance
EmulatorJSBridge? getEmulatorInstance(String containerId) {
  return _instances[containerId];
}
