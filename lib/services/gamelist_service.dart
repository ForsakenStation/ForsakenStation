import 'dart:io';
import 'package:xml/xml.dart';
import '../models/game_info.dart';
import 'debug_service.dart';

/// Service for loading and parsing gamelist.xml files
/// Structure: GAMELIST_PATH/platform/gamelist.xml
class GamelistService {
  final String gamelistBasePath;
  final DebugService _debugService = DebugService.instance;

  // Cache for loaded gamelists: platform -> Map<romPath, GameInfo>
  final Map<String, Map<String, GameInfo>> _gamelistCache = {};

  GamelistService({required this.gamelistBasePath});

  /// Loads gamelist.xml for a specific platform (lazy loading)
  /// Returns a map of ROM path -> GameInfo
  Future<Map<String, GameInfo>> _loadGamelistForPlatform(
    String platformName,
  ) async {
    // Check cache first
    if (_gamelistCache.containsKey(platformName)) {
      _debugService.info(
        'Gamelist for $platformName loaded from cache',
        tag: 'GamelistService',
      );
      return _gamelistCache[platformName]!;
    }

    final gamelistPath = '$gamelistBasePath/$platformName/gamelist.xml';
    final file = File(gamelistPath);

    if (!await file.exists()) {
      _debugService.warning(
        'Gamelist not found for $platformName at $gamelistPath',
        tag: 'GamelistService',
      );
      _gamelistCache[platformName] = {};
      return {};
    }

    try {
      _debugService.info(
        'Loading gamelist for $platformName from $gamelistPath',
        tag: 'GamelistService',
      );
      final xmlContent = await file.readAsString();
      final document = XmlDocument.parse(xmlContent);

      final games = <String, GameInfo>{};

      // Parse all <game> elements
      final gameElements = document.findAllElements('game');

      for (final gameElement in gameElements) {
        try {
          final gameData = <String, String?>{};

          // Extract all child elements
          for (final child in gameElement.children.whereType<XmlElement>()) {
            final tagName = child.name.local;
            final value = child.innerText.trim();
            if (value.isNotEmpty) {
              gameData[tagName] = value;
            }
          }

          // Create GameInfo from parsed data
          if (gameData.containsKey('path') && gameData.containsKey('name')) {
            final gameInfo = GameInfo.fromXml(gameData);

            // Normalize path for matching (remove ./ prefix, convert to lowercase)
            String normalizedPath = gameInfo.path.toLowerCase();
            if (normalizedPath.startsWith('./')) {
              normalizedPath = normalizedPath.substring(2);
            }

            games[normalizedPath] = gameInfo;
            _debugService.debug(
              'Loaded game info: ${gameInfo.name} ($normalizedPath)',
              tag: 'GamelistService',
            );
          }
        } catch (e) {
          _debugService.warning(
            'Failed to parse game element: $e',
            tag: 'GamelistService',
          );
        }
      }

      _debugService.info(
        'Loaded ${games.length} games from gamelist for $platformName',
        tag: 'GamelistService',
      );
      _gamelistCache[platformName] = games;
      return games;
    } catch (e) {
      _debugService.error(
        'Failed to parse gamelist for $platformName: $e',
        tag: 'GamelistService',
      );
      _gamelistCache[platformName] = {};
      return {};
    }
  }

  /// Gets game info for a specific ROM file (lazy loading)
  /// Matches ROM by filename (case-insensitive, ignores extension)
  Future<GameInfo?> getGameInfo(String platformName, String romPath) async {
    try {
      // Load gamelist for platform if not already loaded
      final gamelist = await _loadGamelistForPlatform(platformName);

      if (gamelist.isEmpty) {
        return null;
      }

      // Extract filename from romPath and normalize it
      String romFileName = romPath.split('/').last.toLowerCase();

      // Try exact match first
      if (gamelist.containsKey(romFileName)) {
        return gamelist[romFileName];
      }

      // Try matching without extension
      final nameWithoutExt = romFileName.split('.').first;

      // Search for match (case-insensitive, checks if gamelist path starts with ROM name)
      for (final entry in gamelist.entries) {
        final gamePathLower = entry.key;
        final gameNameWithoutExt = gamePathLower.split('.').first;

        if (gameNameWithoutExt == nameWithoutExt) {
          _debugService.debug(
            'Found game info for $romFileName: ${entry.value.name}',
            tag: 'GamelistService',
          );
          return entry.value;
        }
      }

      _debugService.debug(
        'No game info found for $romFileName in platform $platformName',
        tag: 'GamelistService',
      );
      return null;
    } catch (e) {
      _debugService.error(
        'Error getting game info for $romPath: $e',
        tag: 'GamelistService',
      );
      return null;
    }
  }

  /// Clears the cache for a specific platform or all platforms
  void clearCache([String? platformName]) {
    if (platformName != null) {
      _gamelistCache.remove(platformName);
      _debugService.info(
        'Cleared gamelist cache for $platformName',
        tag: 'GamelistService',
      );
    } else {
      _gamelistCache.clear();
      _debugService.info('Cleared all gamelist cache', tag: 'GamelistService');
    }
  }

  /// Gets the number of cached platforms
  int get cachedPlatformsCount => _gamelistCache.length;

  /// Gets the total number of cached games across all platforms
  int get cachedGamesCount {
    return _gamelistCache.values.fold(0, (sum, map) => sum + map.length);
  }
}
