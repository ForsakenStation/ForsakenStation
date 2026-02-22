// Desktop/Mobile app content - uses dart:io based services

import 'models/app_init_result.dart';
import 'screens/platforms_screen.dart';
import 'services/rom_service.dart';
import 'services/gamepad_service.dart';
import 'services/romlist_download_service.dart';
import 'services/rom_storage_service.dart';
import 'services/config_service.dart';

/// Initialize platform-specific services (desktop/mobile)
Future<void> initializePlatformServices() async {
  // Initialize GamepadService
  await GamepadService.instance.initialize();
}

/// Initialize the app and return the home screen
Future<AppInitResult> initializeApp() async {
  try {
    // Initialize ROM storage directories
    await RomStorageService.instance.initializeStorageDirectories();

    // Load custom storage paths from config (if set)
    final configService = ConfigService.instance;
    if (configService.romTempPath.isNotEmpty) {
      RomStorageService.instance.setCustomTempPath(configService.romTempPath);
    }
    if (configService.romForeverPath.isNotEmpty) {
      RomStorageService.instance.setCustomForeverPath(
        configService.romForeverPath,
      );
    }

    // Check if romlists are already downloaded
    final romlistService = RomlistDownloadService.instance;
    final isDownloaded = await romlistService.isDownloaded();

    if (!isDownloaded) {
      // First-time setup: download romlists
      final success = await romlistService.downloadAndExtract();

      if (!success) {
        return AppInitResult(
          errorMessage: 'Failed to download ROM lists from GitHub',
        );
      }
    }

    // Get the JSONL path
    final jsonlPath = await romlistService.getJsonlPath();
    final romsPath = ConfigService.instance.romsPath;

    final romService = RomService(
      romsBasePath: romsPath,
      jsonlBasePath: jsonlPath,
    );

    return AppInitResult(homeScreen: PlatformsScreen(romService: romService));
  } catch (e) {
    return AppInitResult(errorMessage: 'Error initializing: $e');
  }
}
