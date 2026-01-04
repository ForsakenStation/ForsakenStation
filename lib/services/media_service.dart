import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/media.dart';
import '../models/rom.dart';
import '../models/rom_item.dart';
import 'debug_service.dart';

class MediaService {
  final String mediaBasePath;
  final _debug = DebugService.instance;

  MediaService({required this.mediaBasePath});

  Future<RomMedia> getMediaForRom(Rom rom) async {
    final romNameWithoutExt = rom.displayName;

    final romMedia = RomMedia(
      romName: romNameWithoutExt,
      platform: rom.platform,
    );

    // Check for all media types
    romMedia.box3d = await _findMedia(
      rom.platform,
      romNameWithoutExt,
      MediaType.box3d,
    );
    romMedia.cover = await _findMedia(
      rom.platform,
      romNameWithoutExt,
      MediaType.cover,
    );
    romMedia.marquee = await _findMedia(
      rom.platform,
      romNameWithoutExt,
      MediaType.marquee,
    );
    romMedia.screenshot = await _findMedia(
      rom.platform,
      romNameWithoutExt,
      MediaType.screenshot,
    );
    romMedia.mixImage = await _findMedia(
      rom.platform,
      romNameWithoutExt,
      MediaType.mixImage,
    );
    romMedia.video = await _findMedia(
      rom.platform,
      romNameWithoutExt,
      MediaType.video,
    );
    romMedia.titlescreen = await _findMedia(
      rom.platform,
      romNameWithoutExt,
      MediaType.titlescreen,
    );

    return romMedia;
  }

  Future<RomMedia> getMediaForRomItem(
    RomItem romItem,
    String platformName,
  ) async {
    // Get ROM name without extension for matching media files
    final romNameWithoutExt = _getRomNameWithoutExtension(romItem.name);

    _debug.debug('Loading media for ROM: ${romItem.name}', tag: 'MediaService');
    _debug.debug(
      'ROM name without extension: $romNameWithoutExt',
      tag: 'MediaService',
    );
    _debug.debug('Platform: $platformName', tag: 'MediaService');
    _debug.debug('Media base path: $mediaBasePath', tag: 'MediaService');

    final romMedia = RomMedia(
      romName: romNameWithoutExt,
      platform: platformName,
    );

    // Check for all media types with priority
    romMedia.box3d = await _findMedia(
      platformName,
      romNameWithoutExt,
      MediaType.box3d,
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
    );
    if (romMedia.cover != null) {
      _debug.debug('Found cover: ${romMedia.cover!.path}', tag: 'MediaService');
    }

    romMedia.marquee = await _findMedia(
      platformName,
      romNameWithoutExt,
      MediaType.marquee,
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
    );
    if (romMedia.video != null) {
      _debug.debug('Found video: ${romMedia.video!.path}', tag: 'MediaService');
    }

    romMedia.titlescreen = await _findMedia(
      platformName,
      romNameWithoutExt,
      MediaType.titlescreen,
    );
    if (romMedia.titlescreen != null) {
      _debug.debug(
        'Found titlescreen: ${romMedia.titlescreen!.path}',
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
    // Remove common ROM extensions
    final commonExtensions = [
      '.zip',
      '.rar',
      '.7z',
      '.gz',
      '.nes',
      '.snes',
      '.sfc',
      '.n64',
      '.z64',
      '.v64',
      '.gba',
      '.gbc',
      '.gb',
      '.iso',
      '.cue',
      '.bin',
      '.img',
      '.nds',
      '.3ds',
      '.gcm',
      '.gcz',
      '.smd',
      '.md',
      '.gen',
      '.txt',
    ];

    String name = fileName;
    for (var ext in commonExtensions) {
      if (name.toLowerCase().endsWith(ext)) {
        name = name.substring(0, name.length - ext.length);
        break;
      }
    }

    return name;
  }

  Future<Media?> _findMedia(
    String platform,
    String romName,
    MediaType type,
  ) async {
    final mediaTypePath = _getMediaTypePath(type);
    final platformMediaPath = path.join(mediaBasePath, platform, mediaTypePath);

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

  Future<List<String>> getPlatformBoxartPaths(String platform) async {
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
      final platformImagePath = path.join(systemsPath, '$platformName.$ext');
      final file = File(platformImagePath);

      if (await file.exists()) {
        _debug.debug(
          'Found system image: $platformImagePath',
          tag: 'MediaService',
        );
        return platformImagePath;
      }
    }

    // If platform image not found, try _default
    for (var ext in imageExtensions) {
      final defaultImagePath = path.join(systemsPath, '_default.$ext');
      final file = File(defaultImagePath);

      if (await file.exists()) {
        _debug.debug(
          'Using default system image: $defaultImagePath',
          tag: 'MediaService',
        );
        return defaultImagePath;
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
    final imageExtensions = ['svg', 'png', 'jpg', 'jpeg', 'webp'];

    // Priority 1: Color logo
    for (var ext in imageExtensions) {
      final colorLogoPath = 'assets/theme/images/clogos/$platformName.$ext';
      // Check if asset file exists in the project structure
      final colorLogoFile = File(colorLogoPath);
      if (await colorLogoFile.exists()) {
        _debug.debug('Found color logo: $colorLogoPath', tag: 'MediaService');
        return colorLogoPath;
      }
    }

    // Priority 2: White logo
    for (var ext in imageExtensions) {
      final whiteLogoPath = 'assets/theme/images/logos/$platformName.$ext';
      final whiteLogoFile = File(whiteLogoPath);
      if (await whiteLogoFile.exists()) {
        _debug.debug('Found white logo: $whiteLogoPath', tag: 'MediaService');
        return whiteLogoPath;
      }
    }

    _debug.debug('No system logo found for $platformName', tag: 'MediaService');
    return null;
  }

  /// Get system background image from assets
  /// Returns asset path to background or default.jpg if platform background not found
  Future<String> getSystemBackground(String platformName) async {
    // Try to find platform-specific background
    final backgroundPath = 'assets/theme/images/backgrounds/$platformName.jpg';
    final backgroundFile = File(backgroundPath);

    if (await backgroundFile.exists()) {
      _debug.debug('Found background: $backgroundPath', tag: 'MediaService');
      return backgroundPath;
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
