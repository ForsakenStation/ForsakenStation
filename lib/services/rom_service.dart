import 'package:flutter/foundation.dart';
import '../models/emulator_platform.dart';
import '../models/rom.dart';
import '../models/rom_item.dart';
import '../platforms/web/web_core_manager.dart';
import 'debug_service.dart';
import 'jsonl_rom_loader.dart';

// Conditional import for IO-specific functionality
import 'rom_service_io.dart'
    if (dart.library.js_interop) 'rom_service_web.dart'
    as platform_service;

class RomService {
  final String romsBasePath;
  final String? jsonlBasePath;
  final _debug = DebugService.instance;
  final _jsonlLoader = JsonlRomLoader.instance;

  // Cache for loaded JSONL platform ROMs
  final Map<String, List<Rom>> _jsonlRomsCache = {};

  RomService({required this.romsBasePath, this.jsonlBasePath});

  Future<List<EmulatorPlatform>> loadPlatforms() async {
    // Always use JSONL loader (works on both web and desktop)
    if (jsonlBasePath != null && jsonlBasePath!.isNotEmpty) {
      return await loadPlatformsFromJsonl();
    }

    // Legacy file-based loader (desktop only)
    if (!kIsWeb) {
      return await platform_service.loadPlatformsFromFiles(romsBasePath);
    }

    return [];
  }

  /// Load platforms from JSONL files
  Future<List<EmulatorPlatform>> loadPlatformsFromJsonl() async {
    final List<EmulatorPlatform> platforms = [];

    try {
      _debug.info(
        'Loading platforms from JSONL directory: $jsonlBasePath',
        tag: 'RomService',
      );

      final platformCounts = await _jsonlLoader.getPlatformRomCounts(
        jsonlBasePath!,
      );

      for (final entry in platformCounts.entries) {
        final platformName = entry.key;
        final romCount = entry.value;

        if (romCount > 0) {
          // On web, only show platforms that have WASM core support
          if (kIsWeb && !WebCoreManager.instance.hasCoreSupport(platformName)) {
            _debug.debug(
              'Skipping platform $platformName (no web core support)',
              tag: 'RomService',
            );
            continue;
          }

          platforms.add(
            EmulatorPlatform(
              name: platformName,
              path: '',
              roms: [],
              romCount: romCount,
            ),
          );
        }
      }

      platforms.sort((a, b) => a.name.compareTo(b.name));

      _debug.info(
        'Loaded ${platforms.length} platforms from JSONL',
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

  /// Load ROMs for a specific platform (lazy loading)
  Future<List<Rom>> loadRomsForJsonlPlatform(String platformName) async {
    // Check cache first
    if (_jsonlRomsCache.containsKey(platformName)) {
      _debug.debug(
        'Using cached ROMs for platform: $platformName',
        tag: 'RomService',
      );
      return _jsonlRomsCache[platformName]!;
    }

    if (jsonlBasePath == null || jsonlBasePath!.isEmpty) {
      _debug.error('JSONL base path not set', tag: 'RomService');
      return [];
    }

    try {
      _debug.info(
        'Loading ROMs for platform: $platformName',
        tag: 'RomService',
      );

      // On web, jsonlBasePath is ignored - we fetch from GitHub
      final jsonlFile = kIsWeb
          ? platformName
          : '$jsonlBasePath/$platformName.jsonl';
      final roms = await _jsonlLoader.loadRomsFromJsonl(
        jsonlFile,
        platformName,
      );

      _jsonlRomsCache[platformName] = roms;

      _debug.info(
        'Loaded and cached ${roms.length} ROMs for platform: $platformName',
        tag: 'RomService',
      );

      return roms;
    } catch (e) {
      _debug.error(
        'Error loading ROMs for platform: $platformName',
        tag: 'RomService',
        error: e,
      );
      return [];
    }
  }

  void clearPlatformCache(String platformName) {
    _jsonlRomsCache.remove(platformName);
  }

  void clearAllCaches() {
    _jsonlRomsCache.clear();
  }

  /// Load ROMs for a platform from filesystem (desktop only)
  Future<List<Rom>> loadRomsForPlatform(
    String platformPath,
    String platformName,
  ) async {
    if (kIsWeb) {
      return loadRomsForJsonlPlatform(platformName);
    }
    return platform_service.loadRomsForPlatform(platformPath, platformName);
  }

  /// Load items (ROMs and folders) from EmulatorPlatform.roms list
  Future<List<RomItem>> loadItemsFromRoms(
    List<Rom> roms,
    String? currentSubdirectory,
    String platformName,
  ) async {
    final List<RomItem> items = [];

    try {
      final Map<String, List<Rom>> romsBySubdir = {};
      final List<Rom> romsInCurrentDir = [];

      for (final rom in roms) {
        final romSubdir = rom.subdirectory ?? '';

        if (currentSubdirectory == null) {
          if (romSubdir.isEmpty) {
            romsInCurrentDir.add(rom);
          } else {
            romsBySubdir.putIfAbsent(romSubdir, () => []).add(rom);
          }
        } else {
          if (romSubdir == currentSubdirectory) {
            romsInCurrentDir.add(rom);
          }
        }
      }

      // Add subdirectories as folders
      if (currentSubdirectory == null) {
        for (final subdirName in romsBySubdir.keys) {
          final romsInFolder = romsBySubdir[subdirName]!;
          items.add(
            RomItem(
              name: subdirName,
              path: subdirName,
              type: RomItemType.folder,
              romCount: romsInFolder.length,
              platform: platformName,
            ),
          );
        }
      }

      // Add ROMs
      for (final rom in romsInCurrentDir) {
        items.add(
          RomItem(
            name: rom.fileName,
            path: rom.fileName,
            type: RomItemType.rom,
            downloadUrl: rom.downloadUrl,
            platform: platformName,
            subdirectory: rom.subdirectory,
          ),
        );
      }

      // Sort: folders first, then ROMs (case-insensitive)
      items.sort((a, b) {
        if (a.isFolder && !b.isFolder) return -1;
        if (!a.isFolder && b.isFolder) return 1;
        return a.displayName.toLowerCase().compareTo(
          b.displayName.toLowerCase(),
        );
      });

      _debug.info(
        'Loaded ${items.where((i) => i.isFolder).length} folders, '
        '${items.where((i) => !i.isFolder).length} ROMs',
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

  /// Load items from filesystem directory (desktop only)
  Future<List<RomItem>> loadItemsInDirectory(
    String directoryPath,
    String platformName,
  ) async {
    if (kIsWeb) {
      // On web, we don't have filesystem access
      return [];
    }
    return platform_service.loadItemsInDirectory(directoryPath, platformName);
  }

  Future<EmulatorPlatform?> getPlatformByName(String platformName) async {
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
