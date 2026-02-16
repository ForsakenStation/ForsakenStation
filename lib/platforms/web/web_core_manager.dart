import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../services/debug_service.dart';

/// Information about a RetroArch core for web
class WebCoreInfo {
  final String platform;
  final String filename;
  final String displayName;
  final List<String> extensions;
  final String size;
  final bool included;
  final String? downloadUrl;
  final List<String> supportedPlatforms;

  const WebCoreInfo({
    required this.platform,
    required this.filename,
    required this.displayName,
    required this.extensions,
    required this.size,
    required this.included,
    this.downloadUrl,
    required this.supportedPlatforms,
  });
}

/// Loading state for core downloads
enum CoreLoadingState { notLoaded, downloading, extracting, ready, error }

/// Core loading progress information
class CoreLoadingProgress {
  final CoreLoadingState state;
  final double progress;
  final String message;
  final String? error;

  const CoreLoadingProgress({
    required this.state,
    required this.progress,
    required this.message,
    this.error,
  });
}

/// Manages RetroArch cores for web platform
class WebCoreManager {
  static WebCoreManager? _instance;
  final DebugService _debug = DebugService.instance;

  /// Base URL for downloading cores (can be CDN or local server)
  static const String _coresCDN = 'https://cdn.emulatorjs.org/stable/';

  /// Cache of downloaded cores
  final Map<String, String> _coreCache = {};

  /// Loading states for cores
  final Map<String, CoreLoadingProgress> _loadingStates = {};

  WebCoreManager._();

  static WebCoreManager get instance {
    return _instance ??= WebCoreManager._();
  }

  /// Essential cores included in the build assets
  static const Map<String, WebCoreInfo> essentialCores = {
    'gb': WebCoreInfo(
      platform: 'gb',
      filename: 'gambatte_libretro.js',
      displayName: 'Game Boy / Game Boy Color',
      extensions: ['.gb', '.gbc', '.zip'],
      size: '1.2MB',
      included: true,
      supportedPlatforms: ['gb', 'gbc'],
    ),
    'gba': WebCoreInfo(
      platform: 'gba',
      filename: 'vba_next_libretro.js',
      displayName: 'Game Boy Advance',
      extensions: ['.gba', '.zip'],
      size: '1.8MB',
      included: true,
      supportedPlatforms: ['gba'],
    ),
    'nes': WebCoreInfo(
      platform: 'nes',
      filename: 'nestopia_libretro.js',
      displayName: 'Nintendo Entertainment System',
      extensions: ['.nes', '.zip'],
      size: '1.5MB',
      included: true,
      supportedPlatforms: ['nes'],
    ),
    'snes': WebCoreInfo(
      platform: 'snes',
      filename: 'snes9x_libretro.js',
      displayName: 'Super Nintendo Entertainment System',
      extensions: ['.smc', '.sfc', '.zip'],
      size: '2.1MB',
      included: true,
      supportedPlatforms: ['snes'],
    ),
    'genesis': WebCoreInfo(
      platform: 'genesis',
      filename: 'genesis_plus_gx_libretro.js',
      displayName: 'Sega Genesis / Mega Drive',
      extensions: ['.md', '.gen', '.zip'],
      size: '1.7MB',
      included: true,
      supportedPlatforms: ['genesis', 'megadrive'],
    ),
  };

  /// Optional cores that can be downloaded on-demand
  static const Map<String, WebCoreInfo> downloadableCores = {
    'n64': WebCoreInfo(
      platform: 'n64',
      filename: 'mupen64plus_next_libretro.js',
      displayName: 'Nintendo 64',
      extensions: ['.n64', '.z64', '.v64', '.zip'],
      size: '8.5MB',
      included: false,
      downloadUrl: 'n64/',
      supportedPlatforms: ['n64'],
    ),
    'psx': WebCoreInfo(
      platform: 'psx',
      filename: 'pcsx_rearmed_libretro.js',
      displayName: 'Sony PlayStation',
      extensions: ['.bin', '.cue', '.img', '.pbp', '.chn', '.zip'],
      size: '12.3MB',
      included: false,
      downloadUrl: 'psx/',
      supportedPlatforms: ['psx', 'ps1'],
    ),
    'dreamcast': WebCoreInfo(
      platform: 'dreamcast',
      filename: 'flycast_libretro.js',
      displayName: 'Sega Dreamcast',
      extensions: ['.cdi', '.gdi', '.chd', '.zip'],
      size: '15.7MB',
      included: false,
      downloadUrl: 'dreamcast/',
      supportedPlatforms: ['dreamcast'],
    ),
  };

  /// Get all available cores (essential + downloadable)
  Map<String, WebCoreInfo> get allCores {
    return {...essentialCores, ...downloadableCores};
  }

  /// Check if a platform has core support
  bool hasCoreSupport(String platform) {
    return allCores.values.any(
      (core) => core.supportedPlatforms.contains(platform.toLowerCase()),
    );
  }

  /// Get core information for a platform
  WebCoreInfo? getCoreInfo(String platform) {
    final platformLower = platform.toLowerCase();

    // First check direct platform match
    if (allCores.containsKey(platformLower)) {
      return allCores[platformLower];
    }

    // Then check supported platforms
    for (final core in allCores.values) {
      if (core.supportedPlatforms.contains(platformLower)) {
        return core;
      }
    }

    return null;
  }

  /// Get the URL for a core (asset path or download URL)
  Future<String> getCoreUrl(String platform) async {
    final coreInfo = getCoreInfo(platform);
    if (coreInfo == null) {
      throw Exception('No core available for platform: $platform');
    }

    if (coreInfo.included) {
      // Core is included in assets
      return 'cores/${coreInfo.filename}';
    } else {
      // Core needs to be downloaded
      final cached = _coreCache[coreInfo.platform];
      if (cached != null) {
        _debug.debug(
          'Using cached core for ${coreInfo.platform}',
          tag: 'WebCoreManager',
        );
        return cached;
      }

      // Download and cache the core
      return await _downloadAndCacheCore(coreInfo);
    }
  }

  /// Download and cache a core
  Future<String> _downloadAndCacheCore(WebCoreInfo coreInfo) async {
    if (!kIsWeb) {
      throw Exception('Core downloading only available on web platform');
    }

    if (coreInfo.downloadUrl == null) {
      throw Exception('No download URL for core: ${coreInfo.platform}');
    }

    _updateLoadingState(
      coreInfo.platform,
      const CoreLoadingProgress(
        state: CoreLoadingState.downloading,
        progress: 0.0,
        message: 'Starting download...',
      ),
    );

    try {
      final url = '$_coresCDN${coreInfo.downloadUrl}${coreInfo.filename}';
      _debug.info('Downloading core from: $url', tag: 'WebCoreManager');

      // For now, simulate the download process
      // TODO: Implement actual HTTP download with progress tracking
      await Future.delayed(const Duration(seconds: 2));

      // Simulate progress updates
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 100));
        _updateLoadingState(
          coreInfo.platform,
          CoreLoadingProgress(
            state: CoreLoadingState.downloading,
            progress: i / 100.0,
            message: 'Downloading $i%...',
          ),
        );
      }

      // Simulate successful download
      final simulatedUrl = 'cores/${coreInfo.filename}';
      _coreCache[coreInfo.platform] = simulatedUrl;

      _updateLoadingState(
        coreInfo.platform,
        const CoreLoadingProgress(
          state: CoreLoadingState.ready,
          progress: 1.0,
          message: 'Core ready',
        ),
      );

      _debug.info(
        'Successfully downloaded core: ${coreInfo.platform}',
        tag: 'WebCoreManager',
      );

      return simulatedUrl;
    } catch (e) {
      _updateLoadingState(
        coreInfo.platform,
        CoreLoadingProgress(
          state: CoreLoadingState.error,
          progress: 0.0,
          message: 'Download failed',
          error: e.toString(),
        ),
      );
      rethrow;
    }
  }

  /// Update loading state for a core
  void _updateLoadingState(String platform, CoreLoadingProgress progress) {
    _loadingStates[platform] = progress;
    // TODO: Emit stream event for UI updates
  }

  /// Get loading state for a platform
  CoreLoadingProgress getLoadingState(String platform) {
    return _loadingStates[platform] ??
        const CoreLoadingProgress(
          state: CoreLoadingState.notLoaded,
          progress: 0.0,
          message: 'Not loaded',
        );
  }

  /// Preload essential cores (call on app startup)
  Future<void> preloadEssentialCores() async {
    if (!kIsWeb) return;

    _debug.info('Preloading essential cores...', tag: 'WebCoreManager');

    final futures = essentialCores.keys.map((platform) async {
      try {
        await getCoreUrl(platform);
        _debug.debug('Preloaded core: $platform', tag: 'WebCoreManager');
      } catch (e) {
        _debug.warning(
          'Failed to preload core $platform: $e',
          tag: 'WebCoreManager',
        );
      }
    });

    await Future.wait(futures);
    _debug.info('Essential core preloading complete', tag: 'WebCoreManager');
  }

  /// Get supported file extensions for a platform
  List<String> getSupportedExtensions(String platform) {
    final coreInfo = getCoreInfo(platform);
    return coreInfo?.extensions ?? [];
  }

  /// Check if a file is supported by any core
  bool isFileSupported(String filename) {
    final extension = filename.toLowerCase().substring(
      filename.lastIndexOf('.'),
    );

    return allCores.values.any(
      (core) => core.extensions.any((ext) => ext.toLowerCase() == extension),
    );
  }

  /// Get platform from file extension
  String? getPlatformFromFile(String filename) {
    final extension = filename.toLowerCase().substring(
      filename.lastIndexOf('.'),
    );

    for (final core in allCores.values) {
      if (core.extensions.any((ext) => ext.toLowerCase() == extension)) {
        return core.platform;
      }
    }

    return null;
  }

  /// Clear cached cores (useful for debugging/testing)
  void clearCache() {
    if (!kIsWeb) return;

    // TODO: Implement blob URL cleanup when using real HTTP downloads
    _coreCache.clear();
    _loadingStates.clear();
    _debug.info('Core cache cleared', tag: 'WebCoreManager');
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    return {
      'cached_cores': _coreCache.length,
      'cache_keys': _coreCache.keys.toList(),
      'essential_cores': essentialCores.length,
      'downloadable_cores': downloadableCores.length,
      'total_cores': allCores.length,
    };
  }
}
