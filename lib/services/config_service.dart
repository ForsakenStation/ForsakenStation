import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'debug_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

/// Service for managing application configuration.
///
/// Handles:
/// - Reading emulator configurations from assets/config.json (bundled)
/// - Writing modified configurations to shared_preferences (user overrides)
/// - Managing user-configurable paths via SharedPreferences
/// - Providing convenient accessors for common config values
///
/// The config uses a two-tier system:
/// 1. Base config from assets/config.json (read-only, bundled with app)
/// 2. User overrides in shared_preferences (writable, cross-platform)
class ConfigService {
  static ConfigService? _instance;
  static const String _configKey = 'forsaken_emulator_config';
  static const String _corsProxyKey = 'forsaken_cors_proxy_url';

  // SharedPreferences keys for path settings
  static const String _mediaPathKey = 'forsaken_media_path';
  static const String _emulatorsPathKey = 'forsaken_emulators_path';
  static const String _emulatorsConfigPathKey =
      'forsaken_emulators_config_path';
  static const String _romTempPathKey = 'forsaken_rom_temp_path';
  static const String _romForeverPathKey = 'forsaken_rom_forever_path';
  static const String _debugEnabledKey = 'forsaken_debug_enabled';
  static const String _debugMinLevelKey = 'forsaken_debug_min_level';
  static const String _romsPathKey = 'forsaken_roms_path';
  static const String _setupCompletedKey = 'forsaken_setup_completed';
  static const String _archiveOrgAccessKeyKey =
      'forsaken_archive_org_access_key';
  static const String _archiveOrgSecretKeyKey =
      'forsaken_archive_org_secret_key';

  Map<String, dynamic>? _config;
  bool _hasLocalOverrides = false;

  // In-memory cache for path settings (loaded from SharedPreferences)
  String _mediaPath = '';
  String _emulatorsPath = '';
  String _emulatorsConfigPath = '';
  String _romsPath = '';
  String _romTempPath = '';
  String _romForeverPath = '';
  bool _isDebugEnabled = false;
  String _debugMinLevel = 'debug';
  bool _setupCompleted = false;
  String _archiveOrgAccessKey = '';
  String _archiveOrgSecretKey = '';

  ConfigService._();

  /// Get the singleton instance
  static ConfigService get instance {
    _instance ??= ConfigService._();
    return _instance!;
  }

  /// Initialize the config service
  ///
  /// Loads path settings from SharedPreferences and emulator config
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load path settings from SharedPreferences
      await _loadPathSettings(prefs);

      // Try to load emulator config (shared_preferences first, then assets)
      await loadConfig();

      DebugService.instance.info(
        'ConfigService initialized',
        tag: 'ConfigService',
      );
      DebugService.instance.info(
        'Config source: ${_hasLocalOverrides ? 'shared_preferences' : 'assets/config.json'}',
        tag: 'ConfigService',
      );
      DebugService.instance.debug(
        'Has local overrides: $_hasLocalOverrides',
        tag: 'ConfigService',
      );
    } catch (e) {
      DebugService.instance.error(
        'Error initializing ConfigService: $e',
        tag: 'ConfigService',
      );
      // Don't throw - allow app to continue with empty config
      _config = {'emulators': []};
    }
  }

  /// Load all path settings from SharedPreferences into in-memory cache
  Future<void> _loadPathSettings(SharedPreferences prefs) async {
    // Compute platform-appropriate defaults
    String defaultMediaPath = '';
    String defaultEmulatorsPath = '';
    String defaultEmulatorsConfigPath = '';
    String defaultRomTempPath = '';
    String defaultRomForeverPath = '';

    if (!kIsWeb) {
      final appDir = await getApplicationSupportDirectory();
      final tempDir = await getTemporaryDirectory();
      defaultMediaPath = path.join(appDir.path, 'media');
      defaultEmulatorsPath = path.join(appDir.path, 'emulators');
      defaultEmulatorsConfigPath = path.join(
        appDir.path,
        'emulators',
        'config.json',
      );
      defaultRomTempPath = path.join(tempDir.path, 'forsaken_roms');
      defaultRomForeverPath = path.join(appDir.path, 'roms');
    }

    _mediaPath = prefs.getString(_mediaPathKey) ?? defaultMediaPath;
    _emulatorsPath = prefs.getString(_emulatorsPathKey) ?? defaultEmulatorsPath;
    _emulatorsConfigPath =
        prefs.getString(_emulatorsConfigPathKey) ?? defaultEmulatorsConfigPath;
    _romsPath = prefs.getString(_romsPathKey) ?? '';
    _romTempPath = prefs.getString(_romTempPathKey) ?? defaultRomTempPath;
    _romForeverPath =
        prefs.getString(_romForeverPathKey) ?? defaultRomForeverPath;
    _isDebugEnabled = prefs.getBool(_debugEnabledKey) ?? false;
    _debugMinLevel = prefs.getString(_debugMinLevelKey) ?? 'debug';
    _setupCompleted = prefs.getBool(_setupCompletedKey) ?? false;
    _archiveOrgAccessKey = prefs.getString(_archiveOrgAccessKeyKey) ?? '';
    _archiveOrgSecretKey = prefs.getString(_archiveOrgSecretKeyKey) ?? '';

    DebugService.instance.debug(
      'Path settings loaded from SharedPreferences',
      tag: 'ConfigService',
    );
  }

  /// Get the platform-specific config file name
  String _getPlatformConfigFile() {
    if (kIsWeb) {
      return 'assets/configs/config.web.json';
    } else if (Platform.isAndroid) {
      return 'assets/configs/config.android.json';
    } else if (Platform.isIOS) {
      return 'assets/configs/config.ios.json';
    } else if (Platform.isMacOS) {
      return 'assets/configs/config.macos.json';
    } else if (Platform.isWindows) {
      return 'assets/configs/config.windows.json';
    } else if (Platform.isLinux) {
      return 'assets/configs/config.linux.json';
    }

    // Fallback to default config.json
    return 'assets/config.json';
  }

  /// Load configuration from shared_preferences or assets
  ///
  /// Priority:
  /// 1. shared_preferences (user overrides) - if exists
  /// 2. Platform-specific config (assets/configs/config.{platform}.json)
  /// 3. Default config (assets/config.json) as fallback
  ///
  /// Set forceReload to true to bypass cache and reload from source
  Future<Map<String, dynamic>> loadConfig({bool forceReload = false}) async {
    // Return cached config if available and not forcing reload
    if (!forceReload && _config != null) {
      return _config!;
    }

    try {
      // Try to load from shared_preferences first (user overrides)
      final prefs = await SharedPreferences.getInstance();
      final configString = prefs.getString(_configKey);

      if (configString != null && configString.isNotEmpty) {
        DebugService.instance.debug(
          'Loading config from shared_preferences',
          tag: 'ConfigService',
        );
        _config = json.decode(configString) as Map<String, dynamic>;
        _hasLocalOverrides = true;
        return _config!;
      }

      // If no local config, load platform-specific config from assets
      final platformConfigPath = _getPlatformConfigFile();
      DebugService.instance.debug(
        'Loading config from assets: $platformConfigPath',
        tag: 'ConfigService',
      );

      String assetString;
      try {
        assetString = await rootBundle.loadString(platformConfigPath);
      } catch (e) {
        // If platform-specific config not found, fallback to default
        DebugService.instance.info(
          'Platform-specific config not found, using default: $e',
          tag: 'ConfigService',
        );
        assetString = await rootBundle.loadString('assets/config.json');
      }

      _config = json.decode(assetString) as Map<String, dynamic>;
      _hasLocalOverrides = false;

      return _config!;
    } catch (e) {
      DebugService.instance.error(
        'Error loading config: $e',
        tag: 'ConfigService',
      );
      _config = {'emulators': []};
      _hasLocalOverrides = false;
      return _config!;
    }
  }

  /// Force reload configuration from source
  ///
  /// Clears cache and reloads from shared_preferences or assets
  /// Useful when config file has been modified externally
  Future<void> reloadConfig() async {
    DebugService.instance.info(
      'Force reloading config from source',
      tag: 'ConfigService',
    );
    _config = null;
    await loadConfig(forceReload: true);
    DebugService.instance.info(
      'Config reloaded successfully',
      tag: 'ConfigService',
    );
  }

  /// Save configuration to shared_preferences
  ///
  /// Saves user modifications to shared_preferences (not to bundled assets)
  Future<void> saveConfig(Map<String, dynamic> config) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Write formatted JSON to shared_preferences
      final jsonString = json.encode(config);
      await prefs.setString(_configKey, jsonString);

      _config = config;
      _hasLocalOverrides = true;

      DebugService.instance.info(
        'Config saved to shared_preferences',
        tag: 'ConfigService',
      );
    } catch (e) {
      DebugService.instance.error(
        'Error saving config: $e',
        tag: 'ConfigService',
      );
      rethrow;
    }
  }

  /// Reset configuration to bundled defaults
  ///
  /// Deletes local overrides from shared_preferences and reloads from assets
  Future<void> resetToDefaults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_configKey);
      DebugService.instance.info(
        'Deleted local config overrides from shared_preferences',
        tag: 'ConfigService',
      );

      // Reload from assets
      await loadConfig();
      DebugService.instance.info(
        'Reset to default config from assets',
        tag: 'ConfigService',
      );
    } catch (e) {
      DebugService.instance.error(
        'Error resetting config: $e',
        tag: 'ConfigService',
      );
      rethrow;
    }
  }

  /// Get current config (loads if not already loaded)
  Future<Map<String, dynamic>> getConfig() async {
    if (_config == null) {
      await loadConfig();
    }
    return _config!;
  }

  /// Get list of emulator configurations
  Future<List<Map<String, dynamic>>> getEmulators() async {
    final config = await getConfig();
    final emulators = config['emulators'];

    if (emulators is List) {
      return emulators.cast<Map<String, dynamic>>();
    }

    return [];
  }

  /// Get emulator configuration for a specific platform
  Future<Map<String, dynamic>?> getEmulatorForPlatform(String platform) async {
    final emulators = await getEmulators();

    try {
      return emulators.firstWhere((e) => e['system'] == platform);
    } catch (e) {
      return null;
    }
  }

  /// Add a new emulator configuration
  Future<void> addEmulator(Map<String, dynamic> emulator) async {
    final config = await getConfig();
    final emulators = config['emulators'] as List? ?? [];

    emulators.add(emulator);
    config['emulators'] = emulators;

    await saveConfig(config);
  }

  /// Update an existing emulator configuration
  Future<void> updateEmulator(
    String system,
    Map<String, dynamic> emulator,
  ) async {
    final config = await getConfig();
    final emulators = config['emulators'] as List? ?? [];

    final index = emulators.indexWhere((e) => e['system'] == system);

    if (index != -1) {
      emulators[index] = emulator;
      config['emulators'] = emulators;
      await saveConfig(config);
    }
  }

  /// Remove an emulator configuration
  Future<void> removeEmulator(String system) async {
    final config = await getConfig();
    final emulators = config['emulators'] as List? ?? [];

    emulators.removeWhere((e) => e['system'] == system);
    config['emulators'] = emulators;

    await saveConfig(config);
  }

  // Path setting getters (backed by SharedPreferences)

  /// Get ROMs directory path
  String get romsPath => _romsPath;

  /// Get media directory path
  String get mediaPath => _mediaPath;

  /// Get emulators directory path
  String get emulatorsPath => _emulatorsPath;

  /// Get emulators config file path
  String get emulatorsConfigPath => _emulatorsConfigPath;

  /// Get config file path/source description
  ///
  /// Returns a description of where config is stored
  String get configPath {
    if (_hasLocalOverrides) {
      return 'shared_preferences (custom configuration)';
    }
    return 'assets/config.json (bundled with app)';
  }

  /// Get whether config has been modified from defaults
  bool get hasLocalOverrides => _hasLocalOverrides;

  /// Get gamelist directory path
  ///
  /// Returns the local gamelist directory in app's data directory
  /// Structure: ~/.local/share/com.forsaken.emulator/gamelists/{platform}/gamelist.xml
  Future<String> get gamelistPath async {
    if (kIsWeb) {
      // Web doesn't support local file system - would need backend or IndexedDB
      return '/gamelists';
    }

    final appDir = await getApplicationSupportDirectory();
    return path.join(appDir.path, 'gamelists');
  }

  /// Get temporary ROM storage path
  ///
  /// Used for ROMs downloaded temporarily for single play sessions
  String get romTempPath => _romTempPath;

  /// Get permanent ROM storage path
  ///
  /// Used for ROMs saved permanently for offline play
  String get romForeverPath => _romForeverPath;

  /// Check if debug mode is enabled
  bool get isDebugEnabled => _isDebugEnabled;

  /// Get minimum debug log level
  String get debugMinLevel => _debugMinLevel;

  /// Check if the setup wizard has been completed
  bool get isSetupCompleted => _setupCompleted;

  /// Get Archive.org S3 access key
  String get archiveOrgAccessKey => _archiveOrgAccessKey;

  /// Get Archive.org S3 secret key
  String get archiveOrgSecretKey => _archiveOrgSecretKey;

  /// Check if Archive.org credentials are configured
  bool get hasArchiveOrgCredentials =>
      _archiveOrgAccessKey.isNotEmpty && _archiveOrgSecretKey.isNotEmpty;

  /// Set Archive.org S3 access key
  Future<void> setArchiveOrgAccessKey(String value) async {
    final prefs = await SharedPreferences.getInstance();
    _archiveOrgAccessKey = value;
    await prefs.setString(_archiveOrgAccessKeyKey, value);
  }

  /// Set Archive.org S3 secret key
  Future<void> setArchiveOrgSecretKey(String value) async {
    final prefs = await SharedPreferences.getInstance();
    _archiveOrgSecretKey = value;
    await prefs.setString(_archiveOrgSecretKeyKey, value);
  }

  /// Mark the setup wizard as completed or not
  Future<void> setSetupCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _setupCompleted = value;
    await prefs.setBool(_setupCompletedKey, value);
  }

  /// Set a path setting and persist to SharedPreferences
  Future<void> setPathSetting(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();

    switch (key) {
      case 'MEDIA_PATH':
        _mediaPath = value;
        await prefs.setString(_mediaPathKey, value);
        break;
      case 'EMULATORS_PATH':
        _emulatorsPath = value;
        await prefs.setString(_emulatorsPathKey, value);
        break;
      case 'EMULATORS_CONFIG_PATH':
        _emulatorsConfigPath = value;
        await prefs.setString(_emulatorsConfigPathKey, value);
        break;
      case 'ROM_TEMP_PATH':
        _romTempPath = value;
        await prefs.setString(_romTempPathKey, value);
        break;
      case 'ROM_FOREVER_PATH':
        _romForeverPath = value;
        await prefs.setString(_romForeverPathKey, value);
        break;
      case 'ROMS_PATH':
        _romsPath = value;
        await prefs.setString(_romsPathKey, value);
        break;
      case 'DEBUG_ENABLED':
        _isDebugEnabled = value.toLowerCase() == 'true';
        await prefs.setBool(_debugEnabledKey, _isDebugEnabled);
        break;
      case 'DEBUG_MIN_LEVEL':
        _debugMinLevel = value;
        await prefs.setString(_debugMinLevelKey, value);
        break;
      default:
        DebugService.instance.warning(
          'Unknown path setting key: $key',
          tag: 'ConfigService',
        );
        return;
    }

    DebugService.instance.debug(
      'Path setting updated: $key',
      tag: 'ConfigService',
    );
  }

  /// Save multiple path settings at once
  ///
  /// Convenience method for the System Paths screen
  Future<void> savePathSettings(Map<String, String> settings) async {
    for (final entry in settings.entries) {
      await setPathSetting(entry.key, entry.value);
    }
    DebugService.instance.info(
      'Path settings saved (${settings.length} values)',
      tag: 'ConfigService',
    );
  }

  /// Get CORS proxy URL from shared_preferences
  ///
  /// Returns null if not configured (CORS proxy disabled).
  Future<String?> getCorsProxyUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_corsProxyKey);
  }

  /// Save CORS proxy URL to shared_preferences
  ///
  /// Pass null or empty string to disable CORS proxy.
  Future<void> setCorsProxyUrl(String? url) async {
    final prefs = await SharedPreferences.getInstance();
    if (url == null || url.isEmpty) {
      await prefs.remove(_corsProxyKey);
    } else {
      await prefs.setString(_corsProxyKey, url);
    }
  }
}
