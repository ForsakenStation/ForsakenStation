// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Forsaken Emulator';

  @override
  String get retroGamingFrontend => 'Retro Gaming Frontend';

  @override
  String get platforms => 'Platforms';

  @override
  String get roms => 'ROMs';

  @override
  String get settings => 'Settings';

  @override
  String get settingsAndConfiguration => 'Settings & Configuration';

  @override
  String get aboutForsakenEmulator => 'About Forsaken Emulator';

  @override
  String get version => 'Version';

  @override
  String get appDescription =>
      'A modern multi-platform emulator frontend built with Flutter.';

  @override
  String get emulators => 'Emulators';

  @override
  String get ready => 'Ready';

  @override
  String get back => 'Back';

  @override
  String get select => 'Select';

  @override
  String get search => 'Search';

  @override
  String get refresh => 'Refresh';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get initializationError => 'Initialization Error';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get close => 'Close';

  @override
  String get noRomsFound => 'No ROMs found';

  @override
  String get noPlatformsFound => 'No platforms found';

  @override
  String get checkRomsPath => 'Check your ROMS_PATH environment variable';

  @override
  String get downloading => 'Downloading...';

  @override
  String get downloadComplete => 'Download complete';

  @override
  String get downloadFailed => 'Download failed';

  @override
  String get emulatorNotFound => 'Emulator not found';

  @override
  String get romNotFound => 'ROM not found';

  @override
  String get biosRequired => 'REQUIRED';

  @override
  String get systemCheck => 'System Check';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get systemDefault => 'System default';

  @override
  String get help => 'Help';

  @override
  String get keyboardAndGamepadControls => 'Keyboard & Gamepad Controls';

  @override
  String get navigation => 'Navigation';

  @override
  String get actions => 'Actions';

  @override
  String get viewControls => 'View Controls';

  @override
  String get gotIt => 'Got it!';

  @override
  String get exit => 'Exit';

  @override
  String get exitApplication => 'Exit Application';

  @override
  String get exitConfirm => 'Are you sure you want to exit?';

  @override
  String get downloadManager => 'Download Manager';

  @override
  String get clearCompleted => 'Clear Completed';

  @override
  String get selectCategory => 'Select Category';

  @override
  String get confirmDownload => 'Confirm Download';

  @override
  String get downloadGameLists => 'Download Game Lists';

  @override
  String get downloadGameListsDescription =>
      'This will download ROM lists from GitHub.';

  @override
  String get gameListsDownloaded => 'Game lists downloaded!';

  @override
  String get romStorageManagement => 'ROM Storage Management';

  @override
  String get deleteRom => 'Delete ROM?';

  @override
  String deleteRomConfirm(String fileName) {
    return 'Delete $fileName?';
  }

  @override
  String get actionCannotBeUndone => 'This action cannot be undone.';

  @override
  String deleted(String fileName) {
    return 'Deleted: $fileName';
  }

  @override
  String get savePermanently => 'Save Permanently?';

  @override
  String moveRomConfirm(String fileName) {
    return 'Move $fileName to permanent storage?';
  }

  @override
  String saved(String fileName) {
    return 'Saved: $fileName';
  }

  @override
  String get clearAll => 'Clear All?';

  @override
  String get clearAllConfirm => 'Delete all temporary ROMs?';

  @override
  String get allCleared => 'All temporary ROMs cleared';

  @override
  String get systemPathsConfiguration => 'System Paths Configuration';

  @override
  String get migrateRoms => 'Migrate ROMs?';

  @override
  String get migrateRomsDescription =>
      'The permanent ROM storage path has changed from \$oldPath to \$newPath. Would you like to migrate existing ROMs to the new location?';

  @override
  String get noKeepThem => 'No, keep them';

  @override
  String get yesMigrateRoms => 'Yes, migrate ROMs';

  @override
  String get migratingRoms => 'Migrating ROMs...';

  @override
  String get romMigrationFailed => 'Warning: ROM migration failed';

  @override
  String get pathsSaved => 'Paths saved successfully';

  @override
  String get errorSavingPaths => 'Error saving paths:';

  @override
  String get resetConfiguration => 'Reset Configuration';

  @override
  String get resetConfigDescription =>
      'This will reset all paths to their default values. Your ROMs and media files will not be affected.';

  @override
  String get configurationReset => 'Configuration reset to defaults';

  @override
  String get errorResettingConfiguration => 'Error resetting configuration:';

  @override
  String get savePaths => 'Save Paths';

  @override
  String get saving => 'Saving...';

  @override
  String get emulatorManagement => 'Emulator Management';

  @override
  String get configurationReloaded => 'Configuration reloaded';

  @override
  String get errorLoadingEmulators => 'Error loading emulators:';

  @override
  String get emulatorAdded => 'Emulator added successfully';

  @override
  String get errorAddingEmulator => 'Error adding emulator:';

  @override
  String get emulatorUpdated => 'Emulator updated successfully';

  @override
  String get errorUpdatingEmulator => 'Error updating emulator:';

  @override
  String get deleteEmulator => 'Delete Emulator';

  @override
  String get emulatorDeleted => 'Emulator deleted';

  @override
  String get errorDeletingEmulator => 'Error deleting emulator:';

  @override
  String get configurationSource => 'Configuration Source';

  @override
  String get addEmulator => 'Add Emulator';

  @override
  String get systemNameRequired => 'System name is required';

  @override
  String get commandRequired => 'At least one command is required';

  @override
  String get addCommand => 'Add Command';

  @override
  String get acceptZipFiles => 'Accept ZIP files';

  @override
  String get acceptZipSubtitle => 'Allow launching ROMs from ZIP archives';

  @override
  String get useForeverMode => 'Use Forever Mode';

  @override
  String get useForeverSubtitle => 'Keep emulator running';

  @override
  String get launchFile => 'Launch File';

  @override
  String get launchFileSubtitle =>
      'File to find inside extracted ZIP (e.g. eboot.bin)';

  @override
  String get launchFileHint => 'e.g. eboot.bin';

  @override
  String get workInProgress => 'Work In Progress';

  @override
  String get wipSubtitle => 'Mark as not yet fully configured';

  @override
  String get biosFirmwareHelp => 'BIOS & Firmware Help';

  @override
  String get downloadMissingFiles => 'Download Missing Files';

  @override
  String get showOnlyMissing => 'Show only missing';

  @override
  String get downloadAllMissingBios => 'Download All Missing BIOS';

  @override
  String get configurationError => 'Configuration Error';

  @override
  String get configurationErrorDescription =>
      'The application could not find the required configuration.\nPlease configure your paths in Settings > System Paths.';

  @override
  String get configurationRequired =>
      'Required:\n- Media Path: directory containing media assets\n- Emulators Path: directory containing emulator binaries\n\nOptional:\n- ROM storage paths for temporary/permanent downloads';

  @override
  String get goToSettingsToConfigure =>
      'Go to Settings > System Paths to configure';

  @override
  String get noDownloadableBios => 'No downloadable BIOS files are missing';

  @override
  String get allDownloadsCompleted => 'All downloads completed successfully!';

  @override
  String get batchDownloadFailed => 'Batch download failed:';

  @override
  String get download => 'Download';

  @override
  String get downloadCancelled => 'Download cancelled';

  @override
  String get launched => 'Launched:';

  @override
  String get failedToSave => 'Failed to save ROM permanently';

  @override
  String get failedToSaveRom => 'Failed to save ROM permanently';

  @override
  String get errorSaving => 'Error saving ROM:';

  @override
  String errorSavingRom(String error) {
    return 'Error saving ROM: $error';
  }

  @override
  String get openFolder => 'Open Folder';

  @override
  String get viewManual => 'View Manual';

  @override
  String get play => 'Play';

  @override
  String get goBack => 'Go Back';

  @override
  String get clearSearch => 'Clear Search';

  @override
  String get iUnderstand => 'I understand and agree to these terms';

  @override
  String get start => 'Start';

  @override
  String get debugMode => 'Debug Mode: ';

  @override
  String get toggleDebugMode => 'Toggle Debug Mode';

  @override
  String get preparingDownload => 'Preparing download...';

  @override
  String get noEmulatorsAvailable => 'No emulators available for this category';

  @override
  String get failedToLaunch => 'Failed to launch web emulator:';

  @override
  String get platformInfo => 'Platform Info';

  @override
  String get emulatorPlatformInfo => 'EmulatorPlatform Info';

  @override
  String get favorites => 'Favorites';

  @override
  String get all => 'All';

  @override
  String get collections => 'Collections';

  @override
  String get searchRoms => 'Search ROMs...';

  @override
  String get searchPlatforms => 'Search platforms...';

  @override
  String romsCount(int count) {
    return '$count ROMs';
  }

  @override
  String platformsCount(int count) {
    return '$count platforms';
  }

  @override
  String get region => 'Region';

  @override
  String get genre => 'Genre';

  @override
  String get year => 'Year';

  @override
  String get publisher => 'Publisher';

  @override
  String get developer => 'Developer';

  @override
  String get playWithNetplay => 'Play with Netplay';

  @override
  String get downloadBios => 'Download BIOS';

  @override
  String get viewDetails => 'View Details';

  @override
  String get addToFavorites => 'Add to Favorites';

  @override
  String get removeFromFavorites => 'Remove from Favorites';

  @override
  String get biosMissing => 'Missing';

  @override
  String get biosPresent => 'BIOS present';

  @override
  String get checkingBios => 'Checking BIOS...';

  @override
  String get emulatorDownloading => 'Downloading emulator...';

  @override
  String get emulatorDownloadComplete => 'Emulator downloaded';

  @override
  String get emulatorDownloadFailed => 'Failed to download emulator';

  @override
  String get installingEmulator => 'Installing emulator...';

  @override
  String get emulatorReady => 'Emulator ready';

  @override
  String get configuration => 'Configuration';

  @override
  String get paths => 'Paths';

  @override
  String get storage => 'Storage';

  @override
  String get emulatorsPath => 'Emulators Path';

  @override
  String get romsPath => 'ROMs Path';

  @override
  String get mediaPath => 'Media Path';

  @override
  String get biosPath => 'BIOS Path';

  @override
  String get tempPath => 'Temporary Path';

  @override
  String get browse => 'Browse';

  @override
  String get apply => 'Apply';

  @override
  String get reset => 'Reset';

  @override
  String get clear => 'Clear';

  @override
  String get scan => 'Scan';

  @override
  String get scanForRoms => 'Scan for ROMs';

  @override
  String get scanningRoms => 'Scanning ROMs...';

  @override
  String get scanComplete => 'Scan complete';

  @override
  String romsFound(int count) {
    return '$count ROMs found';
  }

  @override
  String get noNewRomsFound => 'No new ROMs found';

  @override
  String get launchEmulator => 'Launch Emulator';

  @override
  String get emulatorError => 'Emulator Error';

  @override
  String get gamepadConnected => 'Gamepad Connected';

  @override
  String get gamepadDisconnected => 'Gamepad disconnected';

  @override
  String get gamepadTest => 'Gamepad Test';

  @override
  String get pressAnyButton => 'Press any button to test';

  @override
  String get buttonA => 'A';

  @override
  String get buttonB => 'B';

  @override
  String get buttonX => 'X';

  @override
  String get buttonY => 'Y';

  @override
  String get buttonStart => 'Start';

  @override
  String get buttonSelect => 'Select';

  @override
  String get dpadUp => 'D-Pad Up';

  @override
  String get dpadDown => 'D-Pad Down';

  @override
  String get dpadLeft => 'D-Pad Left';

  @override
  String get dpadRight => 'D-Pad Right';

  @override
  String get leftShoulder => 'L1';

  @override
  String get rightShoulder => 'R1';

  @override
  String get leftTrigger => 'L2';

  @override
  String get rightTrigger => 'R2';

  @override
  String get leftStick => 'Left Stick';

  @override
  String get rightStick => 'Right Stick';

  @override
  String get setupWizard => 'Setup Wizard';

  @override
  String get welcome => 'Welcome';

  @override
  String get welcomeMessage => 'Welcome to Forsaken Emulator';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get finish => 'Finish';

  @override
  String get skip => 'Skip';

  @override
  String get setupComplete => 'Setup Complete';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get selectEmulatorsPath => 'Select Emulators Path';

  @override
  String get selectRomsPath => 'Select ROMs Path';

  @override
  String get selectMediaPath => 'Select Media Path';

  @override
  String get allSettingsConfigured => 'All settings configured';

  @override
  String get darkTheme => 'Dark';

  @override
  String get lightTheme => 'Light';

  @override
  String get systemTheme => 'System';

  @override
  String get about => 'About';

  @override
  String get checkForUpdates => 'Check for Updates';

  @override
  String get noUpdatesAvailable => 'No updates available';

  @override
  String get updateAvailable => 'Update available';

  @override
  String get downloadingUpdate => 'Downloading update...';

  @override
  String get installingUpdate => 'Installing update...';

  @override
  String get updateComplete => 'Update complete';

  @override
  String get updateFailed => 'Update failed';

  @override
  String get networkError => 'Network error';

  @override
  String get connectionError => 'Connection error';

  @override
  String get timeoutError => 'Timeout error';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get permissionDenied => 'Permission denied';

  @override
  String get fileNotFound => 'File not found';

  @override
  String get directoryNotFound => 'Directory not found';

  @override
  String get diskFull => 'Disk full';

  @override
  String get invalidPath => 'Invalid path';

  @override
  String get pathNotWritable => 'Path not writable';

  @override
  String get romCorrupted => 'ROM file may be corrupted';

  @override
  String get zipError => 'ZIP archive error';

  @override
  String get extractionFailed => 'Extraction failed';

  @override
  String get checksumMismatch => 'Checksum mismatch';

  @override
  String get biosCheckFailed => 'BIOS check failed';

  @override
  String get continueAnyway => 'Continue anyway';

  @override
  String get reportIssue => 'Report Issue';

  @override
  String get copyToClipboard => 'Copy to clipboard';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get share => 'Share';

  @override
  String get hide => 'Hide';

  @override
  String get show => 'Show';

  @override
  String get toggleView => 'Toggle View';

  @override
  String get gridView => 'Grid View';

  @override
  String get listView => 'List View';

  @override
  String get carouselView => 'Carousel View';

  @override
  String get sortBy => 'Sort by';

  @override
  String get sortByName => 'Name';

  @override
  String get sortByDate => 'Date';

  @override
  String get sortBySize => 'Size';

  @override
  String get sortByRegion => 'Region';

  @override
  String get ascending => 'Ascending';

  @override
  String get descending => 'Descending';

  @override
  String get filter => 'Filter';

  @override
  String get filterByRegion => 'Filter by Region';

  @override
  String get filterByGenre => 'Filter by Genre';

  @override
  String get filterByYear => 'Filter by Year';

  @override
  String get clearFilters => 'Clear Filters';

  @override
  String get systemInfo => 'System Info';

  @override
  String get cpu => 'CPU';

  @override
  String get memory => 'Memory';

  @override
  String get storageInfo => 'Storage';

  @override
  String get os => 'Operating System';

  @override
  String get emulatorVersion => 'Emulator Version';

  @override
  String get totalRoms => 'Total ROMs';

  @override
  String get totalSize => 'Total Size';

  @override
  String get freeSpace => 'Free Space';

  @override
  String get usedSpace => 'Used Space';

  @override
  String get systemUtilities => 'System Utilities';

  @override
  String get romVerificationResults => 'ROM Verification Results';

  @override
  String get totalRomFiles => 'Total ROM files';

  @override
  String get emptyRomFiles => 'Empty ROM files';

  @override
  String get validRomFiles => 'Valid ROM files';

  @override
  String get romsDirectoryDoesNotExist => 'ROMs directory does not exist';

  @override
  String get gamelistCheckResults => 'Gamelist Check Results';

  @override
  String get totalPlatforms => 'Total platforms';

  @override
  String get missingGamelists => 'Missing gamelists';

  @override
  String get configurationBackup => 'Configuration Backup';

  @override
  String get configurationBackedUp => 'Configuration backed up to:';

  @override
  String get errorBackingUp => 'Error backing up configuration:';

  @override
  String get romDatabase => 'ROM Database';

  @override
  String get romDatabaseDownloaded => 'ROM database downloaded successfully';

  @override
  String get failedDownloadRomDatabase => 'Failed to download ROM database';

  @override
  String get romDatabaseCleared => 'ROM database cleared';

  @override
  String get failedClearDatabase => 'Failed to clear database';

  @override
  String get downloadRomDatabase => 'Download ROM Database';

  @override
  String get clearRomDatabase => 'Clear ROM Database';

  @override
  String get systemRequirements => 'System Requirements';

  @override
  String get failedToCheckSystem => 'Failed to check system';

  @override
  String cleanedUpTempFiles(String deletedCount) {
    return 'Cleaned up $deletedCount temporary ROM files';
  }

  @override
  String get errorCleaningTempFiles => 'Error cleaning temp files:';

  @override
  String get errorVerifyingRomFiles => 'Error verifying ROM files:';

  @override
  String get errorCheckingGamelists => 'Error checking gamelists:';

  @override
  String get cancelDownload => 'Cancel Download';

  @override
  String get selectEmulator => 'Select Emulator';

  @override
  String get biosStatusDashboard => 'BIOS Status Dashboard';

  @override
  String get webSettings => 'Web Settings';

  @override
  String get saveSettings => 'Save Settings';

  @override
  String get errorSavingSettings => 'Error saving settings:';

  @override
  String romsCountItems(String count) {
    return '$count ROMs';
  }

  @override
  String get savedPermanently => 'saved permanently';

  @override
  String get keptInTemporary => 'kept in temporary storage';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get allDownloads => 'All downloads completed';

  @override
  String romSavedPermanently(String name) {
    return '$name saved permanently';
  }

  @override
  String get undo => 'Undo';

  @override
  String romKeptInTemporary(String name) {
    return '$name kept in temporary storage';
  }

  @override
  String romsCountWithSize(String count, String size) {
    return '$count ROMs • $size';
  }

  @override
  String get whatYouCanTry => 'What you can try:';

  @override
  String get tips => 'Tips';

  @override
  String get helpNavigateItems => 'Navigate through items';

  @override
  String get helpGamepadNavigation => 'Gamepad navigation';

  @override
  String get helpQuickNavigation => 'Quick navigation (jump multiple items)';

  @override
  String get helpGamepadPageNavigation => 'Gamepad page navigation';

  @override
  String get helpGoToFirst => 'Go to first item';

  @override
  String get helpGoToLast => 'Go to last item';

  @override
  String get helpJumpToLetter => 'Jump to item starting with that letter';

  @override
  String get helpSelectItem => 'Select item';

  @override
  String get helpGamepadSelect => 'Gamepad select';

  @override
  String get helpGoBackCloseDialogs => 'Go back / Close dialogs';

  @override
  String get helpExitApplication => 'Exit application';

  @override
  String get helpGamepadBackClose => 'Gamepad back / Close dialogs';

  @override
  String get helpToggleViewMode => 'Toggle view mode (Grid/List/Carousel)';

  @override
  String get helpGamepadViewToggle => 'Gamepad view toggle';

  @override
  String get helpRefreshView => 'Refresh current view';

  @override
  String get helpShowPlatformInfo => 'Show platform information';

  @override
  String get helpActivateSearch => 'Activate search';

  @override
  String get helpGamepadSearch => 'Gamepad search';

  @override
  String get helpShowHelpDialog => 'Show this help dialog';

  @override
  String get helpGamepadHelp => 'Gamepad help';

  @override
  String get tipUseKeyboardOrGamepad =>
      'Use keyboard or gamepad for navigation';

  @override
  String get tipAlphabeticalJump => 'Alphabetical jump works in all view modes';

  @override
  String get tipPressQuestionMark => 'Press ? anytime to see this help';

  @override
  String get tipGamepadAlongside => 'Gamepad works alongside keyboard controls';

  @override
  String get configurePathsDescription =>
      'Configure the paths used by the application to locate ROMs, media, and emulators.';

  @override
  String get romListsAutoManaged =>
      'ROM lists are now managed automatically. Download them from Settings > ROM Database.';

  @override
  String get romStorage => 'ROM Storage';

  @override
  String get configureRomStorageDescription =>
      'Configure where downloaded ROMs are stored temporarily and permanently.';

  @override
  String get resetToDefaults => 'Reset to defaults';

  @override
  String get mediaPathLabel => 'Media Path';

  @override
  String get mediaPathHint => 'Directory containing media (images, videos)';

  @override
  String get emulatorsPathLabel => 'Emulators Path';

  @override
  String get emulatorsPathHint => 'Directory containing emulator binaries';

  @override
  String get gamelistPathAutomatic => 'Gamelist Path (Automatic)';

  @override
  String get gamelistAutoDescription =>
      'Gamelists are now managed automatically in the app data directory. This makes the app fully independent and prepares for future GitHub-based gamelist distribution.';

  @override
  String get tempRomStorageLabel => 'Temporary ROM Storage (Optional)';

  @override
  String get tempRomStorageDescription =>
      'ROMs are downloaded here first. They can be promoted to permanent storage after playing.';

  @override
  String get permanentRomStorageLabel => 'Permanent ROM Storage (Optional)';

  @override
  String get permanentRomStorageDescription =>
      'ROMs saved permanently are stored here. These are not cleaned up automatically.';

  @override
  String get defaultAppSupportDir => 'Default: app support directory';

  @override
  String currentPathDisplay(String path) {
    return 'Current: $path';
  }

  @override
  String get configurationFile => 'Configuration File';

  @override
  String get source => 'Source:';

  @override
  String get customConfigActive => 'Custom configuration active';

  @override
  String get pathStructure => 'Path Structure';

  @override
  String get pathStructureDescription =>
      'Media Path: MEDIA_PATH/platform/boxart|screenshots|videos/rom.png\nGamelist Path: ~/.local/share/com.example.emulator/gamelists/platform/gamelist.xml (automatic)\nEmulators Path: EMULATORS_PATH/emulator_binary';

  @override
  String get errorCheckingSystem => 'Error checking system';

  @override
  String get recheckR => 'Re-check (R)';

  @override
  String get allRequiredToolsInstalled => 'All Required Tools Installed';

  @override
  String get missingRequiredTools => 'Missing Required Tools';

  @override
  String get systemReadyToUse => 'Your system is ready to use the emulator';

  @override
  String get someRequiredToolsMissing => 'Some required tools are missing';

  @override
  String get requiredTools => 'Required Tools';

  @override
  String get requiredToolsDescription =>
      'These tools are required for downloading and extracting emulators';

  @override
  String get installationInstructions => 'Installation Instructions';

  @override
  String get installed => 'Installed';

  @override
  String get missing => 'Missing';

  @override
  String get downloadEmulatorsAndGameLists =>
      'Download emulators and game lists';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get downloadAll => 'Download All';

  @override
  String get byCategory => 'By Category';

  @override
  String get downloadQueue => 'Download Queue';

  @override
  String get noDownloadsInProgress => 'No downloads in progress';

  @override
  String get selectQuickActionToStart =>
      'Select a quick action above to start downloading';

  @override
  String get categorySony => 'Sony (PS1-PS4)';

  @override
  String get categoryNintendo => 'Nintendo (GC, Wii, Switch)';

  @override
  String get categoryMicrosoft => 'Microsoft (Xbox, Xbox 360)';

  @override
  String get categoryMultiPlatform => 'Multi-Platform (RetroArch)';

  @override
  String get categoryOtherEmulators => 'Other Emulators';

  @override
  String get categoryUtilities => 'Utilities';

  @override
  String confirmDownloadDescription(String count, String size) {
    return 'Download $count emulator(s)?\nEstimated size: ~$size MB\n\nThis may take a while depending on your internet connection.';
  }

  @override
  String get alreadyInstalled => 'Already installed';

  @override
  String get starting => 'Starting...';

  @override
  String get completed => 'Completed';

  @override
  String get gameListsAlreadyDownloaded => 'Game lists already downloaded';

  @override
  String get redownload => 'Re-Download';

  @override
  String get gameListsFromGitHub => 'Game Lists (from GitHub)';

  @override
  String get downloaded => 'Downloaded';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get missingFor => 'Missing for:';

  @override
  String get noCustomConfigToBackup =>
      'No custom configuration to backup. Using bundled defaults.';

  @override
  String get saveConfigurationBackup => 'Save Configuration Backup';

  @override
  String get refreshStatsR => 'Refresh stats (R)';

  @override
  String get systemStatistics => 'System Statistics';

  @override
  String get romFiles => 'ROM Files';

  @override
  String get maintenanceTools => 'Maintenance Tools';

  @override
  String get cleanupTemporaryRoms => 'Cleanup Temporary ROMs';

  @override
  String get cleanupTemporaryRomsDescription =>
      'Remove temporary ROM files from system temp directory';

  @override
  String get verifyRomFiles => 'Verify ROM Files';

  @override
  String get verifyRomFilesDescription =>
      'Check that all ROM files exist and are valid';

  @override
  String get checkMissingGamelists => 'Check Missing Gamelists';

  @override
  String get checkMissingGamelistsDescription =>
      'Find platforms missing gamelist.xml files';

  @override
  String get backupConfiguration => 'Backup Configuration';

  @override
  String get backupConfigurationDescription => 'Create a backup of config.json';

  @override
  String get downloadingRomDatabase => 'Downloading ROM Database...';

  @override
  String get downloadMayTakeMinutes =>
      'This may take a few minutes depending on your connection...';

  @override
  String get databaseStatus => 'Database Status';

  @override
  String get notDownloaded => 'Not Downloaded';

  @override
  String get aboutRomDatabase => 'About ROM Database';

  @override
  String get aboutRomDatabaseDescription =>
      'The ROM database contains lists of available ROMs organized by platform. It is downloaded from the Forsaken romList repository on GitHub.';

  @override
  String get romDatabaseSource => 'Source: github.com/ForsakenStation/romList';

  @override
  String get downloadRomDatabaseDescription =>
      'This will download ROM lists from the Forsaken romList repository on GitHub.';

  @override
  String get downloadRomDatabaseStats =>
      'Size: ~7 MB\nPlatforms: 138\nTotal ROMs: ~240,000';

  @override
  String get downloadWillOverwrite =>
      'Note: This will overwrite existing data.';

  @override
  String get clearRomDatabaseDescription =>
      'This will delete all downloaded ROM lists and reset the database to its initial state.';

  @override
  String get gamelistsStatus => 'Gamelists Status';

  @override
  String get gamelistsDownloaded => 'Downloaded';

  @override
  String get gamelistsNotDownloaded => 'Not Downloaded';

  @override
  String get aboutGamelists => 'About Gamelists';

  @override
  String get aboutGamelistsDescription =>
      'Gamelists contain game metadata (names, descriptions, ratings) for each platform. They are downloaded from the Forsaken gamelists repository on GitHub.';

  @override
  String get gamelistsSource => 'Source: github.com/ForsakenStation/gamelists';

  @override
  String get downloadGamelists => 'Download Gamelists';

  @override
  String get downloadGamelistsDescription =>
      'This will download gamelist.xml files from the Forsaken gamelists repository on GitHub.';

  @override
  String get downloadGamelistsWillOverwrite =>
      'Note: This will overwrite existing gamelist files.';

  @override
  String get downloadingGamelists => 'Downloading Gamelists...';

  @override
  String get gamelistsDownloadedSuccess => 'Gamelists downloaded successfully';

  @override
  String get failedDownloadGamelists => 'Failed to download gamelists';

  @override
  String get clearGamelists => 'Clear Gamelists';

  @override
  String get clearGamelistsDescription =>
      'This will delete all downloaded gamelist files.';

  @override
  String get gamelistsCleared => 'Gamelists cleared';

  @override
  String get failedClearGamelists => 'Failed to clear gamelists';

  @override
  String get rebuildMediaCache => 'Rebuild Media Cache';

  @override
  String get rebuildMediaCacheDescription =>
      'Scan media directories and cache paths in gamelists for faster loading';

  @override
  String get rebuildMediaCacheConfirmTitle => 'Rebuild Media Cache?';

  @override
  String get rebuildMediaCacheConfirmBody =>
      'This will scan all media directories and update gamelist.xml files with media paths. This may take a moment for large collections.';

  @override
  String get rebuildMediaCacheProgress => 'Rebuilding media cache...';

  @override
  String rebuildMediaCacheProcessingPlatform(
    String platform,
    String current,
    String total,
  ) {
    return 'Processing $platform ($current/$total)';
  }

  @override
  String get rebuildMediaCacheComplete => 'Media Cache Rebuilt';

  @override
  String rebuildMediaCacheSummary(
    String platforms,
    String games,
    String updated,
    String paths,
  ) {
    return '$platforms platforms, $games games scanned, $updated updated, $paths media paths cached';
  }

  @override
  String get rebuildMediaCacheError => 'Failed to rebuild media cache';

  @override
  String rebuildMediaCacheErrors(String count) {
    return '$count errors occurred during rebuild';
  }

  @override
  String get description => 'Description';

  @override
  String get noDescriptionAvailable => 'No description available for this ROM.';

  @override
  String get releaseDate => 'Release Date';

  @override
  String get players => 'Players';

  @override
  String get rating => 'Rating';

  @override
  String get regions => 'Regions';

  @override
  String folderRomCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ROMs',
      one: '$count ROM',
    );
    return '$_temp0';
  }

  @override
  String manualTitle(String name) {
    return '$name - Manual';
  }

  @override
  String get playInBrowser => 'Play in Browser';

  @override
  String downloadingPlatformBios(String platformName) {
    return 'Downloading $platformName BIOS';
  }

  @override
  String get downloadingAllMissingBios => 'Downloading All Missing BIOS';

  @override
  String biosFileLabel(String filename) {
    return 'File: $filename';
  }

  @override
  String batchProgressLabel(String completed, String total) {
    return 'Progress: $completed/$total files';
  }

  @override
  String get fileDetails => 'File Details:';

  @override
  String get waiting => 'Waiting...';

  @override
  String get verifying => 'Verifying...';

  @override
  String get failed => 'Failed';

  @override
  String get preparing => 'Preparing...';

  @override
  String get downloadingFiles => 'Downloading files...';

  @override
  String get someDownloadsFailed => 'Some downloads failed';

  @override
  String get downloadsCancelled => 'Downloads cancelled';

  @override
  String get calculating => 'Calculating...';

  @override
  String secondsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seconds',
      one: '1 second',
    );
    return '$_temp0';
  }

  @override
  String minutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String hoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String get downloadingAndLaunching => 'Downloading & Launching...';

  @override
  String get launching => 'Launching...';

  @override
  String emulatorLabel(String name) {
    return 'Emulator: $name';
  }

  @override
  String get generalInformation => 'General Information';

  @override
  String get manufacturer => 'Manufacturer';

  @override
  String get releaseYear => 'Release Year';

  @override
  String get generation => 'Generation';

  @override
  String get technicalSpecifications => 'Technical Specifications';

  @override
  String get resolution => 'Resolution';

  @override
  String get colors => 'Colors';

  @override
  String get notNow => 'Not Now';

  @override
  String get saveRomPermanently => 'Save ROM Permanently?';

  @override
  String get keepRomOfflineQuestion =>
      'Would you like to keep this ROM downloaded for offline play?';

  @override
  String get deletedToSaveSpace =>
      'If not, it will be deleted later to save space.';

  @override
  String get view => 'View';

  @override
  String get media => 'Media';

  @override
  String get navigate => 'Navigate';

  @override
  String get info => 'Info';

  @override
  String get toggleFilter => 'Toggle Filter';

  @override
  String get changeTheme => 'Change theme';

  @override
  String get keyboard => 'Keyboard';

  @override
  String get gamepad => 'Gamepad';

  @override
  String get hideKeyboard => 'Hide keyboard';

  @override
  String get gameManual => 'Game Manual';

  @override
  String get pdfDocument => 'PDF Document';

  @override
  String get manual => 'Manual';

  @override
  String get video => 'Video';

  @override
  String get zoomOut => 'Zoom Out';

  @override
  String get zoomIn => 'Zoom In';

  @override
  String pageCounter(String current, String total) {
    return 'Page $current / $total';
  }

  @override
  String get zoom => 'Zoom';

  @override
  String get firstLast => 'First/Last';

  @override
  String get scroll => 'Scroll';

  @override
  String get loadingVideo => 'Loading video...';

  @override
  String get playPause => 'Play/Pause';

  @override
  String get useArrowKeysToNavigate => 'Use arrow keys or swipe to navigate';

  @override
  String get searchRomsHint => 'Search ROMs...';

  @override
  String get cancelSearch => 'Cancel Search';

  @override
  String get virtualKeyboard => 'Virtual Keyboard';

  @override
  String get noRomsAvailable => 'No ROMs available';

  @override
  String get noRomsForPlatformMessage =>
      'No ROM files were found for this platform. ROM files should be placed as .txt files containing download URLs in the platform directory.';

  @override
  String get noMatchingRoms => 'No matching ROMs';

  @override
  String get tryDifferentSearch => 'Try a different search term';

  @override
  String get saveToPermanentStorage => 'Save to permanent storage';

  @override
  String get temporary => 'Temporary';

  @override
  String get permanent => 'Permanent';

  @override
  String get tempPathLabel => 'Temp';

  @override
  String get foreverPathLabel => 'Forever';

  @override
  String get storageOverview => 'Storage Overview';

  @override
  String get clearTemporaryStorage => 'Clear temporary storage';

  @override
  String filesCount(String count) {
    return '$count files';
  }

  @override
  String pathDisplay(String label, String path) {
    return '$label path: $path';
  }

  @override
  String get unknown => 'Unknown';

  @override
  String get tagVerifiedGoodDump => 'Verified good dump - confirmed working';

  @override
  String get tagBadDump => 'Bad dump - may not work correctly';

  @override
  String get tagAlternateVersion => 'Alternate version';

  @override
  String get tagOverdump => 'Overdump - contains extra data';

  @override
  String get tagModifiedHacked => 'Modified/hacked ROM';

  @override
  String get tagFanTranslation => 'Fan translation';

  @override
  String get tagPirateBootleg => 'Pirate/bootleg version';

  @override
  String get tagFixedVersion => 'Fixed version';

  @override
  String get tagCheatTrainer => 'Includes cheat trainer';

  @override
  String tagVersion(String text) {
    return 'Version: $text';
  }

  @override
  String tagSpecialRelease(String text) {
    return 'Special release: $text';
  }

  @override
  String tagMediaInfo(String text) {
    return 'Media info: $text';
  }

  @override
  String noEmulatorConfigured(
    String displayName,
    String platform,
    String configPath,
  ) {
    return 'No emulator configured for $displayName.\n\nPlease add configuration for \"$platform\" in:\n$configPath';
  }

  @override
  String get noEmulatorCommandAvailable => 'No emulator command available';

  @override
  String platformNotSupportedWeb(String platform, String supportedPlatforms) {
    return 'Platform \"$platform\" is not yet supported in web browser.\n\nSupported platforms: $supportedPlatforms';
  }

  @override
  String failedToLaunchWebEmulator(String error) {
    return 'Failed to launch web emulator: $error';
  }

  @override
  String failedToLaunchRom(String error) {
    return 'Failed to launch ROM.\n\nCheck that:\n• Emulator is installed correctly\n• ROM file is valid\n• Configuration is correct\n\nError: $error';
  }

  @override
  String errorLaunchingRom(String error) {
    return 'Error launching ROM: $error';
  }

  @override
  String noInfoAvailable(String platformName) {
    return 'No information available for $platformName';
  }

  @override
  String get platformInfoTooltip => 'Platform Info (I)';

  @override
  String get navigationHint => 'Use arrow keys or swipe to navigate';

  @override
  String get noGamesFound => 'No games found';

  @override
  String get noGamesFoundForSearch => 'No games found for search';

  @override
  String get tryDifferentSearchOrClear =>
      'Try a different search term or clear the filter';

  @override
  String get checkStorageOrDownload =>
      'Check your storage settings or download some ROMs';

  @override
  String get searchGamesHint => 'Search games...';

  @override
  String get settingsHeaderTitle => 'Forsaken Emulator Configuration';

  @override
  String get settingsHeaderSubtitle =>
      'Configure emulators, paths, and download content';

  @override
  String get emulatorManagementDesc =>
      'Add, edit, and configure emulator commands';

  @override
  String get systemPaths => 'System Paths';

  @override
  String get systemPathsDesc => 'Configure ROMs, media, and emulator paths';

  @override
  String get romDatabaseDesc => 'Download and manage ROM lists from GitHub';

  @override
  String get romStorageDesc =>
      'Manage downloaded ROMs, storage, and temp files cleanup';

  @override
  String get downloadManagerDesc =>
      'Download emulators, ROMs lists, and game data';

  @override
  String get systemRequirementsDesc => 'Check required tools and dependencies';

  @override
  String get gamepadTestDebug => 'Gamepad Test & Debug';

  @override
  String get gamepadTestDebugDesc =>
      'Test gamepad buttons, axes, and troubleshoot issues';

  @override
  String get biosFirmwareHelpDesc =>
      'Check BIOS files and firmware requirements';

  @override
  String get webSettingsDesc => 'CORS proxy and web platform configuration';

  @override
  String get setupWizardDesc => 'Re-run the initial setup wizard';

  @override
  String get languageDesc => 'Select application language';

  @override
  String get aboutDebug => 'About & Debug';

  @override
  String get aboutDebugDesc => 'App information and debug settings';

  @override
  String get legalDisclaimer => 'Legal Disclaimer';

  @override
  String get romDatabaseCredits =>
      'ROM lists are originally sourced from the AndroidRoms repository by Arley4d:';

  @override
  String get romDatabaseThanks =>
      'Special thanks to the AndroidRoms project for maintaining comprehensive ROM databases for preservation purposes.';

  @override
  String get biosFilesSection => 'BIOS Files';

  @override
  String get biosFilesCredits =>
      'BIOS files are sourced from the retroarch_system repository by Abdess:';

  @override
  String get biosFilesThanks =>
      'This repository contains system files and BIOS required by various emulation platforms. Special thanks to the maintainers for preserving these essential files.';

  @override
  String get amigaCopyProtection =>
      'Amiga copy protection support provided by the capsimg library:';

  @override
  String get amigaCopyProtectionThanks =>
      'Special thanks to rsn8887 for maintaining the capsimg library that enables IPF (copy-protected) disk image support for Amiga emulation.';

  @override
  String get additionalBiosFiles =>
      'Additional BIOS files provided by the RetroPieBios project:';

  @override
  String get additionalBiosThanks =>
      'Thanks to PIBSAS/RetroPieBios for providing additional BIOS variants and regional files that enhance compatibility across different systems and regions.';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get disclaimerRequired =>
      'You must accept the disclaimer to continue.';

  @override
  String get emulatorsPathRequired => 'Emulators directory path is required.';

  @override
  String get emulatorConfigPathRequired =>
      'Emulator config file path is required.';

  @override
  String get mediaPathRequired => 'Media path is required.';

  @override
  String get tempRomPathRequired => 'Temporary ROM storage path is required.';

  @override
  String get permanentRomPathRequired =>
      'Permanent ROM storage path is required.';

  @override
  String wizardStepCounter(int current, int total) {
    return 'Step $current / $total';
  }

  @override
  String get emulatorConfiguration => 'Emulator Configuration';

  @override
  String get emulatorConfigStepDesc =>
      'Set the paths where your emulators are installed. You can change these later in Settings > System Paths.';

  @override
  String get emulatorsDirectory => 'Emulators Directory';

  @override
  String get pathToEmulatorBinaries => 'Path to emulator binaries';

  @override
  String get emulatorConfigFile => 'Emulator Config File';

  @override
  String get pathToEmulatorConfig => 'Path to emulator configuration JSON';

  @override
  String get storagePaths => 'Storage Paths';

  @override
  String get storagePathsStepDesc =>
      'Configure where media assets and ROM files are stored. You can change these later in Settings > System Paths.';

  @override
  String get wizardMediaPathHint => 'Box art, screenshots, and videos';

  @override
  String get temporaryRomStorage => 'Temporary ROM Storage';

  @override
  String get temporaryRomStorageHint =>
      'Downloaded ROMs for single play sessions';

  @override
  String get permanentRomStorage => 'Permanent ROM Storage';

  @override
  String get permanentRomStorageHint => 'ROMs saved for offline play';

  @override
  String get allSet => 'You\'re All Set!';

  @override
  String get wizardEmulatorReady => 'Forsaken Emulator is ready to use.';

  @override
  String get changeSettingsLater =>
      'You can change any of these settings later from the Settings screen.';

  @override
  String get configurationSummary => 'Configuration Summary';

  @override
  String get summaryEmulators => 'Emulators';

  @override
  String get summaryMedia => 'Media';

  @override
  String get summaryTempRoms => 'Temp ROMs';

  @override
  String get summarySavedRoms => 'Saved ROMs';

  @override
  String get defaultValue => '(default)';

  @override
  String pdfPageIndicator(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get pdfZoomOut => 'Zoom out (-)';

  @override
  String get pdfZoomIn => 'Zoom in (+)';

  @override
  String get pdfResetZoom => 'Reset zoom (0)';

  @override
  String get pdfFirstPage => 'First page (Home)';

  @override
  String get pdfPreviousPage => 'Previous page (←/PgUp)';

  @override
  String get pdfNextPage => 'Next page (→/PgDn)';

  @override
  String get pdfLastPage => 'Last page (End)';

  @override
  String get pdfFileNotFound => 'PDF file not found';

  @override
  String confirmDeleteEmulator(String system) {
    return 'Are you sure you want to delete the emulator configuration for $system?';
  }

  @override
  String commandsConfigured(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count commands configured',
      one: '1 command configured',
    );
    return '$_temp0';
  }

  @override
  String get noCommand => 'No command';

  @override
  String get reloadConfigTooltip => 'Reload Configuration (R)';

  @override
  String get configurationInfo => 'Configuration Info';

  @override
  String get configLocation => 'Config location:';

  @override
  String get hasLocalOverridesYes => 'Has local overrides: Yes';

  @override
  String get hasLocalOverridesNo => 'Has local overrides: No';

  @override
  String get changesSavedToDevice =>
      'Your changes are saved to device storage.';

  @override
  String get usingBundledConfig =>
      'Using bundled config. Edit to create local overrides.';

  @override
  String get noEmulatorsConfigured => 'No emulators configured';

  @override
  String get addFirstEmulator => 'Add your first emulator to get started';

  @override
  String get edit => 'Edit';

  @override
  String get editEmulator => 'Edit Emulator';

  @override
  String get system => 'System';

  @override
  String get systemHint => 'e.g., nes, snes, ps1';

  @override
  String get commands => 'Commands';

  @override
  String commandNumber(int number) {
    return 'Command $number';
  }

  @override
  String get commandHint => 'e.g., ../retroarch.AppImage -f -L core.so';

  @override
  String get remove => 'Remove';

  @override
  String get options => 'Options';

  @override
  String get biosDownloading => 'Downloading...';

  @override
  String downloadRequiredAndExtras(int requiredCount, int optionalCount) {
    return 'Download $requiredCount required + $optionalCount extras';
  }

  @override
  String downloadRequiredFiles(int requiredCount) {
    return 'Download $requiredCount required files';
  }

  @override
  String downloadOptionalExtras(int optionalCount) {
    return 'Download $optionalCount optional extras';
  }

  @override
  String get downloadFiles => 'Download files';

  @override
  String batchDownloadConfirmation(int totalFiles, int platformCount) {
    return 'This will download $totalFiles BIOS files for $platformCount platforms:';
  }

  @override
  String get downloadSourceNote =>
      'Files will be downloaded from the retroarch_system repository.';

  @override
  String get biosOptional => 'OPTIONAL';

  @override
  String biosFilesFound(int foundCount, int totalCount) {
    return '$foundCount/$totalCount files found';
  }

  @override
  String optionalExtrasAvailable(int count) {
    return '+$count optional extras available';
  }

  @override
  String get biosLocations => 'Locations:';

  @override
  String get availableForDownload =>
      'Available for download from multiple sources';

  @override
  String get summary => 'Summary';

  @override
  String get biosComplete => 'Complete';

  @override
  String get biosPartial => 'Partial';

  @override
  String get biosFiles => 'Files';

  @override
  String get biosDownloadable => 'Downloadable';

  @override
  String get refreshF5Tooltip => 'Refresh (F5)';

  @override
  String get allBiosFilesFound => 'All BIOS files found!';

  @override
  String get noBiosRequirements => 'No BIOS requirements found';

  @override
  String platformCount(int count) {
    return '$count platforms';
  }

  @override
  String failedToLoadBiosStatus(String error) {
    return 'Failed to load BIOS status: $error';
  }

  @override
  String get refreshStatus => 'Refresh Status';

  @override
  String platformsCompleteCount(int complete, int total) {
    return '$complete/$total platforms complete';
  }

  @override
  String get platformStatusHeader => 'Platform Status';

  @override
  String filesVerifiedStatus(
    int presentFiles,
    int totalFiles,
    int verifiedFiles,
  ) {
    return '$presentFiles/$totalFiles files ($verifiedFiles verified)';
  }

  @override
  String get biosCollectionOverview => 'BIOS Collection Overview';

  @override
  String get biosVerified => 'Verified';

  @override
  String downloadComingSoon(String platformName) {
    return 'Download functionality for $platformName - Coming soon!';
  }

  @override
  String get noGamepadConnected => 'No gamepad connected';

  @override
  String get connectGamepadPrompt => 'Connect a gamepad and press any button';

  @override
  String get pressButtonToTest => 'Press any button to test (actions disabled)';

  @override
  String get buttonFunctionTests => 'Button Function Tests';

  @override
  String get gamepadASelect => 'A (Select)';

  @override
  String get gamepadBBack => 'B (Back)';

  @override
  String get gamepadXSearch => 'X (Search)';

  @override
  String get gamepadYHelp => 'Y (Help)';

  @override
  String get gamepadLBPageDown => 'LB (Page Down)';

  @override
  String get gamepadRBPageUp => 'RB (Page Up)';

  @override
  String get gamepadStartMenu => 'Start (Menu)';

  @override
  String get gamepadSelectSettings => 'Select (Settings)';

  @override
  String get gamepadLSClick => 'LS Click';

  @override
  String get gamepadRSView => 'RS Click (View)';

  @override
  String get gamepadLTTrigger => 'LT (Trigger)';

  @override
  String get gamepadRTTrigger => 'RT (Trigger)';

  @override
  String get rawButtonStates => 'Raw Button States';

  @override
  String get noButtonsPressed => 'No buttons pressed';

  @override
  String get axisValues => 'Axis Values';

  @override
  String get noAxisMovement => 'No axis movement';

  @override
  String get dpadLeftStick => 'D-Pad + Left Stick';

  @override
  String get webSettingsDescription =>
      'Configure settings specific to the web platform';

  @override
  String get corsProxyWhyNeeded => 'Why is a CORS proxy needed?';

  @override
  String get corsProxyExplanation =>
      'Browsers block ROM downloads from external servers due to CORS security restrictions. A CORS proxy relays the request from a server you control, adding the necessary headers.\n\nForsaken includes a Cloudflare Worker you can deploy for free (100k requests/day). See the tools/cors-proxy-worker/ directory for setup instructions.';

  @override
  String get corsProxyUrl => 'CORS Proxy URL';

  @override
  String get corsProxyHelperText =>
      'Leave empty to disable CORS proxy (ROMs from servers without CORS will fail)';

  @override
  String get testingProxy => 'Testing proxy...';

  @override
  String get testProxyConnection => 'Test Proxy Connection';

  @override
  String get noProxyUrlConfigured => 'No proxy URL configured';

  @override
  String proxyWorking(int statusCode) {
    return 'Proxy is working (HTTP $statusCode)';
  }

  @override
  String proxyReturnedHttp(int statusCode) {
    return 'Proxy returned HTTP $statusCode';
  }

  @override
  String get connectionTimedOut => 'Connection timed out';

  @override
  String get corsProxySettingsSaved =>
      'CORS proxy settings saved. Takes effect immediately for new ROM launches.';

  @override
  String get quickDeploy => 'Quick Deploy';

  @override
  String get corsProxyDeploySteps =>
      '1. Sign up at dash.cloudflare.com (free)\n2. Install Wrangler: npm install -g wrangler\n3. Login: wrangler login\n4. cd tools/cors-proxy-worker\n5. npx wrangler deploy\n6. Paste the worker URL above';

  @override
  String get permanentStorage => 'Permanent Storage';

  @override
  String get temporaryStorage => 'Temporary Storage';

  @override
  String get noDownloadedRoms => 'No downloaded ROMs';

  @override
  String get biosErrorNetworkMessage => 'Network connection failed';

  @override
  String get biosErrorNetworkSuggestions =>
      'Check your internet connection\nTry again in a few moments\nVerify DNS settings\nTry using a VPN if access is restricted';

  @override
  String get biosErrorFileNotFoundMessage => 'File not found on server';

  @override
  String get biosErrorFileNotFoundSuggestions =>
      'The BIOS file may have been moved or renamed\nTry downloading from an alternative source\nCheck if the file exists in a different branch/repository\nReport this issue if problem persists';

  @override
  String get biosErrorAccessDeniedMessage => 'Access denied by server';

  @override
  String get biosErrorAccessDeniedSuggestions =>
      'Server may be blocking downloads\nTry again later - server may be temporarily restricted\nUse VPN if access is region-restricted\nCheck if authentication is required';

  @override
  String get biosErrorRateLimitedMessage => 'Rate limit exceeded';

  @override
  String get biosErrorRateLimitedSuggestions =>
      'Wait a few minutes before trying again\nReduce number of simultaneous downloads\nServer is protecting against excessive requests';

  @override
  String get biosErrorChecksumMessage => 'File integrity verification failed';

  @override
  String get biosErrorChecksumSuggestions =>
      'File may be corrupted during download\nTry downloading again\nCheck if file was updated on server\nVerify your internet connection stability';

  @override
  String get biosErrorSizeMismatchMessage => 'Unexpected file size';

  @override
  String get biosErrorSizeMismatchSuggestions =>
      'File may be different version than expected\nDownload may be incomplete\nTry downloading again\nCheck available disk space';

  @override
  String get biosErrorStorageMessage => 'Storage error';

  @override
  String get biosErrorStorageSuggestions =>
      'Free up disk space\nCheck file permissions\nEnsure destination directory is writable\nTry downloading to a different location';

  @override
  String get biosErrorTimeoutMessage => 'Download timeout';

  @override
  String get biosErrorTimeoutSuggestions =>
      'Internet connection may be slow\nServer may be overloaded\nTry again with a stable connection\nCheck if firewall is blocking the connection';

  @override
  String get biosErrorArchiveMessage => 'Archive extraction failed';

  @override
  String get biosErrorArchiveSuggestions =>
      'Downloaded archive may be corrupted\nTry downloading the file again\nCheck if correct extraction tool is available\nVerify file is a valid archive format';

  @override
  String get biosErrorUnknownMessage => 'Download failed';

  @override
  String get biosErrorUnknownSuggestions =>
      'Try downloading again\nCheck your internet connection\nVerify the file is still available\nContact support if problem persists';

  @override
  String get wizardDownloadEmulators => 'Download Emulators';

  @override
  String get wizardDownloadEmulatorsDesc =>
      'Download pre-configured emulator binaries for your platform. You can choose to download all or select by category.';

  @override
  String get wizardDownloadRomLists => 'Download ROM Lists';

  @override
  String get wizardDownloadRomListsDesc =>
      'Download the ROM database files from GitHub. These contain metadata for organizing your game library.';

  @override
  String get wizardDownloadGamelists => 'Download Gamelists';

  @override
  String get wizardDownloadGamelistsDesc =>
      'Download gamelist.xml files from GitHub. These contain game names, descriptions, ratings, and other metadata.';

  @override
  String get wizardSkipStep => 'Skip';

  @override
  String get wizardDownloadComplete => 'Download complete!';

  @override
  String wizardDownloadFailed(String error) {
    return 'Download failed: $error';
  }

  @override
  String get wizardAlreadyDownloaded => 'Already downloaded';

  @override
  String get wizardSelectCategory =>
      'Select a category to download, or download all:';

  @override
  String get wizardDownloading => 'Downloading...';

  @override
  String get wizardDownloadOptional =>
      'This step is optional. You can download later from Settings.';

  @override
  String get archiveOrgSettings => 'Archive.org Account';

  @override
  String get archiveOrgSettingsDesc =>
      'Configure Archive.org credentials for ROM downloads';

  @override
  String get archiveOrgSettingsDescription =>
      'Some ROMs are hosted on Archive.org and require authentication to download. Configure your S3 API keys here.';

  @override
  String get archiveOrgWhyNeeded => 'Why are credentials needed?';

  @override
  String get archiveOrgExplanation =>
      'Some files on Archive.org require a logged-in account to download. Forsaken uses S3-style API keys so your password is never stored.\n\nGenerate your keys at:\nhttps://archive.org/account/s3.php';

  @override
  String get archiveOrgAccessKey => 'Access Key';

  @override
  String get archiveOrgSecretKey => 'Secret Key';

  @override
  String get archiveOrgAccessKeyHint => 'Your S3-like access key';

  @override
  String get archiveOrgSecretKeyHint => 'Your S3-like secret key';

  @override
  String get archiveOrgSettingsSaved => 'Archive.org credentials saved.';

  @override
  String get archiveOrgAuthRequired => 'Authentication Required';

  @override
  String get archiveOrgAuthRequiredMessage =>
      'This file requires an Archive.org account to download.\n\nPlease configure your Archive.org S3 API keys in Settings to continue.';

  @override
  String get goToSettings => 'Go to Settings';
}
