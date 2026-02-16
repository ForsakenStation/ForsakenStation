// Web implementation stub for RomStorageService
// On web, we use browser storage (IndexedDB/localStorage) - placeholder implementation

Future<void> initializeStorageDirectories(
  String? customTempPath,
  String? customForeverPath,
) async {
  // No-op on web
}

Future<Map<String, dynamic>> getStorageStats(
  String? customTempPath,
  String? customForeverPath,
) async {
  return {
    'tempPath': 'Browser Storage (temp)',
    'foreverPath': 'Browser Storage (permanent)',
    'tempSize': 0,
    'foreverSize': 0,
    'tempCount': 0,
    'foreverCount': 0,
  };
}

Future<String?> findRomInForeverStorage(
  String platform,
  String fileName,
  String? customPath,
) async {
  return null;
}

Future<String?> findRomInTempStorage(
  String platform,
  String fileName,
  String? customPath,
) async {
  return null;
}

Future<String?> moveToForeverStorage(
  String platform,
  String fileName,
  String? customTempPath,
  String? customForeverPath,
) async {
  return null;
}

Future<bool> deleteFromTempStorage(
  String platform,
  String fileName,
  String? customPath,
) async {
  return false;
}

Future<bool> deleteFromForeverStorage(
  String platform,
  String fileName,
  String? customPath,
) async {
  return false;
}

Future<void> cleanupAllTempRoms(String? customPath) async {}

Future<void> cleanupPlatformTempRoms(
  String platform,
  String? customPath,
) async {}

Future<bool> migrateForeverStorage(
  String newPath,
  String? currentCustomPath,
) async {
  return false;
}

// Directory getters return null on web
Future<dynamic> getTempStorageDirectory(String? customPath) async => null;
Future<dynamic> getForeverStorageDirectory(String? customPath) async => null;
Future<dynamic> getPlatformTempDirectory(
  String platform,
  String? customPath,
) async => null;
Future<dynamic> getPlatformForeverDirectory(
  String platform,
  String? customPath,
) async => null;
