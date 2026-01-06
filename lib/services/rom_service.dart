import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/platform.dart';
import '../models/rom.dart';
import '../models/rom_item.dart';
import 'debug_service.dart';
import 'jsonl_rom_loader.dart';

class RomService {
  final String romsBasePath;
  final String? jsonlBasePath; // Optional path to JSONL files directory
  final _debug = DebugService.instance;
  final _jsonlLoader = JsonlRomLoader();

  // Cache for loaded JSONL platform ROMs (platform name -> List<Rom>)
  final Map<String, List<Rom>> _jsonlRomsCache = {};

  RomService({required this.romsBasePath, this.jsonlBasePath});

  Future<List<Platform>> loadPlatforms() async {
    // If JSONL path is provided, use JSONL loader
    if (jsonlBasePath != null && jsonlBasePath!.isNotEmpty) {
      return await loadPlatformsFromJsonl();
    }

    // Otherwise, use legacy file-based loader
    return await loadPlatformsFromFiles();
  }

  /// Load platforms from JSONL files (lazy loading - only loads ROM counts)
  Future<List<Platform>> loadPlatformsFromJsonl() async {
    final List<Platform> platforms = [];

    try {
      _debug.info(
        'Loading platforms from JSONL directory: $jsonlBasePath',
        tag: 'RomService',
      );

      // Get ROM counts for all platforms (without loading all ROMs)
      final platformCounts = await _jsonlLoader.getPlatformRomCounts(
        jsonlBasePath!,
      );

      // Convert to Platform objects (without loading ROM data)
      for (final entry in platformCounts.entries) {
        final platformName = entry.key;
        final romCount = entry.value;

        if (romCount > 0) {
          platforms.add(
            Platform(
              name: platformName,
              path: '', // Not used for JSONL platforms
              roms: [], // Empty - ROMs will be lazy-loaded when needed
              romCount: romCount, // Pre-calculated count
            ),
          );
        }
      }

      // Sort platforms alphabetically
      platforms.sort((a, b) => a.name.compareTo(b.name));

      _debug.info(
        'Loaded ${platforms.length} platforms from JSONL (lazy loading enabled)',
        tag: 'RomService',
      );
    } catch (e) {
      _debug.error(
        'Error loading platforms from JSONL',
        tag: 'RomService',
        error: e,
      );
    }

    return platforms;
  }

  /// Load ROMs for a specific JSONL platform (lazy loading)
  ///
  /// This is called when the user enters a platform screen
  /// ROMs are cached after first load
  Future<List<Rom>> loadRomsForJsonlPlatform(String platformName) async {
    // Check cache first
    if (_jsonlRomsCache.containsKey(platformName)) {
      _debug.debug(
        'Using cached ROMs for platform: $platformName',
        tag: 'RomService',
      );
      return _jsonlRomsCache[platformName]!;
    }

    // Load from JSONL file
    if (jsonlBasePath == null || jsonlBasePath!.isEmpty) {
      _debug.error(
        'JSONL base path not set, cannot load platform: $platformName',
        tag: 'RomService',
      );
      return [];
    }

    try {
      _debug.info(
        'Loading ROMs for platform: $platformName',
        tag: 'RomService',
      );

      final jsonlFile = path.join(jsonlBasePath!, '$platformName.jsonl');
      final roms = await _jsonlLoader.loadRomsFromJsonl(
        jsonlFile,
        platformName,
      );

      // Cache the loaded ROMs
      _jsonlRomsCache[platformName] = roms;

      _debug.info(
        'Loaded and cached ${roms.length} ROMs for platform: $platformName',
        tag: 'RomService',
      );

      return roms;
    } catch (e) {
      _debug.error(
        'Error loading ROMs for JSONL platform: $platformName',
        tag: 'RomService',
        error: e,
      );
      return [];
    }
  }

  /// Clear the JSONL ROMs cache for a specific platform
  /// This can be called when leaving a platform to free up memory
  void clearPlatformCache(String platformName) {
    if (_jsonlRomsCache.containsKey(platformName)) {
      _debug.debug(
        'Clearing cache for platform: $platformName',
        tag: 'RomService',
      );
      _jsonlRomsCache.remove(platformName);
    }
  }

  /// Clear all JSONL ROMs caches
  void clearAllCaches() {
    _debug.debug('Clearing all platform caches', tag: 'RomService');
    _jsonlRomsCache.clear();
  }

  /// Load platforms from directory structure (legacy method)
  Future<List<Platform>> loadPlatformsFromFiles() async {
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

  /// Load items (ROMs and folders) from Platform.roms list
  /// Used for JSONL-based platforms
  Future<List<RomItem>> loadItemsFromRoms(
    List<Rom> roms,
    String? currentSubdirectory,
  ) async {
    final List<RomItem> items = [];

    try {
      // Group ROMs by subdirectory
      final Map<String, List<Rom>> romsBySubdir = {};
      final List<Rom> romsInCurrentDir = [];

      for (final rom in roms) {
        final romSubdir = rom.subdirectory ?? '';

        // If we're at root level (currentSubdirectory is null)
        if (currentSubdirectory == null) {
          if (romSubdir.isEmpty) {
            // ROM is at root level
            romsInCurrentDir.add(rom);
          } else {
            // ROM is in a subdirectory - group them
            romsBySubdir.putIfAbsent(romSubdir, () => []).add(rom);
          }
        } else {
          // We're inside a subdirectory
          if (romSubdir == currentSubdirectory) {
            romsInCurrentDir.add(rom);
          }
        }
      }

      // Add subdirectories as folders (only at root level)
      if (currentSubdirectory == null) {
        for (final subdirName in romsBySubdir.keys) {
          items.add(
            RomItem(
              name: subdirName,
              path: subdirName, // Use subdirectory name as path
              type: RomItemType.folder,
            ),
          );
        }
      }

      // Add ROMs in current directory
      for (final rom in romsInCurrentDir) {
        items.add(
          RomItem(
            name: rom.fileName, // Use fileName to preserve extension
            path: rom.urlFilePath, // For JSONL, this is just the name
            type: RomItemType.rom,
            downloadUrl: rom.downloadUrl,
          ),
        );
      }

      // Sort: folders first, then ROMs, alphabetically within each group
      items.sort((a, b) {
        if (a.isFolder && !b.isFolder) return -1;
        if (!a.isFolder && b.isFolder) return 1;
        return a.displayName.compareTo(b.displayName);
      });

      _debug.info(
        'Loaded ${items.where((i) => i.isFolder).length} folders, '
        '${items.where((i) => !i.isFolder).length} ROMs '
        '${currentSubdirectory != null ? "in subdirectory: $currentSubdirectory" : "at root"}',
        tag: 'RomService',
      );
    } catch (e) {
      _debug.error(
        'Error loading items from ROMs list',
        tag: 'RomService',
        error: e,
      );
    }

    return items;
  }

  /// Load items from filesystem directory (legacy method)
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
