import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'debug_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

/// Service for managing application configuration from config.json and .env files.
///
/// Handles:
/// - Reading emulator configurations from assets/config.json (bundled)
/// - Writing modified configurations to shared_preferences (user overrides)
/// - Managing environment variables from .env file
/// - Providing convenient accessors for common config values
///
/// The config uses a two-tier system:
/// 1. Base config from assets/config.json (read-only, bundled with app)
/// 2. User overrides in shared_preferences (writable, cross-platform)
class ConfigService {
  static ConfigService? _instance;
  static const String _configKey = 'forsaken_emulator_config';
  static const String _corsProxyKey = 'forsaken_cors_proxy_url';

  Map<String, dynamic>? _config;
  bool _hasLocalOverrides = false;

  ConfigService._();

  /// Get the singleton instance
  static ConfigService get instance {
    _instance ??= ConfigService._();
    return _instance!;
  }

  /// Initialize the config service
  ///
  /// Loads the .env file and checks for user overrides in shared_preferences
  Future<void> initialize() async {
    try {
      // Load .env file if not already loaded
      if (!dotenv.isInitialized) {
        await dotenv.load(fileName: '.env');
      }

      // Try to load config (will try shared_preferences first, then assets)
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

  // Environment variable getters

  /// Get ROMs directory path from environment
  String get romsPath => dotenv.maybeGet('ROMS_PATH') ?? '/path/to/roms';

  /// Get media directory path from environment
  String get mediaPath => dotenv.maybeGet('MEDIA_PATH') ?? '/path/to/media';

  /// Get emulators directory path from environment
  String get emulatorsPath =>
      dotenv.maybeGet('EMULATORS_PATH') ?? '/path/to/emulators';

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

  /// Get temporary ROM storage path from environment
  ///
  /// Used for ROMs downloaded temporarily for single play sessions
  String? get romTempPath => dotenv.maybeGet('ROM_TEMP_PATH');

  /// Get permanent ROM storage path from environment
  ///
  /// Used for ROMs saved permanently for offline play
  String? get romForeverPath => dotenv.maybeGet('ROM_FOREVER_PATH');

  /// Check if debug mode is enabled
  bool get isDebugEnabled =>
      dotenv.maybeGet('DEBUG_ENABLED')?.toLowerCase() == 'true';

  /// Get minimum debug log level
  String get debugMinLevel => dotenv.maybeGet('DEBUG_MIN_LEVEL') ?? 'debug';

  /// Update a specific environment variable
  ///
  /// Note: This updates the in-memory dotenv map but does NOT write to .env file
  /// To persist changes, use [saveEnvFile]
  void setEnvVariable(String key, String value) {
    dotenv.env[key] = value;
  }

  /// Save current environment variables to .env file
  Future<void> saveEnvFile() async {
    try {
      final envFile = File(path.join(Directory.current.path, '.env'));

      final buffer = StringBuffer();
      buffer.writeln('# Emulator Frontend Configuration');
      buffer.writeln();

      // Write each environment variable
      dotenv.env.forEach((key, value) {
        buffer.writeln('$key=$value');
      });

      await envFile.writeAsString(buffer.toString());

      DebugService.instance.info(
        'Environment variables saved to .env file',
        tag: 'ConfigService',
      );
    } catch (e) {
      DebugService.instance.error(
        'Error saving .env file: $e',
        tag: 'ConfigService',
      );
      rethrow;
    }
  }

  /// Reload environment variables from .env file
  Future<void> reloadEnv() async {
    try {
      await dotenv.load(fileName: '.env');
      DebugService.instance.info(
        'Environment variables reloaded',
        tag: 'ConfigService',
      );
    } catch (e) {
      DebugService.instance.error(
        'Error reloading .env: $e',
        tag: 'ConfigService',
      );
      rethrow;
    }
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
