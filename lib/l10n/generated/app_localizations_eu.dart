// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Basque (`eu`).
class AppLocalizationsEu extends AppLocalizations {
  AppLocalizationsEu([String locale = 'eu']) : super(locale);

  @override
  String get appTitle => 'Forsaken Emulator';

  @override
  String get retroGamingFrontend => 'Retro Joko Frontend-a';

  @override
  String get platforms => 'Platformak';

  @override
  String get roms => 'ROMak';

  @override
  String get settings => 'Ezarpenak';

  @override
  String get settingsAndConfiguration => 'Ezarpenak eta Konfigurazioa';

  @override
  String get aboutForsakenEmulator => 'Forsaken Emulator-ri buruz';

  @override
  String get version => 'Bertsioa';

  @override
  String get appDescription =>
      'Flutter-rekin egindako moderno eta multiplataforma emuladore frontend bat.';

  @override
  String get emulators => 'Emuladoreak';

  @override
  String get ready => 'Prest';

  @override
  String get back => 'Atzera';

  @override
  String get select => 'Hautatu';

  @override
  String get search => 'Bilatu';

  @override
  String get refresh => 'Berriztu';

  @override
  String get loading => 'Kargatzen...';

  @override
  String get error => 'Akatsa';

  @override
  String get initializationError => 'Hasieratze Akatsa';

  @override
  String get retry => 'Saiatu berriro';

  @override
  String get cancel => 'Ezeztatu';

  @override
  String get ok => 'Ados';

  @override
  String get save => 'Gorde';

  @override
  String get delete => 'Ezabatu';

  @override
  String get confirm => 'Berretsi';

  @override
  String get yes => 'Bai';

  @override
  String get no => 'Ez';

  @override
  String get close => 'Itxi';

  @override
  String get noRomsFound => 'ROMrik ez da aurkitu';

  @override
  String get noPlatformsFound => 'Platformarik ez da aurkitu';

  @override
  String get checkRomsPath => 'EGIAZTATU ROMS_PATH ingurune-aldagaia';

  @override
  String get downloading => 'Deskargatzen...';

  @override
  String get downloadComplete => 'Deskarga amaituta';

  @override
  String get downloadFailed => 'Deskarga huts egin du';

  @override
  String get emulatorNotFound => 'Emuladorea ez da aurkitu';

  @override
  String get romNotFound => 'ROMa ez da aurkitu';

  @override
  String get biosRequired => 'BIOS beharrezkoa';

  @override
  String get systemCheck => 'Sistemaren Egiaztapena';

  @override
  String get language => 'Hizkuntza';

  @override
  String get theme => 'Gaia';

  @override
  String get systemDefault => 'Sistemaren lehenetsia';

  @override
  String get help => 'Laguntza';

  @override
  String get keyboardAndGamepadControls => 'Teklatu eta Gamepad Kontrolak';

  @override
  String get navigation => 'Nabigazioa';

  @override
  String get actions => 'Ekintzak';

  @override
  String get viewControls => 'Ikuspegi Kontrolak';

  @override
  String get gotIt => 'Ulertuta!';

  @override
  String get exit => 'Irten';

  @override
  String get exitApplication => 'Aplikaziotik Irten';

  @override
  String get exitConfirm => 'Irten nahi al duzu?';

  @override
  String get downloadManager => 'Deskarga Kudeatzailea';

  @override
  String get clearCompleted => 'Amaitutakoak Garbitu';

  @override
  String get selectCategory => 'Kategoria Hautatu';

  @override
  String get confirmDownload => 'Deskarga Berretsi';

  @override
  String get downloadGameLists => 'Joko Zerrendak Deskargatu';

  @override
  String get downloadGameListsDescription =>
      'ROM zerrendak GitHub-etik deskargatuko ditu.';

  @override
  String get gameListsDownloaded => 'Joko zerrendak deskargatuta!';

  @override
  String get romStorageManagement => 'ROM Biltegiratze Kudeaketa';

  @override
  String get deleteRom => 'ROMa Ezabatu?';

  @override
  String deleteRomConfirm(String fileName) {
    return '$fileName ezabatu?';
  }

  @override
  String get actionCannotBeUndone => 'Ekintza hau ezin da desegin.';

  @override
  String deleted(String fileName) {
    return 'Ezabatuta: $fileName';
  }

  @override
  String get savePermanently => 'Betiko Gorde?';

  @override
  String moveRomConfirm(String fileName) {
    return '$fileName biltegiratze permanentera mugitu?';
  }

  @override
  String saved(String fileName) {
    return 'Gordeta: $fileName';
  }

  @override
  String get clearAll => 'Dena Garbitu?';

  @override
  String get clearAllConfirm => 'ROM临时 guztiak ezabatu?';

  @override
  String get allCleared => 'ROM临时 guztiak garbituta';

  @override
  String get systemPathsConfiguration => 'Sistemaren Bide Konfigurazioa';

  @override
  String get migrateRoms => 'ROMak Migratu?';

  @override
  String get migrateRomsDescription =>
      'ROMen biltegiratze permanentearen bidea \$oldPath-tik \$newPath-ra aldatu da. Existitzen diren ROMak kokaleku berrira migratu nahi al dituzu?';

  @override
  String get noKeepThem => 'Ez, mantendu';

  @override
  String get yesMigrateRoms => 'Bai, ROMak migratu';

  @override
  String get migratingRoms => 'ROMak migratzen...';

  @override
  String get romMigrationFailed => 'Abisua: ROMen migraketa huts egin du';

  @override
  String get pathsSaved => 'Bideak ondo gorde dira';

  @override
  String get errorSavingPaths => 'Bideak gordetzean akatsa:';

  @override
  String get resetConfiguration => 'Konfigurazioa Berrezarri';

  @override
  String get resetConfigDescription =>
      'Hau bide guztiak lehenetsitako balioetara berrezarriko ditu. Zure ROM eta multimedia fitxategiak ez dute eragingo.';

  @override
  String get configurationReset =>
      'Konfigurazioa lehenetsitakoetara berrezarrita';

  @override
  String get errorResettingConfiguration =>
      'Konfigurazioa berrezartzean akatsa:';

  @override
  String get savePaths => 'Bideak Gorde';

  @override
  String get saving => 'Gordetzen...';

  @override
  String get emulatorManagement => 'Emuladore Kudeaketa';

  @override
  String get configurationReloaded => 'Konfigurazioa berriro kargatuta';

  @override
  String get errorLoadingEmulators => 'Emuladoreak kargatzean akatsa:';

  @override
  String get emulatorAdded => 'Emuladorea ondo gehituta';

  @override
  String get errorAddingEmulator => 'Emuladorea gehitzean akatsa:';

  @override
  String get emulatorUpdated => 'Emuladorea ondo eguneratuta';

  @override
  String get errorUpdatingEmulator => 'Emuladorea eguneratzean akatsa:';

  @override
  String get deleteEmulator => 'Emuladorea Ezabatu';

  @override
  String get emulatorDeleted => 'Emuladorea ezabatuta';

  @override
  String get errorDeletingEmulator => 'Emuladorea ezabatzean akatsa:';

  @override
  String get configurationSource => 'Konfigurazio Iturburua';

  @override
  String get addEmulator => 'Emuladorea Gehitu';

  @override
  String get systemNameRequired => 'Sistemaren izena beharrezkoa da';

  @override
  String get commandRequired => 'Gutxienez komando bat beharrezkoa da';

  @override
  String get addCommand => 'Komandoa Gehitu';

  @override
  String get acceptZipFiles => 'ZIP fitxategiak onartu';

  @override
  String get acceptZipSubtitle => 'ROMak ZIP artxibotik abiaraztea baimendu';

  @override
  String get useForeverMode => 'Forever Modua Erabili';

  @override
  String get useForeverSubtitle => 'Emuladorea martxan mantendu';

  @override
  String get workInProgress => 'Lanean';

  @override
  String get wipSubtitle => 'Oraindik guztiz konfiguratu gabe dagoela markatu';

  @override
  String get biosFirmwareHelp => 'BIOS eta Firmware Laguntza';

  @override
  String get downloadMissingFiles => 'Fitxategi Faltenak Deskargatu';

  @override
  String get showOnlyMissing => 'Faltak soilik erakutsi';

  @override
  String get downloadAllMissingBios => 'Falta diren BIOS guztiak Deskargatu';

  @override
  String get configurationError => 'Konfigurazio Akatsa';

  @override
  String get configurationErrorDescription =>
      'Aplikazioak ezin izan du beharrezko konfigurazioa aurkitu.\nMesedez, konfiguratu zure bideak Ezarpenak > Sistemaren Bideak-en.';

  @override
  String get configurationRequired =>
      'Beharrezkoa:\n- Multimedia Bidea: aktibo multimedia dituen direktorioa\n- Emuladore Bidea: emuladore binarioak dituen direktorioa\n\nAukerakoa:\n- ROM biltegiratzeko bideak deskarga temporaletarako/permanentetarako';

  @override
  String get goToSettingsToConfigure =>
      'Ezarpenak > Sistemaren Bideak-era jo konfiguratzeko';

  @override
  String get noDownloadableBios =>
      'Ez dago falta den BIOS fitxategi deskargagarririk';

  @override
  String get allDownloadsCompleted => 'Deskarga guztiak ondo amaituta!';

  @override
  String get batchDownloadFailed => 'Bildumako deskarga huts egin du:';

  @override
  String get download => 'Deskargatu';

  @override
  String get downloadCancelled => 'Deskarga ezeztatuta';

  @override
  String get launched => 'Abiarazita:';

  @override
  String get failedToSave => 'ROMa betiko gordetzea huts egin du';

  @override
  String get failedToSaveRom => 'ROMa betiko gordetzea huts egin du';

  @override
  String get errorSaving => 'ROMa gordetzean akatsa:';

  @override
  String errorSavingRom(String error) {
    return 'ROMa gordetzean akatsa: $error';
  }

  @override
  String get openFolder => 'Karpeta Ireki';

  @override
  String get viewManual => 'Eskuliburua Ikusi';

  @override
  String get play => 'Jolastu';

  @override
  String get goBack => 'Itzuli';

  @override
  String get clearSearch => 'Bilaketa Garbitu';

  @override
  String get iUnderstand => 'Ulertzen dut eta baldintza hauek onartzen ditut';

  @override
  String get start => 'Hasi';

  @override
  String get debugMode => 'Debug Modua: ';

  @override
  String get toggleDebugMode => 'Debug Modua Aldatu';

  @override
  String get preparingDownload => 'Deskarga prestatzen...';

  @override
  String get noEmulatorsAvailable =>
      'Ez dago emuladore erabilgarririk kategoria honetarako';

  @override
  String get failedToLaunch => 'Web emuladorea abiaratzea huts egin du:';

  @override
  String get platformInfo => 'Plataforma Info';

  @override
  String get emulatorPlatformInfo => 'Emuladore Plataforma Info';

  @override
  String get favorites => 'Gogokoak';

  @override
  String get all => 'Guztiak';

  @override
  String get collections => 'Bildumak';

  @override
  String get searchRoms => 'ROMak Bilatu...';

  @override
  String get searchPlatforms => 'Plataformak Bilatu...';

  @override
  String romsCount(int count) {
    return '$count ROM';
  }

  @override
  String platformsCount(int count) {
    return '$count plataforma';
  }

  @override
  String get region => 'Eskualdea';

  @override
  String get genre => 'Generoa';

  @override
  String get year => 'Urtea';

  @override
  String get publisher => 'Argitaratzailea';

  @override
  String get developer => 'Garatzailea';

  @override
  String get playWithNetplay => 'Netplay-rekin Jolastu';

  @override
  String get downloadBios => 'BIOS Deskargatu';

  @override
  String get viewDetails => 'Xehetasunak Ikusi';

  @override
  String get addToFavorites => 'Gogokoetara Gehitu';

  @override
  String get removeFromFavorites => 'Gogokoetatik Kendu';

  @override
  String get biosMissing => 'BIOS falta';

  @override
  String get biosPresent => 'BIOS dago';

  @override
  String get checkingBios => 'BIOS egiaztatzen...';

  @override
  String get emulatorDownloading => 'Emuladorea deskargatzen...';

  @override
  String get emulatorDownloadComplete => 'Emuladorea deskargatuta';

  @override
  String get emulatorDownloadFailed => 'Emuladorea deskargatzea huts egin du';

  @override
  String get installingEmulator => 'Emuladorea instalatzen...';

  @override
  String get emulatorReady => 'Emuladorea prest';

  @override
  String get configuration => 'Konfigurazioa';

  @override
  String get paths => 'Bideak';

  @override
  String get storage => 'Biltegiratzea';

  @override
  String get emulatorsPath => 'Emuladore Bidea';

  @override
  String get romsPath => 'ROM Bidea';

  @override
  String get mediaPath => 'Multimedia Bidea';

  @override
  String get biosPath => 'BIOS Bidea';

  @override
  String get tempPath => 'Aldi Biko Bidea';

  @override
  String get browse => 'Arakatu';

  @override
  String get apply => 'Aplikatu';

  @override
  String get reset => 'Berrezarri';

  @override
  String get clear => 'Garbitu';

  @override
  String get scan => 'Eskaneatu';

  @override
  String get scanForRoms => 'ROMak Eskaneatu';

  @override
  String get scanningRoms => 'ROMak eskaneatzen...';

  @override
  String get scanComplete => 'Eskaneoa amaituta';

  @override
  String romsFound(int count) {
    return '$count ROM aurkituta';
  }

  @override
  String get noNewRomsFound => 'ROM berririk ez da aurkitu';

  @override
  String get launchEmulator => 'Emuladorea Abiarazi';

  @override
  String get emulatorError => 'Emuladore Akatsa';

  @override
  String get gamepadConnected => 'Gamepad konektatuta';

  @override
  String get gamepadDisconnected => 'Gamepad deskonektatuta';

  @override
  String get gamepadTest => 'Gamepad Probatu';

  @override
  String get pressAnyButton => 'Edozein botoi sakatu probatzeko';

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
  String get dpadUp => 'D-Pad Gora';

  @override
  String get dpadDown => 'D-Pad Behera';

  @override
  String get dpadLeft => 'D-Pad Ezker';

  @override
  String get dpadRight => 'D-Pad Eskuin';

  @override
  String get leftShoulder => 'L1';

  @override
  String get rightShoulder => 'R1';

  @override
  String get leftTrigger => 'L2';

  @override
  String get rightTrigger => 'R2';

  @override
  String get leftStick => 'Ezkerreko Stick-a';

  @override
  String get rightStick => 'Eskuineko Stick-a';

  @override
  String get setupWizard => 'Konfigurazio Laguntzailea';

  @override
  String get welcome => 'Ongi etorri';

  @override
  String get welcomeMessage => 'Ongi etorri Forsaken Emulator-era';

  @override
  String get next => 'Hurrengoa';

  @override
  String get previous => 'Aurrekoa';

  @override
  String get finish => 'Amaitu';

  @override
  String get skip => 'Saltatu';

  @override
  String get setupComplete => 'Konfigurazioa Amaituta';

  @override
  String get selectLanguage => 'Hizkuntza Hautatu';

  @override
  String get selectEmulatorsPath => 'Emuladore Bidea Hautatu';

  @override
  String get selectRomsPath => 'ROM Bidea Hautatu';

  @override
  String get selectMediaPath => 'Multimedia Bidea Hautatu';

  @override
  String get allSettingsConfigured => 'Ezarpen guztiak konfiguratuta';

  @override
  String get darkTheme => 'Iluna';

  @override
  String get lightTheme => 'Argia';

  @override
  String get systemTheme => 'Sistema';

  @override
  String get about => 'Honi buruz';

  @override
  String get checkForUpdates => 'Eguneraketak Egiaztatu';

  @override
  String get noUpdatesAvailable => 'Ez dago eguneraketarik erabilgarririk';

  @override
  String get updateAvailable => 'Eguneraketarik erabilgarri';

  @override
  String get downloadingUpdate => 'Eguneraketa deskargatzen...';

  @override
  String get installingUpdate => 'Eguneraketa instalatzen...';

  @override
  String get updateComplete => 'Eguneraketa amaituta';

  @override
  String get updateFailed => 'Eguneraketa huts egin du';

  @override
  String get networkError => 'Sare Akatsa';

  @override
  String get connectionError => 'Konexio Akatsa';

  @override
  String get timeoutError => 'Denbora-muga Akatsa';

  @override
  String get unknownError => 'Akats ezezaguna';

  @override
  String get permissionDenied => 'Baimena ukatuta';

  @override
  String get fileNotFound => 'Fitxategia ez da aurkitu';

  @override
  String get directoryNotFound => 'Direktorioa ez da aurkitu';

  @override
  String get diskFull => 'Diskoa beteta';

  @override
  String get invalidPath => 'Bide baliogabea';

  @override
  String get pathNotWritable => 'Bide idazgarririk ez';

  @override
  String get romCorrupted => 'ROM fitxategia corrupted egon liteke';

  @override
  String get zipError => 'ZIP artxibo Akatsa';

  @override
  String get extractionFailed => 'Eskuratzea huts egin du';

  @override
  String get checksumMismatch => 'Checksumen desez';

  @override
  String get biosCheckFailed => 'BIOS egiaztapena huts egin du';

  @override
  String get continueAnyway => 'Halere Jarraitu';

  @override
  String get reportIssue => 'Arazoa Salatu';

  @override
  String get copyToClipboard => 'Arbelera Kopiatu';

  @override
  String get copiedToClipboard => 'Arbelera kopiatuta';

  @override
  String get share => 'Partekatu';

  @override
  String get hide => 'Ezkutatu';

  @override
  String get show => 'Erakutsi';

  @override
  String get toggleView => 'Ikuspegia Aldatu';

  @override
  String get gridView => 'Sareta Ikuspegia';

  @override
  String get listView => 'Zerrenda Ikuspegia';

  @override
  String get carouselView => 'Karusel Ikuspegia';

  @override
  String get sortBy => 'Honen arabera ordenatu';

  @override
  String get sortByName => 'Izena';

  @override
  String get sortByDate => 'Data';

  @override
  String get sortBySize => 'Tamaina';

  @override
  String get sortByRegion => 'Eskualdea';

  @override
  String get ascending => 'Goraka';

  @override
  String get descending => 'Beheraka';

  @override
  String get filter => 'Iragazi';

  @override
  String get filterByRegion => 'Eskualdearen arabera Iragazi';

  @override
  String get filterByGenre => 'Generoaren arabera Iragazi';

  @override
  String get filterByYear => 'Urtearen arabera Iragazi';

  @override
  String get clearFilters => 'Iragazkiak Garbitu';

  @override
  String get systemInfo => 'Sistema Info';

  @override
  String get cpu => 'CPU';

  @override
  String get memory => 'Memoria';

  @override
  String get storageInfo => 'Biltegiratzea';

  @override
  String get os => 'Sistema Eragilea';

  @override
  String get emulatorVersion => 'Emuladore Bertsioa';

  @override
  String get totalRoms => 'ROM Guztiak';

  @override
  String get totalSize => 'Tamaina Totala';

  @override
  String get freeSpace => 'Leku Librea';

  @override
  String get usedSpace => 'Erabilitako Lekua';

  @override
  String get systemUtilities => 'Sistema Tresnak';

  @override
  String get romVerificationResults => 'ROM Egiaztapen Emaitzak';

  @override
  String get totalRomFiles => 'ROM Fitxategi Guztiak';

  @override
  String get emptyRomFiles => 'ROM Fitxategi Hutsa';

  @override
  String get validRomFiles => 'ROM Fitxategi Baliagarriak';

  @override
  String get romsDirectoryDoesNotExist => 'ROM direktorioa ez da existitzen';

  @override
  String get gamelistCheckResults => 'Zerrenda Egiaztapen Emaitzak';

  @override
  String get totalPlatforms => 'Plataforma Guztiak';

  @override
  String get missingGamelists => 'Zerrenda Falten';

  @override
  String get configurationBackup => 'Konfigurazio Babeskopia';

  @override
  String get configurationBackedUp => 'Konfigurazioa honetan babestuta:';

  @override
  String get errorBackingUp => 'Konfigurazioa babestean akatsa:';

  @override
  String get romDatabase => 'ROM Datu-basea';

  @override
  String get romDatabaseDownloaded => 'ROM datu-basea ondo deskargatuta';

  @override
  String get failedDownloadRomDatabase =>
      'ROM datu-basea deskargatzea huts egin du';

  @override
  String get romDatabaseCleared => 'ROM datu-basea garbituta';

  @override
  String get failedClearDatabase => 'Datu-basea garbitzea huts egin du';

  @override
  String get downloadRomDatabase => 'ROM Datu-basea Deskargatu';

  @override
  String get clearRomDatabase => 'ROM Datu-basea Garbitu';

  @override
  String get systemRequirements => 'Sistemaren Baldintzak';

  @override
  String get failedToCheckSystem => 'Sistema egiaztatzea huts egin du';

  @override
  String cleanedUpTempFiles(String deletedCount) {
    return '$deletedCount ROM临时 fitxategi garbituta';
  }

  @override
  String get errorCleaningTempFiles => '临时 fitxategiak garbitzean akatsa:';

  @override
  String get errorVerifyingRomFiles => 'ROM fitxategiak egiaztatzean akatsa:';

  @override
  String get errorCheckingGamelists => 'Zerrendak egiaztatzean akatsa:';

  @override
  String get cancelDownload => 'Deskarga Ezeztatu';

  @override
  String get selectEmulator => 'Emuladorea Hautatu';

  @override
  String get biosStatusDashboard => 'BIOS Egoera Panela';

  @override
  String get webSettings => 'Web Ezarpenak';

  @override
  String get saveSettings => 'Ezarpenak Gorde';

  @override
  String get errorSavingSettings => 'Ezarpenak gordetzean akatsa:';

  @override
  String romsCountItems(String count) {
    return '$count ROM';
  }

  @override
  String get savedPermanently => 'betiko gordeta';

  @override
  String get keptInTemporary => 'aldian mantenduta';

  @override
  String get tryAgain => 'Saiatu berriro';

  @override
  String get allDownloads => 'Deskarga guztiak amaituta';

  @override
  String romSavedPermanently(String name) {
    return '$name betiko gordeta';
  }

  @override
  String get undo => 'Desegin';

  @override
  String romKeptInTemporary(String name) {
    return '$name aldi-biltegian mantenduta';
  }

  @override
  String romsCountWithSize(String count, String size) {
    return '$count ROM • $size';
  }

  @override
  String get whatYouCanTry => 'Zer saia daitekeen:';

  @override
  String get tips => 'Aholkuak';

  @override
  String get helpNavigateItems => 'Elementuen artean nabigatu';

  @override
  String get helpGamepadNavigation => 'Gamepad nabigazioa';

  @override
  String get helpQuickNavigation => 'Nabigazio azkarra (elementu asko saltatu)';

  @override
  String get helpGamepadPageNavigation => 'Gamepad orrialde nabigazioa';

  @override
  String get helpGoToFirst => 'Lehen elementura joan';

  @override
  String get helpGoToLast => 'Azken elementura joan';

  @override
  String get helpJumpToLetter =>
      'Hartzatiletrarekin hasten den elementura saltatu';

  @override
  String get helpSelectItem => 'Elementua hautatu';

  @override
  String get helpGamepadSelect => 'Gamepad hautapena';

  @override
  String get helpGoBackCloseDialogs => 'Atzera / Elkarrizketak itxi';

  @override
  String get helpExitApplication => 'Aplikaziotik irten';

  @override
  String get helpGamepadBackClose => 'Gamepad atzera / Elkarrizketak itxi';

  @override
  String get helpToggleViewMode =>
      'Ikuspegi modua aldatu (Sareta/Zerrenda/Karusela)';

  @override
  String get helpGamepadViewToggle => 'Gamepad-ekin ikuspegia aldatu';

  @override
  String get helpRefreshView => 'Oraineko ikuspegia berriztu';

  @override
  String get helpShowPlatformInfo => 'Plataforma informazioa erakutsi';

  @override
  String get helpActivateSearch => 'Bilaketa aktibatu';

  @override
  String get helpGamepadSearch => 'Gamepad bilaketa';

  @override
  String get helpShowHelpDialog => 'Laguntza elkarrizketa hau erakutsi';

  @override
  String get helpGamepadHelp => 'Gamepad laguntza';

  @override
  String get tipUseKeyboardOrGamepad =>
      'Teklatua edo gamepad-a erabili nabigatzeko';

  @override
  String get tipAlphabeticalJump =>
      'Alfabetiko jauzak ikuspegi guztietan funtzionatzen du';

  @override
  String get tipPressQuestionMark =>
      'Sakatu ? edozein unetan laguntza hau ikusteko';

  @override
  String get tipGamepadAlongside =>
      'Gamepad-a teklatu kontrolekin batera funtzionatzen du';

  @override
  String get configurePathsDescription =>
      'Konfiguratu aplikazioak ROM, multimedia eta emuladoreak aurkitzeko erabiltzen dituen bideak.';

  @override
  String get romListsAutoManaged =>
      'ROM zerrendak automatikoki kudeatzen dira orain. Deskargatu Ezarpenak > ROM Datu-basea-tik.';

  @override
  String get romStorage => 'ROM Biltegiratzea';

  @override
  String get configureRomStorageDescription =>
      'Konfiguratu deskargatutako ROMak non biltegiratzen diren aldi baterako eta betiko.';

  @override
  String get resetToDefaults => 'Lehenetsietara berrezarri';

  @override
  String get mediaPathLabel => 'Multimedia Bidea';

  @override
  String get mediaPathHint => 'Multimedia (irudiak, bideoak) duen direktorioa';

  @override
  String get emulatorsPathLabel => 'Emuladore Bidea';

  @override
  String get emulatorsPathHint => 'Emuladore binarioak dituen direktorioa';

  @override
  String get gamelistPathAutomatic => 'Zerrenda Bidea (Automatikoa)';

  @override
  String get gamelistAutoDescription =>
      'Joko zerrendak orain app datu direktorioan automatikoki kudeatzen dira. Hau app oso independente egiten du eta etorkizuneko GitHub-ek oinarritutako zerrenda banaketa prestatzen du.';

  @override
  String get tempRomStorageLabel => 'ROM Biltegiratze Aldibikoa (Aukerakoa)';

  @override
  String get tempRomStorageDescription =>
      'ROMak hemen deskargatzen dira lehenengo. Jolastu ondoren biltegiratze permanentera igo daitezke.';

  @override
  String get permanentRomStorageLabel =>
      'ROM Biltegiratze Permanentea (Aukerakoa)';

  @override
  String get permanentRomStorageDescription =>
      'Betiko gordeta dauden ROMak hemen biltegiratzen dira. Hau ez dira automatikoki garbitzen.';

  @override
  String get defaultAppSupportDir => 'Lehenetsia: app euskarri direktorioa';

  @override
  String currentPathDisplay(String path) {
    return 'Orain: $path';
  }

  @override
  String get configurationFile => 'Konfigurazio Fitxategia';

  @override
  String get source => 'Iturburua:';

  @override
  String get customConfigActive => 'Konfigurazio pertsonalizatua aktibo';

  @override
  String get pathStructure => 'Bide Egitura';

  @override
  String get pathStructureDescription =>
      'Multimedia Bidea: MEDIA_PATH/plataforma/boxart|screenshots|videos/rom.png\nZerrenda Bidea: ~/.local/share/com.example.emulator/gamelists/plataforma/gamelist.xml (automatikoa)\nEmuladore Bidea: EMULATORS_PATH/emulador_binario';

  @override
  String get errorCheckingSystem => 'Sistemaren egiaztatzean akatsa';

  @override
  String get recheckR => 'Berriro egiaztatu (R)';

  @override
  String get allRequiredToolsInstalled =>
      'Beharrezko Tresna Guztiak Instalatuak';

  @override
  String get missingRequiredTools => 'Beharrezko Tresnak Faltan';

  @override
  String get systemReadyToUse =>
      'Zure sistema emuladorea erabiltzeko prest dago';

  @override
  String get someRequiredToolsMissing => 'Beharrezko tresna batzuk falta dira';

  @override
  String get requiredTools => 'Beharrezko Tresnak';

  @override
  String get requiredToolsDescription =>
      'Tresna hauek emuladoreak deskargatu eta ateratzeko beharrezkoak dira';

  @override
  String get installationInstructions => 'Instalazio Argibideak';

  @override
  String get installed => 'Instalatuta';

  @override
  String get missing => 'Faltan';

  @override
  String get downloadEmulatorsAndGameLists =>
      'Emuladoreak eta joko zerrendak deskargatu';

  @override
  String get quickActions => 'Ekintza Azkarrak';

  @override
  String get downloadAll => 'Denak Deskargatu';

  @override
  String get byCategory => 'Kategoriaka';

  @override
  String get downloadQueue => 'Deskarga Ilara';

  @override
  String get noDownloadsInProgress => 'Ez dago martxan deskargarik';

  @override
  String get selectQuickActionToStart =>
      'Hautatu goiko ekintza azkar bat deskargatzen hasteko';

  @override
  String get categorySony => 'Sony (PS1-PS4)';

  @override
  String get categoryNintendo => 'Nintendo (GC, Wii, Switch)';

  @override
  String get categoryMicrosoft => 'Microsoft (Xbox, Xbox 360)';

  @override
  String get categoryMultiPlatform => 'Multi-Plataforma (RetroArch)';

  @override
  String get categoryOtherEmulators => 'Beste Emuladoreak';

  @override
  String get categoryUtilities => 'Tresnak';

  @override
  String confirmDownloadDescription(String count, String size) {
    return '$count emuladore deskargatu?\nZenbatetsitako tamaina: ~$size MB\n\nHau denbora pixka bat har dezake zure internet konexioaren arabera.';
  }

  @override
  String get alreadyInstalled => 'Jadanik instalatuta';

  @override
  String get starting => 'Abiarazten...';

  @override
  String get completed => 'Amaituta';

  @override
  String get gameListsAlreadyDownloaded => 'Joko zerrenda jadanik deskargatuta';

  @override
  String get redownload => 'Berriro Deskargatu';

  @override
  String get gameListsFromGitHub => 'Joko Zerrendak (GitHub-etik)';

  @override
  String get downloaded => 'Deskargatuta';

  @override
  String get cancelled => 'Ezeztatuta';

  @override
  String get missingFor => 'Faltan:';

  @override
  String get noCustomConfigToBackup =>
      'Ez dago babesteko konfigurazio pertsonalizaturik. Lehenetsiak erabiltzen.';

  @override
  String get saveConfigurationBackup => 'Konfigurazio Babeskopia Gorde';

  @override
  String get refreshStatsR => 'Estatistikak berriztu (R)';

  @override
  String get systemStatistics => 'Sistema Estatistikak';

  @override
  String get romFiles => 'ROM Fitxategiak';

  @override
  String get maintenanceTools => 'Mantentze Tresnak';

  @override
  String get cleanupTemporaryRoms => 'ROM Aldibikoak Garbitu';

  @override
  String get cleanupTemporaryRomsDescription =>
      'Sistemaren aldi-biko direktorioko ROM临时 fitxategiak ezabatu';

  @override
  String get verifyRomFiles => 'ROM Fitxategiak Egiaztatu';

  @override
  String get verifyRomFilesDescription =>
      'ROM fitxategi guztiak existitzen eta baliogarriak direla egiaztatu';

  @override
  String get checkMissingGamelists => 'Zerrenda Faltak Egiaztatu';

  @override
  String get checkMissingGamelistsDescription =>
      'gamelist.xml fitxategia falta duten platformak aurkitu';

  @override
  String get backupConfiguration => 'Konfigurazio Babeskopia';

  @override
  String get backupConfigurationDescription =>
      'config.json-ren babeskopia sortu';

  @override
  String get downloadingRomDatabase => 'ROM Datu-basea deskargatzen...';

  @override
  String get downloadMayTakeMinutes =>
      'Hau minutu batzuk har ditzake zure konexioaren arabera...';

  @override
  String get databaseStatus => 'Datu-base Egoera';

  @override
  String get notDownloaded => 'Deskargatu gabe';

  @override
  String get aboutRomDatabase => 'ROM Datu-baseari Buruz';

  @override
  String get aboutRomDatabaseDescription =>
      'ROM datu-baseak platformaren arabera antolatutako ROM eskuragarrien zerrendak ditu. GitHub-eko Forsaken romList repositoriotik deskargatzen da.';

  @override
  String get romDatabaseSource =>
      'Iturburua: github.com/ForsakenStation/romList';

  @override
  String get downloadRomDatabaseDescription =>
      'Hau ROM zerrendak deskargatuko ditu GitHub-eko Forsaken romList repositoriotik.';

  @override
  String get downloadRomDatabaseStats =>
      'Tamaina: ~7 MB\nPlataforma: 138\nROM Guztiak: ~240.000';

  @override
  String get downloadWillOverwrite =>
      'Oharra: honek existitzen diren datuak gainidatziko ditu.';

  @override
  String get clearRomDatabaseDescription =>
      'Hau deskargatutako ROM zerrenda guztiak ezabatu eta datu-basea bere egoera hasierara itzuliko du.';

  @override
  String get gamelistsStatus => 'Zerrenda Egoera';

  @override
  String get gamelistsDownloaded => 'Deskargatuta';

  @override
  String get gamelistsNotDownloaded => 'Deskargatu gabe';

  @override
  String get aboutGamelists => 'Zerrendei Buruz';

  @override
  String get aboutGamelistsDescription =>
      'Joko zerrendek plataforma bakoitzeko joko metadatuak (izenak, deskribapenak, balorazioak) dituzte. GitHub-eko Forsaken gamelists repositoriotik deskargatzen dira.';

  @override
  String get gamelistsSource =>
      'Iturburua: github.com/ForsakenStation/gamelists';

  @override
  String get downloadGamelists => 'Zerrendak Deskargatu';

  @override
  String get downloadGamelistsDescription =>
      'Hau gamelist.xml fitxategiak deskargatuko ditu GitHub-eko Forsaken gamelists repositoriotik.';

  @override
  String get downloadGamelistsWillOverwrite =>
      'Oharra: honek existitzen diren zerrenda fitxategiak gainidatziko ditu.';

  @override
  String get downloadingGamelists => 'Zerrendak deskargatzen...';

  @override
  String get gamelistsDownloadedSuccess => 'Zerrendak ondo deskargatuta';

  @override
  String get failedDownloadGamelists => 'Zerrendak deskargatzea huts egin du';

  @override
  String get clearGamelists => 'Zerrendak Garbitu';

  @override
  String get clearGamelistsDescription =>
      'Hau deskargatutako zerrenda fitxategi guztiak ezabatuko ditu.';

  @override
  String get gamelistsCleared => 'Zerrendak garbituta';

  @override
  String get failedClearGamelists => 'Zerrendak garbitzea huts egin du';

  @override
  String get rebuildMediaCache => 'Multimedia Cache-a Berriz Eraiki';

  @override
  String get rebuildMediaCacheDescription =>
      'Multimedia direktorioak eskaneatu eta zerrendetan bideak cache-atu karga azkarragoa izateko';

  @override
  String get rebuildMediaCacheConfirmTitle =>
      'Multimedia Cache-a Berriz Eraiki?';

  @override
  String get rebuildMediaCacheConfirmBody =>
      'Hau multimedia direktorio guztiak eskaneatuko eta gamelist.xml fitxategiak multimedia bideekin eguneratuko ditu. Honek denbora pixka bat har dezake bilduma handientzat.';

  @override
  String get rebuildMediaCacheProgress =>
      'Multimedia cache-a berriz eraikitzen...';

  @override
  String rebuildMediaCacheProcessingPlatform(
    String platform,
    String current,
    String total,
  ) {
    return '$platform ($current/$total) prozesatzen';
  }

  @override
  String get rebuildMediaCacheComplete => 'Multimedia Cache-a Berriz Eraikita';

  @override
  String rebuildMediaCacheSummary(
    String platforms,
    String games,
    String updated,
    String paths,
  ) {
    return '$platforms plataforma, $games joko eskaneatuta, $updated eguneratuta, $paths multimedia bide cache-atu';
  }

  @override
  String get rebuildMediaCacheError =>
      'Multimedia cache-a berriz eratzea huts egin du';

  @override
  String rebuildMediaCacheErrors(String count) {
    return '$count akats gertatu da berrizeratzean';
  }

  @override
  String get description => 'Deskribapena';

  @override
  String get noDescriptionAvailable => 'Ez dago deskribapenik ROM honentzat.';

  @override
  String get releaseDate => 'Kaleratze data';

  @override
  String get players => 'Jokalariak';

  @override
  String get rating => 'Balorazioa';

  @override
  String get regions => 'Eskualdeak';

  @override
  String folderRomCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ROM',
      one: '$count ROM',
    );
    return '$_temp0';
  }

  @override
  String manualTitle(String name) {
    return '$name - Eskuliburua';
  }

  @override
  String get playInBrowser => 'Nabigatzailean jokatu';

  @override
  String downloadingPlatformBios(String platformName) {
    return '$platformName BIOS deskargatzen';
  }

  @override
  String get downloadingAllMissingBios =>
      'Falta diren BIOS guztiak deskargatzen';

  @override
  String biosFileLabel(String filename) {
    return 'Fitxategia: $filename';
  }

  @override
  String batchProgressLabel(String completed, String total) {
    return 'Aurrerapena: $completed/$total fitxategi';
  }

  @override
  String get fileDetails => 'Fitxategiaren xehetasunak:';

  @override
  String get waiting => 'Itxaroten...';

  @override
  String get verifying => 'Egiaztatzen...';

  @override
  String get failed => 'Huts egin du';

  @override
  String get preparing => 'Prestatzen...';

  @override
  String get downloadingFiles => 'Fitxategiak deskargatzen...';

  @override
  String get someDownloadsFailed => 'Deskarga batzuek huts egin dute';

  @override
  String get downloadsCancelled => 'Deskargak bertan behera utzi dira';

  @override
  String get calculating => 'Kalkulatzen...';

  @override
  String secondsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count segundo',
      one: 'segundo 1',
    );
    return '$_temp0';
  }

  @override
  String minutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutu',
      one: 'minutu 1',
    );
    return '$_temp0';
  }

  @override
  String hoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ordu',
      one: 'ordu 1',
    );
    return '$_temp0';
  }

  @override
  String get downloadingAndLaunching => 'Deskargatzen eta abiarazten...';

  @override
  String get launching => 'Abiarazten...';

  @override
  String emulatorLabel(String name) {
    return 'Emuladorea: $name';
  }

  @override
  String get generalInformation => 'Informazio orokorra';

  @override
  String get manufacturer => 'Fabrikatzailea';

  @override
  String get releaseYear => 'Argitalpen urtea';

  @override
  String get generation => 'Belaunaldia';

  @override
  String get technicalSpecifications => 'Zehaztapen teknikoak';

  @override
  String get resolution => 'Bereizmena';

  @override
  String get colors => 'Koloreak';

  @override
  String get notNow => 'Orain ez';

  @override
  String get saveRomPermanently => 'ROM betirako gorde?';

  @override
  String get keepRomOfflineQuestion =>
      'ROM hau deskargatuta mantendu nahi duzu lineaz kanpo jokatzeko?';

  @override
  String get deletedToSaveSpace =>
      'Bestela, geroago ezabatuko da tokia aurrezteko.';
}
