import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as path;
import 'package:forsaken/models/media.dart';
import 'package:forsaken/models/rom.dart';
import 'package:forsaken/models/rom_item.dart';
import 'debug_service.dart';

class MediaService {
  final String mediaBasePath;
  final _debug = DebugService.instance;

  MediaService({required this.mediaBasePath});

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

    final mediaDir = Directory(platformMediaPath);

    if (!await mediaDir.exists()) {
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
      final file = File(mediaPath);

      _debug.debug('Checking: $mediaPath', tag: 'MediaService');
      if (await file.exists()) {
        _debug.debug('Found media file: $mediaPath', tag: 'MediaService');
        return Media(
          romName: romName,
          platform: platform,
          type: type,
          path: mediaPath,
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
    final boxartDir = Directory(boxartPath);

    if (!await boxartDir.exists()) {
      return [];
    }

    final paths = <String>[];
    await for (var file in boxartDir.list()) {
      if (file is File) {
        paths.add(file.path);
      }
    }

    return paths;
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
    final backgroundPath = 'assets/theme/images/backgrounds/$platformName.jpg';

    // Check if asset exists using rootBundle (works on all platforms including Android)
    try {
      await rootBundle.load(backgroundPath);
      _debug.debug('Found background: $backgroundPath', tag: 'MediaService');
      return backgroundPath;
    } catch (e) {
      // Asset doesn't exist, use default
    }

    // Fallback to default background
    final defaultPath = 'assets/theme/images/backgrounds/default.jpg';
    _debug.debug(
      'Using default background for $platformName',
      tag: 'MediaService',
    );
    return defaultPath;
  }
}
