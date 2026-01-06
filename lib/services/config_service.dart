import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      debugPrint('ConfigService initialized');
      debugPrint(
        'Config source: ${_hasLocalOverrides ? 'shared_preferences' : 'assets/config.json'}',
      );
      debugPrint('Has local overrides: $_hasLocalOverrides');
    } catch (e) {
      debugPrint('Error initializing ConfigService: $e');
      // Don't throw - allow app to continue with empty config
      _config = {'emulators': []};
    }
  }

  /// Load configuration from shared_preferences or assets
  ///
  /// Priority:
  /// 1. shared_preferences (user overrides) - if exists
  /// 2. assets/config.json (bundled default)
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
        debugPrint('Loading config from shared_preferences');
        _config = json.decode(configString) as Map<String, dynamic>;
        _hasLocalOverrides = true;
        return _config!;
      }

      // If no local config, load from assets
      debugPrint('Loading config from assets: assets/config.json');
      final assetString = await rootBundle.loadString('assets/config.json');
      _config = json.decode(assetString) as Map<String, dynamic>;
      _hasLocalOverrides = false;

      return _config!;
    } catch (e) {
      debugPrint('Error loading config: $e');
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
    debugPrint('Force reloading config from source');
    _config = null;
    await loadConfig(forceReload: true);
    debugPrint('Config reloaded successfully');
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

      debugPrint('Config saved to shared_preferences');
    } catch (e) {
      debugPrint('Error saving config: $e');
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
      debugPrint('Deleted local config overrides from shared_preferences');

      // Reload from assets
      await loadConfig();
      debugPrint('Reset to default config from assets');
    } catch (e) {
      debugPrint('Error resetting config: $e');
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

  /// Get gamelist directory path from environment
  String get gamelistPath =>
      dotenv.maybeGet('GAMELIST_PATH') ?? '/path/to/gamelists';

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

      debugPrint('Environment variables saved to .env file');
    } catch (e) {
      debugPrint('Error saving .env file: $e');
      rethrow;
    }
  }

  /// Reload environment variables from .env file
  Future<void> reloadEnv() async {
    try {
      await dotenv.load(fileName: '.env');
      debugPrint('Environment variables reloaded');
    } catch (e) {
      debugPrint('Error reloading .env: $e');
      rethrow;
    }
  }
}
