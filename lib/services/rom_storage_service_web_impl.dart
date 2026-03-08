// Web implementation of RomStorageService using IndexedDB via JS bridge.
//
// All actual storage is handled by window.forsakenRomStorage (defined in
// forsaken_bridge.js) which uses IndexedDB with two object stores:
//   - temp_roms   (auto-downloaded cache, can be cleaned up)
//   - forever_roms (user-opted permanent storage)
//
// The Dart side calls into JS via dart:js_interop.

import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'debug_service.dart';

// ---------------------------------------------------------------------------
// JS interop helpers
// ---------------------------------------------------------------------------

/// Get the window.forsakenRomStorage object.
JSObject? get _storage {
  try {
    return globalContext.getProperty('forsakenRomStorage'.toJS) as JSObject?;
  } catch (_) {
    return null;
  }
}

/// Call a method on forsakenRomStorage and await the resulting Promise.
Future<T?> _callAsync<T extends JSAny?>(
  String method, [
  JSAny? arg1,
  JSAny? arg2,
  JSAny? arg3,
]) async {
  final s = _storage;
  if (s == null) return null;
  final JSAny? result;
  if (arg3 != null) {
    result = s.callMethod(method.toJS, arg1, arg2, arg3);
  } else if (arg2 != null) {
    result = s.callMethod(method.toJS, arg1, arg2);
  } else if (arg1 != null) {
    result = s.callMethod(method.toJS, arg1);
  } else {
    result = s.callMethod(method.toJS);
  }
  if (result != null && result.isA<JSPromise>()) {
    final value = await (result as JSPromise).toDart;
    return value as T?;
  }
  return result as T?;
}

// ---------------------------------------------------------------------------
// Top-level functions matching the IO implementation's signatures
// ---------------------------------------------------------------------------

Future<void> initializeStorageDirectories(
  String? customTempPath,
  String? customForeverPath,
) async {
  // Verify IndexedDB bridge is available by requesting stats.
  // This triggers _openRomDB() on the JS side, ensuring the DB and
  // object stores are created early.
  try {
    final stats = await _callAsync<JSObject>('getStats');
    if (stats != null) {
      final tempCount =
          (stats.getProperty('tempCount'.toJS) as JSNumber?)?.toDartInt ?? 0;
      final foreverCount =
          (stats.getProperty('foreverCount'.toJS) as JSNumber?)?.toDartInt ?? 0;
      DebugService.instance.info(
        'IndexedDB initialized — temp: $tempCount ROMs, forever: $foreverCount ROMs',
        tag: 'RomStorageWeb',
      );
    } else {
      DebugService.instance.warning(
        'getStats returned null — forsakenRomStorage bridge may not be loaded',
        tag: 'RomStorageWeb',
      );
    }
  } catch (e) {
    DebugService.instance.warning(
      'IndexedDB initialization check failed: $e',
      tag: 'RomStorageWeb',
    );
  }
}

Future<Map<String, dynamic>> getStorageStats(
  String? customTempPath,
  String? customForeverPath,
) async {
  try {
    final jsStats = await _callAsync<JSObject>('getStats');
    if (jsStats == null) {
      return _emptyStats();
    }
    return {
      'tempPath':
          (jsStats.getProperty('tempPath'.toJS) as JSString?)?.toDart ??
          'IndexedDB (temp)',
      'foreverPath':
          (jsStats.getProperty('foreverPath'.toJS) as JSString?)?.toDart ??
          'IndexedDB (permanent)',
      'tempSize':
          (jsStats.getProperty('tempSize'.toJS) as JSNumber?)?.toDartInt ?? 0,
      'foreverSize':
          (jsStats.getProperty('foreverSize'.toJS) as JSNumber?)?.toDartInt ??
          0,
      'tempCount':
          (jsStats.getProperty('tempCount'.toJS) as JSNumber?)?.toDartInt ?? 0,
      'foreverCount':
          (jsStats.getProperty('foreverCount'.toJS) as JSNumber?)?.toDartInt ??
          0,
    };
  } catch (e) {
    return _emptyStats();
  }
}

Map<String, dynamic> _emptyStats() => {
  'tempPath': 'IndexedDB (temp)',
  'foreverPath': 'IndexedDB (permanent)',
  'tempSize': 0,
  'foreverSize': 0,
  'tempCount': 0,
  'foreverCount': 0,
};

Future<String?> findRomInForeverStorage(
  String platform,
  String fileName,
  String? customPath,
) async {
  try {
    final found = await _callAsync<JSBoolean>(
      'findInForever',
      platform.toJS,
      fileName.toJS,
    );
    if (found != null && found.toDart) {
      // Return a synthetic path so callers see "not null" = exists.
      return 'idb://forever/$platform/$fileName';
    }
  } catch (_) {}
  return null;
}

/// Web stub: extracted ROM directories are not supported on web.
Future<String?> findExtractedRomInForeverStorage(
  String platform,
  String zipFileName,
  String? customPath,
) async {
  // Extraction is not supported on web platform
  return null;
}

Future<String?> findRomInTempStorage(
  String platform,
  String fileName,
  String? customPath,
) async {
  try {
    final found = await _callAsync<JSBoolean>(
      'findInTemp',
      platform.toJS,
      fileName.toJS,
    );
    if (found != null && found.toDart) {
      return 'idb://temp/$platform/$fileName';
    }
  } catch (_) {}
  return null;
}

Future<String?> moveToForeverStorage(
  String platform,
  String fileName,
  String? customTempPath,
  String? customForeverPath,
) async {
  try {
    final ok = await _callAsync<JSBoolean>(
      'moveToForever',
      platform.toJS,
      fileName.toJS,
    );
    if (ok != null && ok.toDart) {
      return 'idb://forever/$platform/$fileName';
    }
  } catch (_) {}
  return null;
}

Future<bool> deleteFromTempStorage(
  String platform,
  String fileName,
  String? customPath,
) async {
  try {
    final ok = await _callAsync<JSBoolean>(
      'deleteFromTemp',
      platform.toJS,
      fileName.toJS,
    );
    return ok?.toDart ?? false;
  } catch (_) {
    return false;
  }
}

Future<bool> deleteFromForeverStorage(
  String platform,
  String fileName,
  String? customPath,
) async {
  try {
    final ok = await _callAsync<JSBoolean>(
      'deleteFromForever',
      platform.toJS,
      fileName.toJS,
    );
    return ok?.toDart ?? false;
  } catch (_) {
    return false;
  }
}

Future<void> cleanupAllTempRoms(String? customPath) async {
  try {
    await _callAsync<JSAny?>('cleanupTemp');
  } catch (_) {}
}

Future<void> cleanupPlatformTempRoms(
  String platform,
  String? customPath,
) async {
  try {
    await _callAsync<JSAny?>('cleanupTemp', platform.toJS);
  } catch (_) {}
}

Future<bool> migrateForeverStorage(
  String newPath,
  String? currentCustomPath,
) async {
  // Migration doesn't apply to IndexedDB.
  return false;
}

// Directory getters — return descriptive strings on web (not Directory objects).
Future<dynamic> getTempStorageDirectory(String? customPath) async =>
    'IndexedDB (temp)';
Future<dynamic> getForeverStorageDirectory(String? customPath) async =>
    'IndexedDB (permanent)';
Future<dynamic> getPlatformTempDirectory(
  String platform,
  String? customPath,
) async => 'IndexedDB (temp/$platform)';
Future<dynamic> getPlatformForeverDirectory(
  String platform,
  String? customPath,
) async => 'IndexedDB (permanent/$platform)';
