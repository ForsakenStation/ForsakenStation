import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'debug_service.dart';

/// Service for managing ROM storage locations (temporary and permanent downloads)
///
/// Manages two types of storage:
/// - Temporary storage (_temp): ROMs downloaded for single play sessions
/// - Permanent storage (_forever): ROMs saved permanently for offline play
///
/// Uses cross-platform storage directories via path_provider
class RomStorageService {
  static RomStorageService? _instance;
  final _debug = DebugService.instance;

  // Default storage locations (relative to app support directory)
  String? _customTempPath;
  String? _customForeverPath;

  RomStorageService._();

  /// Get the singleton instance
  static RomStorageService get instance {
    _instance ??= RomStorageService._();
    return _instance!;
  }

  /// Get the base app directory for ROM storage
  ///
  /// Returns application support directory for the platform:
  /// - Linux: ~/.local/share/com.example.emulator
  /// - Windows: %APPDATA%/com.example.emulator
  /// - macOS: ~/Library/Application Support/com.example.emulator
  /// - Android: /data/data/com.example.emulator/files
  Future<Directory> _getBaseStorageDirectory() async {
    return await getApplicationSupportDirectory();
  }

  /// Get the temporary ROM storage directory
  ///
  /// This directory is used for ROMs that are downloaded temporarily
  /// for a single play session. ROMs here can be cleaned up automatically.
  ///
  /// Default: {appSupport}/roms_temp
  /// Can be customized by user in settings
  Future<Directory> getTempStorageDirectory() async {
    if (_customTempPath != null && _customTempPath!.isNotEmpty) {
      return Directory(_customTempPath!);
    }

    final baseDir = await _getBaseStorageDirectory();
    return Directory(path.join(baseDir.path, 'roms_temp'));
  }

  /// Get the permanent ROM storage directory
  ///
  /// This directory is used for ROMs that user wants to keep downloaded
  /// permanently for offline play.
  ///
  /// Default: {appSupport}/roms_forever
  /// Can be customized by user in settings
  Future<Directory> getForeverStorageDirectory() async {
    if (_customForeverPath != null && _customForeverPath!.isNotEmpty) {
      return Directory(_customForeverPath!);
    }

    final baseDir = await _getBaseStorageDirectory();
    return Directory(path.join(baseDir.path, 'roms_forever'));
  }

  /// Set custom temporary storage path
  ///
  /// Used when user changes the temp storage location in settings
  void setCustomTempPath(String? customPath) {
    _customTempPath = customPath;
  }

  /// Set custom permanent storage path
  ///
  /// Used when user changes the forever storage location in settings
  void setCustomForeverPath(String? customPath) {
    _customForeverPath = customPath;
  }

  /// Get custom temp path (for displaying in settings)
  String? getCustomTempPath() => _customTempPath;

  /// Get custom forever path (for displaying in settings)
  String? getCustomForeverPath() => _customForeverPath;

  /// Initialize storage directories (create if they don't exist)
  Future<void> initializeStorageDirectories() async {
    try {
      final tempDir = await getTempStorageDirectory();
      final foreverDir = await getForeverStorageDirectory();

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

  /// Get platform-specific temp directory
  ///
  /// Example: {tempStorage}/nes/
  Future<Directory> getPlatformTempDirectory(String platform) async {
    final tempDir = await getTempStorageDirectory();
    return Directory(path.join(tempDir.path, platform));
  }

  /// Get platform-specific forever directory
  ///
  /// Example: {foreverStorage}/nes/
  Future<Directory> getPlatformForeverDirectory(String platform) async {
    final foreverDir = await getForeverStorageDirectory();
    return Directory(path.join(foreverDir.path, platform));
  }

  /// Check if a ROM exists in permanent storage
  ///
  /// Returns the file path if found, null otherwise
  Future<String?> findRomInForeverStorage(
    String platform,
    String fileName,
  ) async {
    try {
      final foreverDir = await getPlatformForeverDirectory(platform);

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

  /// Check if a ROM exists in temporary storage
  ///
  /// Returns the file path if found, null otherwise
  Future<String?> findRomInTempStorage(String platform, String fileName) async {
    try {
      final tempDir = await getPlatformTempDirectory(platform);

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

  /// Move a ROM from temp storage to forever storage
  ///
  /// Returns the new file path if successful, null otherwise
  Future<String?> moveToForeverStorage(String platform, String fileName) async {
    try {
      final tempPath = await findRomInTempStorage(platform, fileName);
      if (tempPath == null) {
        _debug.warning(
          'ROM not found in temp storage: $fileName',
          tag: 'RomStorageService',
        );
        return null;
      }

      final foreverDir = await getPlatformForeverDirectory(platform);
      await foreverDir.create(recursive: true);

      final foreverPath = path.join(foreverDir.path, fileName);
      final tempFile = File(tempPath);

      // Copy file to forever storage
      await tempFile.copy(foreverPath);

      // Delete from temp storage
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

  /// Delete a ROM from temporary storage
  Future<bool> deleteFromTempStorage(String platform, String fileName) async {
    try {
      final tempPath = await findRomInTempStorage(platform, fileName);
      if (tempPath == null) {
        return false;
      }

      final file = File(tempPath);
      await file.delete();

      _debug.info(
        'Deleted ROM from temp storage: $fileName',
        tag: 'RomStorageService',
      );

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

  /// Delete a ROM from permanent storage
  Future<bool> deleteFromForeverStorage(
    String platform,
    String fileName,
  ) async {
    try {
      final foreverPath = await findRomInForeverStorage(platform, fileName);
      if (foreverPath == null) {
        return false;
      }

      final file = File(foreverPath);
      await file.delete();

      _debug.info(
        'Deleted ROM from forever storage: $fileName',
        tag: 'RomStorageService',
      );

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

  /// Clean up all temporary ROMs
  Future<void> cleanupAllTempRoms() async {
    try {
      final tempDir = await getTempStorageDirectory();

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

  /// Clean up temporary ROMs for a specific platform
  Future<void> cleanupPlatformTempRoms(String platform) async {
    try {
      final platformTempDir = await getPlatformTempDirectory(platform);

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

  /// Get storage statistics
  ///
  /// Returns a map with storage information:
  /// - tempPath: Path to temp storage
  /// - foreverPath: Path to forever storage
  /// - tempSize: Total size of temp storage in bytes
  /// - foreverSize: Total size of forever storage in bytes
  /// - tempCount: Number of files in temp storage
  /// - foreverCount: Number of files in forever storage
  Future<Map<String, dynamic>> getStorageStats() async {
    try {
      final tempDir = await getTempStorageDirectory();
      final foreverDir = await getForeverStorageDirectory();

      int tempSize = 0;
      int tempCount = 0;
      int foreverSize = 0;
      int foreverCount = 0;

      // Calculate temp storage stats
      if (await tempDir.exists()) {
        await for (var entity in tempDir.list(recursive: true)) {
          if (entity is File) {
            tempSize += await entity.length();
            tempCount++;
          }
        }
      }

      // Calculate forever storage stats
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

  /// Migrate forever storage to a new location
  ///
  /// Moves all files from old location to new location
  /// Returns true if successful, false otherwise
  Future<bool> migrateForeverStorage(String newPath) async {
    try {
      final oldDir = await getForeverStorageDirectory();
      final newDir = Directory(newPath);

      // Create new directory
      if (!await newDir.exists()) {
        await newDir.create(recursive: true);
      }

      // If old directory exists and has files, move them
      if (await oldDir.exists()) {
        final files = <FileSystemEntity>[];
        await for (var entity in oldDir.list(recursive: false)) {
          files.add(entity);
        }

        _debug.info(
          'Migrating ${files.length} items from ${oldDir.path} to ${newDir.path}',
          tag: 'RomStorageService',
        );

        // Move platform directories
        for (var entity in files) {
          if (entity is Directory) {
            final dirName = path.basename(entity.path);
            final newDirPath = path.join(newDir.path, dirName);

            // Copy directory recursively
            await _copyDirectory(entity, Directory(newDirPath));

            // Delete old directory
            await entity.delete(recursive: true);
          } else if (entity is File) {
            final fileName = path.basename(entity.path);
            final newFilePath = path.join(newDir.path, fileName);

            // Copy file
            await entity.copy(newFilePath);

            // Delete old file
            await entity.delete();
          }
        }

        // Delete old directory if empty
        if (await oldDir.exists()) {
          final remaining = await oldDir.list().length;
          if (remaining == 0) {
            await oldDir.delete();
          }
        }

        _debug.info(
          'Migration completed successfully',
          tag: 'RomStorageService',
        );
      }

      // Update custom path
      setCustomForeverPath(newPath);

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

  /// Helper method to recursively copy a directory
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
}
