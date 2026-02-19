import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'emulatorjs_bridge.dart';
import 'web_core_manager.dart';
import '../../models/rom_item.dart';
import '../../models/launch_result.dart';
import '../../services/debug_service.dart';
import '../../services/download_resolver_service.dart';

/// Web-specific implementation of emulator service using EmulatorJS
class WebEmulatorService {
  static WebEmulatorService? _instance;

  final DebugService _debug = DebugService.instance;
  final WebCoreManager _coreManager = WebCoreManager.instance;
  final DownloadResolverService _downloadResolver = DownloadResolverService();

  /// CORS proxy base URL. Set to null or empty to disable.
  /// The target URL is passed as a `?url=` query parameter.
  /// Example: 'https://my-worker.workers.dev/' → 'https://my-worker.workers.dev/?url=https://example.com/rom.zip'
  String? corsProxyUrl;

  /// Currently active emulator instances
  final Map<String, EmulatorJSBridge> _emulators = {};

  /// Current ROM being played
  RomItem? _currentRom;
  String? _currentEmulatorId;

  WebEmulatorService._();

  static WebEmulatorService get instance {
    return _instance ??= WebEmulatorService._();
  }

  /// Initialize the web emulator service
  Future<void> initialize() async {
    try {
      _debug.info(
        'Initializing WebEmulatorService...',
        tag: 'WebEmulatorService',
      );

      // Preload essential cores
      await _coreManager.preloadEssentialCores();

      _debug.info(
        'WebEmulatorService initialized successfully',
        tag: 'WebEmulatorService',
      );
    } catch (e) {
      _debug.error(
        'Failed to initialize WebEmulatorService: $e',
        tag: 'WebEmulatorService',
      );
      rethrow;
    }
  }

  /// Launch a ROM in the web emulator
  Future<LaunchResult> launchRom(
    RomItem rom, {
    String containerId = 'emulator-container',
  }) async {
    try {
      _debug.info(
        'Launching ROM: ${rom.name} for platform: ${rom.platform}',
        tag: 'WebEmulatorService',
      );

      // Stop any currently running emulator
      if (_currentEmulatorId != null) {
        await stopEmulator(_currentEmulatorId!);
      }

      // Check if platform is specified
      if (rom.platform == null) {
        return LaunchResult.failure('ROM platform is not specified');
      }

      // Check if platform is supported
      if (!_coreManager.hasCoreSupport(rom.platform!)) {
        return LaunchResult.failure(
          'Platform ${rom.platform} not supported in web version',
        );
      }

      // Get core information
      final coreInfo = _coreManager.getCoreInfo(rom.platform!);
      if (coreInfo == null) {
        return LaunchResult.failure(
          'No core found for platform: ${rom.platform}',
        );
      }

      // Create emulator instance with callbacks
      final emulator = EmulatorJSBridge(
        containerId: containerId,
        callbacks: EmulatorCallbacks(
          onReady: () {
            _debug.info(
              'Emulator ready for ROM: ${rom.name}',
              tag: 'WebEmulatorService',
            );
          },
          onError: (error) {
            _debug.error('Emulator error: $error', tag: 'WebEmulatorService');
          },
          onLoadingProgress: (progress) {
            _debug.debug(
              'Loading progress: ${progress.stage} ${(progress.progress * 100).toInt()}%',
              tag: 'WebEmulatorService',
            );
          },
          onCoreLoaded: () {
            _debug.info(
              'Core loaded for ${rom.platform}',
              tag: 'WebEmulatorService',
            );
          },
          onRomLoaded: () {
            _debug.info('ROM loaded: ${rom.name}', tag: 'WebEmulatorService');
          },
        ),
      );

      // Store emulator instance
      _emulators[containerId] = emulator;
      _currentEmulatorId = containerId;
      _currentRom = rom;

      // Get core URL (from assets or download)
      final coreUrl = await _coreManager.getCoreUrl(rom.platform!);
      _debug.info('Using core: $coreUrl', tag: 'WebEmulatorService');

      // Load the core
      await emulator.loadCore(coreUrl, rom.platform!);

      // Resolve the ROM download URL
      final romUrl = await _resolveRomUrl(rom);
      if (romUrl == null) {
        return LaunchResult.failure('Failed to resolve ROM download URL');
      }

      // Pass the URL directly to EmulatorJS (avoids CORS issues with
      // Dart HTTP client since EmulatorJS handles the download).
      // loadRomFromUrl() launches EmulatorJS with EJS_startOnLoaded=true,
      // so the emulator auto-starts once the ROM is ready.
      // Do NOT call start() here — the WASM core/gameManager may not be
      // initialized yet, causing "Cannot read properties of undefined
      // (reading 'toggleMainLoop')" errors.
      await emulator.loadRomFromUrl(romUrl, rom.name);

      _debug.info(
        'ROM ${rom.name} launched successfully',
        tag: 'WebEmulatorService',
      );
      return LaunchResult.success();
    } catch (e, stackTrace) {
      _debug.error(
        'Failed to launch ROM ${rom.name}: $e',
        tag: 'WebEmulatorService',
      );
      _debug.error('Stack trace: $stackTrace', tag: 'WebEmulatorService');

      // Clean up on error
      if (_currentEmulatorId != null) {
        _emulators.remove(_currentEmulatorId!);
        _currentEmulatorId = null;
        _currentRom = null;
      }

      return LaunchResult.failure('Failed to launch ROM: ${e.toString()}');
    }
  }

  /// Resolve ROM download URL for web playback.
  ///
  /// Resolves special URLs (MediaFire, Google Drive, Dropbox) to direct
  /// download links, then optionally wraps with a CORS proxy.
  Future<String?> _resolveRomUrl(RomItem rom) async {
    try {
      _debug.info(
        'Resolving ROM URL for: ${rom.name}',
        tag: 'WebEmulatorService',
      );

      // Get the raw download URL
      String? downloadUrl = rom.downloadUrl;
      if (downloadUrl == null) {
        downloadUrl = await rom.loadDownloadUrl();
        if (downloadUrl == null) {
          _debug.error(
            'No download URL available for: ${rom.name}',
            tag: 'WebEmulatorService',
          );
          return null;
        }
      }

      // Resolve special URLs (MediaFire → direct, Google Drive → direct, etc.)
      final resolvedUrl = await _downloadResolver.resolveDownloadUrl(
        downloadUrl,
      );
      if (resolvedUrl == null) {
        _debug.error(
          'Failed to resolve download URL: $downloadUrl',
          tag: 'WebEmulatorService',
        );
        return null;
      }

      // Apply CORS proxy if configured
      final finalUrl = _applyCorsProxy(resolvedUrl);

      _debug.info('ROM URL resolved: $finalUrl', tag: 'WebEmulatorService');
      return finalUrl;
    } catch (e) {
      _debug.error('Failed to resolve ROM URL: $e', tag: 'WebEmulatorService');
      return null;
    }
  }

  /// Domains known to send CORS headers — no proxy needed.
  /// NOTE: archive.org does NOT send CORS headers for XHR/fetch from
  /// arbitrary origins, so it must NOT be listed here.
  static const _corsFriendlyDomains = <String>[];

  /// Returns `true` when the [url] host is (or is a subdomain of) a
  /// CORS-friendly domain, so the proxy can be skipped.
  bool _isCorsFriendly(String url) {
    try {
      final host = Uri.parse(url).host.toLowerCase();
      return _corsFriendlyDomains.any(
        (domain) => host == domain || host.endsWith('.$domain'),
      );
    } catch (_) {
      return false;
    }
  }

  /// Wrap a URL with the CORS proxy if configured.
  ///
  /// Skips the proxy for domains that already serve CORS headers.
  ///
  /// Produces: `{corsProxyUrl}?url={encodedTargetUrl}`
  ///
  /// The ROM is downloaded by the JS bridge via fetch (not by EmulatorJS
  /// directly), so the proxy URL format doesn't need to encode the
  /// filename — the bridge converts the response to a blob: URL.
  String _applyCorsProxy(String url) {
    if (corsProxyUrl == null || corsProxyUrl!.isEmpty) {
      return url;
    }
    if (_isCorsFriendly(url)) {
      _debug.info(
        'Skipping CORS proxy for CORS-friendly URL: $url',
        tag: 'WebEmulatorService',
      );
      return url;
    }
    final base = corsProxyUrl!.endsWith('/') ? corsProxyUrl! : '$corsProxyUrl/';
    return '$base?url=${Uri.encodeComponent(url)}';
  }

  /// Stop an emulator instance
  Future<void> stopEmulator(String containerId) async {
    try {
      final emulator = _emulators[containerId];
      if (emulator != null) {
        emulator.stop();
        _emulators.remove(containerId);

        if (_currentEmulatorId == containerId) {
          _currentEmulatorId = null;
          _currentRom = null;
        }

        _debug.info(
          'Emulator stopped: $containerId',
          tag: 'WebEmulatorService',
        );
      }
    } catch (e) {
      _debug.error(
        'Error stopping emulator $containerId: $e',
        tag: 'WebEmulatorService',
      );
    }
  }

  /// Pause the current emulator
  void pauseEmulator([String? containerId]) {
    final id = containerId ?? _currentEmulatorId;
    if (id != null) {
      final emulator = _emulators[id];
      emulator?.pause();
      _debug.info('Emulator paused: $id', tag: 'WebEmulatorService');
    }
  }

  /// Resume the current emulator
  void resumeEmulator([String? containerId]) {
    final id = containerId ?? _currentEmulatorId;
    if (id != null) {
      final emulator = _emulators[id];
      emulator?.resume();
      _debug.info('Emulator resumed: $id', tag: 'WebEmulatorService');
    }
  }

  /// Reset the current emulator
  void resetEmulator([String? containerId]) {
    final id = containerId ?? _currentEmulatorId;
    if (id != null) {
      final emulator = _emulators[id];
      emulator?.reset();
      _debug.info('Emulator reset: $id', tag: 'WebEmulatorService');
    }
  }

  /// Create a save state
  Future<Uint8List?> createSaveState([String? containerId]) async {
    final id = containerId ?? _currentEmulatorId;
    if (id != null) {
      final emulator = _emulators[id];
      if (emulator != null) {
        try {
          final saveData = await emulator.createSaveState();
          _debug.info('Save state created for: $id', tag: 'WebEmulatorService');
          return saveData;
        } catch (e) {
          _debug.error(
            'Failed to create save state: $e',
            tag: 'WebEmulatorService',
          );
        }
      }
    }
    return null;
  }

  /// Load a save state
  Future<bool> loadSaveState(Uint8List saveData, [String? containerId]) async {
    final id = containerId ?? _currentEmulatorId;
    if (id != null) {
      final emulator = _emulators[id];
      if (emulator != null) {
        try {
          await emulator.loadSaveState(saveData);
          _debug.info('Save state loaded for: $id', tag: 'WebEmulatorService');
          return true;
        } catch (e) {
          _debug.error(
            'Failed to load save state: $e',
            tag: 'WebEmulatorService',
          );
        }
      }
    }
    return false;
  }

  /// Take a screenshot
  Future<String?> getScreenshot([String? containerId]) async {
    final id = containerId ?? _currentEmulatorId;
    if (id != null) {
      final emulator = _emulators[id];
      if (emulator != null) {
        try {
          return await emulator.getScreenshot();
        } catch (e) {
          _debug.error(
            'Failed to get screenshot: $e',
            tag: 'WebEmulatorService',
          );
        }
      }
    }
    return null;
  }

  /// Get emulator status
  EmulatorStatus? getEmulatorStatus([String? containerId]) {
    final id = containerId ?? _currentEmulatorId;
    if (id != null) {
      final emulator = _emulators[id];
      return emulator?.getStatus();
    }
    return null;
  }

  /// Check if platform is supported
  bool isPlatformSupported(String platform) {
    return _coreManager.hasCoreSupport(platform);
  }

  /// Get supported platforms
  List<String> getSupportedPlatforms() {
    final platforms = <String>[];

    for (final core in _coreManager.allCores.values) {
      platforms.addAll(core.supportedPlatforms);
    }

    return platforms.toSet().toList()..sort();
  }

  /// Get core loading progress for a platform
  CoreLoadingProgress getCoreLoadingProgress(String platform) {
    return _coreManager.getLoadingState(platform);
  }

  /// Check if a ROM file is supported
  bool isRomFileSupported(String filename) {
    return _coreManager.isFileSupported(filename);
  }

  /// Get platform from ROM filename
  String? getPlatformFromRomFile(String filename) {
    return _coreManager.getPlatformFromFile(filename);
  }

  /// Get currently playing ROM
  RomItem? get currentRom => _currentRom;

  /// Check if any emulator is currently running
  bool get isEmulatorRunning => _currentEmulatorId != null;

  /// Get active emulator IDs
  List<String> get activeEmulators => _emulators.keys.toList();

  /// Cleanup all emulators
  Future<void> cleanup() async {
    _debug.info('Cleaning up WebEmulatorService...', tag: 'WebEmulatorService');

    final emulatorIds = _emulators.keys.toList();
    for (final id in emulatorIds) {
      await stopEmulator(id);
    }

    _currentEmulatorId = null;
    _currentRom = null;

    _debug.info(
      'WebEmulatorService cleanup complete',
      tag: 'WebEmulatorService',
    );
  }

  /// Get service statistics
  Map<String, dynamic> getStats() {
    return {
      'active_emulators': _emulators.length,
      'current_rom': _currentRom?.name,
      'current_platform': _currentRom?.platform,
      'supported_platforms': getSupportedPlatforms().length,
      'core_manager_stats': _coreManager.getCacheStats(),
    };
  }
}
