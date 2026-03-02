import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as path;
import '../models/game_info.dart';
import '../models/media.dart';
import '../models/rom.dart';
import '../models/rom_item.dart';
import '../utils/file_utils.dart';
import 'config_service.dart';
import 'debug_service.dart';

class MediaService {
  static MediaService? _instance;
  final _debug = DebugService.instance;

  MediaService._();

  static MediaService get instance {
    _instance ??= MediaService._();
    return _instance!;
  }

  String get mediaBasePath => ConfigService.instance.mediaPath;

  Future<RomMedia> getMediaForRom(Rom rom) async {
    final romNameWithoutExt = rom.displayName;
    final subdirectory = rom.subdirectory;

    final romMedia = RomMedia(
      romName: romNameWithoutExt,
      platform: rom.platform,
    );

    // Check for all media types
    romMedia.box3d = await _findMedia(
      rom.platform,
      romNameWithoutExt,
      MediaType.box3d,
      subdirectory: subdirectory,
    );
    romMedia.cover = await _findMedia(
      rom.platform,
      romNameWithoutExt,
      MediaType.cover,
      subdirectory: subdirectory,
    );
    romMedia.marquee = await _findMedia(
      rom.platform,
      romNameWithoutExt,
      MediaType.marquee,
      subdirectory: subdirectory,
    );
    romMedia.screenshot = await _findMedia(
      rom.platform,
      romNameWithoutExt,
      MediaType.screenshot,
      subdirectory: subdirectory,
    );
    romMedia.mixImage = await _findMedia(
      rom.platform,
      romNameWithoutExt,
      MediaType.mixImage,
      subdirectory: subdirectory,
    );
    romMedia.video = await _findMedia(
      rom.platform,
      romNameWithoutExt,
      MediaType.video,
      subdirectory: subdirectory,
    );
    romMedia.titlescreen = await _findMedia(
      rom.platform,
      romNameWithoutExt,
      MediaType.titlescreen,
      subdirectory: subdirectory,
    );
    romMedia.manual = await _findMedia(
      rom.platform,
      romNameWithoutExt,
      MediaType.manual,
      subdirectory: subdirectory,
    );
    romMedia.backcover = await _findMedia(
      rom.platform,
      romNameWithoutExt,
      MediaType.backcover,
      subdirectory: subdirectory,
    );
    romMedia.fanart = await _findMedia(
      rom.platform,
      romNameWithoutExt,
      MediaType.fanart,
      subdirectory: subdirectory,
    );

    return romMedia;
  }

  Future<RomMedia> getMediaForRomItem(
    RomItem romItem,
    String platformName, {
    GameInfo? gameInfo,
  }) async {
    // Fast path: if GameInfo has cached media paths, use them directly
    // This avoids up to 50 filesystem stat calls per ROM
    if (gameInfo != null && gameInfo.hasMediaPaths) {
      _debug.info(
        'Using cached media paths for ${romItem.name}',
        tag: 'MediaService',
      );
      return _buildMediaFromGameInfo(romItem, platformName, gameInfo);
    }

    // Slow path: filesystem scanning (fallback when gamelist has no media info)
    return _findMediaByFilesystemScan(romItem, platformName);
  }

  /// Build RomMedia from cached paths in GameInfo (no filesystem calls)
  RomMedia _buildMediaFromGameInfo(
    RomItem romItem,
    String platformName,
    GameInfo gameInfo,
  ) {
    final romNameWithoutExt = _getRomNameWithoutExtension(romItem.name);

    final romMedia = RomMedia(
      romName: romNameWithoutExt,
      platform: platformName,
    );

    if (gameInfo.box3dPath != null) {
      romMedia.box3d = Media(
        romName: romNameWithoutExt,
        platform: platformName,
        type: MediaType.box3d,
        path: path.join(mediaBasePath, gameInfo.box3dPath!),
        existsVerified: true,
      );
    }
    if (gameInfo.coverPath != null) {
      romMedia.cover = Media(
        romName: romNameWithoutExt,
        platform: platformName,
        type: MediaType.cover,
        path: path.join(mediaBasePath, gameInfo.coverPath!),
        existsVerified: true,
      );
    }
    if (gameInfo.marqueePath != null) {
      romMedia.marquee = Media(
        romName: romNameWithoutExt,
        platform: platformName,
        type: MediaType.marquee,
        path: path.join(mediaBasePath, gameInfo.marqueePath!),
        existsVerified: true,
      );
    }
    if (gameInfo.screenshotPath != null) {
      romMedia.screenshot = Media(
        romName: romNameWithoutExt,
        platform: platformName,
        type: MediaType.screenshot,
        path: path.join(mediaBasePath, gameInfo.screenshotPath!),
        existsVerified: true,
      );
    }
    if (gameInfo.mixImagePath != null) {
      romMedia.mixImage = Media(
        romName: romNameWithoutExt,
        platform: platformName,
        type: MediaType.mixImage,
        path: path.join(mediaBasePath, gameInfo.mixImagePath!),
        existsVerified: true,
      );
    }
    if (gameInfo.videoPath != null) {
      romMedia.video = Media(
        romName: romNameWithoutExt,
        platform: platformName,
        type: MediaType.video,
        path: path.join(mediaBasePath, gameInfo.videoPath!),
        existsVerified: true,
      );
    }
    if (gameInfo.titlescreenPath != null) {
      romMedia.titlescreen = Media(
        romName: romNameWithoutExt,
        platform: platformName,
        type: MediaType.titlescreen,
        path: path.join(mediaBasePath, gameInfo.titlescreenPath!),
        existsVerified: true,
      );
    }
    if (gameInfo.manualPath != null) {
      romMedia.manual = Media(
        romName: romNameWithoutExt,
        platform: platformName,
        type: MediaType.manual,
        path: path.join(mediaBasePath, gameInfo.manualPath!),
        existsVerified: true,
      );
    }
    if (gameInfo.backcoverPath != null) {
      romMedia.backcover = Media(
        romName: romNameWithoutExt,
        platform: platformName,
        type: MediaType.backcover,
        path: path.join(mediaBasePath, gameInfo.backcoverPath!),
        existsVerified: true,
      );
    }
    if (gameInfo.fanartPath != null) {
      romMedia.fanart = Media(
        romName: romNameWithoutExt,
        platform: platformName,
        type: MediaType.fanart,
        path: path.join(mediaBasePath, gameInfo.fanartPath!),
        existsVerified: true,
      );
    }

    _debug.info(
      'Built media from cache: ${romMedia.allMedia.length} items for ${romItem.name}',
      tag: 'MediaService',
    );

    return romMedia;
  }

  /// Filesystem scanning fallback for media discovery
  Future<RomMedia> _findMediaByFilesystemScan(
    RomItem romItem,
    String platformName,
  ) async {
    // Get ROM name without extension for matching media files
    final romNameWithoutExt = _getRomNameWithoutExtension(romItem.name);
    final subdirectory = romItem.subdirectory;

    _debug.debug('Loading media for ROM: ${romItem.name}', tag: 'MediaService');
    _debug.debug(
      'ROM name without extension: $romNameWithoutExt',
      tag: 'MediaService',
    );
    _debug.debug('Platform: $platformName', tag: 'MediaService');
    _debug.debug('Subdirectory: $subdirectory', tag: 'MediaService');
    _debug.debug('Media base path: $mediaBasePath', tag: 'MediaService');

    final romMedia = RomMedia(
      romName: romNameWithoutExt,
      platform: platformName,
    );

    // Check for all media types with subdirectory support
    romMedia.box3d = await _findMedia(
      platformName,
      romNameWithoutExt,
      MediaType.box3d,
      subdirectory: subdirectory,
    );
    if (romMedia.box3d != null) {
      _debug.debug(
        'Found 3D box: ${romMedia.box3d!.path}',
        tag: 'MediaService',
      );
    }

    romMedia.cover = await _findMedia(
      platformName,
      romNameWithoutExt,
      MediaType.cover,
      subdirectory: subdirectory,
    );
    if (romMedia.cover != null) {
      _debug.debug('Found cover: ${romMedia.cover!.path}', tag: 'MediaService');
    }

    romMedia.marquee = await _findMedia(
      platformName,
      romNameWithoutExt,
      MediaType.marquee,
      subdirectory: subdirectory,
    );
    if (romMedia.marquee != null) {
      _debug.debug(
        'Found marquee: ${romMedia.marquee!.path}',
        tag: 'MediaService',
      );
    }

    romMedia.screenshot = await _findMedia(
      platformName,
      romNameWithoutExt,
      MediaType.screenshot,
      subdirectory: subdirectory,
    );
    if (romMedia.screenshot != null) {
      _debug.debug(
        'Found screenshot: ${romMedia.screenshot!.path}',
        tag: 'MediaService',
      );
    }

    romMedia.mixImage = await _findMedia(
      platformName,
      romNameWithoutExt,
      MediaType.mixImage,
      subdirectory: subdirectory,
    );
    if (romMedia.mixImage != null) {
      _debug.debug(
        'Found mix image: ${romMedia.mixImage!.path}',
        tag: 'MediaService',
      );
    }

    romMedia.video = await _findMedia(
      platformName,
      romNameWithoutExt,
      MediaType.video,
      subdirectory: subdirectory,
    );
    if (romMedia.video != null) {
      _debug.debug('Found video: ${romMedia.video!.path}', tag: 'MediaService');
    }

    romMedia.titlescreen = await _findMedia(
      platformName,
      romNameWithoutExt,
      MediaType.titlescreen,
      subdirectory: subdirectory,
    );
    if (romMedia.titlescreen != null) {
      _debug.debug(
        'Found titlescreen: ${romMedia.titlescreen!.path}',
        tag: 'MediaService',
      );
    }

    romMedia.manual = await _findMedia(
      platformName,
      romNameWithoutExt,
      MediaType.manual,
      subdirectory: subdirectory,
    );
    if (romMedia.manual != null) {
      _debug.debug(
        'Found manual: ${romMedia.manual!.path}',
        tag: 'MediaService',
      );
    }

    romMedia.backcover = await _findMedia(
      platformName,
      romNameWithoutExt,
      MediaType.backcover,
      subdirectory: subdirectory,
    );
    if (romMedia.backcover != null) {
      _debug.debug(
        'Found backcover: ${romMedia.backcover!.path}',
        tag: 'MediaService',
      );
    }

    romMedia.fanart = await _findMedia(
      platformName,
      romNameWithoutExt,
      MediaType.fanart,
      subdirectory: subdirectory,
    );
    if (romMedia.fanart != null) {
      _debug.debug(
        'Found fanart: ${romMedia.fanart!.path}',
        tag: 'MediaService',
      );
    }

    _debug.info(
      'Total media found: ${romMedia.allMedia.length}',
      tag: 'MediaService',
    );

    return romMedia;
  }

  String _getRomNameWithoutExtension(String fileName) {
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex == -1) {
      // No extension found, return the whole filename
      return fileName;
    }
    return fileName.substring(0, dotIndex);
  }

  Future<Media?> _findMedia(
    String platform,
    String romName,
    MediaType type, {
    String? subdirectory,
  }) async {
    final mediaTypePath = _getMediaTypePath(type);

    // Build path including subdirectory if present
    String platformMediaPath;
    if (subdirectory != null && subdirectory.isNotEmpty) {
      platformMediaPath = path.join(
        mediaBasePath,
        platform,
        mediaTypePath,
        subdirectory,
      );
    } else {
      platformMediaPath = path.join(mediaBasePath, platform, mediaTypePath);
    }

    _debug.debug(
      'Looking for ${type.name} in: $platformMediaPath',
      tag: 'MediaService',
    );

    if (!await directoryExists(platformMediaPath)) {
      _debug.debug(
        'Directory does not exist: $platformMediaPath',
        tag: 'MediaService',
      );
      return null;
    }

    // Try common extensions
    final extensions = _getExtensionsForType(type);

    for (var ext in extensions) {
      final mediaPath = path.join(platformMediaPath, '$romName.$ext');

      _debug.debug('Checking: $mediaPath', tag: 'MediaService');
      if (await fileExists(mediaPath)) {
        _debug.debug('Found media file: $mediaPath', tag: 'MediaService');
        return Media(
          romName: romName,
          platform: platform,
          type: type,
          path: mediaPath,
          existsVerified: true,
        );
      }
    }

    _debug.debug('No ${type.name} found for $romName', tag: 'MediaService');
    return null;
  }

  String _getMediaTypePath(MediaType type) {
    switch (type) {
      case MediaType.box3d:
        return '3dboxes';
      case MediaType.cover:
        return 'covers';
      case MediaType.marquee:
        return 'marquee';
      case MediaType.screenshot:
        return 'screenshots';
      case MediaType.mixImage:
        return 'miximages';
      case MediaType.video:
        return 'videos';
      case MediaType.backcover:
        return 'backcovers';
      case MediaType.fanart:
        return 'fanart';
      case MediaType.manual:
        return 'manuals';
      case MediaType.physicalmedia:
        return 'physicalmedia';
      case MediaType.titlescreen:
        return 'titlescreens';
    }
  }

  List<String> _getExtensionsForType(MediaType type) {
    switch (type) {
      case MediaType.box3d:
      case MediaType.cover:
      case MediaType.marquee:
      case MediaType.screenshot:
      case MediaType.mixImage:
      case MediaType.backcover:
      case MediaType.fanart:
      case MediaType.physicalmedia:
      case MediaType.titlescreen:
        return ['png', 'jpg', 'jpeg', 'webp'];
      case MediaType.video:
        return ['mp4', 'webm', 'mkv', 'avi'];
      case MediaType.manual:
        return ['png', 'jpg', 'jpeg', 'webp', 'pdf'];
    }
  }

  Future<bool> hasAnyMedia(Rom rom) async {
    final romMedia = await getMediaForRom(rom);
    return romMedia.hasAnyMedia;
  }

  Future<List<String>> getSystemBoxartPaths(String platform) async {
    final boxartPath = path.join(mediaBasePath, platform, '3dboxes');
    return await listFiles(boxartPath);
  }

  /// Get the best available image for display
  /// Priority: 3dboxes > cover > marquee > miximages > screenshot > null
  String? getBestImagePath(RomMedia media) {
    if (media.box3d?.exists ?? false) {
      return media.box3d!.path;
    }
    if (media.cover?.exists ?? false) {
      return media.cover!.path;
    }
    if (media.titlescreen?.exists ?? false) {
      return media.titlescreen!.path;
    }
    if (media.marquee?.exists ?? false) {
      return media.marquee!.path;
    }
    if (media.mixImage?.exists ?? false) {
      return media.mixImage!.path;
    }
    if (media.screenshot?.exists ?? false) {
      return media.screenshot!.path;
    }
    return null;
  }

  String? getLaunchImagePath(RomMedia media) {
    if (media.marquee?.exists ?? false) {
      return media.marquee!.path;
    }
    if (media.cover?.exists ?? false) {
      return media.cover!.path;
    }
    if (media.titlescreen?.exists ?? false) {
      return media.titlescreen!.path;
    }
    return null;
  }

  /// Get the best available image for carousel display
  /// Priority for ROMs in carousel: miximages > 3dboxes > cover > marquee > screenshot > null
  String? getBestImagePathForCarousel(RomMedia media) {
    if (media.mixImage?.exists ?? false) {
      return media.mixImage!.path;
    }
    if (media.box3d?.exists ?? false) {
      return media.box3d!.path;
    }
    if (media.cover?.exists ?? false) {
      return media.cover!.path;
    }
    if (media.titlescreen?.exists ?? false) {
      return media.titlescreen!.path;
    }
    if (media.marquee?.exists ?? false) {
      return media.marquee!.path;
    }
    if (media.screenshot?.exists ?? false) {
      return media.screenshot!.path;
    }
    return null;
  }

  /// Get system/platform image from _systems folder
  /// Returns path to platform image or _default.png if platform image doesn't exist
  Future<String?> getSystemImage(String platformName) async {
    final systemsPath = 'assets/theme/images/systems';

    // Try common image extensions for the platform
    final imageExtensions = ['png', 'jpg', 'jpeg', 'webp'];

    // First, try to find the platform-specific image
    for (var ext in imageExtensions) {
      final platformImagePath = '$systemsPath/$platformName.$ext';

      // Check if asset exists using rootBundle (works on all platforms including Android)
      try {
        await rootBundle.load(platformImagePath);
        _debug.debug(
          'Found system image: $platformImagePath',
          tag: 'MediaService',
        );
        return platformImagePath;
      } catch (e) {
        // Asset doesn't exist, continue to next
      }
    }

    // If platform image not found, try _default
    for (var ext in imageExtensions) {
      final defaultImagePath = '$systemsPath/_default.$ext';

      try {
        await rootBundle.load(defaultImagePath);
        _debug.debug(
          'Using default system image: $defaultImagePath',
          tag: 'MediaService',
        );
        return defaultImagePath;
      } catch (e) {
        // Asset doesn't exist, continue to next
      }
    }

    _debug.debug(
      'No system image found for $platformName',
      tag: 'MediaService',
    );
    return null;
  }

  /// Get system/platform logo from assets with priority:
  /// 1. Color logo (assets/theme/images/clogos/)
  /// 2. White logo (assets/theme/images/logos/)
  /// Returns asset path or null if not found
  Future<String?> getSystemLogo(String platformName) async {
    final imageExtensions = ['svgz', 'svg'];

    // Priority 1: Color logo
    for (var ext in imageExtensions) {
      final colorLogoPath = 'assets/theme/images/clogos/$platformName.$ext';
      // Check if asset exists using rootBundle (works on all platforms including Android)
      try {
        await rootBundle.load(colorLogoPath);
        _debug.debug('Found color logo: $colorLogoPath', tag: 'MediaService');
        return colorLogoPath;
      } catch (e) {
        // Asset doesn't exist, continue to next
      }
    }

    // Priority 2: White logo
    for (var ext in imageExtensions) {
      final whiteLogoPath = 'assets/theme/images/logos/$platformName.$ext';
      try {
        await rootBundle.load(whiteLogoPath);
        _debug.debug('Found white logo: $whiteLogoPath', tag: 'MediaService');
        return whiteLogoPath;
      } catch (e) {
        // Asset doesn't exist, continue to next
      }
    }

    _debug.debug('No system logo found for $platformName', tag: 'MediaService');
    return null;
  }

  /// Get system background image from assets
  /// Returns asset path to background or default.jpg if platform background not found
  Future<String> getSystemBackground(String platformName) async {
    final backgroundPath = 'assets/theme/images/backgrounds/$platformName.webp';
    try {
      await rootBundle.load(backgroundPath);
      return backgroundPath;
    } catch (e) {
      // Asset doesn't exist, use default
    }

    final defaultPath = 'assets/theme/images/backgrounds/default.webp';
    return defaultPath;
  }
}
