import '../services/debug_service.dart';
import '../services/gamelist_service.dart';
import '../models/game_info.dart';
import 'dart:io';
import 'language_info.dart';
import 'region_info.dart';
import 'rom_tags.dart';

enum RomItemType { folder, rom }

class RomItem {
  final String name;
  final String path;
  final RomItemType type;
  final String? downloadUrl;
  final int? romCount; // Number of ROMs inside folder (only for folders)
  final String? platform; // Platform name (for collection views)
  final String? subdirectory; // Subdirectory path for media lookup

  // Cached extracted info from filename
  LanguageInfo? _languages;
  RegionInfo? _regions;
  RomTags? _tags;

  // GameList integration
  GameInfo? _gameInfo;
  String? _cachedDisplayName;

  RomItem({
    required this.name,
    required this.path,
    required this.type,
    this.downloadUrl,
    this.romCount,
    this.platform,
    this.subdirectory,
  });

  String get displayName {
    // Folders: return raw name without cleaning
    if (isFolder) {
      return name;
    }

    // Return cached display name if available
    if (_cachedDisplayName != null) {
      return _cachedDisplayName!;
    }

    // If we have GameList info, use that name
    if (_gameInfo != null) {
      _cachedDisplayName = _gameInfo!.name;
      return _cachedDisplayName!;
    }

    // Fallback to processed filename (remove extension, replace underscores, remove tags)
    return getCleanFilename();
  }

  /// Gets display name from GameList if available, otherwise from clean filename
  /// This is async because it might need to load GameList data
  Future<String> getDisplayNameAsync(GamelistService? gamelistService) async {
    // Return cached if available
    if (_cachedDisplayName != null) {
      return _cachedDisplayName!;
    }

    // Try to get GameList info if we have the service and platform
    if (gamelistService != null && platform != null && isRom) {
      try {
        _gameInfo = await gamelistService.getGameInfo(platform!, name);
        if (_gameInfo != null) {
          _cachedDisplayName = _gameInfo!.name;
          return _cachedDisplayName!;
        }
      } catch (e) {
        // If GameList lookup fails, continue to fallback
        DebugService.instance.warning(
          'Failed to get GameList info for $name: $e',
          tag: 'RomItem',
        );
      }
    }

    // Fallback to clean filename
    _cachedDisplayName = getCleanFilename();
    return _cachedDisplayName!;
  }

  /// Gets clean filename without extension, underscores, and ROM tags
  String getCleanFilename() {
    // Remove extension
    String cleanName = name.substring(
      0,
      name.lastIndexOf('.') > 0 ? name.lastIndexOf('.') : name.length,
    );

    // Replace underscores with spaces
    cleanName = cleanName.replaceAll('_', ' ');

    // Remove ROM tags (anything in parentheses or brackets)
    cleanName = cleanName.replaceAll(RegExp(r'\s*\([^)]*\)\s*'), ' ');
    cleanName = cleanName.replaceAll(RegExp(r'\s*\[[^\]]*\]\s*'), ' ');

    // Clean up extra spaces
    cleanName = cleanName.replaceAll(RegExp(r'\s+'), ' ').trim();

    return cleanName;
  }

  /// Sets GameList info (used when loading from GameList)
  void setGameInfo(GameInfo gameInfo) {
    _gameInfo = gameInfo;
    _cachedDisplayName = gameInfo.name;
  }

  /// Gets the GameList info if available
  GameInfo? get gameInfo => _gameInfo;

  bool get isFolder => type == RomItemType.folder;

  bool get isRom => type == RomItemType.rom;

  /// Extract language info from ROM filename
  /// Caches result for performance
  LanguageInfo? get languages {
    if (_languages == null && isRom) {
      _languages = LanguageInfo.fromRomName(name);
    }
    return _languages;
  }

  /// Extract region info from ROM filename
  /// Caches result for performance
  RegionInfo? get regions {
    if (_regions == null && isRom) {
      _regions = RegionInfo.fromRomName(name);
    }
    return _regions;
  }

  /// Extract ROM tags from filename
  /// Caches result for performance
  RomTags? get tags {
    if (_tags == null && isRom) {
      _tags = RomTags.fromRomName(name);
    }
    return _tags;
  }

  Future<String?> loadDownloadUrl() async {
    if (type != RomItemType.rom) return null;

    try {
      final file = File(path);
      if (await file.exists()) {
        final content = await file.readAsString();
        return content.trim();
      }
    } catch (e) {
      DebugService.instance.error(
        'Error loading download URL for $name',
        tag: 'RomItem',
        error: e,
      );
    }
    return null;
  }

  @override
  String toString() {
    return 'RomItem(name: $displayName, type: $type)';
  }
}
