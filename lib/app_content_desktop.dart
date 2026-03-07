// Desktop/Mobile app content - uses dart:io based services

import 'models/app_init_result.dart';
import 'screens/platforms_screen.dart';
import 'services/rom_service.dart';
import 'services/gamepad_service.dart';
import 'services/romlist_download_service.dart';
import 'services/rom_storage_service.dart';
import 'services/config_service.dart';

import 'models/bios_requirement.dart';
import 'models/bios_download_mapping.dart';
import 'models/emulator_download_info.dart';

/// Initialize platform-specific services (desktop/mobile)
Future<void> initializePlatformServices() async {
  // Load data assets
  await Future.wait([
    BiosRequirement.loadAll(),
    BiosDownloadMapping.loadAll(),
    EmulatorCatalog.loadAll(),
  ]);

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

    // Get the JSONL path (romlists are downloaded during Setup Wizard)
    final romlistService = RomlistDownloadService.instance;
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
