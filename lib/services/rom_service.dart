import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/platform.dart';
import '../models/rom.dart';
import '../models/rom_item.dart';
import 'debug_service.dart';

class RomService {
  final String romsBasePath;
  final _debug = DebugService.instance;

  RomService({required this.romsBasePath});

  Future<List<Platform>> loadPlatforms() async {
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

          // Skip hidden folders starting with _
          if (platformName.startsWith('_')) {
            _debug.debug(
              'Skipping hidden platform folder: $platformName',
              tag: 'RomService',
            );
            continue;
          }

          final roms = await loadRomsForPlatform(
            platformDir.path,
            platformName,
          );

          platforms.add(
            Platform(name: platformName, path: platformDir.path, roms: roms),
          );
        }
      }

      // Sort platforms alphabetically
      platforms.sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      _debug.error('Error loading platforms', tag: 'RomService', error: e);
    }

    return platforms;
  }

  Future<List<Rom>> loadRomsForPlatform(
    String platformPath,
    String platformName,
  ) async {
    final List<Rom> roms = [];

    try {
      final platformDir = Directory(platformPath);

      if (!await platformDir.exists()) {
        _debug.error(
          'Platform directory does not exist: $platformPath',
          tag: 'RomService',
        );
        return roms;
      }

      await for (var file in platformDir.list(recursive: true)) {
        // Only process files (not directories)
        if (file is File) {
          final fileName = path.basename(file.path);

          // Skip hidden files starting with _
          if (fileName.startsWith('_')) {
            _debug.debug('Skipping hidden file: $fileName', tag: 'RomService');
            continue;
          }

          final rom = Rom(
            name: fileName,
            fileName: fileName,
            platform: platformName,
            urlFilePath: file.path,
          );

          roms.add(rom);
        }
      }

      // Sort ROMs alphabetically
      roms.sort((a, b) => a.displayName.compareTo(b.displayName));

      _debug.info(
        'Loaded ${roms.length} ROMs for platform $platformName (including subdirectories)',
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

  Future<List<RomItem>> loadItemsInDirectory(String directoryPath) async {
    final List<RomItem> items = [];

    try {
      final dir = Directory(directoryPath);

      if (!await dir.exists()) {
        _debug.error(
          'Directory does not exist: $directoryPath',
          tag: 'RomService',
        );
        return items;
      }

      _debug.debug('Loading items from: $directoryPath', tag: 'RomService');
      int folderCount = 0;
      int romCount = 0;

      await for (var entity in dir.list()) {
        if (entity is Directory) {
          // Add folder (skip hidden folders starting with _)
          final folderName = path.basename(entity.path);
          if (!folderName.startsWith('_')) {
            items.add(
              RomItem(
                name: folderName,
                path: entity.path,
                type: RomItemType.folder,
              ),
            );
            folderCount++;
            _debug.debug('Found folder: $folderName', tag: 'RomService');
          } else {
            _debug.debug(
              'Skipping hidden folder: $folderName',
              tag: 'RomService',
            );
          }
        } else if (entity is File) {
          // Add all files as ROMs (no extension filter)
          final fileName = path.basename(entity.path);

          // Skip hidden files starting with _
          if (fileName.startsWith('_')) {
            _debug.debug('Skipping hidden file: $fileName', tag: 'RomService');
            continue;
          }

          // Try to load URL from ALL files
          // All files in ROM folders are text files containing download URLs
          String? downloadUrl = await _loadUrlFromFile(entity.path);

          items.add(
            RomItem(
              name: fileName,
              path: entity.path,
              type: RomItemType.rom,
              downloadUrl: downloadUrl,
            ),
          );
          romCount++;
          _debug.debug(
            'Found ROM: $fileName ${downloadUrl != null ? "with URL: $downloadUrl" : "(local file)"}',
            tag: 'RomService',
          );
        }
      }

      _debug.info(
        'Total items found: $folderCount folders, $romCount ROMs',
        tag: 'RomService',
      );

      // Sort: folders first, then ROMs, alphabetically within each group
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

        // If file is larger than 10KB, it's probably a real ROM file, not a URL
        if (stat.size > 10240) {
          return null; // It's a local ROM file
        }

        // Try to read as text
        final content = await file.readAsString();
        final trimmed = content.trim();

        // Check if it looks like a URL
        if (trimmed.startsWith('http://') ||
            trimmed.startsWith('https://') ||
            trimmed.startsWith('ftp://')) {
          return trimmed;
        }

        // If it doesn't look like a URL, treat as local file
        return null;
      }
    } catch (e) {
      // If we can't read as text, it's probably a binary ROM file
      _debug.debug(
        'Not a text file (probably local ROM): $filePath',
        tag: 'RomService',
      );
    }
    return null;
  }

  Future<Platform?> getPlatformByName(String platformName) async {
    final platforms = await loadPlatforms();
    try {
      return platforms.firstWhere(
        (p) => p.name.toLowerCase() == platformName.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
