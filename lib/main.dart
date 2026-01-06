import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:media_kit/media_kit.dart';

import 'screens/platforms_screen.dart';
import 'services/rom_service.dart';
import 'services/debug_service.dart';
import 'services/config_service.dart';
import 'services/gamepad_service.dart';
import 'services/romlist_download_service.dart';
import 'services/rom_storage_service.dart';
import 'providers/theme_provider.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize MediaKit for video playback
  MediaKit.ensureInitialized();

  // Initialize window manager for fullscreen support
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(1280, 720),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setFullScreen(true);
  });

  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Error loading .env file: $e');
    debugPrint('Please create a .env file with ROMS_PATH and MEDIA_PATH');
  }

  _initializeDebugService();

  // Initialize ConfigService
  await ConfigService.instance.initialize();

  // Initialize GamepadService
  await GamepadService.instance.initialize();

  runApp(const EmulatorApp());
}

/// Initialize the DebugService based on environment variables
void _initializeDebugService() {
  // Get debug settings from environment
  final debugEnabled = dotenv.env['DEBUG_ENABLED']?.toLowerCase() == 'true';
  final debugMinLevelStr =
      dotenv.env['DEBUG_MIN_LEVEL']?.toLowerCase() ?? 'debug';

  // Parse log level
  LogLevel minLevel;
  switch (debugMinLevelStr) {
    case 'info':
      minLevel = LogLevel.info;
      break;
    case 'warning':
      minLevel = LogLevel.warning;
      break;
    case 'error':
      minLevel = LogLevel.error;
      break;
    case 'none':
      minLevel = LogLevel.none;
      break;
    case 'debug':
    default:
      minLevel = LogLevel.debug;
      break;
  }

  // Initialize DebugService
  DebugService.initialize(isEnabled: debugEnabled, minLevel: minLevel);

  // Log initialization
  final debug = DebugService.instance;
  debug.info('DebugService initialized', tag: 'Main');
  debug.debug('Debug enabled: $debugEnabled', tag: 'Main');
  debug.debug('Min log level: ${minLevel.name}', tag: 'Main');
}

class EmulatorApp extends StatefulWidget {
  const EmulatorApp({super.key});

  @override
  State<EmulatorApp> createState() => _EmulatorAppState();
}

class _EmulatorAppState extends State<EmulatorApp> {
  final _romlistService = RomlistDownloadService.instance;
  bool _isInitializing = true;
  String? _jsonlPath;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeRomlists();
  }

  Future<void> _initializeRomlists() async {
    try {
      // Initialize ROM storage directories
      await RomStorageService.instance.initializeStorageDirectories();

      // Load custom storage paths from environment (if set)
      final configService = ConfigService.instance;
      if (configService.romTempPath != null) {
        RomStorageService.instance.setCustomTempPath(configService.romTempPath);
      }
      if (configService.romForeverPath != null) {
        RomStorageService.instance.setCustomForeverPath(
          configService.romForeverPath,
        );
      }

      // Check if romlists are already downloaded
      final isDownloaded = await _romlistService.isDownloaded();

      if (!isDownloaded) {
        // First-time setup: download romlists
        final success = await _romlistService.downloadAndExtract();

        if (!success) {
          setState(() {
            _errorMessage = 'Failed to download ROM lists from GitHub';
            _isInitializing = false;
          });
          return;
        }
      }

      // Get the JSONL path
      final jsonlPath = await _romlistService.getJsonlPath();

      setState(() {
        _jsonlPath = jsonlPath;
        _isInitializing = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error initializing: $e';
        _isInitializing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return MaterialApp(
        title: 'Forsaken Roms',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system,
        home: const InitializingScreen(),
      );
    }

    if (_errorMessage != null) {
      return MaterialApp(
        title: 'Forsaken Roms',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system,
        home: ErrorScreen(message: _errorMessage!),
      );
    }

    final romsPath = dotenv.env['ROMS_PATH'] ?? '';

    final romService = RomService(
      romsBasePath: romsPath,
      jsonlBasePath: _jsonlPath!,
    );

    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Forsaken Roms',
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: themeProvider.themeMode,
            home: PlatformsScreen(romService: romService),
          );
        },
      ),
    );
  }
}

class InitializingScreen extends StatelessWidget {
  const InitializingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(File('assets/images/logo.png'), width: 128, height: 128),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            const Text(
              'Downloading ROM lists...',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'This may take a few minutes on first run',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String message;

  const ErrorScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 24),
              const Text(
                'Initialization Error',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Restart the app
                  // On web/desktop, user needs to manually refresh
                  // On mobile, this would work with hot restart
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConfigurationErrorScreen extends StatelessWidget {
  const ConfigurationErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuration Error')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 24),
              const Text(
                'Configuration Error',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Please create a .env file in the project root with at least one ROM source:',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Option 1 - JSONL ROMs:\nJSONL_ROMS_PATH=/path/to/jsonl\nMEDIA_PATH=/path/to/media\n\nOption 2 - File-based ROMs:\nROMS_PATH=/path/to/roms\nMEDIA_PATH=/path/to/media',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'See .env.example for more details',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
