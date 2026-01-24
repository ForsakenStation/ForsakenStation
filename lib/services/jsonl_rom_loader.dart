import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/rom.dart';
import 'debug_service.dart';

/// Service for loading ROMs from JSONL files (romLists format)
///
/// JSONL format:
/// - Each line is a JSON object
/// - type: "file" | "dir"
/// - p: full path (e.g., "- Aftermarket -/game.zip")
/// - n: display name (e.g., "Game Name (Region)")
/// - ext: file extension (e.g., ".zip")
/// - parent: parent directory name
/// - urls: array of URL objects with 'u' property
class JsonlRomLoader {
  final _debug = DebugService.instance;

  /// Load ROMs from a JSONL file for a specific platform
  ///
  /// [jsonlPath] - Path to the JSONL file (e.g., "path/to/nes.jsonl")
  /// [platform] - Platform name (e.g., "nes")
  ///
  /// Returns a list of Rom objects loaded from the JSONL file
  Future<List<Rom>> loadRomsFromJsonl(String jsonlPath, String platform) async {
    final roms = <Rom>[];

    try {
      final file = File(jsonlPath);

      if (!await file.exists()) {
        _debug.warning(
          'JSONL file not found: $jsonlPath',
          tag: 'JsonlRomLoader',
        );
        return roms;
      }

      _debug.info('Loading ROMs from JSONL: $jsonlPath', tag: 'JsonlRomLoader');

      // Read file line by line
      final lines = await file.readAsLines();
      int fileCount = 0;
      int dirCount = 0;

      for (final line in lines) {
        if (line.trim().isEmpty) continue;

        try {
          final json = jsonDecode(line) as Map<String, dynamic>;

          // Only process file entries (skip directories)
          if (json['type'] != 'file') {
            dirCount++;
            continue;
          }

          fileCount++;

          final name = json['n'] as String? ?? '';
          final filePath = json['p'] as String? ?? '';
          final parent = json['parent'] as String? ?? '';
          final urls = json['urls'] as List<dynamic>? ?? [];

          // Extract download URL from first URL entry
          String? downloadUrl;
          if (urls.isNotEmpty) {
            final firstUrl = urls[0] as Map<String, dynamic>;
            downloadUrl = firstUrl['u'] as String?;
          }

          // Skip if no URL available
          if (downloadUrl == null || downloadUrl.isEmpty) {
            continue;
          }

          // Create Rom object
          final rom = Rom(
            name: name,
            fileName: path.basename(filePath),
            platform: platform,
            urlFilePath: '', // Not used for JSONL ROMs
            downloadUrl: downloadUrl,
          );

          // Set parent directory as subdirectory if present
          if (parent.isNotEmpty && parent != '') {
            rom.subdirectory = parent;
          }

          roms.add(rom);
        } catch (e) {
          _debug.warning('Error parsing JSONL line: $e', tag: 'JsonlRomLoader');
          continue;
        }
      }

      _debug.info(
        'Loaded ${roms.length} ROMs from $jsonlPath ($fileCount files, $dirCount directories)',
        tag: 'JsonlRomLoader',
      );
    } catch (e) {
      _debug.error(
        'Error loading JSONL file: $jsonlPath',
        tag: 'JsonlRomLoader',
        error: e,
      );
    }

    return roms;
  }

  /// Load ROMs for all platforms from a directory containing JSONL files
  ///
  /// [jsonlDirectory] - Directory containing JSONL files
  ///
  /// Returns a map of platform name to list of ROMs
  Future<Map<String, List<Rom>>> loadAllPlatformsFromJsonl(
    String jsonlDirectory,
  ) async {
    final platformRoms = <String, List<Rom>>{};

    try {
      final dir = Directory(jsonlDirectory);

      if (!await dir.exists()) {
        _debug.warning(
          'JSONL directory not found: $jsonlDirectory',
          tag: 'JsonlRomLoader',
        );
        return platformRoms;
      }

      _debug.info(
        'Loading all platforms from JSONL directory: $jsonlDirectory',
        tag: 'JsonlRomLoader',
      );

      // Find all .jsonl files
      await for (final entity in dir.list()) {
        if (entity is File && entity.path.endsWith('.jsonl')) {
          final fileName = path.basenameWithoutExtension(entity.path);
          final roms = await loadRomsFromJsonl(entity.path, fileName);

          if (roms.isNotEmpty) {
            platformRoms[fileName] = roms;
          }
        }
      }

      _debug.info(
        'Loaded ${platformRoms.length} platforms from JSONL directory',
        tag: 'JsonlRomLoader',
      );
    } catch (e) {
      _debug.error(
        'Error loading platforms from JSONL directory: $jsonlDirectory',
        tag: 'JsonlRomLoader',
        error: e,
      );
    }

    return platformRoms;
  }

  /// Count ROMs in a JSONL file without loading them all into memory
  ///
  /// [jsonlPath] - Path to the JSONL file
  ///
  /// Returns the number of file entries (ROMs) in the JSONL
  Future<int> countRomsInJsonl(String jsonlPath) async {
    int romCount = 0;

    try {
      final file = File(jsonlPath);

      if (!await file.exists()) {
        return 0;
      }

      // Read file line by line
      final lines = await file.readAsLines();

      for (final line in lines) {
        if (line.trim().isEmpty) continue;

        try {
          final json = jsonDecode(line) as Map<String, dynamic>;

          // Only count file entries with valid URLs
          if (json['type'] == 'file') {
            final urls = json['urls'] as List<dynamic>? ?? [];
            if (urls.isNotEmpty) {
              final firstUrl = urls[0] as Map<String, dynamic>;
              final downloadUrl = firstUrl['u'] as String?;
              if (downloadUrl != null && downloadUrl.isNotEmpty) {
                romCount++;
              }
            }
          }
        } catch (e) {
          // Skip invalid lines
          continue;
        }
      }
    } catch (e) {
      _debug.error(
        'Error counting ROMs in JSONL: $jsonlPath',
        tag: 'JsonlRomLoader',
        error: e,
      );
    }

    return romCount;
  }

  /// Get platform names and ROM counts without loading all ROMs
  ///
  /// [jsonlDirectory] - Directory containing JSONL files
  ///
  /// Returns a map of platform name to ROM count
  Future<Map<String, int>> getPlatformRomCounts(String jsonlDirectory) async {
    final platformCounts = <String, int>{};

    try {
      final dir = Directory(jsonlDirectory);

      if (!await dir.exists()) {
        _debug.warning(
          'JSONL directory not found: $jsonlDirectory',
          tag: 'JsonlRomLoader',
        );
        return platformCounts;
      }

      _debug.info(
        'Counting ROMs for all platforms in: $jsonlDirectory',
        tag: 'JsonlRomLoader',
      );

      // Find all .jsonl files and count ROMs
      await for (final entity in dir.list()) {
        if (entity is File && entity.path.endsWith('.jsonl')) {
          final fileName = path.basenameWithoutExtension(entity.path);
          final count = await countRomsInJsonl(entity.path);

          if (count > 0) {
            platformCounts[fileName] = count;
          } else {
            _debug.warning(
              'Skipping platform "$fileName" - no ROMs with valid URLs found',
              tag: 'JsonlRomLoader',
            );
          }
        }
      }

      _debug.info(
        'Found ${platformCounts.length} platforms with total ${platformCounts.values.fold(0, (a, b) => a + b)} ROMs',
        tag: 'JsonlRomLoader',
      );
    } catch (e) {
      _debug.error(
        'Error getting platform ROM counts from: $jsonlDirectory',
        tag: 'JsonlRomLoader',
        error: e,
      );
    }

    return platformCounts;
  }

  /// Get list of available platforms from JSONL directory
  ///
  /// [jsonlDirectory] - Directory containing JSONL files
  ///
  /// Returns a list of platform names (without .jsonl extension)
  Future<List<String>> getAvailablePlatforms(String jsonlDirectory) async {
    final platforms = <String>[];

    try {
      final dir = Directory(jsonlDirectory);

      if (!await dir.exists()) {
        return platforms;
      }

      await for (final entity in dir.list()) {
        if (entity is File && entity.path.endsWith('.jsonl')) {
          final fileName = path.basenameWithoutExtension(entity.path);
          platforms.add(fileName);
        }
      }

      platforms.sort();
    } catch (e) {
      _debug.error(
        'Error getting available platforms from: $jsonlDirectory',
        tag: 'JsonlRomLoader',
        error: e,
      );
    }

    return platforms;
  }
}
