import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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

  /// Base URL for downloading cores from EmulatorJS CDN
  static const String _coresCDN = 'https://cdn.emulatorjs.org/stable/data/';

  /// Cache of downloaded core blob URLs (platform -> blob URL or CDN URL)
  final Map<String, String> _coreCache = {};

  /// Cache of downloaded core data (platform -> bytes)
  final Map<String, Uint8List> _coreDataCache = {};

  /// Loading states for cores
  final Map<String, CoreLoadingProgress> _loadingStates = {};

  /// Stream controller for loading progress updates
  final StreamController<MapEntry<String, CoreLoadingProgress>>
  _progressController =
      StreamController<MapEntry<String, CoreLoadingProgress>>.broadcast();

  /// Active download futures to avoid duplicate downloads
  final Map<String, Future<String>> _activeDownloads = {};

  WebCoreManager._();

  static WebCoreManager get instance {
    return _instance ??= WebCoreManager._();
  }

  /// Stream of core loading progress updates
  Stream<MapEntry<String, CoreLoadingProgress>> get progressStream =>
      _progressController.stream;

  /// Check if a core is cached and ready
  bool isCoreReady(String platform) {
    return _coreCache.containsKey(platform.toLowerCase());
  }

  /// Get cached core data (bytes) for a platform
  Uint8List? getCachedCoreData(String platform) {
    return _coreDataCache[platform.toLowerCase()];
  }

  /// Essential cores included in the build assets
  /// Core names match EmulatorJS CDN naming convention
  static const Map<String, WebCoreInfo> essentialCores = {
    'gb': WebCoreInfo(
      platform: 'gb',
      filename: 'gambatte',
      displayName: 'Game Boy / Game Boy Color',
      extensions: ['.gb', '.gbc', '.zip'],
      size: '~1MB',
      included: true,
      supportedPlatforms: ['gb', 'gbc'],
    ),
    'gba': WebCoreInfo(
      platform: 'gba',
      filename: 'mgba',
      displayName: 'Game Boy Advance',
      extensions: ['.gba', '.zip'],
      size: '~2MB',
      included: true,
      supportedPlatforms: ['gba'],
    ),
    'nes': WebCoreInfo(
      platform: 'nes',
      filename: 'fceumm',
      displayName: 'Nintendo Entertainment System',
      extensions: ['.nes', '.zip'],
      size: '~1MB',
      included: true,
      supportedPlatforms: ['nes'],
    ),
    'snes': WebCoreInfo(
      platform: 'snes',
      filename: 'snes9x',
      displayName: 'Super Nintendo Entertainment System',
      extensions: ['.smc', '.sfc', '.zip'],
      size: '~2MB',
      included: true,
      supportedPlatforms: ['snes'],
    ),
    'genesis': WebCoreInfo(
      platform: 'genesis',
      filename: 'genesis_plus_gx',
      displayName: 'Sega Genesis / Mega Drive',
      extensions: ['.md', '.gen', '.bin', '.zip'],
      size: '~2MB',
      included: true,
      supportedPlatforms: [
        'genesis',
        'megadrive',
        'sms',
        'mastersystem',
        'gamegear',
        'gg',
        'segacd',
      ],
    ),
  };

  /// Optional cores that can be downloaded on-demand from EmulatorJS CDN
  static const Map<String, WebCoreInfo> downloadableCores = {
    'n64': WebCoreInfo(
      platform: 'n64',
      filename: 'mupen64plus_next',
      displayName: 'Nintendo 64',
      extensions: ['.n64', '.z64', '.v64', '.zip'],
      size: '~8MB',
      included: false,
      downloadUrl: 'cores/',
      supportedPlatforms: ['n64'],
    ),
    'psx': WebCoreInfo(
      platform: 'psx',
      filename: 'pcsx_rearmed',
      displayName: 'Sony PlayStation',
      extensions: ['.bin', '.cue', '.img', '.pbp', '.chd', '.zip'],
      size: '~5MB',
      included: false,
      downloadUrl: 'cores/',
      supportedPlatforms: ['psx', 'ps1'],
    ),
    'psp': WebCoreInfo(
      platform: 'psp',
      filename: 'ppsspp',
      displayName: 'Sony PSP',
      extensions: ['.iso', '.cso', '.pbp'],
      size: '~10MB',
      included: false,
      downloadUrl: 'cores/',
      supportedPlatforms: ['psp'],
    ),
    'saturn': WebCoreInfo(
      platform: 'saturn',
      filename: 'yabause',
      displayName: 'Sega Saturn',
      extensions: ['.bin', '.cue', '.iso'],
      size: '~5MB',
      included: false,
      downloadUrl: 'cores/',
      supportedPlatforms: ['saturn'],
    ),
    'nds': WebCoreInfo(
      platform: 'nds',
      filename: 'melonds',
      displayName: 'Nintendo DS',
      extensions: ['.nds', '.zip'],
      size: '~3MB',
      included: false,
      downloadUrl: 'cores/',
      supportedPlatforms: ['nds'],
    ),
    'arcade': WebCoreInfo(
      platform: 'arcade',
      filename: 'fbneo',
      displayName: 'Arcade (FinalBurn Neo)',
      extensions: ['.zip'],
      size: '~15MB',
      included: false,
      downloadUrl: 'cores/',
      supportedPlatforms: ['arcade', 'neogeo', 'cps1', 'cps2', 'cps3'],
    ),
    'mame': WebCoreInfo(
      platform: 'mame',
      filename: 'mame2003_plus',
      displayName: 'MAME 2003+',
      extensions: ['.zip'],
      size: '~15MB',
      included: false,
      downloadUrl: 'cores/',
      supportedPlatforms: ['mame'],
    ),
    'pce': WebCoreInfo(
      platform: 'pce',
      filename: 'mednafen_pce',
      displayName: 'PC Engine / TurboGrafx-16',
      extensions: ['.pce', '.cue', '.zip'],
      size: '~2MB',
      included: false,
      downloadUrl: 'cores/',
      supportedPlatforms: ['pce', 'pcengine', 'pcenginecd', 'tg16'],
    ),
    'atari2600': WebCoreInfo(
      platform: 'atari2600',
      filename: 'stella2014',
      displayName: 'Atari 2600',
      extensions: ['.a26', '.bin', '.zip'],
      size: '~1MB',
      included: false,
      downloadUrl: 'cores/',
      supportedPlatforms: ['atari2600', '2600'],
    ),
    'atari7800': WebCoreInfo(
      platform: 'atari7800',
      filename: 'prosystem',
      displayName: 'Atari 7800',
      extensions: ['.a78', '.bin', '.zip'],
      size: '~1MB',
      included: false,
      downloadUrl: 'cores/',
      supportedPlatforms: ['atari7800', '7800'],
    ),
    'lynx': WebCoreInfo(
      platform: 'lynx',
      filename: 'handy',
      displayName: 'Atari Lynx',
      extensions: ['.lnx', '.zip'],
      size: '~1MB',
      included: false,
      downloadUrl: 'cores/',
      supportedPlatforms: ['lynx', 'atarilynx'],
    ),
    'jaguar': WebCoreInfo(
      platform: 'jaguar',
      filename: 'virtualjaguar',
      displayName: 'Atari Jaguar',
      extensions: ['.j64', '.jag', '.zip'],
      size: '~2MB',
      included: false,
      downloadUrl: 'cores/',
      supportedPlatforms: ['jaguar', 'atarijaguar'],
    ),
    'vb': WebCoreInfo(
      platform: 'vb',
      filename: 'beetle_vb',
      displayName: 'Virtual Boy',
      extensions: ['.vb', '.vboy', '.zip'],
      size: '~1MB',
      included: false,
      downloadUrl: 'cores/',
      supportedPlatforms: ['vb', 'virtualboy'],
    ),
    'ws': WebCoreInfo(
      platform: 'ws',
      filename: 'mednafen_wswan',
      displayName: 'WonderSwan / WonderSwan Color',
      extensions: ['.ws', '.wsc', '.zip'],
      size: '~1MB',
      included: false,
      downloadUrl: 'cores/',
      supportedPlatforms: ['ws', 'wsc', 'wonderswan', 'wonderswancolor'],
    ),
    'sega32x': WebCoreInfo(
      platform: 'sega32x',
      filename: 'picodrive',
      displayName: 'Sega 32X',
      extensions: ['.32x', '.bin', '.zip'],
      size: '~2MB',
      included: false,
      downloadUrl: 'cores/',
      supportedPlatforms: ['sega32x', '32x'],
    ),
    '3do': WebCoreInfo(
      platform: '3do',
      filename: 'opera',
      displayName: '3DO Interactive Multiplayer',
      extensions: ['.iso', '.bin', '.cue', '.chd'],
      size: '~3MB',
      included: false,
      downloadUrl: 'cores/',
      supportedPlatforms: ['3do'],
    ),
    'ngp': WebCoreInfo(
      platform: 'ngp',
      filename: 'mednafen_ngp',
      displayName: 'Neo Geo Pocket / Color',
      extensions: ['.ngp', '.ngc', '.zip'],
      size: '~1MB',
      included: false,
      downloadUrl: 'cores/',
      supportedPlatforms: ['ngp', 'ngpc'],
    ),
    'coleco': WebCoreInfo(
      platform: 'coleco',
      filename: 'gearcoleco',
      displayName: 'ColecoVision',
      extensions: ['.col', '.bin', '.rom', '.zip'],
      size: '~1MB',
      included: false,
      downloadUrl: 'cores/',
      supportedPlatforms: ['coleco', 'colecovision'],
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
      // Essential cores - pre-warm browser HTTP cache so EmulatorJS
      // finds the file cached when it loads it.
      // CDN format: cores/{corename}-wasm.data
      final coreUrl = '${_coresCDN}cores/${coreInfo.filename}-wasm.data';
      _coreCache[coreInfo.platform] = coreUrl;
      _updateLoadingState(
        coreInfo.platform,
        const CoreLoadingProgress(
          state: CoreLoadingState.ready,
          progress: 1.0,
          message: 'Core ready',
        ),
      );
      return coreUrl;
    } else {
      // Downloadable core - check cache first
      final cached = _coreCache[coreInfo.platform];
      if (cached != null) {
        _debug.debug(
          'Using cached core for ${coreInfo.platform}',
          tag: 'WebCoreManager',
        );
        return cached;
      }

      // Check if already downloading (avoid duplicate downloads)
      final activeDownload = _activeDownloads[coreInfo.platform];
      if (activeDownload != null) {
        _debug.debug(
          'Waiting for active download: ${coreInfo.platform}',
          tag: 'WebCoreManager',
        );
        return activeDownload;
      }

      // Start download and cache the future
      final downloadFuture = _downloadAndCacheCore(coreInfo);
      _activeDownloads[coreInfo.platform] = downloadFuture;

      try {
        final result = await downloadFuture;
        return result;
      } finally {
        _activeDownloads.remove(coreInfo.platform);
      }
    }
  }

  /// Download and cache a core WASM from the EmulatorJS CDN
  ///
  /// Downloads the core WASM data file and caches it in memory.
  /// The browser's HTTP cache will also retain the file for subsequent
  /// page loads, so EmulatorJS finds it pre-cached.
  Future<String> _downloadAndCacheCore(WebCoreInfo coreInfo) async {
    if (!kIsWeb) {
      throw Exception('Core downloading only available on web platform');
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
      // EmulatorJS CDN core URL pattern: cores/{corename}-wasm.data
      final url = '${_coresCDN}cores/${coreInfo.filename}-wasm.data';
      _debug.info('Downloading core from: $url', tag: 'WebCoreManager');

      // Use streamed request for progress tracking
      final request = http.Request('GET', Uri.parse(url));
      final streamedResponse = await request.send();

      if (streamedResponse.statusCode != 200) {
        throw Exception(
          'HTTP ${streamedResponse.statusCode} downloading core '
          '${coreInfo.filename}',
        );
      }

      // Get content length for progress calculation
      final contentLength = streamedResponse.contentLength ?? 0;
      final chunks = <List<int>>[];
      int receivedBytes = 0;

      _debug.info(
        'Core download started: ${coreInfo.filename} '
        '(${_formatBytes(contentLength)})',
        tag: 'WebCoreManager',
      );

      // Download with progress tracking
      await for (final chunk in streamedResponse.stream) {
        chunks.add(chunk);
        receivedBytes += chunk.length;

        final progress = contentLength > 0
            ? receivedBytes / contentLength
            : 0.0;
        final progressPct = (progress * 100).toInt();

        _updateLoadingState(
          coreInfo.platform,
          CoreLoadingProgress(
            state: CoreLoadingState.downloading,
            progress: progress,
            message:
                'Downloading ${_formatBytes(receivedBytes)}'
                '${contentLength > 0 ? ' / ${_formatBytes(contentLength)}' : ''}'
                ' ($progressPct%)',
          ),
        );
      }

      // Combine chunks into final bytes
      final totalBytes = chunks.fold<int>(0, (sum, c) => sum + c.length);
      final coreData = Uint8List(totalBytes);
      int offset = 0;
      for (final chunk in chunks) {
        coreData.setRange(offset, offset + chunk.length, chunk);
        offset += chunk.length;
      }

      // Cache the core data in memory
      _coreDataCache[coreInfo.platform] = coreData;

      // The CDN URL is what EmulatorJS will use - the browser HTTP cache
      // now has the file cached from our fetch
      _coreCache[coreInfo.platform] = url;

      _updateLoadingState(
        coreInfo.platform,
        CoreLoadingProgress(
          state: CoreLoadingState.ready,
          progress: 1.0,
          message: 'Core ready (${_formatBytes(totalBytes)})',
        ),
      );

      _debug.info(
        'Successfully downloaded core: ${coreInfo.platform} '
        '(${_formatBytes(totalBytes)})',
        tag: 'WebCoreManager',
      );

      return url;
    } catch (e) {
      _debug.error(
        'Failed to download core ${coreInfo.platform}: $e',
        tag: 'WebCoreManager',
      );

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

  /// Format bytes into human-readable string
  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Update loading state for a core and emit to stream
  void _updateLoadingState(String platform, CoreLoadingProgress progress) {
    _loadingStates[platform] = progress;
    if (!_progressController.isClosed) {
      _progressController.add(MapEntry(platform, progress));
    }
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

  /// Clear cached cores
  void clearCache() {
    if (!kIsWeb) return;

    _coreCache.clear();
    _coreDataCache.clear();
    _loadingStates.clear();
    _debug.info('Core cache cleared', tag: 'WebCoreManager');
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    final totalCacheSize = _coreDataCache.values.fold<int>(
      0,
      (sum, data) => sum + data.length,
    );

    return {
      'cached_cores': _coreCache.length,
      'cache_keys': _coreCache.keys.toList(),
      'cache_data_size': _formatBytes(totalCacheSize),
      'essential_cores': essentialCores.length,
      'downloadable_cores': downloadableCores.length,
      'total_cores': allCores.length,
      'active_downloads': _activeDownloads.length,
    };
  }

  /// Dispose the manager and release resources
  void dispose() {
    _progressController.close();
    clearCache();
  }
}
