import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/rom.dart';
import '../models/rom_item.dart';
import '../models/emulator_config.dart';
import '../models/launch_result.dart';
import 'download_service.dart';
import 'debug_service.dart';
import 'config_service.dart';

class EmulatorService {
  static EmulatorService? _instance;

  final String emulatorsBasePath;
  final DownloadService downloadService;
  final _debug = DebugService.instance;
  final _configService = ConfigService.instance;

  EmulatorsConfig? _config;
  DateTime? _configLoadTime;

  EmulatorService._({
    required this.emulatorsBasePath,
    required this.downloadService,
  });

  /// Get the singleton instance
  static EmulatorService get instance {
    if (_instance == null) {
      final emulatorsPath = dotenv.env['EMULATORS_PATH'] ?? '';

      _instance = EmulatorService._(
        emulatorsBasePath: emulatorsPath,
        downloadService: DownloadService.instance,
      );
    }
    return _instance!;
  }

  /// Initialize the service with custom paths (for testing or custom config)
  static void initialize({
    required String emulatorsBasePath,
    required DownloadService downloadService,
  }) {
    _instance = EmulatorService._(
      emulatorsBasePath: emulatorsBasePath,
      downloadService: downloadService,
    );
  }

  /// Load the main emulators configuration file
  Future<EmulatorsConfig?> _loadConfig({bool forceReload = false}) async {
    // Cache config for 5 seconds to avoid repeated reads
    if (!forceReload &&
        _config != null &&
        _configLoadTime != null &&
        DateTime.now().difference(_configLoadTime!).inSeconds < 5) {
      return _config;
    }

    _debug.info(
      'Loading emulators config from ConfigService',
      tag: 'EmulatorService',
    );

    try {
      final configData = await _configService.loadConfig();
      _config = EmulatorsConfig.fromJson(configData);
      _configLoadTime = DateTime.now();

      if (_config != null) {
        _debug.info(
          'Loaded ${_config!.emulators.length} platform configurations',
          tag: 'EmulatorService',
        );
      }

      return _config;
    } catch (e) {
      _debug.error(
        'Error loading emulators config',
        tag: 'EmulatorService',
        error: e,
      );
      return null;
    }
  }

  /// Force reload the configuration from ConfigService
  ///
  /// This will refresh the config from shared_preferences or assets,
  /// bypassing the cache
  Future<void> reloadConfig() async {
    _debug.info('Force reloading emulators config', tag: 'EmulatorService');
    _config = null;
    _configLoadTime = null;
    await _loadConfig(forceReload: true);
  }

  /// Load emulator configuration for a specific platform
  Future<EmulatorConfig?> loadPlatformConfig(String platform) async {
    final config = await _loadConfig();
    if (config == null) {
      _debug.error('Failed to load emulators config', tag: 'EmulatorService');
      return null;
    }

    final platformConfig = config.getConfigForPlatform(platform);
    if (platformConfig == null) {
      _debug.warning(
        'No configuration found for platform: $platform',
        tag: 'EmulatorService',
      );
    } else {
      _debug.info(
        'Found ${platformConfig.commands.length} emulator(s) for $platform',
        tag: 'EmulatorService',
      );
    }

    return platformConfig;
  }

  /// Check if emulator is configured for a platform
  Future<bool> isPlatformConfigured(String platform) async {
    final config = await _loadConfig();
    return config?.isPlatformConfigured(platform) ?? false;
  }

  /// Launch emulator with a specific command
  Future<bool> launchWithCommand({
    required EmulatorCommand command,
    required String romPath,
    required String platform,
  }) async {
    try {
      String emulatorPath;

      // Check if command is a relative path (starts with ./ or ../)
      if (command.command.startsWith('./') ||
          command.command.startsWith('../')) {
        // Resolve relative to emulators base path
        emulatorPath = path.normalize(
          path.join(emulatorsBasePath, command.command),
        );
      } else if (command.command.startsWith('/')) {
        // Absolute path, use as-is
        emulatorPath = command.command;
      } else {
        // Relative to EMULATORS_PATH
        emulatorPath = path.join(emulatorsBasePath, command.command);
      }

      _debug.info(
        'Launching emulator: ${command.name}',
        tag: 'EmulatorService',
      );
      _debug.debug('Emulator path: $emulatorPath', tag: 'EmulatorService');
      _debug.debug('ROM path: $romPath', tag: 'EmulatorService');

      // Check if emulator exists
      final emulatorFile = File(emulatorPath);
      if (!await emulatorFile.exists()) {
        _debug.error(
          'Emulator not found at: $emulatorPath',
          tag: 'EmulatorService',
        );
        return false;
      }

      // Check if ROM exists
      final romFile = File(romPath);
      if (!await romFile.exists()) {
        _debug.error('ROM not found at: $romPath', tag: 'EmulatorService');
        return false;
      }

      // Build command arguments with ROM path
      final args = command.buildCommand(romPath);

      _debug.info(
        'Command: $emulatorPath ${args.join(' ')}',
        tag: 'EmulatorService',
      );
      _debug.debug(
        'Working directory: $emulatorsBasePath',
        tag: 'EmulatorService',
      );
      _debug.debug(
        "Environment: DISPLAY=${Platform.environment['DISPLAY']}",
        tag: 'EmulatorService',
      );

      // Launch emulator process
      // Pass environment variables explicitly to ensure UI displays correctly
      final process = await Process.start(
        emulatorPath,
        args,
        mode: ProcessStartMode.detached,
        workingDirectory: emulatorsBasePath,
        environment: {
          'DISPLAY': Platform.environment['DISPLAY'] ?? ':0',
          'HOME': Platform.environment['HOME'] ?? '',
          'XDG_RUNTIME_DIR': Platform.environment['XDG_RUNTIME_DIR'] ?? '',
          'WAYLAND_DISPLAY': Platform.environment['WAYLAND_DISPLAY'] ?? '',
        }..removeWhere((key, value) => value.isEmpty),
      );

      _debug.info(
        'Emulator launched with PID: ${process.pid}',
        tag: 'EmulatorService',
      );

      // Give the process a moment to initialize
      await Future.delayed(Duration(milliseconds: 500));

      // Verify process is still running
      try {
        final result = await Process.run('ps', ['-p', '${process.pid}']);
        if (result.exitCode == 0) {
          _debug.debug(
            'Process ${process.pid} is running',
            tag: 'EmulatorService',
          );
        } else {
          _debug.warning(
            'Process ${process.pid} may have terminated',
            tag: 'EmulatorService',
          );
        }
      } catch (e) {
        _debug.warning(
          'Could not verify process status',
          tag: 'EmulatorService',
        );
      }

      // In detached mode, we can't read stdout/stderr
      // The process runs completely independently

      // Don't wait for process to complete - let it run independently
      // The process will continue running even after this method returns

      return true;
    } catch (e) {
      _debug.error(
        'Error launching emulator',
        tag: 'EmulatorService',
        error: e,
      );
      return false;
    }
  }

  /// Launch emulator for a ROM (download first if needed)
  /// Returns LaunchResult with success status and file path
  /// If the file is a PDF, it will NOT launch an emulator and will set isPdf=true
  Future<LaunchResult> launchRom({
    required RomItem romItem,
    required String platform,
    EmulatorCommand? selectedCommand,
    Function(double progress, int received, int total)? onDownloadProgress,
  }) async {
    try {
      _debug.info(
        'Attempting to launch ROM: ${romItem.displayName}',
        tag: 'EmulatorService',
      );
      _debug.debug('Platform: $platform', tag: 'EmulatorService');

      String romPath;

      // Check if ROM needs to be downloaded
      if (romItem.downloadUrl != null && romItem.downloadUrl!.isNotEmpty) {
        _debug.info(
          'ROM has download URL: ${romItem.downloadUrl}',
          tag: 'EmulatorService',
        );
        _debug.debug(
          'Will download to: _temp/$platform/${romItem.name}',
          tag: 'EmulatorService',
        );

        // Create a temporary Rom object for download
        final rom = Rom(
          name: romItem.name,
          fileName: romItem.name,
          platform: platform,
          urlFilePath: romItem.path,
        );
        rom.downloadUrl = romItem.downloadUrl;

        // Download ROM
        final downloadedPath = await downloadService.downloadRom(
          rom,
          onProgress: onDownloadProgress,
        );
        if (downloadedPath == null) {
          _debug.error('Failed to download ROM', tag: 'EmulatorService');
          return LaunchResult.failure('Failed to download file');
        }

        _debug.info(
          'Downloaded ROM to: $downloadedPath',
          tag: 'EmulatorService',
        );
        romPath = downloadedPath;
      } else {
        // Use local ROM file
        romPath = romItem.path;
      }

      // Check if the file is a PDF
      final extension = path.extension(romPath).toLowerCase();
      if (extension == '.pdf') {
        _debug.info(
          'Detected PDF file, will not launch emulator',
          tag: 'EmulatorService',
        );
        return LaunchResult.success(filePath: romPath, isPdf: true);
      }

      // Load platform configuration
      final config = await loadPlatformConfig(platform);
      if (config == null || config.commands.isEmpty) {
        _debug.error(
          'No emulator configuration found for platform: $platform',
          tag: 'EmulatorService',
        );
        return LaunchResult.failure(
          'No emulator configuration found for platform: $platform',
        );
      }

      // Determine which command to use
      final command = selectedCommand ?? config.defaultCommand;
      if (command == null) {
        _debug.error('No emulator command available', tag: 'EmulatorService');
        return LaunchResult.failure('No emulator command available');
      }

      // Launch emulator
      final success = await launchWithCommand(
        command: command,
        romPath: romPath,
        platform: platform,
      );

      if (success) {
        return LaunchResult.success(filePath: romPath);
      } else {
        return LaunchResult.failure('Failed to launch emulator');
      }
    } catch (e) {
      _debug.error('Error in launchRom', tag: 'EmulatorService', error: e);
      return LaunchResult.failure('Error: $e');
    }
  }

  /// Get list of all configured platforms
  Future<List<String>> getConfiguredPlatforms() async {
    final config = await _loadConfig();
    return config?.configuredPlatforms ?? [];
  }

  /// Cancel the current download
  void cancelDownload() {
    downloadService.cancelDownload();
  }
}
