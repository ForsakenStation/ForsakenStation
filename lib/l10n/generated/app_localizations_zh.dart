// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Forsaken Emulator';

  @override
  String get retroGamingFrontend => 'Retro Gaming Frontend';

  @override
  String get platforms => '平台';

  @override
  String get roms => 'ROM';

  @override
  String get settings => '设置';

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
  String get back => '返回';

  @override
  String get select => '选择';

  @override
  String get search => '搜索';

  @override
  String get refresh => '刷新';

  @override
  String get loading => '加载中...';

  @override
  String get error => '错误';

  @override
  String get initializationError => 'Initialization Error';

  @override
  String get retry => '重试';

  @override
  String get cancel => '取消';

  @override
  String get ok => '确定';

  @override
  String get save => '保存';

  @override
  String get delete => '删除';

  @override
  String get confirm => '确认';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get close => '关闭';

  @override
  String get noRomsFound => '未找到ROM';

  @override
  String get noPlatformsFound => '未找到平台';

  @override
  String get checkRomsPath => 'Check your ROMS_PATH environment variable';

  @override
  String get downloading => '下载中...';

  @override
  String get downloadComplete => '下载完成';

  @override
  String get downloadFailed => '下载失败';

  @override
  String get emulatorNotFound => '未找到模拟器';

  @override
  String get romNotFound => '未找到ROM';

  @override
  String get biosRequired => '需要BIOS';

  @override
  String get systemCheck => '系统检查';

  @override
  String get language => '语言';

  @override
  String get theme => '主题';

  @override
  String get systemDefault => '系统默认';

  @override
  String get help => '帮助';

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
  String get exit => '退出';

  @override
  String get exitApplication => 'Exit Application';

  @override
  String get exitConfirm => '确定要退出吗？';

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
  String get favorites => '收藏';

  @override
  String get all => '全部';

  @override
  String get collections => '集合';

  @override
  String get searchRoms => '搜索ROM...';

  @override
  String get searchPlatforms => '搜索平台...';

  @override
  String romsCount(int count) {
    return '$count 个ROM';
  }

  @override
  String platformsCount(int count) {
    return '$count 个平台';
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
  String get biosMissing => 'BIOS missing';

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
  String get gamepadConnected => 'Gamepad connected';

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
}
