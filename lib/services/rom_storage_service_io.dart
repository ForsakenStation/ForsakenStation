// IO implementation for RomStorageService (desktop/mobile)
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'debug_service.dart';

final _debug = DebugService.instance;

Future<Directory> _getBaseStorageDirectory() async {
  return await getApplicationSupportDirectory();
}

Future<Directory> getTempStorageDirectory(String? customPath) async {
  if (customPath != null && customPath.isNotEmpty) {
    return Directory(customPath);
  }
  final baseDir = await _getBaseStorageDirectory();
  return Directory(path.join(baseDir.path, 'roms_temp'));
}

Future<Directory> getForeverStorageDirectory(String? customPath) async {
  if (customPath != null && customPath.isNotEmpty) {
    return Directory(customPath);
  }
  final baseDir = await _getBaseStorageDirectory();
  return Directory(path.join(baseDir.path, 'roms_forever'));
}

Future<Directory> getPlatformTempDirectory(
  String platform,
  String? customPath,
) async {
  final tempDir = await getTempStorageDirectory(customPath);
  return Directory(path.join(tempDir.path, platform));
}

Future<Directory> getPlatformForeverDirectory(
  String platform,
  String? customPath,
) async {
  final foreverDir = await getForeverStorageDirectory(customPath);
  return Directory(path.join(foreverDir.path, platform));
}

Future<void> initializeStorageDirectories(
  String? customTempPath,
  String? customForeverPath,
) async {
  try {
    final tempDir = await getTempStorageDirectory(customTempPath);
    final foreverDir = await getForeverStorageDirectory(customForeverPath);

    if (!await tempDir.exists()) {
      await tempDir.create(recursive: true);
      _debug.info(
        'Created temp storage directory: ${tempDir.path}',
        tag: 'RomStorageService',
      );
    }

    if (!await foreverDir.exists()) {
      await foreverDir.create(recursive: true);
      _debug.info(
        'Created forever storage directory: ${foreverDir.path}',
        tag: 'RomStorageService',
      );
    }
  } catch (e) {
    _debug.error(
      'Error initializing storage directories',
      tag: 'RomStorageService',
      error: e,
    );
    rethrow;
  }
}

Future<Map<String, dynamic>> getStorageStats(
  String? customTempPath,
  String? customForeverPath,
) async {
  try {
    final tempDir = await getTempStorageDirectory(customTempPath);
    final foreverDir = await getForeverStorageDirectory(customForeverPath);

    int tempSize = 0;
    int tempCount = 0;
    int foreverSize = 0;
    int foreverCount = 0;

    if (await tempDir.exists()) {
      await for (var entity in tempDir.list(recursive: true)) {
        if (entity is File) {
          tempSize += await entity.length();
          tempCount++;
        }
      }
    }

    if (await foreverDir.exists()) {
      await for (var entity in foreverDir.list(recursive: true)) {
        if (entity is File) {
          foreverSize += await entity.length();
          foreverCount++;
        }
      }
    }

    return {
      'tempPath': tempDir.path,
      'foreverPath': foreverDir.path,
      'tempSize': tempSize,
      'foreverSize': foreverSize,
      'tempCount': tempCount,
      'foreverCount': foreverCount,
    };
  } catch (e) {
    _debug.error(
      'Error getting storage stats',
      tag: 'RomStorageService',
      error: e,
    );
    return {
      'tempPath': '',
      'foreverPath': '',
      'tempSize': 0,
      'foreverSize': 0,
      'tempCount': 0,
      'foreverCount': 0,
    };
  }
}

Future<String?> findRomInForeverStorage(
  String platform,
  String fileName,
  String? customPath,
) async {
  try {
    final foreverDir = await getPlatformForeverDirectory(platform, customPath);

    if (!await foreverDir.exists()) {
      return null;
    }

    final filePath = path.join(foreverDir.path, fileName);
    final file = File(filePath);

    if (await file.exists()) {
      return filePath;
    }

    return null;
  } catch (e) {
    _debug.error(
      'Error checking forever storage',
      tag: 'RomStorageService',
      error: e,
    );
    return null;
  }
}

Future<String?> findRomInTempStorage(
  String platform,
  String fileName,
  String? customPath,
) async {
  try {
    final tempDir = await getPlatformTempDirectory(platform, customPath);

    if (!await tempDir.exists()) {
      return null;
    }

    final filePath = path.join(tempDir.path, fileName);
    final file = File(filePath);

    if (await file.exists()) {
      return filePath;
    }

    return null;
  } catch (e) {
    _debug.error(
      'Error checking temp storage',
      tag: 'RomStorageService',
      error: e,
    );
    return null;
  }
}

Future<String?> moveToForeverStorage(
  String platform,
  String fileName,
  String? customTempPath,
  String? customForeverPath,
) async {
  try {
    final tempPath = await findRomInTempStorage(
      platform,
      fileName,
      customTempPath,
    );
    if (tempPath == null) {
      return null;
    }

    final foreverDir = await getPlatformForeverDirectory(
      platform,
      customForeverPath,
    );
    await foreverDir.create(recursive: true);

    final foreverPath = path.join(foreverDir.path, fileName);
    final tempFile = File(tempPath);

    await tempFile.copy(foreverPath);
    await tempFile.delete();

    _debug.info(
      'Moved ROM to forever storage: $fileName',
      tag: 'RomStorageService',
    );

    return foreverPath;
  } catch (e) {
    _debug.error(
      'Error moving ROM to forever storage',
      tag: 'RomStorageService',
      error: e,
    );
    return null;
  }
}

Future<bool> deleteFromTempStorage(
  String platform,
  String fileName,
  String? customPath,
) async {
  try {
    final tempPath = await findRomInTempStorage(platform, fileName, customPath);
    if (tempPath == null) {
      return false;
    }

    final file = File(tempPath);
    await file.delete();
    return true;
  } catch (e) {
    _debug.error(
      'Error deleting ROM from temp storage',
      tag: 'RomStorageService',
      error: e,
    );
    return false;
  }
}

Future<bool> deleteFromForeverStorage(
  String platform,
  String fileName,
  String? customPath,
) async {
  try {
    final foreverPath = await findRomInForeverStorage(
      platform,
      fileName,
      customPath,
    );
    if (foreverPath == null) {
      return false;
    }

    final file = File(foreverPath);
    await file.delete();
    return true;
  } catch (e) {
    _debug.error(
      'Error deleting ROM from forever storage',
      tag: 'RomStorageService',
      error: e,
    );
    return false;
  }
}

Future<void> cleanupAllTempRoms(String? customPath) async {
  try {
    final tempDir = await getTempStorageDirectory(customPath);

    if (!await tempDir.exists()) {
      return;
    }

    await tempDir.delete(recursive: true);
    await tempDir.create(recursive: true);

    _debug.info('Cleaned up all temp ROMs', tag: 'RomStorageService');
  } catch (e) {
    _debug.error(
      'Error cleaning up temp ROMs',
      tag: 'RomStorageService',
      error: e,
    );
  }
}

Future<void> cleanupPlatformTempRoms(
  String platform,
  String? customPath,
) async {
  try {
    final platformTempDir = await getPlatformTempDirectory(
      platform,
      customPath,
    );

    if (!await platformTempDir.exists()) {
      return;
    }

    await platformTempDir.delete(recursive: true);

    _debug.info(
      'Cleaned up temp ROMs for platform: $platform',
      tag: 'RomStorageService',
    );
  } catch (e) {
    _debug.error(
      'Error cleaning up temp ROMs for platform: $platform',
      tag: 'RomStorageService',
      error: e,
    );
  }
}

Future<bool> migrateForeverStorage(
  String newPath,
  String? currentCustomPath,
) async {
  try {
    final oldDir = await getForeverStorageDirectory(currentCustomPath);
    final newDir = Directory(newPath);

    if (!await newDir.exists()) {
      await newDir.create(recursive: true);
    }

    if (await oldDir.exists()) {
      final files = <FileSystemEntity>[];
      await for (var entity in oldDir.list(recursive: false)) {
        files.add(entity);
      }

      for (var entity in files) {
        if (entity is Directory) {
          final dirName = path.basename(entity.path);
          final newDirPath = path.join(newDir.path, dirName);
          await _copyDirectory(entity, Directory(newDirPath));
          await entity.delete(recursive: true);
        } else if (entity is File) {
          final fileName = path.basename(entity.path);
          final newFilePath = path.join(newDir.path, fileName);
          await entity.copy(newFilePath);
          await entity.delete();
        }
      }

      if (await oldDir.exists()) {
        final remaining = await oldDir.list().length;
        if (remaining == 0) {
          await oldDir.delete();
        }
      }

      _debug.info('Migration completed successfully', tag: 'RomStorageService');
    }

    return true;
  } catch (e) {
    _debug.error(
      'Error migrating forever storage',
      tag: 'RomStorageService',
      error: e,
    );
    return false;
  }
}

Future<void> _copyDirectory(Directory source, Directory destination) async {
  if (!await destination.exists()) {
    await destination.create(recursive: true);
  }

  await for (var entity in source.list(recursive: false)) {
    if (entity is Directory) {
      final newDirectory = Directory(
        path.join(destination.path, path.basename(entity.path)),
      );
      await _copyDirectory(entity, newDirectory);
    } else if (entity is File) {
      await entity.copy(
        path.join(destination.path, path.basename(entity.path)),
      );
    }
  }
}
