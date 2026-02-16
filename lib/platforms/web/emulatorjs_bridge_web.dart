// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:js' as js;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'emulatorjs_bridge.dart';

/// Web implementation of EmulatorJSBridge using dart:js
class EmulatorJSBridgeWeb implements EmulatorJSBridge {
  @override
  final String containerId;

  @override
  final EmulatorCallbacks callbacks;

  js.JsObject? _jsEmulator;
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

      // Create JavaScript callbacks object using jsify
      final jsCallbacks = js.JsObject.jsify({
        'onReady': () {
          debugPrint('[EmulatorJS] Ready');
          callbacks.onReady?.call();
        },
        'onError': (dynamic error) {
          final errorMsg = error.toString();
          debugPrint('[EmulatorJS] Error: $errorMsg');
          callbacks.onError?.call(errorMsg);
        },
        'onLoadingProgress': (dynamic progress) {
          try {
            final progressObj = progress as js.JsObject;
            final stage = progressObj['stage'] as String? ?? 'unknown';
            final progressValue = (progressObj['progress'] as num? ?? 0)
                .toDouble();
            final message = progressObj['message'] as String? ?? '';

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
        },
        'onCoreLoaded': () {
          debugPrint('[EmulatorJS] Core loaded');
          callbacks.onCoreLoaded?.call();
        },
        'onRomLoaded': () {
          debugPrint('[EmulatorJS] ROM loaded');
          callbacks.onRomLoaded?.call();
        },
        'onPause': () {
          debugPrint('[EmulatorJS] Paused');
          callbacks.onPause?.call();
        },
        'onResume': () {
          debugPrint('[EmulatorJS] Resumed');
          callbacks.onResume?.call();
        },
      });

      debugPrint(
        '[EmulatorJS] Callbacks created, attempting to instantiate...',
      );

      // Use eval to create the instance - this avoids _Namespace issues
      // This is a workaround for dart:js limitations with constructors
      final evalCode = '''
        (function(containerId, callbacks) {
          return window.createForsakenEmulator(containerId, callbacks);
        })
      ''';

      try {
        // Create a function from the eval code
        final factory =
            js.context.callMethod('eval', [evalCode]) as js.JsFunction;

        // Call the factory function with our parameters
        _jsEmulator = factory.apply([containerId, jsCallbacks]) as js.JsObject;

        _initialized = true;
        debugPrint(
          '[EmulatorJS] Bridge initialized successfully for container: $containerId',
        );
      } catch (e) {
        debugPrint('[EmulatorJS] Failed to create instance: $e');

        // Fallback: Try direct access to window.ForsakenEmulators
        try {
          debugPrint('[EmulatorJS] Trying fallback method...');
          final emulators = js.context['ForsakenEmulators'];
          if (emulators != null) {
            _jsEmulator = emulators[containerId] as js.JsObject?;
            if (_jsEmulator != null) {
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

  Future<T> _callAsyncMethod<T>(
    String method, [
    List<dynamic> args = const [],
  ]) async {
    _ensureInitialized();

    if (_jsEmulator == null) {
      throw Exception('Emulator not initialized');
    }

    final result = _jsEmulator!.callMethod(method, args);

    // Check if result is a Promise
    if (result is js.JsObject && result.hasProperty('then')) {
      // Convert Promise to Future
      final completer = Completer<T>();

      result.callMethod('then', [
        (dynamic value) {
          completer.complete(value as T);
        },
      ]);

      result.callMethod('catch', [
        (dynamic error) {
          completer.completeError(error);
        },
      ]);

      return completer.future;
    }

    return result as T;
  }

  @override
  Future<void> loadCore(String coreUrl, String platform) async {
    _ensureInitialized();

    if (!_initialized || _jsEmulator == null) {
      throw Exception('Emulator not initialized');
    }

    try {
      debugPrint('[EmulatorJS] Loading core: $platform from $coreUrl');

      await _callAsyncMethod<void>('loadCore', [coreUrl, platform]);

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

      // Pass Uint8List directly - dart:js will handle the conversion
      await _callAsyncMethod<void>('loadRom', [romData, fileName]);

      debugPrint('[EmulatorJS] ROM loaded successfully: $fileName');
    } catch (e) {
      debugPrint('[EmulatorJS] ROM loading error: $e');
      callbacks.onError?.call('Failed to load ROM: $e');
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
      _jsEmulator!.callMethod('start');
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
      _jsEmulator!.callMethod('pause');
    } catch (e) {
      debugPrint('[EmulatorJS] Pause error: $e');
    }
  }

  @override
  void resume() {
    if (!_initialized || _jsEmulator == null) return;

    try {
      debugPrint('[EmulatorJS] Resuming emulator');
      _jsEmulator!.callMethod('resume');
    } catch (e) {
      debugPrint('[EmulatorJS] Resume error: $e');
    }
  }

  @override
  void reset() {
    if (!_initialized || _jsEmulator == null) return;

    try {
      debugPrint('[EmulatorJS] Resetting emulator');
      _jsEmulator!.callMethod('reset');
    } catch (e) {
      debugPrint('[EmulatorJS] Reset error: $e');
    }
  }

  @override
  void stop() {
    if (!_initialized || _jsEmulator == null) return;

    try {
      debugPrint('[EmulatorJS] Stopping emulator');
      _jsEmulator!.callMethod('stop');
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

      await _callAsyncMethod('createSaveState');

      // Convert JavaScript ArrayBuffer to Uint8List
      // For now, return dummy data - this will be improved once we test with actual core
      debugPrint('[EmulatorJS] Save state created');
      return Uint8List(1024);
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

      await _callAsyncMethod<void>('loadSaveState', [saveData]);

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

      final result = await _callAsyncMethod<String>('getScreenshot');

      debugPrint('[EmulatorJS] Screenshot captured');
      return result;
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
      final jsStatus = _jsEmulator!.callMethod('getStatus') as js.JsObject;

      return EmulatorStatus(
        isLoaded: jsStatus['isLoaded'] as bool? ?? false,
        currentCore: jsStatus['currentCore'] as String?,
        currentRom: jsStatus['currentRom'] as String?,
        isLoading: jsStatus['isLoading'] as bool? ?? false,
        container: jsStatus['container'] as String? ?? containerId,
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
