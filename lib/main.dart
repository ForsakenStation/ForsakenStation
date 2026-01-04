import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'screens/platforms_screen.dart';
import 'services/rom_service.dart';
import 'services/debug_service.dart';
import 'providers/theme_provider.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

class EmulatorApp extends StatelessWidget {
  const EmulatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final romsPath = dotenv.env['ROMS_PATH'] ?? '';

    if (romsPath.isEmpty) {
      return MaterialApp(
        title: 'Forsaken Roms',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system,
        home: const ConfigurationErrorScreen(),
      );
    }

    final romService = RomService(romsBasePath: romsPath);

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
                'Please create a .env file in the project root with the following variables:',
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
                  'ROMS_PATH=/path/to/roms\nMEDIA_PATH=/path/to/media',
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
