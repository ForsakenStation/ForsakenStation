// Web app content - uses HTTP-based services instead of dart:io

import 'models/app_init_result.dart';
import 'screens/platforms_screen.dart';
import 'services/rom_service.dart';
import 'services/gamepad_service.dart';
import 'services/romlist_download_service.dart';
import 'services/rom_storage_service.dart';

/// Initialize platform-specific services (web)
Future<void> initializePlatformServices() async {
  // Initialize GamepadService (stub on web)
  await GamepadService.instance.initialize();
}

/// Initialize the app and return the home screen
Future<AppInitResult> initializeApp() async {
  try {
    // Initialize storage (no-op on web but keeps consistency)
    await RomStorageService.instance.initializeStorageDirectories();

    // On web, romlists are fetched from GitHub on demand
    final romlistService = RomlistDownloadService.instance;
    final jsonlPath = await romlistService.getJsonlPath();

    final romService = RomService(
      romsBasePath: '', // Not used on web
      jsonlBasePath: jsonlPath,
    );

    return AppInitResult(homeScreen: PlatformsScreen(romService: romService));
  } catch (e) {
    return AppInitResult(errorMessage: 'Error initializing: $e');
  }
}
