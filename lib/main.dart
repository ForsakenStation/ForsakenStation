import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:media_kit/media_kit.dart';

import 'screens/initializing_screen.dart';
import 'screens/error_screen.dart';
import 'screens/setup_wizard_screen.dart';
import 'services/debug_service.dart';
import 'services/config_service.dart';
import 'providers/theme_provider.dart';
import 'utils/app_theme.dart';

// Platform-specific imports (use stubs on web to avoid dart:io)
import 'utils/platform_init.dart';

// Web-specific imports (conditional for web platform)
import 'platforms/web/web_emulator_service.dart'
    if (dart.library.io) 'services/empty_stub.dart';

// Import the app content builder based on platform
import 'app_content_desktop.dart'
    if (dart.library.js_interop) 'app_content_web.dart'
    as app_content;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize MediaKit for video playback (desktop only)
  if (!kIsWeb) {
    MediaKit.ensureInitialized();
  }

  // Initialize window manager for fullscreen support (desktop only)
  if (!kIsWeb) {
    await initializePlatform();
  }

  // Initialize ConfigService (loads path settings from SharedPreferences)
  await ConfigService.instance.initialize();

  // Initialize DebugService from config settings
  _initializeDebugService();

  // Platform-specific initialization
  await app_content.initializePlatformServices();

  // Initialize Web Emulator Service (web only)
  if (kIsWeb) {
    try {
      // Load CORS proxy URL from settings before initializing
      final corsProxy = await ConfigService.instance.getCorsProxyUrl();
      if (corsProxy != null && corsProxy.isNotEmpty) {
        WebEmulatorService.instance.corsProxyUrl = corsProxy;
      }

      await WebEmulatorService.instance.initialize();
      DebugService.instance.info(
        'Web emulator service initialized',
        tag: 'Main',
      );
    } catch (e) {
      DebugService.instance.error(
        'Failed to initialize web emulator service: $e',
        tag: 'Main',
      );
    }
  }

  runApp(const EmulatorApp());
}

/// Initialize the DebugService based on config settings
void _initializeDebugService() {
  final configService = ConfigService.instance;
  final debugEnabled = configService.isDebugEnabled;
  final debugMinLevelStr = configService.debugMinLevel.toLowerCase();

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
  bool _isInitializing = true;
  bool _showWizard = false;
  String? _errorMessage;
  Widget? _homeScreen;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Use platform-specific initialization
      final result = await app_content.initializeApp();

      final needsWizard =
          result.errorMessage == null &&
          !ConfigService.instance.isSetupCompleted;

      setState(() {
        _homeScreen = result.homeScreen;
        _errorMessage = result.errorMessage;
        _showWizard = needsWizard;
        _isInitializing = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error initializing: $e';
        _isInitializing = false;
      });
    }
  }

  void _onWizardComplete() {
    setState(() => _showWizard = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return MaterialApp(
        title: 'Forsaken Emulator',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system,
        home: const InitializingScreen(),
      );
    }

    if (_errorMessage != null) {
      return MaterialApp(
        title: 'Forsaken Emulator',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system,
        home: ErrorScreen(
          message: _errorMessage!,
          onRetry: () {
            setState(() {
              _isInitializing = true;
              _errorMessage = null;
            });
            _initialize();
          },
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Forsaken Emulator',
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: themeProvider.themeMode,
            home: _showWizard
                ? SetupWizardScreen(onComplete: _onWizardComplete)
                : _homeScreen,
          );
        },
      ),
    );
  }
}
