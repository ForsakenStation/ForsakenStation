import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:xml/xml.dart';
import 'config_service.dart';
import 'debug_service.dart';

/// Service that enriches gamelist.xml files with media path elements.
///
/// Scans the media directory for each game entry in a gamelist and adds
/// `media_*` elements with relative paths. This allows the app to skip
/// expensive filesystem scanning (~50 stat calls per ROM) when loading
/// media, by reading cached paths directly from the gamelist.
class GamelistMediaCacheService {
  final _debug = DebugService.instance;

  /// Media directory name → gamelist XML element name
  static const _mediaDirToXmlTag = {
    '3dboxes': 'media_box3d',
    'covers': 'media_cover',
    'marquees': 'media_marquee',
    'screenshots': 'media_screenshot',
    'miximages': 'media_miximage',
    'videos': 'media_video',
    'titlescreens': 'media_titlescreen',
    'manuals': 'media_manual',
    'backcovers': 'media_backcover',
    'fanart': 'media_fanart',
  };

  /// File extensions to check per media type
  static const _imageExtensions = ['png', 'jpg', 'jpeg', 'webp'];
  static const _videoExtensions = ['mp4', 'webm', 'mkv', 'avi'];
  static const _manualExtensions = ['png', 'jpg', 'jpeg', 'webp', 'pdf'];

  static const _extensionsByType = {
    '3dboxes': _imageExtensions,
    'covers': _imageExtensions,
    'marquees': _imageExtensions,
    'screenshots': _imageExtensions,
    'miximages': _imageExtensions,
    'titlescreens': _imageExtensions,
    'backcovers': _imageExtensions,
    'fanart': _imageExtensions,
    'videos': _videoExtensions,
    'manuals': _manualExtensions,
  };

  /// Progress callback: (currentPlatform, platformIndex, totalPlatforms)
  final void Function(String platform, int current, int total)?
  onPlatformProgress;

  /// Detailed progress callback: (currentPlatform, gamesProcessed, totalGames)
  final void Function(String platform, int current, int total)? onGameProgress;

  GamelistMediaCacheService({this.onPlatformProgress, this.onGameProgress});

  /// Rebuild media cache for all platforms.
  ///
  /// Returns a summary of the operation.
  Future<MediaCacheResult> rebuildAll() async {
    final config = ConfigService.instance;
    final gamelistBasePath = await config.gamelistPath;
    final mediaBasePath = config.mediaPath;

    final gamelistDir = Directory(gamelistBasePath);
    if (!await gamelistDir.exists()) {
      _debug.warning(
        'Gamelist directory does not exist: $gamelistBasePath',
        tag: 'GamelistMediaCache',
      );
      return MediaCacheResult(error: 'Gamelist directory not found');
    }

    // Find all platforms with gamelist.xml
    final platforms = <String>[];
    await for (final entity in gamelistDir.list()) {
      if (entity is Directory) {
        final gamelistFile = File(path.join(entity.path, 'gamelist.xml'));
        if (await gamelistFile.exists()) {
          platforms.add(path.basename(entity.path));
        }
      }
    }
    platforms.sort();

    _debug.info(
      'Rebuilding media cache for ${platforms.length} platforms',
      tag: 'GamelistMediaCache',
    );

    int totalGames = 0;
    int totalUpdated = 0;
    int totalMediaPaths = 0;
    int totalErrors = 0;

    for (int i = 0; i < platforms.length; i++) {
      final platform = platforms[i];
      onPlatformProgress?.call(platform, i + 1, platforms.length);

      final result = await _processPlatform(
        platform,
        gamelistBasePath,
        mediaBasePath,
      );

      totalGames += result.gamesTotal;
      totalUpdated += result.gamesUpdated;
      totalMediaPaths += result.mediaPathsAdded;
      totalErrors += result.errors;
    }

    _debug.info(
      'Media cache rebuild complete: '
      '$totalGames games, $totalUpdated updated, '
      '$totalMediaPaths media paths added',
      tag: 'GamelistMediaCache',
    );

    return MediaCacheResult(
      platformsProcessed: platforms.length,
      gamesTotal: totalGames,
      gamesUpdated: totalUpdated,
      mediaPathsAdded: totalMediaPaths,
      errors: totalErrors,
    );
  }

  /// Rebuild media cache for a single platform.
  Future<MediaCacheResult> rebuildForPlatform(String platform) async {
    final config = ConfigService.instance;
    final gamelistBasePath = await config.gamelistPath;
    final mediaBasePath = config.mediaPath;

    final result = await _processPlatform(
      platform,
      gamelistBasePath,
      mediaBasePath,
    );

    return MediaCacheResult(
      platformsProcessed: 1,
      gamesTotal: result.gamesTotal,
      gamesUpdated: result.gamesUpdated,
      mediaPathsAdded: result.mediaPathsAdded,
      errors: result.errors,
    );
  }

  Future<_PlatformResult> _processPlatform(
    String platform,
    String gamelistBasePath,
    String mediaBasePath,
  ) async {
    final gamelistPath = path.join(gamelistBasePath, platform, 'gamelist.xml');
    final gamelistFile = File(gamelistPath);

    if (!await gamelistFile.exists()) {
      _debug.warning(
        'Gamelist not found for $platform',
        tag: 'GamelistMediaCache',
      );
      return _PlatformResult();
    }

    try {
      final xmlContent = await gamelistFile.readAsString();
      final document = XmlDocument.parse(xmlContent);
      final gameElements = document.findAllElements('game').toList();

      int gamesUpdated = 0;
      int mediaPathsAdded = 0;
      bool modified = false;

      for (int g = 0; g < gameElements.length; g++) {
        final gameElem = gameElements[g];
        onGameProgress?.call(platform, g + 1, gameElements.length);

        final pathElem = gameElem.getElement('path');
        if (pathElem == null) continue;

        final gamePath = pathElem.innerText;
        final romName = _getRomNameFromPath(gamePath);
        final subdirectory = _getSubdirectoryFromPath(gamePath);
        bool gameModified = false;

        for (final entry in _mediaDirToXmlTag.entries) {
          final mediaType = entry.key;
          final xmlTag = entry.value;

          String mediaDir;
          if (subdirectory != null) {
            mediaDir = path.join(
              mediaBasePath,
              platform,
              mediaType,
              subdirectory,
            );
          } else {
            mediaDir = path.join(mediaBasePath, platform, mediaType);
          }

          final mediaFile = await _findMediaFile(mediaDir, romName, mediaType);

          if (mediaFile != null) {
            // Build relative path from media base
            final relPath = path.relative(mediaFile, from: mediaBasePath);
            final existingElem = gameElem.getElement(xmlTag);

            if (existingElem != null) {
              if (existingElem.innerText == relPath) {
                continue; // Already correct
              }
              // Update existing element
              existingElem.children.clear();
              existingElem.children.add(XmlText(relPath));
            } else {
              // Add new element
              gameElem.children.add(
                XmlElement(XmlName(xmlTag), [], [XmlText(relPath)]),
              );
            }
            mediaPathsAdded++;
            gameModified = true;
            modified = true;
          } else {
            // Remove stale media path if file no longer exists
            final existingElem = gameElem.getElement(xmlTag);
            if (existingElem != null) {
              gameElem.children.remove(existingElem);
              modified = true;
              gameModified = true;
            }
          }
        }

        if (gameModified) {
          gamesUpdated++;
        }
      }

      if (modified) {
        await gamelistFile.writeAsString(document.toXmlString(pretty: true));
        _debug.info(
          '$platform: $gamesUpdated games updated, '
          '$mediaPathsAdded media paths',
          tag: 'GamelistMediaCache',
        );
      }

      return _PlatformResult(
        gamesTotal: gameElements.length,
        gamesUpdated: gamesUpdated,
        mediaPathsAdded: mediaPathsAdded,
      );
    } catch (e) {
      _debug.error(
        'Failed to process $platform: $e',
        tag: 'GamelistMediaCache',
      );
      return _PlatformResult(errors: 1);
    }
  }

  /// Extract ROM name (without extension) from gamelist path.
  String _getRomNameFromPath(String gamePath) {
    var clean = gamePath;
    if (clean.startsWith('./')) {
      clean = clean.substring(2);
    }
    // Get filename without extension
    final fileName = path.basename(clean);
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex > 0) {
      return fileName.substring(0, dotIndex);
    }
    return fileName;
  }

  /// Extract subdirectory from gamelist path (null if no subdirectory).
  String? _getSubdirectoryFromPath(String gamePath) {
    var clean = gamePath;
    if (clean.startsWith('./')) {
      clean = clean.substring(2);
    }
    final parts = path.split(clean);
    if (parts.length > 1) {
      return path.joinAll(parts.sublist(0, parts.length - 1));
    }
    return null;
  }

  /// Find a media file for a ROM, checking common extensions.
  Future<String?> _findMediaFile(
    String mediaDir,
    String romName,
    String mediaType,
  ) async {
    final dir = Directory(mediaDir);
    if (!await dir.exists()) return null;

    final extensions = _extensionsByType[mediaType] ?? _imageExtensions;
    for (final ext in extensions) {
      final filePath = path.join(mediaDir, '$romName.$ext');
      if (await File(filePath).exists()) {
        return filePath;
      }
    }
    return null;
  }
}

/// Internal result for a single platform processing.
class _PlatformResult {
  final int gamesTotal;
  final int gamesUpdated;
  final int mediaPathsAdded;
  final int errors;

  _PlatformResult({
    this.gamesTotal = 0,
    this.gamesUpdated = 0,
    this.mediaPathsAdded = 0,
    this.errors = 0,
  });
}

/// Result of a media cache rebuild operation.
class MediaCacheResult {
  final int platformsProcessed;
  final int gamesTotal;
  final int gamesUpdated;
  final int mediaPathsAdded;
  final int errors;
  final String? error;

  MediaCacheResult({
    this.platformsProcessed = 0,
    this.gamesTotal = 0,
    this.gamesUpdated = 0,
    this.mediaPathsAdded = 0,
    this.errors = 0,
    this.error,
  });

  bool get hasError => error != null;
}
