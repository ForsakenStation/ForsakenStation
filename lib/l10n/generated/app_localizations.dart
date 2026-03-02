import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Forsaken Emulator'**
  String get appTitle;

  /// Subtitle shown on initializing screen
  ///
  /// In en, this message translates to:
  /// **'Retro Gaming Frontend'**
  String get retroGamingFrontend;

  /// No description provided for @platforms.
  ///
  /// In en, this message translates to:
  /// **'Platforms'**
  String get platforms;

  /// No description provided for @roms.
  ///
  /// In en, this message translates to:
  /// **'ROMs'**
  String get roms;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsAndConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Settings & Configuration'**
  String get settingsAndConfiguration;

  /// No description provided for @aboutForsakenEmulator.
  ///
  /// In en, this message translates to:
  /// **'About Forsaken Emulator'**
  String get aboutForsakenEmulator;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'A modern multi-platform emulator frontend built with Flutter.'**
  String get appDescription;

  /// No description provided for @emulators.
  ///
  /// In en, this message translates to:
  /// **'Emulators'**
  String get emulators;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @initializationError.
  ///
  /// In en, this message translates to:
  /// **'Initialization Error'**
  String get initializationError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @noRomsFound.
  ///
  /// In en, this message translates to:
  /// **'No ROMs found'**
  String get noRomsFound;

  /// No description provided for @noPlatformsFound.
  ///
  /// In en, this message translates to:
  /// **'No platforms found'**
  String get noPlatformsFound;

  /// No description provided for @checkRomsPath.
  ///
  /// In en, this message translates to:
  /// **'Check your ROMS_PATH environment variable'**
  String get checkRomsPath;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloading;

  /// No description provided for @downloadComplete.
  ///
  /// In en, this message translates to:
  /// **'Download complete'**
  String get downloadComplete;

  /// No description provided for @downloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get downloadFailed;

  /// No description provided for @emulatorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Emulator not found'**
  String get emulatorNotFound;

  /// No description provided for @romNotFound.
  ///
  /// In en, this message translates to:
  /// **'ROM not found'**
  String get romNotFound;

  /// No description provided for @biosRequired.
  ///
  /// In en, this message translates to:
  /// **'BIOS required'**
  String get biosRequired;

  /// No description provided for @systemCheck.
  ///
  /// In en, this message translates to:
  /// **'System Check'**
  String get systemCheck;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @keyboardAndGamepadControls.
  ///
  /// In en, this message translates to:
  /// **'Keyboard & Gamepad Controls'**
  String get keyboardAndGamepadControls;

  /// No description provided for @navigation.
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get navigation;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @viewControls.
  ///
  /// In en, this message translates to:
  /// **'View Controls'**
  String get viewControls;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get gotIt;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @exitApplication.
  ///
  /// In en, this message translates to:
  /// **'Exit Application'**
  String get exitApplication;

  /// No description provided for @exitConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get exitConfirm;

  /// No description provided for @downloadManager.
  ///
  /// In en, this message translates to:
  /// **'Download Manager'**
  String get downloadManager;

  /// No description provided for @clearCompleted.
  ///
  /// In en, this message translates to:
  /// **'Clear Completed'**
  String get clearCompleted;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @confirmDownload.
  ///
  /// In en, this message translates to:
  /// **'Confirm Download'**
  String get confirmDownload;

  /// No description provided for @downloadGameLists.
  ///
  /// In en, this message translates to:
  /// **'Download Game Lists'**
  String get downloadGameLists;

  /// No description provided for @downloadGameListsDescription.
  ///
  /// In en, this message translates to:
  /// **'This will download ROM lists from GitHub.'**
  String get downloadGameListsDescription;

  /// No description provided for @gameListsDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Game lists downloaded!'**
  String get gameListsDownloaded;

  /// No description provided for @romStorageManagement.
  ///
  /// In en, this message translates to:
  /// **'ROM Storage Management'**
  String get romStorageManagement;

  /// No description provided for @deleteRom.
  ///
  /// In en, this message translates to:
  /// **'Delete ROM?'**
  String get deleteRom;

  /// No description provided for @deleteRomConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete {fileName}?'**
  String deleteRomConfirm(String fileName);

  /// No description provided for @actionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get actionCannotBeUndone;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted: {fileName}'**
  String deleted(String fileName);

  /// No description provided for @savePermanently.
  ///
  /// In en, this message translates to:
  /// **'Save Permanently?'**
  String get savePermanently;

  /// No description provided for @moveRomConfirm.
  ///
  /// In en, this message translates to:
  /// **'Move {fileName} to permanent storage?'**
  String moveRomConfirm(String fileName);

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved: {fileName}'**
  String saved(String fileName);

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All?'**
  String get clearAll;

  /// No description provided for @clearAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete all temporary ROMs?'**
  String get clearAllConfirm;

  /// No description provided for @allCleared.
  ///
  /// In en, this message translates to:
  /// **'All temporary ROMs cleared'**
  String get allCleared;

  /// No description provided for @systemPathsConfiguration.
  ///
  /// In en, this message translates to:
  /// **'System Paths Configuration'**
  String get systemPathsConfiguration;

  /// No description provided for @migrateRoms.
  ///
  /// In en, this message translates to:
  /// **'Migrate ROMs?'**
  String get migrateRoms;

  /// No description provided for @migrateRomsDescription.
  ///
  /// In en, this message translates to:
  /// **'The permanent ROM storage path has changed from \$oldPath to \$newPath. Would you like to migrate existing ROMs to the new location?'**
  String get migrateRomsDescription;

  /// No description provided for @noKeepThem.
  ///
  /// In en, this message translates to:
  /// **'No, keep them'**
  String get noKeepThem;

  /// No description provided for @yesMigrateRoms.
  ///
  /// In en, this message translates to:
  /// **'Yes, migrate ROMs'**
  String get yesMigrateRoms;

  /// No description provided for @migratingRoms.
  ///
  /// In en, this message translates to:
  /// **'Migrating ROMs...'**
  String get migratingRoms;

  /// No description provided for @romMigrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Warning: ROM migration failed'**
  String get romMigrationFailed;

  /// No description provided for @pathsSaved.
  ///
  /// In en, this message translates to:
  /// **'Paths saved successfully'**
  String get pathsSaved;

  /// No description provided for @errorSavingPaths.
  ///
  /// In en, this message translates to:
  /// **'Error saving paths:'**
  String get errorSavingPaths;

  /// No description provided for @resetConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Reset Configuration'**
  String get resetConfiguration;

  /// No description provided for @resetConfigDescription.
  ///
  /// In en, this message translates to:
  /// **'This will reset all paths to their default values. Your ROMs and media files will not be affected.'**
  String get resetConfigDescription;

  /// No description provided for @configurationReset.
  ///
  /// In en, this message translates to:
  /// **'Configuration reset to defaults'**
  String get configurationReset;

  /// No description provided for @errorResettingConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Error resetting configuration:'**
  String get errorResettingConfiguration;

  /// No description provided for @savePaths.
  ///
  /// In en, this message translates to:
  /// **'Save Paths'**
  String get savePaths;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @emulatorManagement.
  ///
  /// In en, this message translates to:
  /// **'Emulator Management'**
  String get emulatorManagement;

  /// No description provided for @configurationReloaded.
  ///
  /// In en, this message translates to:
  /// **'Configuration reloaded'**
  String get configurationReloaded;

  /// No description provided for @errorLoadingEmulators.
  ///
  /// In en, this message translates to:
  /// **'Error loading emulators:'**
  String get errorLoadingEmulators;

  /// No description provided for @emulatorAdded.
  ///
  /// In en, this message translates to:
  /// **'Emulator added successfully'**
  String get emulatorAdded;

  /// No description provided for @errorAddingEmulator.
  ///
  /// In en, this message translates to:
  /// **'Error adding emulator:'**
  String get errorAddingEmulator;

  /// No description provided for @emulatorUpdated.
  ///
  /// In en, this message translates to:
  /// **'Emulator updated successfully'**
  String get emulatorUpdated;

  /// No description provided for @errorUpdatingEmulator.
  ///
  /// In en, this message translates to:
  /// **'Error updating emulator:'**
  String get errorUpdatingEmulator;

  /// No description provided for @deleteEmulator.
  ///
  /// In en, this message translates to:
  /// **'Delete Emulator'**
  String get deleteEmulator;

  /// No description provided for @emulatorDeleted.
  ///
  /// In en, this message translates to:
  /// **'Emulator deleted'**
  String get emulatorDeleted;

  /// No description provided for @errorDeletingEmulator.
  ///
  /// In en, this message translates to:
  /// **'Error deleting emulator:'**
  String get errorDeletingEmulator;

  /// No description provided for @configurationSource.
  ///
  /// In en, this message translates to:
  /// **'Configuration Source'**
  String get configurationSource;

  /// No description provided for @addEmulator.
  ///
  /// In en, this message translates to:
  /// **'Add Emulator'**
  String get addEmulator;

  /// No description provided for @systemNameRequired.
  ///
  /// In en, this message translates to:
  /// **'System name is required'**
  String get systemNameRequired;

  /// No description provided for @commandRequired.
  ///
  /// In en, this message translates to:
  /// **'At least one command is required'**
  String get commandRequired;

  /// No description provided for @addCommand.
  ///
  /// In en, this message translates to:
  /// **'Add Command'**
  String get addCommand;

  /// No description provided for @acceptZipFiles.
  ///
  /// In en, this message translates to:
  /// **'Accept ZIP files'**
  String get acceptZipFiles;

  /// No description provided for @acceptZipSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow launching ROMs from ZIP archives'**
  String get acceptZipSubtitle;

  /// No description provided for @useForeverMode.
  ///
  /// In en, this message translates to:
  /// **'Use Forever Mode'**
  String get useForeverMode;

  /// No description provided for @useForeverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep emulator running'**
  String get useForeverSubtitle;

  /// No description provided for @workInProgress.
  ///
  /// In en, this message translates to:
  /// **'Work In Progress'**
  String get workInProgress;

  /// No description provided for @wipSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mark as not yet fully configured'**
  String get wipSubtitle;

  /// No description provided for @biosFirmwareHelp.
  ///
  /// In en, this message translates to:
  /// **'BIOS & Firmware Help'**
  String get biosFirmwareHelp;

  /// No description provided for @downloadMissingFiles.
  ///
  /// In en, this message translates to:
  /// **'Download Missing Files'**
  String get downloadMissingFiles;

  /// No description provided for @showOnlyMissing.
  ///
  /// In en, this message translates to:
  /// **'Show only missing'**
  String get showOnlyMissing;

  /// No description provided for @downloadAllMissingBios.
  ///
  /// In en, this message translates to:
  /// **'Download All Missing BIOS'**
  String get downloadAllMissingBios;

  /// No description provided for @configurationError.
  ///
  /// In en, this message translates to:
  /// **'Configuration Error'**
  String get configurationError;

  /// No description provided for @configurationErrorDescription.
  ///
  /// In en, this message translates to:
  /// **'The application could not find the required configuration.\nPlease configure your paths in Settings > System Paths.'**
  String get configurationErrorDescription;

  /// No description provided for @configurationRequired.
  ///
  /// In en, this message translates to:
  /// **'Required:\n- Media Path: directory containing media assets\n- Emulators Path: directory containing emulator binaries\n\nOptional:\n- ROM storage paths for temporary/permanent downloads'**
  String get configurationRequired;

  /// No description provided for @goToSettingsToConfigure.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings > System Paths to configure'**
  String get goToSettingsToConfigure;

  /// No description provided for @noDownloadableBios.
  ///
  /// In en, this message translates to:
  /// **'No downloadable BIOS files are missing'**
  String get noDownloadableBios;

  /// No description provided for @allDownloadsCompleted.
  ///
  /// In en, this message translates to:
  /// **'All downloads completed successfully!'**
  String get allDownloadsCompleted;

  /// No description provided for @batchDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Batch download failed:'**
  String get batchDownloadFailed;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @downloadCancelled.
  ///
  /// In en, this message translates to:
  /// **'Download cancelled'**
  String get downloadCancelled;

  /// No description provided for @launched.
  ///
  /// In en, this message translates to:
  /// **'Launched:'**
  String get launched;

  /// No description provided for @failedToSave.
  ///
  /// In en, this message translates to:
  /// **'Failed to save ROM permanently'**
  String get failedToSave;

  /// No description provided for @failedToSaveRom.
  ///
  /// In en, this message translates to:
  /// **'Failed to save ROM permanently'**
  String get failedToSaveRom;

  /// No description provided for @errorSaving.
  ///
  /// In en, this message translates to:
  /// **'Error saving ROM:'**
  String get errorSaving;

  /// No description provided for @errorSavingRom.
  ///
  /// In en, this message translates to:
  /// **'Error saving ROM: {error}'**
  String errorSavingRom(String error);

  /// No description provided for @openFolder.
  ///
  /// In en, this message translates to:
  /// **'Open Folder'**
  String get openFolder;

  /// No description provided for @viewManual.
  ///
  /// In en, this message translates to:
  /// **'View Manual'**
  String get viewManual;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get clearSearch;

  /// No description provided for @iUnderstand.
  ///
  /// In en, this message translates to:
  /// **'I understand and agree to these terms'**
  String get iUnderstand;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @debugMode.
  ///
  /// In en, this message translates to:
  /// **'Debug Mode: '**
  String get debugMode;

  /// No description provided for @toggleDebugMode.
  ///
  /// In en, this message translates to:
  /// **'Toggle Debug Mode'**
  String get toggleDebugMode;

  /// No description provided for @preparingDownload.
  ///
  /// In en, this message translates to:
  /// **'Preparing download...'**
  String get preparingDownload;

  /// No description provided for @noEmulatorsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No emulators available for this category'**
  String get noEmulatorsAvailable;

  /// No description provided for @failedToLaunch.
  ///
  /// In en, this message translates to:
  /// **'Failed to launch web emulator:'**
  String get failedToLaunch;

  /// No description provided for @platformInfo.
  ///
  /// In en, this message translates to:
  /// **'Platform Info'**
  String get platformInfo;

  /// No description provided for @emulatorPlatformInfo.
  ///
  /// In en, this message translates to:
  /// **'EmulatorPlatform Info'**
  String get emulatorPlatformInfo;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @collections.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get collections;

  /// No description provided for @searchRoms.
  ///
  /// In en, this message translates to:
  /// **'Search ROMs...'**
  String get searchRoms;

  /// No description provided for @searchPlatforms.
  ///
  /// In en, this message translates to:
  /// **'Search platforms...'**
  String get searchPlatforms;

  /// No description provided for @romsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} ROMs'**
  String romsCount(int count);

  /// No description provided for @platformsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} platforms'**
  String platformsCount(int count);

  /// No description provided for @region.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get region;

  /// No description provided for @genre.
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get genre;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @publisher.
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get publisher;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @playWithNetplay.
  ///
  /// In en, this message translates to:
  /// **'Play with Netplay'**
  String get playWithNetplay;

  /// No description provided for @downloadBios.
  ///
  /// In en, this message translates to:
  /// **'Download BIOS'**
  String get downloadBios;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get removeFromFavorites;

  /// No description provided for @biosMissing.
  ///
  /// In en, this message translates to:
  /// **'BIOS missing'**
  String get biosMissing;

  /// No description provided for @biosPresent.
  ///
  /// In en, this message translates to:
  /// **'BIOS present'**
  String get biosPresent;

  /// No description provided for @checkingBios.
  ///
  /// In en, this message translates to:
  /// **'Checking BIOS...'**
  String get checkingBios;

  /// No description provided for @emulatorDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading emulator...'**
  String get emulatorDownloading;

  /// No description provided for @emulatorDownloadComplete.
  ///
  /// In en, this message translates to:
  /// **'Emulator downloaded'**
  String get emulatorDownloadComplete;

  /// No description provided for @emulatorDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to download emulator'**
  String get emulatorDownloadFailed;

  /// No description provided for @installingEmulator.
  ///
  /// In en, this message translates to:
  /// **'Installing emulator...'**
  String get installingEmulator;

  /// No description provided for @emulatorReady.
  ///
  /// In en, this message translates to:
  /// **'Emulator ready'**
  String get emulatorReady;

  /// No description provided for @configuration.
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get configuration;

  /// No description provided for @paths.
  ///
  /// In en, this message translates to:
  /// **'Paths'**
  String get paths;

  /// No description provided for @storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// No description provided for @emulatorsPath.
  ///
  /// In en, this message translates to:
  /// **'Emulators Path'**
  String get emulatorsPath;

  /// No description provided for @romsPath.
  ///
  /// In en, this message translates to:
  /// **'ROMs Path'**
  String get romsPath;

  /// No description provided for @mediaPath.
  ///
  /// In en, this message translates to:
  /// **'Media Path'**
  String get mediaPath;

  /// No description provided for @biosPath.
  ///
  /// In en, this message translates to:
  /// **'BIOS Path'**
  String get biosPath;

  /// No description provided for @tempPath.
  ///
  /// In en, this message translates to:
  /// **'Temporary Path'**
  String get tempPath;

  /// No description provided for @browse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get browse;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @scanForRoms.
  ///
  /// In en, this message translates to:
  /// **'Scan for ROMs'**
  String get scanForRoms;

  /// No description provided for @scanningRoms.
  ///
  /// In en, this message translates to:
  /// **'Scanning ROMs...'**
  String get scanningRoms;

  /// No description provided for @scanComplete.
  ///
  /// In en, this message translates to:
  /// **'Scan complete'**
  String get scanComplete;

  /// No description provided for @romsFound.
  ///
  /// In en, this message translates to:
  /// **'{count} ROMs found'**
  String romsFound(int count);

  /// No description provided for @noNewRomsFound.
  ///
  /// In en, this message translates to:
  /// **'No new ROMs found'**
  String get noNewRomsFound;

  /// No description provided for @launchEmulator.
  ///
  /// In en, this message translates to:
  /// **'Launch Emulator'**
  String get launchEmulator;

  /// No description provided for @emulatorError.
  ///
  /// In en, this message translates to:
  /// **'Emulator Error'**
  String get emulatorError;

  /// No description provided for @gamepadConnected.
  ///
  /// In en, this message translates to:
  /// **'Gamepad connected'**
  String get gamepadConnected;

  /// No description provided for @gamepadDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Gamepad disconnected'**
  String get gamepadDisconnected;

  /// No description provided for @gamepadTest.
  ///
  /// In en, this message translates to:
  /// **'Gamepad Test'**
  String get gamepadTest;

  /// No description provided for @pressAnyButton.
  ///
  /// In en, this message translates to:
  /// **'Press any button to test'**
  String get pressAnyButton;

  /// No description provided for @buttonA.
  ///
  /// In en, this message translates to:
  /// **'A'**
  String get buttonA;

  /// No description provided for @buttonB.
  ///
  /// In en, this message translates to:
  /// **'B'**
  String get buttonB;

  /// No description provided for @buttonX.
  ///
  /// In en, this message translates to:
  /// **'X'**
  String get buttonX;

  /// No description provided for @buttonY.
  ///
  /// In en, this message translates to:
  /// **'Y'**
  String get buttonY;

  /// No description provided for @buttonStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get buttonStart;

  /// No description provided for @buttonSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get buttonSelect;

  /// No description provided for @dpadUp.
  ///
  /// In en, this message translates to:
  /// **'D-Pad Up'**
  String get dpadUp;

  /// No description provided for @dpadDown.
  ///
  /// In en, this message translates to:
  /// **'D-Pad Down'**
  String get dpadDown;

  /// No description provided for @dpadLeft.
  ///
  /// In en, this message translates to:
  /// **'D-Pad Left'**
  String get dpadLeft;

  /// No description provided for @dpadRight.
  ///
  /// In en, this message translates to:
  /// **'D-Pad Right'**
  String get dpadRight;

  /// No description provided for @leftShoulder.
  ///
  /// In en, this message translates to:
  /// **'L1'**
  String get leftShoulder;

  /// No description provided for @rightShoulder.
  ///
  /// In en, this message translates to:
  /// **'R1'**
  String get rightShoulder;

  /// No description provided for @leftTrigger.
  ///
  /// In en, this message translates to:
  /// **'L2'**
  String get leftTrigger;

  /// No description provided for @rightTrigger.
  ///
  /// In en, this message translates to:
  /// **'R2'**
  String get rightTrigger;

  /// No description provided for @leftStick.
  ///
  /// In en, this message translates to:
  /// **'Left Stick'**
  String get leftStick;

  /// No description provided for @rightStick.
  ///
  /// In en, this message translates to:
  /// **'Right Stick'**
  String get rightStick;

  /// No description provided for @setupWizard.
  ///
  /// In en, this message translates to:
  /// **'Setup Wizard'**
  String get setupWizard;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Forsaken Emulator'**
  String get welcomeMessage;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @setupComplete.
  ///
  /// In en, this message translates to:
  /// **'Setup Complete'**
  String get setupComplete;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @selectEmulatorsPath.
  ///
  /// In en, this message translates to:
  /// **'Select Emulators Path'**
  String get selectEmulatorsPath;

  /// No description provided for @selectRomsPath.
  ///
  /// In en, this message translates to:
  /// **'Select ROMs Path'**
  String get selectRomsPath;

  /// No description provided for @selectMediaPath.
  ///
  /// In en, this message translates to:
  /// **'Select Media Path'**
  String get selectMediaPath;

  /// No description provided for @allSettingsConfigured.
  ///
  /// In en, this message translates to:
  /// **'All settings configured'**
  String get allSettingsConfigured;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for Updates'**
  String get checkForUpdates;

  /// No description provided for @noUpdatesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No updates available'**
  String get noUpdatesAvailable;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get updateAvailable;

  /// No description provided for @downloadingUpdate.
  ///
  /// In en, this message translates to:
  /// **'Downloading update...'**
  String get downloadingUpdate;

  /// No description provided for @installingUpdate.
  ///
  /// In en, this message translates to:
  /// **'Installing update...'**
  String get installingUpdate;

  /// No description provided for @updateComplete.
  ///
  /// In en, this message translates to:
  /// **'Update complete'**
  String get updateComplete;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update failed'**
  String get updateFailed;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get networkError;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection error'**
  String get connectionError;

  /// No description provided for @timeoutError.
  ///
  /// In en, this message translates to:
  /// **'Timeout error'**
  String get timeoutError;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDenied;

  /// No description provided for @fileNotFound.
  ///
  /// In en, this message translates to:
  /// **'File not found'**
  String get fileNotFound;

  /// No description provided for @directoryNotFound.
  ///
  /// In en, this message translates to:
  /// **'Directory not found'**
  String get directoryNotFound;

  /// No description provided for @diskFull.
  ///
  /// In en, this message translates to:
  /// **'Disk full'**
  String get diskFull;

  /// No description provided for @invalidPath.
  ///
  /// In en, this message translates to:
  /// **'Invalid path'**
  String get invalidPath;

  /// No description provided for @pathNotWritable.
  ///
  /// In en, this message translates to:
  /// **'Path not writable'**
  String get pathNotWritable;

  /// No description provided for @romCorrupted.
  ///
  /// In en, this message translates to:
  /// **'ROM file may be corrupted'**
  String get romCorrupted;

  /// No description provided for @zipError.
  ///
  /// In en, this message translates to:
  /// **'ZIP archive error'**
  String get zipError;

  /// No description provided for @extractionFailed.
  ///
  /// In en, this message translates to:
  /// **'Extraction failed'**
  String get extractionFailed;

  /// No description provided for @checksumMismatch.
  ///
  /// In en, this message translates to:
  /// **'Checksum mismatch'**
  String get checksumMismatch;

  /// No description provided for @biosCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'BIOS check failed'**
  String get biosCheckFailed;

  /// No description provided for @continueAnyway.
  ///
  /// In en, this message translates to:
  /// **'Continue anyway'**
  String get continueAnyway;

  /// No description provided for @reportIssue.
  ///
  /// In en, this message translates to:
  /// **'Report Issue'**
  String get reportIssue;

  /// No description provided for @copyToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get copyToClipboard;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @show.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get show;

  /// No description provided for @toggleView.
  ///
  /// In en, this message translates to:
  /// **'Toggle View'**
  String get toggleView;

  /// No description provided for @gridView.
  ///
  /// In en, this message translates to:
  /// **'Grid View'**
  String get gridView;

  /// No description provided for @listView.
  ///
  /// In en, this message translates to:
  /// **'List View'**
  String get listView;

  /// No description provided for @carouselView.
  ///
  /// In en, this message translates to:
  /// **'Carousel View'**
  String get carouselView;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @sortByName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sortByName;

  /// No description provided for @sortByDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get sortByDate;

  /// No description provided for @sortBySize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get sortBySize;

  /// No description provided for @sortByRegion.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get sortByRegion;

  /// No description provided for @ascending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get ascending;

  /// No description provided for @descending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get descending;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @filterByRegion.
  ///
  /// In en, this message translates to:
  /// **'Filter by Region'**
  String get filterByRegion;

  /// No description provided for @filterByGenre.
  ///
  /// In en, this message translates to:
  /// **'Filter by Genre'**
  String get filterByGenre;

  /// No description provided for @filterByYear.
  ///
  /// In en, this message translates to:
  /// **'Filter by Year'**
  String get filterByYear;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @systemInfo.
  ///
  /// In en, this message translates to:
  /// **'System Info'**
  String get systemInfo;

  /// No description provided for @cpu.
  ///
  /// In en, this message translates to:
  /// **'CPU'**
  String get cpu;

  /// No description provided for @memory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get memory;

  /// No description provided for @storageInfo.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storageInfo;

  /// No description provided for @os.
  ///
  /// In en, this message translates to:
  /// **'Operating System'**
  String get os;

  /// No description provided for @emulatorVersion.
  ///
  /// In en, this message translates to:
  /// **'Emulator Version'**
  String get emulatorVersion;

  /// No description provided for @totalRoms.
  ///
  /// In en, this message translates to:
  /// **'Total ROMs'**
  String get totalRoms;

  /// No description provided for @totalSize.
  ///
  /// In en, this message translates to:
  /// **'Total Size'**
  String get totalSize;

  /// No description provided for @freeSpace.
  ///
  /// In en, this message translates to:
  /// **'Free Space'**
  String get freeSpace;

  /// No description provided for @usedSpace.
  ///
  /// In en, this message translates to:
  /// **'Used Space'**
  String get usedSpace;

  /// No description provided for @systemUtilities.
  ///
  /// In en, this message translates to:
  /// **'System Utilities'**
  String get systemUtilities;

  /// No description provided for @romVerificationResults.
  ///
  /// In en, this message translates to:
  /// **'ROM Verification Results'**
  String get romVerificationResults;

  /// No description provided for @totalRomFiles.
  ///
  /// In en, this message translates to:
  /// **'Total ROM files'**
  String get totalRomFiles;

  /// No description provided for @emptyRomFiles.
  ///
  /// In en, this message translates to:
  /// **'Empty ROM files'**
  String get emptyRomFiles;

  /// No description provided for @validRomFiles.
  ///
  /// In en, this message translates to:
  /// **'Valid ROM files'**
  String get validRomFiles;

  /// No description provided for @romsDirectoryDoesNotExist.
  ///
  /// In en, this message translates to:
  /// **'ROMs directory does not exist'**
  String get romsDirectoryDoesNotExist;

  /// No description provided for @gamelistCheckResults.
  ///
  /// In en, this message translates to:
  /// **'Gamelist Check Results'**
  String get gamelistCheckResults;

  /// No description provided for @totalPlatforms.
  ///
  /// In en, this message translates to:
  /// **'Total platforms'**
  String get totalPlatforms;

  /// No description provided for @missingGamelists.
  ///
  /// In en, this message translates to:
  /// **'Missing gamelists'**
  String get missingGamelists;

  /// No description provided for @configurationBackup.
  ///
  /// In en, this message translates to:
  /// **'Configuration Backup'**
  String get configurationBackup;

  /// No description provided for @configurationBackedUp.
  ///
  /// In en, this message translates to:
  /// **'Configuration backed up to:'**
  String get configurationBackedUp;

  /// No description provided for @errorBackingUp.
  ///
  /// In en, this message translates to:
  /// **'Error backing up configuration:'**
  String get errorBackingUp;

  /// No description provided for @romDatabase.
  ///
  /// In en, this message translates to:
  /// **'ROM Database'**
  String get romDatabase;

  /// No description provided for @romDatabaseDownloaded.
  ///
  /// In en, this message translates to:
  /// **'ROM database downloaded successfully'**
  String get romDatabaseDownloaded;

  /// No description provided for @failedDownloadRomDatabase.
  ///
  /// In en, this message translates to:
  /// **'Failed to download ROM database'**
  String get failedDownloadRomDatabase;

  /// No description provided for @romDatabaseCleared.
  ///
  /// In en, this message translates to:
  /// **'ROM database cleared'**
  String get romDatabaseCleared;

  /// No description provided for @failedClearDatabase.
  ///
  /// In en, this message translates to:
  /// **'Failed to clear database'**
  String get failedClearDatabase;

  /// No description provided for @downloadRomDatabase.
  ///
  /// In en, this message translates to:
  /// **'Download ROM Database'**
  String get downloadRomDatabase;

  /// No description provided for @clearRomDatabase.
  ///
  /// In en, this message translates to:
  /// **'Clear ROM Database'**
  String get clearRomDatabase;

  /// No description provided for @systemRequirements.
  ///
  /// In en, this message translates to:
  /// **'System Requirements'**
  String get systemRequirements;

  /// No description provided for @failedToCheckSystem.
  ///
  /// In en, this message translates to:
  /// **'Failed to check system'**
  String get failedToCheckSystem;

  /// No description provided for @cleanedUpTempFiles.
  ///
  /// In en, this message translates to:
  /// **'Cleaned up {deletedCount} temporary ROM files'**
  String cleanedUpTempFiles(String deletedCount);

  /// No description provided for @errorCleaningTempFiles.
  ///
  /// In en, this message translates to:
  /// **'Error cleaning temp files:'**
  String get errorCleaningTempFiles;

  /// No description provided for @errorVerifyingRomFiles.
  ///
  /// In en, this message translates to:
  /// **'Error verifying ROM files:'**
  String get errorVerifyingRomFiles;

  /// No description provided for @errorCheckingGamelists.
  ///
  /// In en, this message translates to:
  /// **'Error checking gamelists:'**
  String get errorCheckingGamelists;

  /// No description provided for @cancelDownload.
  ///
  /// In en, this message translates to:
  /// **'Cancel Download'**
  String get cancelDownload;

  /// No description provided for @selectEmulator.
  ///
  /// In en, this message translates to:
  /// **'Select Emulator'**
  String get selectEmulator;

  /// No description provided for @biosStatusDashboard.
  ///
  /// In en, this message translates to:
  /// **'BIOS Status Dashboard'**
  String get biosStatusDashboard;

  /// No description provided for @webSettings.
  ///
  /// In en, this message translates to:
  /// **'Web Settings'**
  String get webSettings;

  /// No description provided for @saveSettings.
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get saveSettings;

  /// No description provided for @errorSavingSettings.
  ///
  /// In en, this message translates to:
  /// **'Error saving settings:'**
  String get errorSavingSettings;

  /// No description provided for @romsCountItems.
  ///
  /// In en, this message translates to:
  /// **'{count} ROMs'**
  String romsCountItems(String count);

  /// No description provided for @savedPermanently.
  ///
  /// In en, this message translates to:
  /// **'saved permanently'**
  String get savedPermanently;

  /// No description provided for @keptInTemporary.
  ///
  /// In en, this message translates to:
  /// **'kept in temporary storage'**
  String get keptInTemporary;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @allDownloads.
  ///
  /// In en, this message translates to:
  /// **'All downloads completed'**
  String get allDownloads;

  /// No description provided for @romSavedPermanently.
  ///
  /// In en, this message translates to:
  /// **'{name} saved permanently'**
  String romSavedPermanently(String name);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @romKeptInTemporary.
  ///
  /// In en, this message translates to:
  /// **'{name} kept in temporary storage'**
  String romKeptInTemporary(String name);

  /// No description provided for @romsCountWithSize.
  ///
  /// In en, this message translates to:
  /// **'{count} ROMs • {size}'**
  String romsCountWithSize(String count, String size);

  /// No description provided for @whatYouCanTry.
  ///
  /// In en, this message translates to:
  /// **'What you can try:'**
  String get whatYouCanTry;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// No description provided for @helpNavigateItems.
  ///
  /// In en, this message translates to:
  /// **'Navigate through items'**
  String get helpNavigateItems;

  /// No description provided for @helpGamepadNavigation.
  ///
  /// In en, this message translates to:
  /// **'Gamepad navigation'**
  String get helpGamepadNavigation;

  /// No description provided for @helpQuickNavigation.
  ///
  /// In en, this message translates to:
  /// **'Quick navigation (jump multiple items)'**
  String get helpQuickNavigation;

  /// No description provided for @helpGamepadPageNavigation.
  ///
  /// In en, this message translates to:
  /// **'Gamepad page navigation'**
  String get helpGamepadPageNavigation;

  /// No description provided for @helpGoToFirst.
  ///
  /// In en, this message translates to:
  /// **'Go to first item'**
  String get helpGoToFirst;

  /// No description provided for @helpGoToLast.
  ///
  /// In en, this message translates to:
  /// **'Go to last item'**
  String get helpGoToLast;

  /// No description provided for @helpJumpToLetter.
  ///
  /// In en, this message translates to:
  /// **'Jump to item starting with that letter'**
  String get helpJumpToLetter;

  /// No description provided for @helpSelectItem.
  ///
  /// In en, this message translates to:
  /// **'Select item'**
  String get helpSelectItem;

  /// No description provided for @helpGamepadSelect.
  ///
  /// In en, this message translates to:
  /// **'Gamepad select'**
  String get helpGamepadSelect;

  /// No description provided for @helpGoBackCloseDialogs.
  ///
  /// In en, this message translates to:
  /// **'Go back / Close dialogs'**
  String get helpGoBackCloseDialogs;

  /// No description provided for @helpExitApplication.
  ///
  /// In en, this message translates to:
  /// **'Exit application'**
  String get helpExitApplication;

  /// No description provided for @helpGamepadBackClose.
  ///
  /// In en, this message translates to:
  /// **'Gamepad back / Close dialogs'**
  String get helpGamepadBackClose;

  /// No description provided for @helpToggleViewMode.
  ///
  /// In en, this message translates to:
  /// **'Toggle view mode (Grid/List/Carousel)'**
  String get helpToggleViewMode;

  /// No description provided for @helpGamepadViewToggle.
  ///
  /// In en, this message translates to:
  /// **'Gamepad view toggle'**
  String get helpGamepadViewToggle;

  /// No description provided for @helpRefreshView.
  ///
  /// In en, this message translates to:
  /// **'Refresh current view'**
  String get helpRefreshView;

  /// No description provided for @helpShowPlatformInfo.
  ///
  /// In en, this message translates to:
  /// **'Show platform information'**
  String get helpShowPlatformInfo;

  /// No description provided for @helpActivateSearch.
  ///
  /// In en, this message translates to:
  /// **'Activate search'**
  String get helpActivateSearch;

  /// No description provided for @helpGamepadSearch.
  ///
  /// In en, this message translates to:
  /// **'Gamepad search'**
  String get helpGamepadSearch;

  /// No description provided for @helpShowHelpDialog.
  ///
  /// In en, this message translates to:
  /// **'Show this help dialog'**
  String get helpShowHelpDialog;

  /// No description provided for @helpGamepadHelp.
  ///
  /// In en, this message translates to:
  /// **'Gamepad help'**
  String get helpGamepadHelp;

  /// No description provided for @tipUseKeyboardOrGamepad.
  ///
  /// In en, this message translates to:
  /// **'Use keyboard or gamepad for navigation'**
  String get tipUseKeyboardOrGamepad;

  /// No description provided for @tipAlphabeticalJump.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical jump works in all view modes'**
  String get tipAlphabeticalJump;

  /// No description provided for @tipPressQuestionMark.
  ///
  /// In en, this message translates to:
  /// **'Press ? anytime to see this help'**
  String get tipPressQuestionMark;

  /// No description provided for @tipGamepadAlongside.
  ///
  /// In en, this message translates to:
  /// **'Gamepad works alongside keyboard controls'**
  String get tipGamepadAlongside;

  /// No description provided for @configurePathsDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure the paths used by the application to locate ROMs, media, and emulators.'**
  String get configurePathsDescription;

  /// No description provided for @romListsAutoManaged.
  ///
  /// In en, this message translates to:
  /// **'ROM lists are now managed automatically. Download them from Settings > ROM Database.'**
  String get romListsAutoManaged;

  /// No description provided for @romStorage.
  ///
  /// In en, this message translates to:
  /// **'ROM Storage'**
  String get romStorage;

  /// No description provided for @configureRomStorageDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure where downloaded ROMs are stored temporarily and permanently.'**
  String get configureRomStorageDescription;

  /// No description provided for @resetToDefaults.
  ///
  /// In en, this message translates to:
  /// **'Reset to defaults'**
  String get resetToDefaults;

  /// No description provided for @mediaPathLabel.
  ///
  /// In en, this message translates to:
  /// **'Media Path'**
  String get mediaPathLabel;

  /// No description provided for @mediaPathHint.
  ///
  /// In en, this message translates to:
  /// **'Directory containing media (images, videos)'**
  String get mediaPathHint;

  /// No description provided for @emulatorsPathLabel.
  ///
  /// In en, this message translates to:
  /// **'Emulators Path'**
  String get emulatorsPathLabel;

  /// No description provided for @emulatorsPathHint.
  ///
  /// In en, this message translates to:
  /// **'Directory containing emulator binaries'**
  String get emulatorsPathHint;

  /// No description provided for @gamelistPathAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Gamelist Path (Automatic)'**
  String get gamelistPathAutomatic;

  /// No description provided for @gamelistAutoDescription.
  ///
  /// In en, this message translates to:
  /// **'Gamelists are now managed automatically in the app data directory. This makes the app fully independent and prepares for future GitHub-based gamelist distribution.'**
  String get gamelistAutoDescription;

  /// No description provided for @tempRomStorageLabel.
  ///
  /// In en, this message translates to:
  /// **'Temporary ROM Storage (Optional)'**
  String get tempRomStorageLabel;

  /// No description provided for @tempRomStorageDescription.
  ///
  /// In en, this message translates to:
  /// **'ROMs are downloaded here first. They can be promoted to permanent storage after playing.'**
  String get tempRomStorageDescription;

  /// No description provided for @permanentRomStorageLabel.
  ///
  /// In en, this message translates to:
  /// **'Permanent ROM Storage (Optional)'**
  String get permanentRomStorageLabel;

  /// No description provided for @permanentRomStorageDescription.
  ///
  /// In en, this message translates to:
  /// **'ROMs saved permanently are stored here. These are not cleaned up automatically.'**
  String get permanentRomStorageDescription;

  /// No description provided for @defaultAppSupportDir.
  ///
  /// In en, this message translates to:
  /// **'Default: app support directory'**
  String get defaultAppSupportDir;

  /// No description provided for @currentPathDisplay.
  ///
  /// In en, this message translates to:
  /// **'Current: {path}'**
  String currentPathDisplay(String path);

  /// No description provided for @configurationFile.
  ///
  /// In en, this message translates to:
  /// **'Configuration File'**
  String get configurationFile;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source:'**
  String get source;

  /// No description provided for @customConfigActive.
  ///
  /// In en, this message translates to:
  /// **'Custom configuration active'**
  String get customConfigActive;

  /// No description provided for @pathStructure.
  ///
  /// In en, this message translates to:
  /// **'Path Structure'**
  String get pathStructure;

  /// No description provided for @pathStructureDescription.
  ///
  /// In en, this message translates to:
  /// **'Media Path: MEDIA_PATH/platform/boxart|screenshots|videos/rom.png\nGamelist Path: ~/.local/share/com.example.emulator/gamelists/platform/gamelist.xml (automatic)\nEmulators Path: EMULATORS_PATH/emulator_binary'**
  String get pathStructureDescription;

  /// No description provided for @errorCheckingSystem.
  ///
  /// In en, this message translates to:
  /// **'Error checking system'**
  String get errorCheckingSystem;

  /// No description provided for @recheckR.
  ///
  /// In en, this message translates to:
  /// **'Re-check (R)'**
  String get recheckR;

  /// No description provided for @allRequiredToolsInstalled.
  ///
  /// In en, this message translates to:
  /// **'All Required Tools Installed'**
  String get allRequiredToolsInstalled;

  /// No description provided for @missingRequiredTools.
  ///
  /// In en, this message translates to:
  /// **'Missing Required Tools'**
  String get missingRequiredTools;

  /// No description provided for @systemReadyToUse.
  ///
  /// In en, this message translates to:
  /// **'Your system is ready to use the emulator'**
  String get systemReadyToUse;

  /// No description provided for @someRequiredToolsMissing.
  ///
  /// In en, this message translates to:
  /// **'Some required tools are missing'**
  String get someRequiredToolsMissing;

  /// No description provided for @requiredTools.
  ///
  /// In en, this message translates to:
  /// **'Required Tools'**
  String get requiredTools;

  /// No description provided for @requiredToolsDescription.
  ///
  /// In en, this message translates to:
  /// **'These tools are required for downloading and extracting emulators'**
  String get requiredToolsDescription;

  /// No description provided for @installationInstructions.
  ///
  /// In en, this message translates to:
  /// **'Installation Instructions'**
  String get installationInstructions;

  /// No description provided for @installed.
  ///
  /// In en, this message translates to:
  /// **'Installed'**
  String get installed;

  /// No description provided for @missing.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get missing;

  /// No description provided for @downloadEmulatorsAndGameLists.
  ///
  /// In en, this message translates to:
  /// **'Download emulators and game lists'**
  String get downloadEmulatorsAndGameLists;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @downloadAll.
  ///
  /// In en, this message translates to:
  /// **'Download All'**
  String get downloadAll;

  /// No description provided for @byCategory.
  ///
  /// In en, this message translates to:
  /// **'By Category'**
  String get byCategory;

  /// No description provided for @downloadQueue.
  ///
  /// In en, this message translates to:
  /// **'Download Queue'**
  String get downloadQueue;

  /// No description provided for @noDownloadsInProgress.
  ///
  /// In en, this message translates to:
  /// **'No downloads in progress'**
  String get noDownloadsInProgress;

  /// No description provided for @selectQuickActionToStart.
  ///
  /// In en, this message translates to:
  /// **'Select a quick action above to start downloading'**
  String get selectQuickActionToStart;

  /// No description provided for @categorySony.
  ///
  /// In en, this message translates to:
  /// **'Sony (PS1-PS4)'**
  String get categorySony;

  /// No description provided for @categoryNintendo.
  ///
  /// In en, this message translates to:
  /// **'Nintendo (GC, Wii, Switch)'**
  String get categoryNintendo;

  /// No description provided for @categoryMicrosoft.
  ///
  /// In en, this message translates to:
  /// **'Microsoft (Xbox, Xbox 360)'**
  String get categoryMicrosoft;

  /// No description provided for @categoryMultiPlatform.
  ///
  /// In en, this message translates to:
  /// **'Multi-Platform (RetroArch)'**
  String get categoryMultiPlatform;

  /// No description provided for @categoryOtherEmulators.
  ///
  /// In en, this message translates to:
  /// **'Other Emulators'**
  String get categoryOtherEmulators;

  /// No description provided for @categoryUtilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get categoryUtilities;

  /// No description provided for @confirmDownloadDescription.
  ///
  /// In en, this message translates to:
  /// **'Download {count} emulator(s)?\nEstimated size: ~{size} MB\n\nThis may take a while depending on your internet connection.'**
  String confirmDownloadDescription(String count, String size);

  /// No description provided for @alreadyInstalled.
  ///
  /// In en, this message translates to:
  /// **'Already installed'**
  String get alreadyInstalled;

  /// No description provided for @starting.
  ///
  /// In en, this message translates to:
  /// **'Starting...'**
  String get starting;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @gameListsAlreadyDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Game lists already downloaded'**
  String get gameListsAlreadyDownloaded;

  /// No description provided for @redownload.
  ///
  /// In en, this message translates to:
  /// **'Re-Download'**
  String get redownload;

  /// No description provided for @gameListsFromGitHub.
  ///
  /// In en, this message translates to:
  /// **'Game Lists (from GitHub)'**
  String get gameListsFromGitHub;

  /// No description provided for @downloaded.
  ///
  /// In en, this message translates to:
  /// **'Downloaded'**
  String get downloaded;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @missingFor.
  ///
  /// In en, this message translates to:
  /// **'Missing for:'**
  String get missingFor;

  /// No description provided for @noCustomConfigToBackup.
  ///
  /// In en, this message translates to:
  /// **'No custom configuration to backup. Using bundled defaults.'**
  String get noCustomConfigToBackup;

  /// No description provided for @saveConfigurationBackup.
  ///
  /// In en, this message translates to:
  /// **'Save Configuration Backup'**
  String get saveConfigurationBackup;

  /// No description provided for @refreshStatsR.
  ///
  /// In en, this message translates to:
  /// **'Refresh stats (R)'**
  String get refreshStatsR;

  /// No description provided for @systemStatistics.
  ///
  /// In en, this message translates to:
  /// **'System Statistics'**
  String get systemStatistics;

  /// No description provided for @romFiles.
  ///
  /// In en, this message translates to:
  /// **'ROM Files'**
  String get romFiles;

  /// No description provided for @maintenanceTools.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Tools'**
  String get maintenanceTools;

  /// No description provided for @cleanupTemporaryRoms.
  ///
  /// In en, this message translates to:
  /// **'Cleanup Temporary ROMs'**
  String get cleanupTemporaryRoms;

  /// No description provided for @cleanupTemporaryRomsDescription.
  ///
  /// In en, this message translates to:
  /// **'Remove temporary ROM files from system temp directory'**
  String get cleanupTemporaryRomsDescription;

  /// No description provided for @verifyRomFiles.
  ///
  /// In en, this message translates to:
  /// **'Verify ROM Files'**
  String get verifyRomFiles;

  /// No description provided for @verifyRomFilesDescription.
  ///
  /// In en, this message translates to:
  /// **'Check that all ROM files exist and are valid'**
  String get verifyRomFilesDescription;

  /// No description provided for @checkMissingGamelists.
  ///
  /// In en, this message translates to:
  /// **'Check Missing Gamelists'**
  String get checkMissingGamelists;

  /// No description provided for @checkMissingGamelistsDescription.
  ///
  /// In en, this message translates to:
  /// **'Find platforms missing gamelist.xml files'**
  String get checkMissingGamelistsDescription;

  /// No description provided for @backupConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Backup Configuration'**
  String get backupConfiguration;

  /// No description provided for @backupConfigurationDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a backup of config.json'**
  String get backupConfigurationDescription;

  /// No description provided for @downloadingRomDatabase.
  ///
  /// In en, this message translates to:
  /// **'Downloading ROM Database...'**
  String get downloadingRomDatabase;

  /// No description provided for @downloadMayTakeMinutes.
  ///
  /// In en, this message translates to:
  /// **'This may take a few minutes depending on your connection...'**
  String get downloadMayTakeMinutes;

  /// No description provided for @databaseStatus.
  ///
  /// In en, this message translates to:
  /// **'Database Status'**
  String get databaseStatus;

  /// No description provided for @notDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Not Downloaded'**
  String get notDownloaded;

  /// No description provided for @aboutRomDatabase.
  ///
  /// In en, this message translates to:
  /// **'About ROM Database'**
  String get aboutRomDatabase;

  /// No description provided for @aboutRomDatabaseDescription.
  ///
  /// In en, this message translates to:
  /// **'The ROM database contains lists of available ROMs organized by platform. It is downloaded from the Forsaken romList repository on GitHub.'**
  String get aboutRomDatabaseDescription;

  /// No description provided for @romDatabaseSource.
  ///
  /// In en, this message translates to:
  /// **'Source: github.com/ForsakenStation/romList'**
  String get romDatabaseSource;

  /// No description provided for @downloadRomDatabaseDescription.
  ///
  /// In en, this message translates to:
  /// **'This will download ROM lists from the Forsaken romList repository on GitHub.'**
  String get downloadRomDatabaseDescription;

  /// No description provided for @downloadRomDatabaseStats.
  ///
  /// In en, this message translates to:
  /// **'Size: ~7 MB\nPlatforms: 138\nTotal ROMs: ~240,000'**
  String get downloadRomDatabaseStats;

  /// No description provided for @downloadWillOverwrite.
  ///
  /// In en, this message translates to:
  /// **'Note: This will overwrite existing data.'**
  String get downloadWillOverwrite;

  /// No description provided for @clearRomDatabaseDescription.
  ///
  /// In en, this message translates to:
  /// **'This will delete all downloaded ROM lists and reset the database to its initial state.'**
  String get clearRomDatabaseDescription;

  /// No description provided for @gamelistsStatus.
  ///
  /// In en, this message translates to:
  /// **'Gamelists Status'**
  String get gamelistsStatus;

  /// No description provided for @gamelistsDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Downloaded'**
  String get gamelistsDownloaded;

  /// No description provided for @gamelistsNotDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Not Downloaded'**
  String get gamelistsNotDownloaded;

  /// No description provided for @aboutGamelists.
  ///
  /// In en, this message translates to:
  /// **'About Gamelists'**
  String get aboutGamelists;

  /// No description provided for @aboutGamelistsDescription.
  ///
  /// In en, this message translates to:
  /// **'Gamelists contain game metadata (names, descriptions, ratings) for each platform. They are downloaded from the Forsaken gamelists repository on GitHub.'**
  String get aboutGamelistsDescription;

  /// No description provided for @gamelistsSource.
  ///
  /// In en, this message translates to:
  /// **'Source: github.com/ForsakenStation/gamelists'**
  String get gamelistsSource;

  /// No description provided for @downloadGamelists.
  ///
  /// In en, this message translates to:
  /// **'Download Gamelists'**
  String get downloadGamelists;

  /// No description provided for @downloadGamelistsDescription.
  ///
  /// In en, this message translates to:
  /// **'This will download gamelist.xml files from the Forsaken gamelists repository on GitHub.'**
  String get downloadGamelistsDescription;

  /// No description provided for @downloadGamelistsWillOverwrite.
  ///
  /// In en, this message translates to:
  /// **'Note: This will overwrite existing gamelist files.'**
  String get downloadGamelistsWillOverwrite;

  /// No description provided for @downloadingGamelists.
  ///
  /// In en, this message translates to:
  /// **'Downloading Gamelists...'**
  String get downloadingGamelists;

  /// No description provided for @gamelistsDownloadedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Gamelists downloaded successfully'**
  String get gamelistsDownloadedSuccess;

  /// No description provided for @failedDownloadGamelists.
  ///
  /// In en, this message translates to:
  /// **'Failed to download gamelists'**
  String get failedDownloadGamelists;

  /// No description provided for @clearGamelists.
  ///
  /// In en, this message translates to:
  /// **'Clear Gamelists'**
  String get clearGamelists;

  /// No description provided for @clearGamelistsDescription.
  ///
  /// In en, this message translates to:
  /// **'This will delete all downloaded gamelist files.'**
  String get clearGamelistsDescription;

  /// No description provided for @gamelistsCleared.
  ///
  /// In en, this message translates to:
  /// **'Gamelists cleared'**
  String get gamelistsCleared;

  /// No description provided for @failedClearGamelists.
  ///
  /// In en, this message translates to:
  /// **'Failed to clear gamelists'**
  String get failedClearGamelists;

  /// No description provided for @rebuildMediaCache.
  ///
  /// In en, this message translates to:
  /// **'Rebuild Media Cache'**
  String get rebuildMediaCache;

  /// No description provided for @rebuildMediaCacheDescription.
  ///
  /// In en, this message translates to:
  /// **'Scan media directories and cache paths in gamelists for faster loading'**
  String get rebuildMediaCacheDescription;

  /// No description provided for @rebuildMediaCacheConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Rebuild Media Cache?'**
  String get rebuildMediaCacheConfirmTitle;

  /// No description provided for @rebuildMediaCacheConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will scan all media directories and update gamelist.xml files with media paths. This may take a moment for large collections.'**
  String get rebuildMediaCacheConfirmBody;

  /// No description provided for @rebuildMediaCacheProgress.
  ///
  /// In en, this message translates to:
  /// **'Rebuilding media cache...'**
  String get rebuildMediaCacheProgress;

  /// No description provided for @rebuildMediaCacheProcessingPlatform.
  ///
  /// In en, this message translates to:
  /// **'Processing {platform} ({current}/{total})'**
  String rebuildMediaCacheProcessingPlatform(
    String platform,
    String current,
    String total,
  );

  /// No description provided for @rebuildMediaCacheComplete.
  ///
  /// In en, this message translates to:
  /// **'Media Cache Rebuilt'**
  String get rebuildMediaCacheComplete;

  /// No description provided for @rebuildMediaCacheSummary.
  ///
  /// In en, this message translates to:
  /// **'{platforms} platforms, {games} games scanned, {updated} updated, {paths} media paths cached'**
  String rebuildMediaCacheSummary(
    String platforms,
    String games,
    String updated,
    String paths,
  );

  /// No description provided for @rebuildMediaCacheError.
  ///
  /// In en, this message translates to:
  /// **'Failed to rebuild media cache'**
  String get rebuildMediaCacheError;

  /// No description provided for @rebuildMediaCacheErrors.
  ///
  /// In en, this message translates to:
  /// **'{count} errors occurred during rebuild'**
  String rebuildMediaCacheErrors(String count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'it',
    'ja',
    'ko',
    'pt',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
