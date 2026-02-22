import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/rom.dart';
import 'debug_service.dart';

// Conditional import for dart:io
import 'jsonl_rom_loader_io.dart'
    if (dart.library.js_interop) 'jsonl_rom_loader_web.dart'
    as platform_loader;

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
  static JsonlRomLoader? _instance;
  final _debug = DebugService.instance;

  // GitHub raw URL base for romList repository
  static const String _githubRawBase =
      'https://raw.githubusercontent.com/ForsakenStation/romList/main/';

  // Cache for web platform (platform name -> JSONL content)
  final Map<String, String> _webJsonlCache = {};

  // Cache for platform ROM counts
  final Map<String, int> _platformCountsCache = {};

  JsonlRomLoader._();

  static JsonlRomLoader get instance {
    _instance ??= JsonlRomLoader._();
    return _instance!;
  }

  /// Load ROMs from a JSONL file for a specific platform
  Future<List<Rom>> loadRomsFromJsonl(String jsonlPath, String platform) async {
    if (kIsWeb) {
      return _loadRomsFromJsonlWeb(platform);
    } else {
      return platform_loader.loadRomsFromJsonlIO(jsonlPath, platform);
    }
  }

  /// Web implementation - load JSONL from GitHub
  Future<List<Rom>> _loadRomsFromJsonlWeb(String platform) async {
    final roms = <Rom>[];

    try {
      // Check cache first
      String? jsonlContent = _webJsonlCache[platform];

      if (jsonlContent == null) {
        // Fetch from GitHub
        final url = '$_githubRawBase$platform.jsonl';
        _debug.info('Fetching JSONL from: $url', tag: 'JsonlRomLoader');

        final response = await http.get(Uri.parse(url));

        if (response.statusCode != 200) {
          _debug.warning(
            'Failed to fetch JSONL for $platform: HTTP ${response.statusCode}',
            tag: 'JsonlRomLoader',
          );
          return roms;
        }

        jsonlContent = response.body;
        _webJsonlCache[platform] = jsonlContent;
      }

      // Parse JSONL content
      final lines = jsonlContent.split('\n');

      for (final line in lines) {
        if (line.trim().isEmpty) continue;

        try {
          final json = jsonDecode(line) as Map<String, dynamic>;

          if (json['type'] != 'file') continue;

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
            fileName: filePath.split('/').last,
            platform: platform,
            urlFilePath: '',
            downloadUrl: downloadUrl,
          );

          if (parent.isNotEmpty) {
            rom.subdirectory = parent;
          }

          roms.add(rom);
        } catch (e) {
          continue;
        }
      }

      _debug.info(
        'Loaded ${roms.length} ROMs for platform: $platform (web)',
        tag: 'JsonlRomLoader',
      );
    } catch (e) {
      _debug.error(
        'Error loading JSONL for platform: $platform',
        tag: 'JsonlRomLoader',
        error: e,
      );
    }

    return roms;
  }

  /// Get platform ROM counts
  Future<Map<String, int>> getPlatformRomCounts(String jsonlDirectory) async {
    if (kIsWeb) {
      return _getPlatformRomCountsWeb();
    } else {
      return platform_loader.getPlatformRomCountsIO(jsonlDirectory);
    }
  }

  /// Web implementation - get platform counts from GitHub index
  Future<Map<String, int>> _getPlatformRomCountsWeb() async {
    // Return cached counts if available
    if (_platformCountsCache.isNotEmpty) {
      return Map.from(_platformCountsCache);
    }

    final platformCounts = <String, int>{};

    try {
      // First try to fetch a pre-computed index file with counts
      final countsUrl = '${_githubRawBase}platform_counts.json';
      _debug.info(
        'Fetching platform counts from: $countsUrl',
        tag: 'JsonlRomLoader',
      );

      final countsResponse = await http.get(Uri.parse(countsUrl));

      if (countsResponse.statusCode == 200) {
        // Parse the counts file
        final countsJson =
            jsonDecode(countsResponse.body) as Map<String, dynamic>;
        for (final entry in countsJson.entries) {
          platformCounts[entry.key] = entry.value as int;
        }
        _platformCountsCache.addAll(platformCounts);
        _debug.info(
          'Loaded ${platformCounts.length} platform counts from index',
          tag: 'JsonlRomLoader',
        );
        return platformCounts;
      }

      // Fallback: fetch platforms.txt and count ROMs by loading each JSONL
      final indexUrl = '${_githubRawBase}platforms.txt';
      _debug.info(
        'Fetching platforms index from: $indexUrl',
        tag: 'JsonlRomLoader',
      );

      final response = await http.get(Uri.parse(indexUrl));

      List<String> platforms;
      if (response.statusCode == 200) {
        platforms = response.body
            .split('\n')
            .map((p) => p.trim())
            .where((p) => p.isNotEmpty)
            .toList();
      } else {
        // Fallback: load list from local assets
        _debug.warning(
          'Could not fetch platforms index, using fallback from assets',
          tag: 'JsonlRomLoader',
        );
        try {
          final jsonStr = await rootBundle.loadString(
            'assets/data/platforms.json',
          );
          platforms = List<String>.from(jsonDecode(jsonStr));
        } catch (e) {
          _debug.error(
            'Failed to load fallback platforms: $e',
            tag: 'JsonlRomLoader',
          );
          platforms = [];
        }
      }

      // Count ROMs for each platform by fetching the JSONL
      // This is slower but gives accurate counts
      for (final platform in platforms) {
        final count = await _countRomsInJsonlWeb(platform);
        if (count > 0) {
          platformCounts[platform] = count;
        }
      }

      _platformCountsCache.addAll(platformCounts);

      _debug.info(
        'Found ${platformCounts.length} platforms with ROMs (web)',
        tag: 'JsonlRomLoader',
      );
    } catch (e) {
      _debug.error(
        'Error getting platform counts (web)',
        tag: 'JsonlRomLoader',
        error: e,
      );
    }

    return platformCounts;
  }

  /// Count ROMs in a JSONL file from web
  Future<int> _countRomsInJsonlWeb(String platform) async {
    try {
      final url = '$_githubRawBase$platform.jsonl';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        return 0;
      }

      final lines = response.body.split('\n');
      int count = 0;

      for (final line in lines) {
        if (line.trim().isEmpty) continue;

        try {
          final json = jsonDecode(line) as Map<String, dynamic>;
          if (json['type'] == 'file') {
            final urls = json['urls'] as List<dynamic>? ?? [];
            if (urls.isNotEmpty) {
              count++;
            }
          }
        } catch (e) {
          continue;
        }
      }

      // Cache the content for later use
      _webJsonlCache[platform] = response.body;

      return count;
    } catch (e) {
      return 0;
    }
  }

  /// Count ROMs in a JSONL file
  Future<int> countRomsInJsonl(String jsonlPath) async {
    if (kIsWeb) {
      // For web, we count when loading
      return 0;
    } else {
      return platform_loader.countRomsInJsonlIO(jsonlPath);
    }
  }

  /// Clear web caches
  void clearWebCache() {
    _webJsonlCache.clear();
    _platformCountsCache.clear();
  }
}
