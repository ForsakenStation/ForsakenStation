// IO implementation for JsonlRomLoader (desktop/mobile)
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/rom.dart';
import 'debug_service.dart';

final _debug = DebugService.instance;

/// Load ROMs from a JSONL file (IO implementation)
Future<List<Rom>> loadRomsFromJsonlIO(String jsonlPath, String platform) async {
  final roms = <Rom>[];

  try {
    final file = File(jsonlPath);

    if (!await file.exists()) {
      _debug.warning('JSONL file not found: $jsonlPath', tag: 'JsonlRomLoader');
      return roms;
    }

    _debug.info('Loading ROMs from JSONL: $jsonlPath', tag: 'JsonlRomLoader');

    final lines = await file.readAsLines();
    int fileCount = 0;
    int dirCount = 0;

    for (final line in lines) {
      if (line.trim().isEmpty) continue;

      try {
        final json = jsonDecode(line) as Map<String, dynamic>;

        if (json['type'] != 'file') {
          dirCount++;
          continue;
        }

        fileCount++;

        final name = json['n'] as String? ?? '';
        final filePath = json['p'] as String? ?? '';
        final parent = json['parent'] as String? ?? '';
        final urls = json['urls'] as List<dynamic>? ?? [];

        String? downloadUrl;
        if (urls.isNotEmpty) {
          final firstUrl = urls[0] as Map<String, dynamic>;
          downloadUrl = firstUrl['u'] as String?;
        }

        if (downloadUrl == null || downloadUrl.isEmpty) continue;

        final rom = Rom(
          name: name,
          fileName: path.basename(filePath),
          platform: platform,
          urlFilePath: '',
          downloadUrl: downloadUrl,
        );

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

/// Get platform ROM counts (IO implementation)
Future<Map<String, int>> getPlatformRomCountsIO(String jsonlDirectory) async {
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

    await for (final entity in dir.list()) {
      if (entity is File && entity.path.endsWith('.jsonl')) {
        final fileName = path.basenameWithoutExtension(entity.path);
        final count = await countRomsInJsonlIO(entity.path);

        if (count > 0) {
          platformCounts[fileName] = count;
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

/// Count ROMs in a JSONL file (IO implementation)
Future<int> countRomsInJsonlIO(String jsonlPath) async {
  int romCount = 0;

  try {
    final file = File(jsonlPath);

    if (!await file.exists()) {
      return 0;
    }

    final lines = await file.readAsLines();

    for (final line in lines) {
      if (line.trim().isEmpty) continue;

      try {
        final json = jsonDecode(line) as Map<String, dynamic>;

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
