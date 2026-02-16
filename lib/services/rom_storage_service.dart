import 'package:flutter/foundation.dart';
import 'debug_service.dart';

// Conditional import for IO-specific functionality
import 'rom_storage_service_io.dart'
    if (dart.library.html) 'rom_storage_service_web_impl.dart'
    as platform_service;

/// Service for managing ROM storage locations
class RomStorageService {
  static RomStorageService? _instance;
  final _debug = DebugService.instance;

  String? _customTempPath;
  String? _customForeverPath;

  RomStorageService._();

  static RomStorageService get instance {
    _instance ??= RomStorageService._();
    return _instance!;
  }

  void setCustomTempPath(String? customPath) {
    _customTempPath = customPath;
  }

  void setCustomForeverPath(String? customPath) {
    _customForeverPath = customPath;
  }

  String? getCustomTempPath() => _customTempPath;
  String? getCustomForeverPath() => _customForeverPath;

  /// Initialize storage directories
  Future<void> initializeStorageDirectories() async {
    if (kIsWeb) {
      // On web, we use browser storage (IndexedDB/localStorage)
      _debug.info(
        'Web platform: using browser storage',
        tag: 'RomStorageService',
      );
      return;
    }
    await platform_service.initializeStorageDirectories(
      _customTempPath,
      _customForeverPath,
    );
  }

  /// Get storage statistics
  Future<Map<String, dynamic>> getStorageStats() async {
    if (kIsWeb) {
      return {
        'tempPath': 'Browser Storage (temp)',
        'foreverPath': 'Browser Storage (permanent)',
        'tempSize': 0,
        'foreverSize': 0,
        'tempCount': 0,
        'foreverCount': 0,
      };
    }
    return platform_service.getStorageStats(
      _customTempPath,
      _customForeverPath,
    );
  }

  /// Find ROM in permanent storage
  Future<String?> findRomInForeverStorage(
    String platform,
    String fileName,
  ) async {
    if (kIsWeb) {
      // TODO: Implement web storage lookup
      return null;
    }
    return platform_service.findRomInForeverStorage(
      platform,
      fileName,
      _customForeverPath,
    );
  }

  /// Find ROM in temporary storage
  Future<String?> findRomInTempStorage(String platform, String fileName) async {
    if (kIsWeb) {
      return null;
    }
    return platform_service.findRomInTempStorage(
      platform,
      fileName,
      _customTempPath,
    );
  }

  /// Move ROM from temp to permanent storage
  Future<String?> moveToForeverStorage(String platform, String fileName) async {
    if (kIsWeb) {
      return null;
    }
    return platform_service.moveToForeverStorage(
      platform,
      fileName,
      _customTempPath,
      _customForeverPath,
    );
  }

  /// Delete ROM from temp storage
  Future<bool> deleteFromTempStorage(String platform, String fileName) async {
    if (kIsWeb) {
      return false;
    }
    return platform_service.deleteFromTempStorage(
      platform,
      fileName,
      _customTempPath,
    );
  }

  /// Delete ROM from permanent storage
  Future<bool> deleteFromForeverStorage(
    String platform,
    String fileName,
  ) async {
    if (kIsWeb) {
      return false;
    }
    return platform_service.deleteFromForeverStorage(
      platform,
      fileName,
      _customForeverPath,
    );
  }

  /// Clean up all temporary ROMs
  Future<void> cleanupAllTempRoms() async {
    if (kIsWeb) {
      return;
    }
    await platform_service.cleanupAllTempRoms(_customTempPath);
  }

  /// Clean up temporary ROMs for a specific platform
  Future<void> cleanupPlatformTempRoms(String platform) async {
    if (kIsWeb) {
      return;
    }
    await platform_service.cleanupPlatformTempRoms(platform, _customTempPath);
  }

  /// Migrate forever storage to a new location
  Future<bool> migrateForeverStorage(String newPath) async {
    if (kIsWeb) {
      return false;
    }
    final result = await platform_service.migrateForeverStorage(
      newPath,
      _customForeverPath,
    );
    if (result) {
      setCustomForeverPath(newPath);
    }
    return result;
  }

  /// Get temp storage directory (for UI display)
  Future<dynamic> getTempStorageDirectory() async {
    if (kIsWeb) {
      return null;
    }
    return platform_service.getTempStorageDirectory(_customTempPath);
  }

  /// Get forever storage directory (for UI display)
  Future<dynamic> getForeverStorageDirectory() async {
    if (kIsWeb) {
      return null;
    }
    return platform_service.getForeverStorageDirectory(_customForeverPath);
  }

  /// Get platform-specific temp directory
  Future<dynamic> getPlatformTempDirectory(String platform) async {
    if (kIsWeb) {
      return null;
    }
    return platform_service.getPlatformTempDirectory(platform, _customTempPath);
  }

  /// Get platform-specific forever directory
  Future<dynamic> getPlatformForeverDirectory(String platform) async {
    if (kIsWeb) {
      return null;
    }
    return platform_service.getPlatformForeverDirectory(
      platform,
      _customForeverPath,
    );
  }
}
