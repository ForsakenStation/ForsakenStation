// IO implementation for RomService (desktop/mobile)
import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/platform.dart';
import '../models/rom.dart';
import '../models/rom_item.dart';
import 'debug_service.dart';

final _debug = DebugService.instance;

/// Load platforms from directory structure (IO implementation)
Future<List<Platform>> loadPlatformsFromFiles(String romsBasePath) async {
  final List<Platform> platforms = [];

  try {
    final romsDir = Directory(romsBasePath);

    if (!await romsDir.exists()) {
      _debug.error(
        'ROMs directory does not exist: $romsBasePath',
        tag: 'RomService',
      );
      return platforms;
    }

    await for (var platformDir in romsDir.list()) {
      if (platformDir is Directory) {
        final platformName = path.basename(platformDir.path);

        if (platformName.startsWith('_')) continue;

        final roms = await loadRomsForPlatform(platformDir.path, platformName);

        platforms.add(
          Platform(name: platformName, path: platformDir.path, roms: roms),
        );
      }
    }

    platforms.sort((a, b) => a.name.compareTo(b.name));
  } catch (e) {
    _debug.error('Error loading platforms', tag: 'RomService', error: e);
  }

  return platforms;
}

/// Load ROMs for a platform (IO implementation)
Future<List<Rom>> loadRomsForPlatform(
  String platformPath,
  String platformName,
) async {
  final List<Rom> roms = [];

  try {
    final platformDir = Directory(platformPath);

    if (!await platformDir.exists()) {
      return roms;
    }

    await for (var file in platformDir.list(recursive: true)) {
      if (file is File) {
        final fileName = path.basename(file.path);

        if (fileName.startsWith('_')) continue;

        final rom = Rom(
          name: fileName,
          fileName: fileName,
          platform: platformName,
          urlFilePath: file.path,
        );

        roms.add(rom);
      }
    }

    roms.sort((a, b) => a.displayName.compareTo(b.displayName));

    _debug.info(
      'Loaded ${roms.length} ROMs for platform $platformName',
      tag: 'RomService',
    );
  } catch (e) {
    _debug.error(
      'Error loading ROMs for platform $platformName',
      tag: 'RomService',
      error: e,
    );
  }

  return roms;
}

/// Load items from filesystem directory (IO implementation)
Future<List<RomItem>> loadItemsInDirectory(
  String directoryPath,
  String platformName,
) async {
  final List<RomItem> items = [];

  try {
    final dir = Directory(directoryPath);

    if (!await dir.exists()) {
      return items;
    }

    await for (var entity in dir.list()) {
      if (entity is Directory) {
        final folderName = path.basename(entity.path);
        if (!folderName.startsWith('_')) {
          items.add(
            RomItem(
              name: folderName,
              path: entity.path,
              type: RomItemType.folder,
              platform: platformName,
            ),
          );
        }
      } else if (entity is File) {
        final fileName = path.basename(entity.path);

        if (fileName.startsWith('_')) continue;

        String? downloadUrl = await _loadUrlFromFile(entity.path);

        items.add(
          RomItem(
            name: fileName,
            path: entity.path,
            type: RomItemType.rom,
            downloadUrl: downloadUrl,
            platform: platformName,
          ),
        );
      }
    }

    items.sort((a, b) {
      if (a.isFolder && !b.isFolder) return -1;
      if (!a.isFolder && b.isFolder) return 1;
      return a.displayName.compareTo(b.displayName);
    });
  } catch (e) {
    _debug.error(
      'Error loading items in directory $directoryPath',
      tag: 'RomService',
      error: e,
    );
  }

  return items;
}

Future<String?> _loadUrlFromFile(String filePath) async {
  try {
    final file = File(filePath);
    if (await file.exists()) {
      final stat = await file.stat();

      if (stat.size > 10240) {
        return null;
      }

      final content = await file.readAsString();
      final trimmed = content.trim();

      if (trimmed.startsWith('http://') ||
          trimmed.startsWith('https://') ||
          trimmed.startsWith('ftp://')) {
        return trimmed;
      }

      return null;
    }
  } catch (e) {
    // Not a text file
  }
  return null;
}
