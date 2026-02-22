import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../services/debug_service.dart';
import '../../utils/format_utils.dart';

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

  factory WebCoreInfo.fromJson(Map<String, dynamic> json) {
    return WebCoreInfo(
      platform: json['platform'] as String,
      filename: json['filename'] as String,
      displayName: json['displayName'] as String,
      extensions: List<String>.from(json['extensions'] as List),
      size: json['size'] as String,
      included: json['included'] as bool? ?? false,
      downloadUrl: json['downloadUrl'] as String?,
      supportedPlatforms: List<String>.from(json['supportedPlatforms'] as List),
    );
  }
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

  Map<String, WebCoreInfo> _essentialCores = {};
  Map<String, WebCoreInfo> _downloadableCores = {};

  WebCoreManager._();

  static WebCoreManager get instance {
    return _instance ??= WebCoreManager._();
  }

  /// Initialize the manager by loading core information from assets
  Future<void> initialize() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/data/web_cores.json');
      final Map<String, dynamic> data = jsonDecode(jsonStr);

      if (data.containsKey('essentialCores')) {
        final Map<String, dynamic> essential = data['essentialCores'];
        _essentialCores = essential.map(
          (k, v) =>
              MapEntry(k, WebCoreInfo.fromJson(v as Map<String, dynamic>)),
        );
      }

      if (data.containsKey('downloadableCores')) {
        final Map<String, dynamic> downloadable = data['downloadableCores'];
        _downloadableCores = downloadable.map(
          (k, v) =>
              MapEntry(k, WebCoreInfo.fromJson(v as Map<String, dynamic>)),
        );
      }

      _debug.info(
        'WebCoreManager initialized with ${_essentialCores.length} essential and '
        '${_downloadableCores.length} downloadable cores',
        tag: 'WebCoreManager',
      );
    } catch (e) {
      _debug.error(
        'Failed to initialize WebCoreManager: $e',
        tag: 'WebCoreManager',
      );
    }
  }

  /// Essential cores included in the build assets
  Map<String, WebCoreInfo> get essentialCores => _essentialCores;

  /// Optional cores that can be downloaded on-demand from EmulatorJS CDN
  Map<String, WebCoreInfo> get downloadableCores => _downloadableCores;

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

  /// Get all available cores (essential + downloadable)
  Map<String, WebCoreInfo> get allCores {
    return {..._essentialCores, ..._downloadableCores};
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

      // The CDN URL is what EmulatorJS will use
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
  static String _formatBytes(int bytes) => formatBytes(bytes);

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
