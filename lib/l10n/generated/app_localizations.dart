import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_eu.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_gl.dart';
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
    Locale('ca'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('eu'),
    Locale('fr'),
    Locale('gl'),
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

  /// Label for required BIOS files
  ///
  /// In en, this message translates to:
  /// **'REQUIRED'**
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

  /// Label for missing BIOS status in summary
  ///
  /// In en, this message translates to:
  /// **'Missing'**
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

  /// Status message when gamepad is connected
  ///
  /// In en, this message translates to:
  /// **'Gamepad Connected'**
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

  /// Header for right stick test section
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

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @noDescriptionAvailable.
  ///
  /// In en, this message translates to:
  /// **'No description available for this ROM.'**
  String get noDescriptionAvailable;

  /// No description provided for @releaseDate.
  ///
  /// In en, this message translates to:
  /// **'Release Date'**
  String get releaseDate;

  /// No description provided for @players.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get players;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @regions.
  ///
  /// In en, this message translates to:
  /// **'Regions'**
  String get regions;

  /// No description provided for @folderRomCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} ROM} other{{count} ROMs}}'**
  String folderRomCount(int count);

  /// No description provided for @manualTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} - Manual'**
  String manualTitle(String name);

  /// No description provided for @playInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Play in Browser'**
  String get playInBrowser;

  /// No description provided for @downloadingPlatformBios.
  ///
  /// In en, this message translates to:
  /// **'Downloading {platformName} BIOS'**
  String downloadingPlatformBios(String platformName);

  /// No description provided for @downloadingAllMissingBios.
  ///
  /// In en, this message translates to:
  /// **'Downloading All Missing BIOS'**
  String get downloadingAllMissingBios;

  /// No description provided for @biosFileLabel.
  ///
  /// In en, this message translates to:
  /// **'File: {filename}'**
  String biosFileLabel(String filename);

  /// No description provided for @batchProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Progress: {completed}/{total} files'**
  String batchProgressLabel(String completed, String total);

  /// No description provided for @fileDetails.
  ///
  /// In en, this message translates to:
  /// **'File Details:'**
  String get fileDetails;

  /// No description provided for @waiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting...'**
  String get waiting;

  /// No description provided for @verifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get verifying;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @preparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing...'**
  String get preparing;

  /// No description provided for @downloadingFiles.
  ///
  /// In en, this message translates to:
  /// **'Downloading files...'**
  String get downloadingFiles;

  /// No description provided for @someDownloadsFailed.
  ///
  /// In en, this message translates to:
  /// **'Some downloads failed'**
  String get someDownloadsFailed;

  /// No description provided for @downloadsCancelled.
  ///
  /// In en, this message translates to:
  /// **'Downloads cancelled'**
  String get downloadsCancelled;

  /// No description provided for @calculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get calculating;

  /// No description provided for @secondsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 second} other{{count} seconds}}'**
  String secondsRemaining(int count);

  /// No description provided for @minutesRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute} other{{count} minutes}}'**
  String minutesRemaining(int count);

  /// No description provided for @hoursRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour} other{{count} hours}}'**
  String hoursRemaining(int count);

  /// No description provided for @downloadingAndLaunching.
  ///
  /// In en, this message translates to:
  /// **'Downloading & Launching...'**
  String get downloadingAndLaunching;

  /// No description provided for @launching.
  ///
  /// In en, this message translates to:
  /// **'Launching...'**
  String get launching;

  /// No description provided for @emulatorLabel.
  ///
  /// In en, this message translates to:
  /// **'Emulator: {name}'**
  String emulatorLabel(String name);

  /// No description provided for @generalInformation.
  ///
  /// In en, this message translates to:
  /// **'General Information'**
  String get generalInformation;

  /// No description provided for @manufacturer.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer'**
  String get manufacturer;

  /// No description provided for @releaseYear.
  ///
  /// In en, this message translates to:
  /// **'Release Year'**
  String get releaseYear;

  /// No description provided for @generation.
  ///
  /// In en, this message translates to:
  /// **'Generation'**
  String get generation;

  /// No description provided for @technicalSpecifications.
  ///
  /// In en, this message translates to:
  /// **'Technical Specifications'**
  String get technicalSpecifications;

  /// No description provided for @resolution.
  ///
  /// In en, this message translates to:
  /// **'Resolution'**
  String get resolution;

  /// No description provided for @colors.
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get colors;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get notNow;

  /// No description provided for @saveRomPermanently.
  ///
  /// In en, this message translates to:
  /// **'Save ROM Permanently?'**
  String get saveRomPermanently;

  /// No description provided for @keepRomOfflineQuestion.
  ///
  /// In en, this message translates to:
  /// **'Would you like to keep this ROM downloaded for offline play?'**
  String get keepRomOfflineQuestion;

  /// No description provided for @deletedToSaveSpace.
  ///
  /// In en, this message translates to:
  /// **'If not, it will be deleted later to save space.'**
  String get deletedToSaveSpace;

  /// Label for view toggle action in bottom bar
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// Label for media action in bottom bar
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get media;

  /// Label for navigate action in bottom bar
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get navigate;

  /// Label for info action in bottom bar
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// Label for toggle filter action
  ///
  /// In en, this message translates to:
  /// **'Toggle Filter'**
  String get toggleFilter;

  /// Tooltip for theme selector button
  ///
  /// In en, this message translates to:
  /// **'Change theme'**
  String get changeTheme;

  /// Label for keyboard input mode
  ///
  /// In en, this message translates to:
  /// **'Keyboard'**
  String get keyboard;

  /// Label for gamepad input mode
  ///
  /// In en, this message translates to:
  /// **'Gamepad'**
  String get gamepad;

  /// Tooltip for hiding virtual keyboard
  ///
  /// In en, this message translates to:
  /// **'Hide keyboard'**
  String get hideKeyboard;

  /// Label for game manual media type
  ///
  /// In en, this message translates to:
  /// **'Game Manual'**
  String get gameManual;

  /// Label for PDF document type
  ///
  /// In en, this message translates to:
  /// **'PDF Document'**
  String get pdfDocument;

  /// Short label for manual
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// Label for video media type
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// Tooltip for zoom out button
  ///
  /// In en, this message translates to:
  /// **'Zoom Out'**
  String get zoomOut;

  /// Tooltip for zoom in button
  ///
  /// In en, this message translates to:
  /// **'Zoom In'**
  String get zoomIn;

  /// Page counter display in document viewer
  ///
  /// In en, this message translates to:
  /// **'Page {current} / {total}'**
  String pageCounter(String current, String total);

  /// Label for zoom control hint
  ///
  /// In en, this message translates to:
  /// **'Zoom'**
  String get zoom;

  /// Label for first/last page navigation hint
  ///
  /// In en, this message translates to:
  /// **'First/Last'**
  String get firstLast;

  /// Label for scroll control hint
  ///
  /// In en, this message translates to:
  /// **'Scroll'**
  String get scroll;

  /// Status text shown while video is loading
  ///
  /// In en, this message translates to:
  /// **'Loading video...'**
  String get loadingVideo;

  /// Tooltip for play/pause button
  ///
  /// In en, this message translates to:
  /// **'Play/Pause'**
  String get playPause;

  /// Navigation hint shown in carousel/platform views
  ///
  /// In en, this message translates to:
  /// **'Use arrow keys or swipe to navigate'**
  String get useArrowKeysToNavigate;

  /// Hint text in ROM search field
  ///
  /// In en, this message translates to:
  /// **'Search ROMs...'**
  String get searchRomsHint;

  /// Tooltip for cancel search button
  ///
  /// In en, this message translates to:
  /// **'Cancel Search'**
  String get cancelSearch;

  /// Tooltip for virtual keyboard toggle
  ///
  /// In en, this message translates to:
  /// **'Virtual Keyboard'**
  String get virtualKeyboard;

  /// Title for empty ROM list state
  ///
  /// In en, this message translates to:
  /// **'No ROMs available'**
  String get noRomsAvailable;

  /// Description shown when no ROMs found for a platform
  ///
  /// In en, this message translates to:
  /// **'No ROM files were found for this platform. ROM files should be placed as .txt files containing download URLs in the platform directory.'**
  String get noRomsForPlatformMessage;

  /// Title when search has no results
  ///
  /// In en, this message translates to:
  /// **'No matching ROMs'**
  String get noMatchingRoms;

  /// Suggestion when search has no results
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearch;

  /// Tooltip for save to permanent storage button
  ///
  /// In en, this message translates to:
  /// **'Save to permanent storage'**
  String get saveToPermanentStorage;

  /// Label for temporary storage section
  ///
  /// In en, this message translates to:
  /// **'Temporary'**
  String get temporary;

  /// Label for permanent storage section
  ///
  /// In en, this message translates to:
  /// **'Permanent'**
  String get permanent;

  /// Short label for temporary path
  ///
  /// In en, this message translates to:
  /// **'Temp'**
  String get tempPathLabel;

  /// Short label for permanent/forever path
  ///
  /// In en, this message translates to:
  /// **'Forever'**
  String get foreverPathLabel;

  /// Title for storage overview section
  ///
  /// In en, this message translates to:
  /// **'Storage Overview'**
  String get storageOverview;

  /// Tooltip for clear temporary storage button
  ///
  /// In en, this message translates to:
  /// **'Clear temporary storage'**
  String get clearTemporaryStorage;

  /// Display count of files
  ///
  /// In en, this message translates to:
  /// **'{count} files'**
  String filesCount(String count);

  /// Display a labeled path
  ///
  /// In en, this message translates to:
  /// **'{label} path: {path}'**
  String pathDisplay(String label, String path);

  /// Fallback text for unknown values
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Tooltip for verified good ROM dump tag
  ///
  /// In en, this message translates to:
  /// **'Verified good dump - confirmed working'**
  String get tagVerifiedGoodDump;

  /// Tooltip for bad ROM dump tag
  ///
  /// In en, this message translates to:
  /// **'Bad dump - may not work correctly'**
  String get tagBadDump;

  /// Tooltip for alternate version ROM tag
  ///
  /// In en, this message translates to:
  /// **'Alternate version'**
  String get tagAlternateVersion;

  /// Tooltip for overdump ROM tag
  ///
  /// In en, this message translates to:
  /// **'Overdump - contains extra data'**
  String get tagOverdump;

  /// Tooltip for modified/hacked ROM tag
  ///
  /// In en, this message translates to:
  /// **'Modified/hacked ROM'**
  String get tagModifiedHacked;

  /// Tooltip for fan translation ROM tag
  ///
  /// In en, this message translates to:
  /// **'Fan translation'**
  String get tagFanTranslation;

  /// Tooltip for pirate/bootleg ROM tag
  ///
  /// In en, this message translates to:
  /// **'Pirate/bootleg version'**
  String get tagPirateBootleg;

  /// Tooltip for fixed version ROM tag
  ///
  /// In en, this message translates to:
  /// **'Fixed version'**
  String get tagFixedVersion;

  /// Tooltip for cheat trainer ROM tag
  ///
  /// In en, this message translates to:
  /// **'Includes cheat trainer'**
  String get tagCheatTrainer;

  /// Tooltip for version ROM tag
  ///
  /// In en, this message translates to:
  /// **'Version: {text}'**
  String tagVersion(String text);

  /// Tooltip for special release ROM tag
  ///
  /// In en, this message translates to:
  /// **'Special release: {text}'**
  String tagSpecialRelease(String text);

  /// Tooltip for media info ROM tag
  ///
  /// In en, this message translates to:
  /// **'Media info: {text}'**
  String tagMediaInfo(String text);

  /// Error when no emulator is configured for a platform
  ///
  /// In en, this message translates to:
  /// **'No emulator configured for {displayName}.\n\nPlease add configuration for \"{platform}\" in:\n{configPath}'**
  String noEmulatorConfigured(
    String displayName,
    String platform,
    String configPath,
  );

  /// Error when no emulator command is available for launching
  ///
  /// In en, this message translates to:
  /// **'No emulator command available'**
  String get noEmulatorCommandAvailable;

  /// Error when trying to launch a ROM for an unsupported platform in web
  ///
  /// In en, this message translates to:
  /// **'Platform \"{platform}\" is not yet supported in web browser.\n\nSupported platforms: {supportedPlatforms}'**
  String platformNotSupportedWeb(String platform, String supportedPlatforms);

  /// Error when web emulator fails to launch
  ///
  /// In en, this message translates to:
  /// **'Failed to launch web emulator: {error}'**
  String failedToLaunchWebEmulator(String error);

  /// Error dialog message when ROM launch fails with troubleshooting tips
  ///
  /// In en, this message translates to:
  /// **'Failed to launch ROM.\n\nCheck that:\n• Emulator is installed correctly\n• ROM file is valid\n• Configuration is correct\n\nError: {error}'**
  String failedToLaunchRom(String error);

  /// Error message when an exception occurs during ROM launch
  ///
  /// In en, this message translates to:
  /// **'Error launching ROM: {error}'**
  String errorLaunchingRom(String error);

  /// Message when no platform info is available
  ///
  /// In en, this message translates to:
  /// **'No information available for {platformName}'**
  String noInfoAvailable(String platformName);

  /// Tooltip for platform info button with keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Platform Info (I)'**
  String get platformInfoTooltip;

  /// Navigation hint shown in carousel views
  ///
  /// In en, this message translates to:
  /// **'Use arrow keys or swipe to navigate'**
  String get navigationHint;

  /// Empty state title when no games are available
  ///
  /// In en, this message translates to:
  /// **'No games found'**
  String get noGamesFound;

  /// Empty state title when search returns no results
  ///
  /// In en, this message translates to:
  /// **'No games found for search'**
  String get noGamesFoundForSearch;

  /// Suggestion when search returns no results
  ///
  /// In en, this message translates to:
  /// **'Try a different search term or clear the filter'**
  String get tryDifferentSearchOrClear;

  /// Suggestion when no games are found
  ///
  /// In en, this message translates to:
  /// **'Check your storage settings or download some ROMs'**
  String get checkStorageOrDownload;

  /// Hint text in games search field
  ///
  /// In en, this message translates to:
  /// **'Search games...'**
  String get searchGamesHint;

  /// Header title on the settings screen
  ///
  /// In en, this message translates to:
  /// **'Forsaken Emulator Configuration'**
  String get settingsHeaderTitle;

  /// Header subtitle on the settings screen
  ///
  /// In en, this message translates to:
  /// **'Configure emulators, paths, and download content'**
  String get settingsHeaderSubtitle;

  /// Description for emulator management settings category
  ///
  /// In en, this message translates to:
  /// **'Add, edit, and configure emulator commands'**
  String get emulatorManagementDesc;

  /// System paths settings category title
  ///
  /// In en, this message translates to:
  /// **'System Paths'**
  String get systemPaths;

  /// Description for system paths settings category
  ///
  /// In en, this message translates to:
  /// **'Configure ROMs, media, and emulator paths'**
  String get systemPathsDesc;

  /// Description for ROM database settings category
  ///
  /// In en, this message translates to:
  /// **'Download and manage ROM lists from GitHub'**
  String get romDatabaseDesc;

  /// Description for ROM storage settings category
  ///
  /// In en, this message translates to:
  /// **'Manage downloaded ROMs, storage, and temp files cleanup'**
  String get romStorageDesc;

  /// Description for download manager settings category
  ///
  /// In en, this message translates to:
  /// **'Download emulators, ROMs lists, and game data'**
  String get downloadManagerDesc;

  /// Description for system requirements settings category
  ///
  /// In en, this message translates to:
  /// **'Check required tools and dependencies'**
  String get systemRequirementsDesc;

  /// Gamepad test and debug settings category title
  ///
  /// In en, this message translates to:
  /// **'Gamepad Test & Debug'**
  String get gamepadTestDebug;

  /// Description for gamepad test and debug settings category
  ///
  /// In en, this message translates to:
  /// **'Test gamepad buttons, axes, and troubleshoot issues'**
  String get gamepadTestDebugDesc;

  /// Description for BIOS and firmware help settings category
  ///
  /// In en, this message translates to:
  /// **'Check BIOS files and firmware requirements'**
  String get biosFirmwareHelpDesc;

  /// Description for web settings category
  ///
  /// In en, this message translates to:
  /// **'CORS proxy and web platform configuration'**
  String get webSettingsDesc;

  /// Description for setup wizard settings category
  ///
  /// In en, this message translates to:
  /// **'Re-run the initial setup wizard'**
  String get setupWizardDesc;

  /// Description for language settings category
  ///
  /// In en, this message translates to:
  /// **'Select application language'**
  String get languageDesc;

  /// About and debug settings category title
  ///
  /// In en, this message translates to:
  /// **'About & Debug'**
  String get aboutDebug;

  /// Description for about and debug settings category
  ///
  /// In en, this message translates to:
  /// **'App information and debug settings'**
  String get aboutDebugDesc;

  /// Title for legal disclaimer section in about dialog
  ///
  /// In en, this message translates to:
  /// **'Legal Disclaimer'**
  String get legalDisclaimer;

  /// Credit text for ROM database source
  ///
  /// In en, this message translates to:
  /// **'ROM lists are originally sourced from the AndroidRoms repository by Arley4d:'**
  String get romDatabaseCredits;

  /// Thanks text for ROM database source
  ///
  /// In en, this message translates to:
  /// **'Special thanks to the AndroidRoms project for maintaining comprehensive ROM databases for preservation purposes.'**
  String get romDatabaseThanks;

  /// Section title for BIOS files in about dialog
  ///
  /// In en, this message translates to:
  /// **'BIOS Files'**
  String get biosFilesSection;

  /// Credit text for BIOS files source
  ///
  /// In en, this message translates to:
  /// **'BIOS files are sourced from the retroarch_system repository by Abdess:'**
  String get biosFilesCredits;

  /// Thanks text for BIOS files source
  ///
  /// In en, this message translates to:
  /// **'This repository contains system files and BIOS required by various emulation platforms. Special thanks to the maintainers for preserving these essential files.'**
  String get biosFilesThanks;

  /// Credit text for Amiga capsimg library
  ///
  /// In en, this message translates to:
  /// **'Amiga copy protection support provided by the capsimg library:'**
  String get amigaCopyProtection;

  /// Thanks text for capsimg library
  ///
  /// In en, this message translates to:
  /// **'Special thanks to rsn8887 for maintaining the capsimg library that enables IPF (copy-protected) disk image support for Amiga emulation.'**
  String get amigaCopyProtectionThanks;

  /// Credit text for additional BIOS files
  ///
  /// In en, this message translates to:
  /// **'Additional BIOS files provided by the RetroPieBios project:'**
  String get additionalBiosFiles;

  /// Thanks text for RetroPieBios project
  ///
  /// In en, this message translates to:
  /// **'Thanks to PIBSAS/RetroPieBios for providing additional BIOS variants and regional files that enhance compatibility across different systems and regions.'**
  String get additionalBiosThanks;

  /// Status text for enabled state
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// Status text for disabled state
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// Validation error when disclaimer is not accepted in setup wizard
  ///
  /// In en, this message translates to:
  /// **'You must accept the disclaimer to continue.'**
  String get disclaimerRequired;

  /// Validation error when emulators path is empty
  ///
  /// In en, this message translates to:
  /// **'Emulators directory path is required.'**
  String get emulatorsPathRequired;

  /// Validation error when emulator config path is empty
  ///
  /// In en, this message translates to:
  /// **'Emulator config file path is required.'**
  String get emulatorConfigPathRequired;

  /// Validation error when media path is empty
  ///
  /// In en, this message translates to:
  /// **'Media path is required.'**
  String get mediaPathRequired;

  /// Validation error when temporary ROM path is empty
  ///
  /// In en, this message translates to:
  /// **'Temporary ROM storage path is required.'**
  String get tempRomPathRequired;

  /// Validation error when permanent ROM path is empty
  ///
  /// In en, this message translates to:
  /// **'Permanent ROM storage path is required.'**
  String get permanentRomPathRequired;

  /// Step counter in setup wizard bottom bar
  ///
  /// In en, this message translates to:
  /// **'Step {current} / {total}'**
  String wizardStepCounter(int current, int total);

  /// Title for emulator configuration step in setup wizard
  ///
  /// In en, this message translates to:
  /// **'Emulator Configuration'**
  String get emulatorConfiguration;

  /// Description for emulator configuration step
  ///
  /// In en, this message translates to:
  /// **'Set the paths where your emulators are installed. You can change these later in Settings > System Paths.'**
  String get emulatorConfigStepDesc;

  /// Label for emulators directory path field
  ///
  /// In en, this message translates to:
  /// **'Emulators Directory'**
  String get emulatorsDirectory;

  /// Hint for emulators directory path field
  ///
  /// In en, this message translates to:
  /// **'Path to emulator binaries'**
  String get pathToEmulatorBinaries;

  /// Label for emulator config file path field
  ///
  /// In en, this message translates to:
  /// **'Emulator Config File'**
  String get emulatorConfigFile;

  /// Hint for emulator config file path field
  ///
  /// In en, this message translates to:
  /// **'Path to emulator configuration JSON'**
  String get pathToEmulatorConfig;

  /// Title for storage paths step in setup wizard
  ///
  /// In en, this message translates to:
  /// **'Storage Paths'**
  String get storagePaths;

  /// Description for storage paths step
  ///
  /// In en, this message translates to:
  /// **'Configure where media assets and ROM files are stored. You can change these later in Settings > System Paths.'**
  String get storagePathsStepDesc;

  /// Hint for media path field in setup wizard
  ///
  /// In en, this message translates to:
  /// **'Box art, screenshots, and videos'**
  String get wizardMediaPathHint;

  /// Label for temporary ROM storage path field
  ///
  /// In en, this message translates to:
  /// **'Temporary ROM Storage'**
  String get temporaryRomStorage;

  /// Hint for temporary ROM storage path field
  ///
  /// In en, this message translates to:
  /// **'Downloaded ROMs for single play sessions'**
  String get temporaryRomStorageHint;

  /// Label for permanent ROM storage path field
  ///
  /// In en, this message translates to:
  /// **'Permanent ROM Storage'**
  String get permanentRomStorage;

  /// Hint for permanent ROM storage path field
  ///
  /// In en, this message translates to:
  /// **'ROMs saved for offline play'**
  String get permanentRomStorageHint;

  /// Title for the ready step in setup wizard
  ///
  /// In en, this message translates to:
  /// **'You\'re All Set!'**
  String get allSet;

  /// Subtitle for the ready step in setup wizard
  ///
  /// In en, this message translates to:
  /// **'Forsaken Emulator is ready to use.'**
  String get wizardEmulatorReady;

  /// Note about changing settings later in setup wizard
  ///
  /// In en, this message translates to:
  /// **'You can change any of these settings later from the Settings screen.'**
  String get changeSettingsLater;

  /// Title for configuration summary card in setup wizard
  ///
  /// In en, this message translates to:
  /// **'Configuration Summary'**
  String get configurationSummary;

  /// Summary label for emulators path
  ///
  /// In en, this message translates to:
  /// **'Emulators'**
  String get summaryEmulators;

  /// Summary label for media path
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get summaryMedia;

  /// Summary label for temporary ROMs path
  ///
  /// In en, this message translates to:
  /// **'Temp ROMs'**
  String get summaryTempRoms;

  /// Summary label for saved ROMs path
  ///
  /// In en, this message translates to:
  /// **'Saved ROMs'**
  String get summarySavedRoms;

  /// Placeholder shown when a path value is empty
  ///
  /// In en, this message translates to:
  /// **'(default)'**
  String get defaultValue;

  /// Page indicator in PDF viewer
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String pdfPageIndicator(int current, int total);

  /// Tooltip for zoom out button in PDF viewer
  ///
  /// In en, this message translates to:
  /// **'Zoom out (-)'**
  String get pdfZoomOut;

  /// Tooltip for zoom in button in PDF viewer
  ///
  /// In en, this message translates to:
  /// **'Zoom in (+)'**
  String get pdfZoomIn;

  /// Tooltip for reset zoom button in PDF viewer
  ///
  /// In en, this message translates to:
  /// **'Reset zoom (0)'**
  String get pdfResetZoom;

  /// Tooltip for first page button in PDF viewer
  ///
  /// In en, this message translates to:
  /// **'First page (Home)'**
  String get pdfFirstPage;

  /// Tooltip for previous page button in PDF viewer
  ///
  /// In en, this message translates to:
  /// **'Previous page (←/PgUp)'**
  String get pdfPreviousPage;

  /// Tooltip for next page button in PDF viewer
  ///
  /// In en, this message translates to:
  /// **'Next page (→/PgDn)'**
  String get pdfNextPage;

  /// Tooltip for last page button in PDF viewer
  ///
  /// In en, this message translates to:
  /// **'Last page (End)'**
  String get pdfLastPage;

  /// Error message when PDF file is not found
  ///
  /// In en, this message translates to:
  /// **'PDF file not found'**
  String get pdfFileNotFound;

  /// Confirmation message for deleting an emulator
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the emulator configuration for {system}?'**
  String confirmDeleteEmulator(String system);

  /// Number of commands configured for an emulator
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{1 command configured} other{{count} commands configured}}'**
  String commandsConfigured(int count);

  /// Shown when no command is configured for an emulator
  ///
  /// In en, this message translates to:
  /// **'No command'**
  String get noCommand;

  /// Tooltip for reload configuration button
  ///
  /// In en, this message translates to:
  /// **'Reload Configuration (R)'**
  String get reloadConfigTooltip;

  /// Tooltip for configuration info button
  ///
  /// In en, this message translates to:
  /// **'Configuration Info'**
  String get configurationInfo;

  /// Label for config file location
  ///
  /// In en, this message translates to:
  /// **'Config location:'**
  String get configLocation;

  /// Shows that local overrides exist
  ///
  /// In en, this message translates to:
  /// **'Has local overrides: Yes'**
  String get hasLocalOverridesYes;

  /// Shows that no local overrides exist
  ///
  /// In en, this message translates to:
  /// **'Has local overrides: No'**
  String get hasLocalOverridesNo;

  /// Note about changes being saved to device storage
  ///
  /// In en, this message translates to:
  /// **'Your changes are saved to device storage.'**
  String get changesSavedToDevice;

  /// Note about using bundled config
  ///
  /// In en, this message translates to:
  /// **'Using bundled config. Edit to create local overrides.'**
  String get usingBundledConfig;

  /// Empty state title when no emulators are configured
  ///
  /// In en, this message translates to:
  /// **'No emulators configured'**
  String get noEmulatorsConfigured;

  /// Empty state subtitle when no emulators are configured
  ///
  /// In en, this message translates to:
  /// **'Add your first emulator to get started'**
  String get addFirstEmulator;

  /// Generic edit action label
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Title for edit emulator dialog
  ///
  /// In en, this message translates to:
  /// **'Edit Emulator'**
  String get editEmulator;

  /// Label for system/platform name field
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Hint text for system name input
  ///
  /// In en, this message translates to:
  /// **'e.g., nes, snes, ps1'**
  String get systemHint;

  /// Section header for emulator commands
  ///
  /// In en, this message translates to:
  /// **'Commands'**
  String get commands;

  /// Label for a numbered command entry
  ///
  /// In en, this message translates to:
  /// **'Command {number}'**
  String commandNumber(int number);

  /// Hint text for command input
  ///
  /// In en, this message translates to:
  /// **'e.g., ../retroarch.AppImage -f -L core.so'**
  String get commandHint;

  /// Generic remove action label
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Section header for options
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// Text shown while BIOS files are being downloaded
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get biosDownloading;

  /// Download button text showing required and optional file counts
  ///
  /// In en, this message translates to:
  /// **'Download {requiredCount} required + {optionalCount} extras'**
  String downloadRequiredAndExtras(int requiredCount, int optionalCount);

  /// Download button text showing required file count
  ///
  /// In en, this message translates to:
  /// **'Download {requiredCount} required files'**
  String downloadRequiredFiles(int requiredCount);

  /// Download button text showing optional file count
  ///
  /// In en, this message translates to:
  /// **'Download {optionalCount} optional extras'**
  String downloadOptionalExtras(int optionalCount);

  /// Generic download files button text
  ///
  /// In en, this message translates to:
  /// **'Download files'**
  String get downloadFiles;

  /// Confirmation message for batch BIOS download
  ///
  /// In en, this message translates to:
  /// **'This will download {totalFiles} BIOS files for {platformCount} platforms:'**
  String batchDownloadConfirmation(int totalFiles, int platformCount);

  /// Note about the source of BIOS file downloads
  ///
  /// In en, this message translates to:
  /// **'Files will be downloaded from the retroarch_system repository.'**
  String get downloadSourceNote;

  /// Label for optional BIOS files
  ///
  /// In en, this message translates to:
  /// **'OPTIONAL'**
  String get biosOptional;

  /// Status showing how many BIOS files were found
  ///
  /// In en, this message translates to:
  /// **'{foundCount}/{totalCount} files found'**
  String biosFilesFound(int foundCount, int totalCount);

  /// Text showing number of optional extras available for download
  ///
  /// In en, this message translates to:
  /// **'+{count} optional extras available'**
  String optionalExtrasAvailable(int count);

  /// Header for BIOS file locations list
  ///
  /// In en, this message translates to:
  /// **'Locations:'**
  String get biosLocations;

  /// Text indicating BIOS files can be downloaded
  ///
  /// In en, this message translates to:
  /// **'Available for download from multiple sources'**
  String get availableForDownload;

  /// Summary section header
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// Label for complete BIOS status in summary
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get biosComplete;

  /// Label for partial BIOS status in summary
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get biosPartial;

  /// Label for files count in BIOS summary
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get biosFiles;

  /// Label for downloadable count in BIOS summary
  ///
  /// In en, this message translates to:
  /// **'Downloadable'**
  String get biosDownloadable;

  /// Tooltip for refresh button with keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Refresh (F5)'**
  String get refreshF5Tooltip;

  /// Message when all BIOS files are present
  ///
  /// In en, this message translates to:
  /// **'All BIOS files found!'**
  String get allBiosFilesFound;

  /// Message when no BIOS requirements are found
  ///
  /// In en, this message translates to:
  /// **'No BIOS requirements found'**
  String get noBiosRequirements;

  /// Counter text showing number of platforms
  ///
  /// In en, this message translates to:
  /// **'{count} platforms'**
  String platformCount(int count);

  /// Error message when BIOS status loading fails
  ///
  /// In en, this message translates to:
  /// **'Failed to load BIOS status: {error}'**
  String failedToLoadBiosStatus(String error);

  /// Tooltip for refresh status button
  ///
  /// In en, this message translates to:
  /// **'Refresh Status'**
  String get refreshStatus;

  /// Counter showing completed platforms
  ///
  /// In en, this message translates to:
  /// **'{complete}/{total} platforms complete'**
  String platformsCompleteCount(int complete, int total);

  /// Header for platform status section
  ///
  /// In en, this message translates to:
  /// **'Platform Status'**
  String get platformStatusHeader;

  /// Status showing files present and verified count
  ///
  /// In en, this message translates to:
  /// **'{presentFiles}/{totalFiles} files ({verifiedFiles} verified)'**
  String filesVerifiedStatus(
    int presentFiles,
    int totalFiles,
    int verifiedFiles,
  );

  /// Header for BIOS collection overview card
  ///
  /// In en, this message translates to:
  /// **'BIOS Collection Overview'**
  String get biosCollectionOverview;

  /// Label for verified files count in BIOS dashboard
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get biosVerified;

  /// Placeholder message for unimplemented download feature
  ///
  /// In en, this message translates to:
  /// **'Download functionality for {platformName} - Coming soon!'**
  String downloadComingSoon(String platformName);

  /// Message when no gamepad is detected
  ///
  /// In en, this message translates to:
  /// **'No gamepad connected'**
  String get noGamepadConnected;

  /// Instruction to connect a gamepad
  ///
  /// In en, this message translates to:
  /// **'Connect a gamepad and press any button'**
  String get connectGamepadPrompt;

  /// Prompt to press gamepad buttons in test mode
  ///
  /// In en, this message translates to:
  /// **'Press any button to test (actions disabled)'**
  String get pressButtonToTest;

  /// Header for button function test section
  ///
  /// In en, this message translates to:
  /// **'Button Function Tests'**
  String get buttonFunctionTests;

  /// Gamepad A button label with function
  ///
  /// In en, this message translates to:
  /// **'A (Select)'**
  String get gamepadASelect;

  /// Gamepad B button label with function
  ///
  /// In en, this message translates to:
  /// **'B (Back)'**
  String get gamepadBBack;

  /// Gamepad X button label with function
  ///
  /// In en, this message translates to:
  /// **'X (Search)'**
  String get gamepadXSearch;

  /// Gamepad Y button label with function
  ///
  /// In en, this message translates to:
  /// **'Y (Help)'**
  String get gamepadYHelp;

  /// Gamepad LB button label with function
  ///
  /// In en, this message translates to:
  /// **'LB (Page Down)'**
  String get gamepadLBPageDown;

  /// Gamepad RB button label with function
  ///
  /// In en, this message translates to:
  /// **'RB (Page Up)'**
  String get gamepadRBPageUp;

  /// Gamepad Start button label with function
  ///
  /// In en, this message translates to:
  /// **'Start (Menu)'**
  String get gamepadStartMenu;

  /// Gamepad Select button label with function
  ///
  /// In en, this message translates to:
  /// **'Select (Settings)'**
  String get gamepadSelectSettings;

  /// Gamepad left stick click label
  ///
  /// In en, this message translates to:
  /// **'LS Click'**
  String get gamepadLSClick;

  /// Gamepad right stick click label with function
  ///
  /// In en, this message translates to:
  /// **'RS Click (View)'**
  String get gamepadRSView;

  /// Gamepad left trigger label
  ///
  /// In en, this message translates to:
  /// **'LT (Trigger)'**
  String get gamepadLTTrigger;

  /// Gamepad right trigger label
  ///
  /// In en, this message translates to:
  /// **'RT (Trigger)'**
  String get gamepadRTTrigger;

  /// Header for raw button state display section
  ///
  /// In en, this message translates to:
  /// **'Raw Button States'**
  String get rawButtonStates;

  /// Message when no gamepad buttons are pressed
  ///
  /// In en, this message translates to:
  /// **'No buttons pressed'**
  String get noButtonsPressed;

  /// Header for axis values display section
  ///
  /// In en, this message translates to:
  /// **'Axis Values'**
  String get axisValues;

  /// Message when no axis movement detected
  ///
  /// In en, this message translates to:
  /// **'No axis movement'**
  String get noAxisMovement;

  /// Header for D-pad and left stick test section
  ///
  /// In en, this message translates to:
  /// **'D-Pad + Left Stick'**
  String get dpadLeftStick;

  /// Subtitle description for web settings screen
  ///
  /// In en, this message translates to:
  /// **'Configure settings specific to the web platform'**
  String get webSettingsDescription;

  /// Info card title explaining CORS proxy necessity
  ///
  /// In en, this message translates to:
  /// **'Why is a CORS proxy needed?'**
  String get corsProxyWhyNeeded;

  /// Detailed explanation of why CORS proxy is needed
  ///
  /// In en, this message translates to:
  /// **'Browsers block ROM downloads from external servers due to CORS security restrictions. A CORS proxy relays the request from a server you control, adding the necessary headers.\n\nForsaken includes a Cloudflare Worker you can deploy for free (100k requests/day). See the tools/cors-proxy-worker/ directory for setup instructions.'**
  String get corsProxyExplanation;

  /// Label for CORS proxy URL input field
  ///
  /// In en, this message translates to:
  /// **'CORS Proxy URL'**
  String get corsProxyUrl;

  /// Helper text for CORS proxy URL field
  ///
  /// In en, this message translates to:
  /// **'Leave empty to disable CORS proxy (ROMs from servers without CORS will fail)'**
  String get corsProxyHelperText;

  /// Status text while testing proxy connection
  ///
  /// In en, this message translates to:
  /// **'Testing proxy...'**
  String get testingProxy;

  /// Button label to test CORS proxy connection
  ///
  /// In en, this message translates to:
  /// **'Test Proxy Connection'**
  String get testProxyConnection;

  /// Error when testing proxy with no URL set
  ///
  /// In en, this message translates to:
  /// **'No proxy URL configured'**
  String get noProxyUrlConfigured;

  /// Success message when proxy test passes
  ///
  /// In en, this message translates to:
  /// **'Proxy is working (HTTP {statusCode})'**
  String proxyWorking(int statusCode);

  /// Error message when proxy returns non-200 status
  ///
  /// In en, this message translates to:
  /// **'Proxy returned HTTP {statusCode}'**
  String proxyReturnedHttp(int statusCode);

  /// Error message when proxy connection times out
  ///
  /// In en, this message translates to:
  /// **'Connection timed out'**
  String get connectionTimedOut;

  /// Success snackbar message after saving CORS proxy settings
  ///
  /// In en, this message translates to:
  /// **'CORS proxy settings saved. Takes effect immediately for new ROM launches.'**
  String get corsProxySettingsSaved;

  /// Header for quick deployment instructions card
  ///
  /// In en, this message translates to:
  /// **'Quick Deploy'**
  String get quickDeploy;

  /// Step-by-step deployment instructions for CORS proxy worker
  ///
  /// In en, this message translates to:
  /// **'1. Sign up at dash.cloudflare.com (free)\n2. Install Wrangler: npm install -g wrangler\n3. Login: wrangler login\n4. cd tools/cors-proxy-worker\n5. npx wrangler deploy\n6. Paste the worker URL above'**
  String get corsProxyDeploySteps;

  /// Section header for permanently saved ROMs
  ///
  /// In en, this message translates to:
  /// **'Permanent Storage'**
  String get permanentStorage;

  /// Section header for temporarily downloaded ROMs
  ///
  /// In en, this message translates to:
  /// **'Temporary Storage'**
  String get temporaryStorage;

  /// Empty state message when no ROMs have been downloaded
  ///
  /// In en, this message translates to:
  /// **'No downloaded ROMs'**
  String get noDownloadedRoms;

  /// Error message for BIOS download network failure
  ///
  /// In en, this message translates to:
  /// **'Network connection failed'**
  String get biosErrorNetworkMessage;

  /// Recovery suggestions for network errors (newline-separated)
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection\nTry again in a few moments\nVerify DNS settings\nTry using a VPN if access is restricted'**
  String get biosErrorNetworkSuggestions;

  /// Error message when BIOS file is not found (HTTP 404)
  ///
  /// In en, this message translates to:
  /// **'File not found on server'**
  String get biosErrorFileNotFoundMessage;

  /// Recovery suggestions for file not found errors (newline-separated)
  ///
  /// In en, this message translates to:
  /// **'The BIOS file may have been moved or renamed\nTry downloading from an alternative source\nCheck if the file exists in a different branch/repository\nReport this issue if problem persists'**
  String get biosErrorFileNotFoundSuggestions;

  /// Error message when server denies access (HTTP 403)
  ///
  /// In en, this message translates to:
  /// **'Access denied by server'**
  String get biosErrorAccessDeniedMessage;

  /// Recovery suggestions for access denied errors (newline-separated)
  ///
  /// In en, this message translates to:
  /// **'Server may be blocking downloads\nTry again later - server may be temporarily restricted\nUse VPN if access is region-restricted\nCheck if authentication is required'**
  String get biosErrorAccessDeniedSuggestions;

  /// Error message when server rate limits requests (HTTP 429)
  ///
  /// In en, this message translates to:
  /// **'Rate limit exceeded'**
  String get biosErrorRateLimitedMessage;

  /// Recovery suggestions for rate limit errors (newline-separated)
  ///
  /// In en, this message translates to:
  /// **'Wait a few minutes before trying again\nReduce number of simultaneous downloads\nServer is protecting against excessive requests'**
  String get biosErrorRateLimitedSuggestions;

  /// Error message when BIOS file checksum does not match
  ///
  /// In en, this message translates to:
  /// **'File integrity verification failed'**
  String get biosErrorChecksumMessage;

  /// Recovery suggestions for checksum mismatch errors (newline-separated)
  ///
  /// In en, this message translates to:
  /// **'File may be corrupted during download\nTry downloading again\nCheck if file was updated on server\nVerify your internet connection stability'**
  String get biosErrorChecksumSuggestions;

  /// Error message when BIOS file size does not match expected
  ///
  /// In en, this message translates to:
  /// **'Unexpected file size'**
  String get biosErrorSizeMismatchMessage;

  /// Recovery suggestions for file size mismatch errors (newline-separated)
  ///
  /// In en, this message translates to:
  /// **'File may be different version than expected\nDownload may be incomplete\nTry downloading again\nCheck available disk space'**
  String get biosErrorSizeMismatchSuggestions;

  /// Error message for disk/storage related failures
  ///
  /// In en, this message translates to:
  /// **'Storage error'**
  String get biosErrorStorageMessage;

  /// Recovery suggestions for storage errors (newline-separated)
  ///
  /// In en, this message translates to:
  /// **'Free up disk space\nCheck file permissions\nEnsure destination directory is writable\nTry downloading to a different location'**
  String get biosErrorStorageSuggestions;

  /// Error message when BIOS download times out
  ///
  /// In en, this message translates to:
  /// **'Download timeout'**
  String get biosErrorTimeoutMessage;

  /// Recovery suggestions for timeout errors (newline-separated)
  ///
  /// In en, this message translates to:
  /// **'Internet connection may be slow\nServer may be overloaded\nTry again with a stable connection\nCheck if firewall is blocking the connection'**
  String get biosErrorTimeoutSuggestions;

  /// Error message when BIOS archive extraction fails
  ///
  /// In en, this message translates to:
  /// **'Archive extraction failed'**
  String get biosErrorArchiveMessage;

  /// Recovery suggestions for archive extraction errors (newline-separated)
  ///
  /// In en, this message translates to:
  /// **'Downloaded archive may be corrupted\nTry downloading the file again\nCheck if correct extraction tool is available\nVerify file is a valid archive format'**
  String get biosErrorArchiveSuggestions;

  /// Generic error message for unclassified BIOS download failures
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get biosErrorUnknownMessage;

  /// Recovery suggestions for unknown/generic errors (newline-separated)
  ///
  /// In en, this message translates to:
  /// **'Try downloading again\nCheck your internet connection\nVerify the file is still available\nContact support if problem persists'**
  String get biosErrorUnknownSuggestions;

  /// Title for the download emulators step in setup wizard
  ///
  /// In en, this message translates to:
  /// **'Download Emulators'**
  String get wizardDownloadEmulators;

  /// Description for the download emulators step in setup wizard
  ///
  /// In en, this message translates to:
  /// **'Download pre-configured emulator binaries for your platform. You can choose to download all or select by category.'**
  String get wizardDownloadEmulatorsDesc;

  /// Title for the download ROM lists step in setup wizard
  ///
  /// In en, this message translates to:
  /// **'Download ROM Lists'**
  String get wizardDownloadRomLists;

  /// Description for the download ROM lists step in setup wizard
  ///
  /// In en, this message translates to:
  /// **'Download the ROM database files from GitHub. These contain metadata for organizing your game library.'**
  String get wizardDownloadRomListsDesc;

  /// Title for the download gamelists step in setup wizard
  ///
  /// In en, this message translates to:
  /// **'Download Gamelists'**
  String get wizardDownloadGamelists;

  /// Description for the download gamelists step in setup wizard
  ///
  /// In en, this message translates to:
  /// **'Download gamelist.xml files from GitHub. These contain game names, descriptions, ratings, and other metadata.'**
  String get wizardDownloadGamelistsDesc;

  /// Button label to skip an optional download step in setup wizard
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get wizardSkipStep;

  /// Status message when a wizard download step finishes successfully
  ///
  /// In en, this message translates to:
  /// **'Download complete!'**
  String get wizardDownloadComplete;

  /// Status message when a wizard download step fails
  ///
  /// In en, this message translates to:
  /// **'Download failed: {error}'**
  String wizardDownloadFailed(String error);

  /// Status shown when content is already downloaded in wizard step
  ///
  /// In en, this message translates to:
  /// **'Already downloaded'**
  String get wizardAlreadyDownloaded;

  /// Instruction text for emulator category selection in wizard
  ///
  /// In en, this message translates to:
  /// **'Select a category to download, or download all:'**
  String get wizardSelectCategory;

  /// Status text shown while a download is in progress in wizard
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get wizardDownloading;

  /// Note shown on optional download steps in setup wizard
  ///
  /// In en, this message translates to:
  /// **'This step is optional. You can download later from Settings.'**
  String get wizardDownloadOptional;
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
    'ca',
    'de',
    'en',
    'es',
    'eu',
    'fr',
    'gl',
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
    case 'ca':
      return AppLocalizationsCa();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'eu':
      return AppLocalizationsEu();
    case 'fr':
      return AppLocalizationsFr();
    case 'gl':
      return AppLocalizationsGl();
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
