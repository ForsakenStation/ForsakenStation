import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/foundation.dart';

import '../../services/debug_service.dart';
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
      DebugService.instance.info(
        'Starting initialization for container: $containerId',
        tag: 'EmulatorJS',
      );

      // Create JavaScript callbacks object
      final jsCallbacks =
          {
                'onReady': (() {
                  DebugService.instance.info('Ready', tag: 'EmulatorJS');
                  callbacks.onReady?.call();
                }).toJS,
                'onError': ((JSString error) {
                  final errorMsg = error.toDart;
                  DebugService.instance.error(
                    'Error: $errorMsg',
                    tag: 'EmulatorJS',
                  );
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
                    DebugService.instance.error(
                      'Progress callback error: $e',
                      tag: 'EmulatorJS',
                    );
                  }
                }).toJS,
                'onCoreLoaded': (() {
                  DebugService.instance.info('Core loaded', tag: 'EmulatorJS');
                  callbacks.onCoreLoaded?.call();
                }).toJS,
                'onRomLoaded': (() {
                  DebugService.instance.info('ROM loaded', tag: 'EmulatorJS');
                  callbacks.onRomLoaded?.call();
                }).toJS,
                'onPause': (() {
                  DebugService.instance.info('Paused', tag: 'EmulatorJS');
                  callbacks.onPause?.call();
                }).toJS,
                'onResume': (() {
                  DebugService.instance.info('Resumed', tag: 'EmulatorJS');
                  callbacks.onResume?.call();
                }).toJS,
              }.jsify()
              as JSObject;

      DebugService.instance.info(
        'Callbacks created, attempting to instantiate...',
        tag: 'EmulatorJS',
      );

      try {
        // Call window.createForsakenEmulator(containerId, callbacks)
        _jsEmulator = _createForsakenEmulator(containerId.toJS, jsCallbacks);

        if (_jsEmulator != null) {
          _initialized = true;
          DebugService.instance.info(
            'Bridge initialized successfully for container: $containerId',
            tag: 'EmulatorJS',
          );
        } else {
          throw Exception('createForsakenEmulator returned null');
        }
      } catch (e) {
        DebugService.instance.error(
          'Failed to create instance: $e',
          tag: 'EmulatorJS',
        );

        // Fallback: Try direct access to window.ForsakenEmulators
        try {
          DebugService.instance.warning(
            'Trying fallback method...',
            tag: 'EmulatorJS',
          );
          final emulators = _forsakenEmulators;
          if (emulators != null) {
            final instance =
                emulators.getProperty(containerId.toJS) as JSObject?;
            if (instance != null) {
              _jsEmulator = instance;
              _initialized = true;
              DebugService.instance.info(
                'Retrieved existing instance from ForsakenEmulators',
                tag: 'EmulatorJS',
              );
            }
          }
        } catch (e2) {
          DebugService.instance.error(
            'Fallback also failed: $e2',
            tag: 'EmulatorJS',
          );
        }

        if (!_initialized) {
          rethrow;
        }
      }
    } catch (e, stackTrace) {
      DebugService.instance.error(
        'Initialization error: $e',
        tag: 'EmulatorJS',
        stackTrace: stackTrace,
      );
      callbacks.onError?.call('Failed to initialize emulator: $e');
      rethrow;
    }
  }

  /// Call a method on the JS emulator object, handling Promises.
  /// Supports 0-2 arguments (covers all current use cases).
  Future<JSAny?> _callAsyncMethod(
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
      return await future;
    }

    return result;
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
      DebugService.instance.info(
        'Loading core: $platform from $coreUrl',
        tag: 'EmulatorJS',
      );

      await _callAsyncMethod('loadCore', coreUrl.toJS, platform.toJS);

      DebugService.instance.info(
        'Core loaded successfully: $platform',
        tag: 'EmulatorJS',
      );
    } catch (e) {
      DebugService.instance.error('Core loading error: $e', tag: 'EmulatorJS');
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
      DebugService.instance.debug(
        'Loading ROM: $fileName (${romData.length} bytes)',
        tag: 'EmulatorJS',
      );

      // Convert Uint8List to JS Uint8Array
      final jsArray = romData.toJS;

      await _callAsyncMethod('loadRom', jsArray, fileName.toJS);

      DebugService.instance.info(
        'ROM loaded successfully: $fileName',
        tag: 'EmulatorJS',
      );
    } catch (e) {
      DebugService.instance.error('ROM loading error: $e', tag: 'EmulatorJS');
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
      DebugService.instance.info(
        'Loading ROM from URL: $romUrl ($fileName)',
        tag: 'EmulatorJS',
      );

      await _callAsyncMethod(
        'loadRomFromUrl',
        romUrl.toJS,
        fileName.toJS,
      );

      DebugService.instance.info(
        'ROM loaded from URL successfully: $fileName',
        tag: 'EmulatorJS',
      );
    } catch (e) {
      DebugService.instance.error(
        'ROM URL loading error: $e',
        tag: 'EmulatorJS',
      );
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
      DebugService.instance.info('Starting emulator', tag: 'EmulatorJS');
      _callVoidMethod('start');
    } catch (e) {
      DebugService.instance.error('Start error: $e', tag: 'EmulatorJS');
      callbacks.onError?.call('Failed to start emulator: $e');
      rethrow;
    }
  }

  @override
  void pause() {
    if (!_initialized || _jsEmulator == null) return;

    try {
      DebugService.instance.info('Pausing emulator', tag: 'EmulatorJS');
      _callVoidMethod('pause');
    } catch (e) {
      DebugService.instance.error('Pause error: $e', tag: 'EmulatorJS');
    }
  }

  @override
  void resume() {
    if (!_initialized || _jsEmulator == null) return;

    try {
      DebugService.instance.info('Resuming emulator', tag: 'EmulatorJS');
      _callVoidMethod('resume');
    } catch (e) {
      DebugService.instance.error('Resume error: $e', tag: 'EmulatorJS');
    }
  }

  @override
  void reset() {
    if (!_initialized || _jsEmulator == null) return;

    try {
      DebugService.instance.info('Resetting emulator', tag: 'EmulatorJS');
      _callVoidMethod('reset');
    } catch (e) {
      DebugService.instance.error('Reset error: $e', tag: 'EmulatorJS');
    }
  }

  @override
  void stop() {
    if (!_initialized || _jsEmulator == null) {
      _instances.remove(containerId);
      return;
    }

    try {
      DebugService.instance.info('Stopping emulator', tag: 'EmulatorJS');
      _callVoidMethod('stop');
    } catch (e) {
      DebugService.instance.error('Stop error: $e', tag: 'EmulatorJS');
    } finally {
      // Clean up instance
      _instances.remove(containerId);
      _jsEmulator = null;
      _initialized = false;
    }
  }

  @override
  Future<Uint8List> createSaveState() async {
    _ensureInitialized();

    if (!_initialized || _jsEmulator == null) {
      throw Exception('Emulator not initialized');
    }

    try {
      DebugService.instance.info('Creating save state', tag: 'EmulatorJS');

      final result = await _callAsyncMethod('createSaveState');

      if (result == null) {
        DebugService.instance.warning(
          'Save state returned null',
          tag: 'EmulatorJS',
        );
        return Uint8List(0);
      }

      // If the JS side returns a Uint8Array, convert directly
      if (result.isA<JSUint8Array>()) {
        final jsBytes = result as JSUint8Array;
        final bytes = jsBytes.toDart;
        DebugService.instance.debug(
          'Save state created: ${bytes.length} bytes',
          tag: 'EmulatorJS',
        );
        return bytes;
      }

      // If it's an ArrayBuffer, wrap in Uint8Array first
      if (result.isA<JSArrayBuffer>()) {
        final jsBytes = JSUint8Array(result as JSArrayBuffer);
        final bytes = jsBytes.toDart;
        DebugService.instance.debug(
          'Save state created: ${bytes.length} bytes',
          tag: 'EmulatorJS',
        );
        return bytes;
      }

      DebugService.instance.warning(
        'Save state returned unexpected type',
        tag: 'EmulatorJS',
      );
      return Uint8List(0);
    } catch (e) {
      DebugService.instance.error('Save state error: $e', tag: 'EmulatorJS');
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
      DebugService.instance.debug(
        'Loading save state: ${saveData.length} bytes',
        tag: 'EmulatorJS',
      );

      await _callAsyncMethod('loadSaveState', saveData.toJS);

      DebugService.instance.info(
        'Save state loaded successfully',
        tag: 'EmulatorJS',
      );
    } catch (e) {
      DebugService.instance.error(
        'Load save state error: $e',
        tag: 'EmulatorJS',
      );
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
      DebugService.instance.info('Taking screenshot', tag: 'EmulatorJS');

      final result = await _callAsyncMethod('getScreenshot');

      if (result != null && result.isA<JSString>()) {
        final screenshot = (result as JSString).toDart;
        DebugService.instance.info('Screenshot captured', tag: 'EmulatorJS');
        return screenshot;
      }

      return null;
    } catch (e) {
      DebugService.instance.error('Screenshot error: $e', tag: 'EmulatorJS');
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
      DebugService.instance.error('Get status error: $e', tag: 'EmulatorJS');
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
