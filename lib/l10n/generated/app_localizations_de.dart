// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Forsaken Emulator';

  @override
  String get retroGamingFrontend => 'Retro-Gaming-Frontend';

  @override
  String get platforms => 'Plattformen';

  @override
  String get roms => 'ROMs';

  @override
  String get settings => 'Einstellungen';

  @override
  String get settingsAndConfiguration => 'Einstellungen & Konfiguration';

  @override
  String get aboutForsakenEmulator => 'Über Forsaken Emulator';

  @override
  String get version => 'Version';

  @override
  String get appDescription =>
      'Ein moderner plattformübergreifender Emulator-Frontend, gebaut mit Flutter.';

  @override
  String get emulators => 'Emulatoren';

  @override
  String get ready => 'Bereit';

  @override
  String get back => 'Zurück';

  @override
  String get select => 'Auswählen';

  @override
  String get search => 'Suchen';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get loading => 'Laden...';

  @override
  String get error => 'Fehler';

  @override
  String get initializationError => 'Initialisierungsfehler';

  @override
  String get retry => 'Wiederholen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get ok => 'OK';

  @override
  String get save => 'Speichern';

  @override
  String get delete => 'Löschen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get close => 'Schließen';

  @override
  String get noRomsFound => 'Keine ROMs gefunden';

  @override
  String get noPlatformsFound => 'Keine Plattformen gefunden';

  @override
  String get checkRomsPath => 'Überprüfen Sie die ROMS_PATH Umgebungsvariable';

  @override
  String get downloading => 'Herunterladen...';

  @override
  String get downloadComplete => 'Download abgeschlossen';

  @override
  String get downloadFailed => 'Download fehlgeschlagen';

  @override
  String get emulatorNotFound => 'Emulator nicht gefunden';

  @override
  String get romNotFound => 'ROM nicht gefunden';

  @override
  String get biosRequired => 'BIOS erforderlich';

  @override
  String get systemCheck => 'Systemprüfung';

  @override
  String get language => 'Sprache';

  @override
  String get theme => 'Design';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String get help => 'Hilfe';

  @override
  String get keyboardAndGamepadControls => 'Tastatur- & Gamepad-Steuerung';

  @override
  String get navigation => 'Navigation';

  @override
  String get actions => 'Aktionen';

  @override
  String get viewControls => 'Ansichtssteuerung';

  @override
  String get gotIt => 'Verstanden!';

  @override
  String get exit => 'Beenden';

  @override
  String get exitApplication => 'Anwendung beenden';

  @override
  String get exitConfirm => 'Sind Sie sicher, dass Sie beenden möchten?';

  @override
  String get downloadManager => 'Download-Manager';

  @override
  String get clearCompleted => 'Abgeschlossene löschen';

  @override
  String get selectCategory => 'Kategorie auswählen';

  @override
  String get confirmDownload => 'Download bestätigen';

  @override
  String get downloadGameLists => 'Spielelisten herunterladen';

  @override
  String get downloadGameListsDescription =>
      'Dies wird ROM-Listen von GitHub herunterladen.';

  @override
  String get gameListsDownloaded => 'Spielelisten heruntergeladen!';

  @override
  String get romStorageManagement => 'ROM-Speicherverwaltung';

  @override
  String get deleteRom => 'ROM löschen?';

  @override
  String deleteRomConfirm(String fileName) {
    return '$fileName löschen?';
  }

  @override
  String get actionCannotBeUndone =>
      'Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String deleted(String fileName) {
    return 'Gelöscht: $fileName';
  }

  @override
  String get savePermanently => 'Dauerhaft speichern?';

  @override
  String moveRomConfirm(String fileName) {
    return '$fileName in den dauerhaften Speicher verschieben?';
  }

  @override
  String saved(String fileName) {
    return 'Gespeichert: $fileName';
  }

  @override
  String get clearAll => 'Alle löschen?';

  @override
  String get clearAllConfirm => 'Alle temporären ROMs löschen?';

  @override
  String get allCleared => 'Alle temporären ROMs gelöscht';

  @override
  String get systemPathsConfiguration => 'Systempfad-Konfiguration';

  @override
  String get migrateRoms => 'ROMs migrieren?';

  @override
  String get migrateRomsDescription =>
      'Der permanente ROM-Speicherpfad hat sich von \$oldPath zu \$newPath geändert. Möchten Sie vorhandene ROMs an den neuen Speicherort migrieren?';

  @override
  String get noKeepThem => 'Nein, behalten';

  @override
  String get yesMigrateRoms => 'Ja, ROMs migrieren';

  @override
  String get migratingRoms => 'ROMs werden migriert...';

  @override
  String get romMigrationFailed => 'Warnung: ROM-Migration fehlgeschlagen';

  @override
  String get pathsSaved => 'Pfade erfolgreich gespeichert';

  @override
  String get errorSavingPaths => 'Fehler beim Speichern der Pfade:';

  @override
  String get resetConfiguration => 'Konfiguration zurücksetzen';

  @override
  String get resetConfigDescription =>
      'Dies setzt alle Pfade auf ihre Standardwerte zurück. Ihre ROMs und Mediendateien werden nicht beeinträchtigt.';

  @override
  String get configurationReset =>
      'Konfiguration auf Standardwerte zurückgesetzt';

  @override
  String get errorResettingConfiguration =>
      'Fehler beim Zurücksetzen der Konfiguration:';

  @override
  String get savePaths => 'Pfade speichern';

  @override
  String get saving => 'Speichern...';

  @override
  String get emulatorManagement => 'Emulatorverwaltung';

  @override
  String get configurationReloaded => 'Konfiguration neu geladen';

  @override
  String get errorLoadingEmulators => 'Fehler beim Laden der Emulatoren:';

  @override
  String get emulatorAdded => 'Emulator erfolgreich hinzugefügt';

  @override
  String get errorAddingEmulator => 'Fehler beim Hinzufügen des Emulators:';

  @override
  String get emulatorUpdated => 'Emulator erfolgreich aktualisiert';

  @override
  String get errorUpdatingEmulator =>
      'Fehler beim Aktualisieren des Emulators:';

  @override
  String get deleteEmulator => 'Emulator löschen';

  @override
  String get emulatorDeleted => 'Emulator gelöscht';

  @override
  String get errorDeletingEmulator => 'Fehler beim Löschen des Emulators:';

  @override
  String get configurationSource => 'Konfigurationsquelle';

  @override
  String get addEmulator => 'Emulator hinzufügen';

  @override
  String get systemNameRequired => 'Systemname ist erforderlich';

  @override
  String get commandRequired => 'Mindestens ein Befehl ist erforderlich';

  @override
  String get addCommand => 'Befehl hinzufügen';

  @override
  String get acceptZipFiles => 'ZIP-Dateien akzeptieren';

  @override
  String get acceptZipSubtitle => 'Starten von ROMs aus ZIP-Archiven erlauben';

  @override
  String get useForeverMode => 'Forever-Modus verwenden';

  @override
  String get useForeverSubtitle => 'Emulator weiterlaufen lassen';

  @override
  String get workInProgress => 'Arbeit in Arbeit';

  @override
  String get wipSubtitle => 'Als noch nicht vollständig konfiguriert markieren';

  @override
  String get biosFirmwareHelp => 'BIOS- & Firmware-Hilfe';

  @override
  String get downloadMissingFiles => 'Fehlende Dateien herunterladen';

  @override
  String get showOnlyMissing => 'Nur fehlende anzeigen';

  @override
  String get downloadAllMissingBios => 'Alle fehlenden BIOS herunterladen';

  @override
  String get configurationError => 'Konfigurationsfehler';

  @override
  String get configurationErrorDescription =>
      'Die Anwendung konnte die erforderliche Konfiguration nicht finden.\nBitte konfigurieren Sie Ihre Pfade in Einstellungen > Systempfade.';

  @override
  String get configurationRequired =>
      'Erforderlich:\n- Medienpfad: Verzeichnis mit Medien-Assets\n- Emulatorenpfad: Verzeichnis mit Emulator-Binärdateien\n\nOptional:\n- ROM-Speicherpfade für temporäre/permanente Downloads';

  @override
  String get goToSettingsToConfigure =>
      'Gehen Sie zu Einstellungen > Systempfade zum Konfigurieren';

  @override
  String get noDownloadableBios => 'Keine herunterladbaren BIOS-Dateien fehlen';

  @override
  String get allDownloadsCompleted =>
      'Alle Downloads erfolgreich abgeschlossen!';

  @override
  String get batchDownloadFailed => 'Stapel-Download fehlgeschlagen:';

  @override
  String get download => 'Herunterladen';

  @override
  String get downloadCancelled => 'Download abgebrochen';

  @override
  String get launched => 'Gestartet:';

  @override
  String get failedToSave => 'ROM konnte nicht dauerhaft gespeichert werden';

  @override
  String get failedToSaveRom => 'ROM konnte nicht dauerhaft gespeichert werden';

  @override
  String get errorSaving => 'Fehler beim Speichern der ROM:';

  @override
  String errorSavingRom(String error) {
    return 'Fehler beim Speichern der ROM: $error';
  }

  @override
  String get openFolder => 'Ordner öffnen';

  @override
  String get viewManual => 'Handbuch anzeigen';

  @override
  String get play => 'Spielen';

  @override
  String get goBack => 'Zurückgehen';

  @override
  String get clearSearch => 'Suche löschen';

  @override
  String get iUnderstand => 'Ich verstehe und akzeptiere diese Bedingungen';

  @override
  String get start => 'Starten';

  @override
  String get debugMode => 'Debug-Modus: ';

  @override
  String get toggleDebugMode => 'Debug-Modus umschalten';

  @override
  String get preparingDownload => 'Download vorbereiten...';

  @override
  String get noEmulatorsAvailable =>
      'Keine Emulatoren für diese Kategorie verfügbar';

  @override
  String get failedToLaunch => 'Web-Emulator konnte nicht gestartet werden:';

  @override
  String get platformInfo => 'Plattform-Info';

  @override
  String get emulatorPlatformInfo => 'Emulator-Plattform-Info';

  @override
  String get favorites => 'Favoriten';

  @override
  String get all => 'Alle';

  @override
  String get collections => 'Sammlungen';

  @override
  String get searchRoms => 'ROMs suchen...';

  @override
  String get searchPlatforms => 'Plattformen suchen...';

  @override
  String romsCount(int count) {
    return '$count ROMs';
  }

  @override
  String platformsCount(int count) {
    return '$count Plattformen';
  }

  @override
  String get region => 'Region';

  @override
  String get genre => 'Genre';

  @override
  String get year => 'Jahr';

  @override
  String get publisher => 'Herausgeber';

  @override
  String get developer => 'Entwickler';

  @override
  String get playWithNetplay => 'Mit Netplay spielen';

  @override
  String get downloadBios => 'BIOS herunterladen';

  @override
  String get viewDetails => 'Details anzeigen';

  @override
  String get addToFavorites => 'Zu Favoriten hinzufügen';

  @override
  String get removeFromFavorites => 'Aus Favoriten entfernen';

  @override
  String get biosMissing => 'BIOS fehlt';

  @override
  String get biosPresent => 'BIOS vorhanden';

  @override
  String get checkingBios => 'BIOS wird überprüft...';

  @override
  String get emulatorDownloading => 'Emulator wird heruntergeladen...';

  @override
  String get emulatorDownloadComplete => 'Emulator heruntergeladen';

  @override
  String get emulatorDownloadFailed => 'Emulator-Download fehlgeschlagen';

  @override
  String get installingEmulator => 'Emulator wird installiert...';

  @override
  String get emulatorReady => 'Emulator bereit';

  @override
  String get configuration => 'Konfiguration';

  @override
  String get paths => 'Pfade';

  @override
  String get storage => 'Speicher';

  @override
  String get emulatorsPath => 'Emulatorenpfad';

  @override
  String get romsPath => 'ROMs-Pfad';

  @override
  String get mediaPath => 'Medienpfad';

  @override
  String get biosPath => 'BIOS-Pfad';

  @override
  String get tempPath => 'Temporärer Pfad';

  @override
  String get browse => 'Durchsuchen';

  @override
  String get apply => 'Anwenden';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get clear => 'Löschen';

  @override
  String get scan => 'Scannen';

  @override
  String get scanForRoms => 'Nach ROMs scannen';

  @override
  String get scanningRoms => 'ROMs werden gescannt...';

  @override
  String get scanComplete => 'Scan abgeschlossen';

  @override
  String romsFound(int count) {
    return '$count ROMs gefunden';
  }

  @override
  String get noNewRomsFound => 'Keine neuen ROMs gefunden';

  @override
  String get launchEmulator => 'Emulator starten';

  @override
  String get emulatorError => 'Emulatorfehler';

  @override
  String get gamepadConnected => 'Gamepad verbunden';

  @override
  String get gamepadDisconnected => 'Gamepad getrennt';

  @override
  String get gamepadTest => 'Gamepad testen';

  @override
  String get pressAnyButton => 'Drücken Sie eine beliebige Taste zum Testen';

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
  String get dpadUp => 'D-Pad Hoch';

  @override
  String get dpadDown => 'D-Pad Runter';

  @override
  String get dpadLeft => 'D-Pad Links';

  @override
  String get dpadRight => 'D-Pad Rechts';

  @override
  String get leftShoulder => 'L1';

  @override
  String get rightShoulder => 'R1';

  @override
  String get leftTrigger => 'L2';

  @override
  String get rightTrigger => 'R2';

  @override
  String get leftStick => 'Linker Stick';

  @override
  String get rightStick => 'Rechter Stick';

  @override
  String get setupWizard => 'Einrichtungsassistent';

  @override
  String get welcome => 'Willkommen';

  @override
  String get welcomeMessage => 'Willkommen bei Forsaken Emulator';

  @override
  String get next => 'Weiter';

  @override
  String get previous => 'Zurück';

  @override
  String get finish => 'Fertig';

  @override
  String get skip => 'Überspringen';

  @override
  String get setupComplete => 'Einrichtung abgeschlossen';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get selectEmulatorsPath => 'Emulatorenpfad auswählen';

  @override
  String get selectRomsPath => 'ROMs-Pfad auswählen';

  @override
  String get selectMediaPath => 'Medienpfad auswählen';

  @override
  String get allSettingsConfigured => 'Alle Einstellungen konfiguriert';

  @override
  String get darkTheme => 'Dunkel';

  @override
  String get lightTheme => 'Hell';

  @override
  String get systemTheme => 'System';

  @override
  String get about => 'Über';

  @override
  String get checkForUpdates => 'Nach Updates suchen';

  @override
  String get noUpdatesAvailable => 'Keine Updates verfügbar';

  @override
  String get updateAvailable => 'Update verfügbar';

  @override
  String get downloadingUpdate => 'Update wird heruntergeladen...';

  @override
  String get installingUpdate => 'Update wird installiert...';

  @override
  String get updateComplete => 'Update abgeschlossen';

  @override
  String get updateFailed => 'Update fehlgeschlagen';

  @override
  String get networkError => 'Netzwerkfehler';

  @override
  String get connectionError => 'Verbindungsfehler';

  @override
  String get timeoutError => 'Zeitüberschreitung';

  @override
  String get unknownError => 'Unbekannter Fehler';

  @override
  String get permissionDenied => 'Berechtigung verweigert';

  @override
  String get fileNotFound => 'Datei nicht gefunden';

  @override
  String get directoryNotFound => 'Verzeichnis nicht gefunden';

  @override
  String get diskFull => 'Festplatte voll';

  @override
  String get invalidPath => 'Ungültiger Pfad';

  @override
  String get pathNotWritable => 'Pfad nicht beschreibbar';

  @override
  String get romCorrupted => 'ROM-Datei könnte beschädigt sein';

  @override
  String get zipError => 'ZIP-Archiv-Fehler';

  @override
  String get extractionFailed => 'Extraktion fehlgeschlagen';

  @override
  String get checksumMismatch => 'Prüfsummenabgleich fehlgeschlagen';

  @override
  String get biosCheckFailed => 'BIOS-Prüfung fehlgeschlagen';

  @override
  String get continueAnyway => 'Trotzdem fortfahren';

  @override
  String get reportIssue => 'Problem melden';

  @override
  String get copyToClipboard => 'In Zwischenablage kopieren';

  @override
  String get copiedToClipboard => 'In Zwischenablage kopiert';

  @override
  String get share => 'Teilen';

  @override
  String get hide => 'Ausblenden';

  @override
  String get show => 'Anzeigen';

  @override
  String get toggleView => 'Ansicht umschalten';

  @override
  String get gridView => 'Rasteransicht';

  @override
  String get listView => 'Listenansicht';

  @override
  String get carouselView => 'Karussellansicht';

  @override
  String get sortBy => 'Sortieren nach';

  @override
  String get sortByName => 'Name';

  @override
  String get sortByDate => 'Datum';

  @override
  String get sortBySize => 'Größe';

  @override
  String get sortByRegion => 'Region';

  @override
  String get ascending => 'Aufsteigend';

  @override
  String get descending => 'Absteigend';

  @override
  String get filter => 'Filtern';

  @override
  String get filterByRegion => 'Nach Region filtern';

  @override
  String get filterByGenre => 'Nach Genre filtern';

  @override
  String get filterByYear => 'Nach Jahr filtern';

  @override
  String get clearFilters => 'Filter löschen';

  @override
  String get systemInfo => 'Systeminfo';

  @override
  String get cpu => 'CPU';

  @override
  String get memory => 'Speicher';

  @override
  String get storageInfo => 'Speicher';

  @override
  String get os => 'Betriebssystem';

  @override
  String get emulatorVersion => 'Emulator-Version';

  @override
  String get totalRoms => 'Gesamt ROMs';

  @override
  String get totalSize => 'Gesamtgröße';

  @override
  String get freeSpace => 'Freier Speicher';

  @override
  String get usedSpace => 'Belegter Speicher';

  @override
  String get systemUtilities => 'Systemwerkzeuge';

  @override
  String get romVerificationResults => 'ROM-Verifizierungsergebnisse';

  @override
  String get totalRomFiles => 'ROM-Dateien gesamt';

  @override
  String get emptyRomFiles => 'Leere ROM-Dateien';

  @override
  String get validRomFiles => 'Gültige ROM-Dateien';

  @override
  String get romsDirectoryDoesNotExist => 'ROM-Verzeichnis existiert nicht';

  @override
  String get gamelistCheckResults => 'Gamelist-Prüfergebnisse';

  @override
  String get totalPlatforms => 'Plattformen gesamt';

  @override
  String get missingGamelists => 'Fehlende Gamelists';

  @override
  String get configurationBackup => 'Konfigurations-Backup';

  @override
  String get configurationBackedUp => 'Konfiguration gesichert unter:';

  @override
  String get errorBackingUp => 'Fehler beim Sichern der Konfiguration:';

  @override
  String get romDatabase => 'ROM-Datenbank';

  @override
  String get romDatabaseDownloaded =>
      'ROM-Datenbank erfolgreich heruntergeladen';

  @override
  String get failedDownloadRomDatabase =>
      'ROM-Datenbank-Download fehlgeschlagen';

  @override
  String get romDatabaseCleared => 'ROM-Datenbank gelöscht';

  @override
  String get failedClearDatabase => 'Datenbank-Löschung fehlgeschlagen';

  @override
  String get downloadRomDatabase => 'ROM-Datenbank herunterladen';

  @override
  String get clearRomDatabase => 'ROM-Datenbank löschen';

  @override
  String get systemRequirements => 'Systemanforderungen';

  @override
  String get failedToCheckSystem => 'Systemprüfung fehlgeschlagen';

  @override
  String cleanedUpTempFiles(String deletedCount) {
    return '$deletedCount temporäre ROM-Dateien bereinigt';
  }

  @override
  String get errorCleaningTempFiles =>
      'Fehler beim Bereinigen temporärer Dateien:';

  @override
  String get errorVerifyingRomFiles =>
      'Fehler beim Verifizieren der ROM-Dateien:';

  @override
  String get errorCheckingGamelists => 'Fehler beim Prüfen der Gamelists:';

  @override
  String get cancelDownload => 'Download abbrechen';

  @override
  String get selectEmulator => 'Emulator auswählen';

  @override
  String get biosStatusDashboard => 'BIOS-Status-Dashboard';

  @override
  String get webSettings => 'Web-Einstellungen';

  @override
  String get saveSettings => 'Einstellungen speichern';

  @override
  String get errorSavingSettings => 'Fehler beim Speichern der Einstellungen:';

  @override
  String romsCountItems(String count) {
    return '$count ROMs';
  }

  @override
  String get savedPermanently => 'dauerhaft gespeichert';

  @override
  String get keptInTemporary => 'im temporären Speicher behalten';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get allDownloads => 'Alle Downloads abgeschlossen';

  @override
  String romSavedPermanently(String name) {
    return '$name dauerhaft gespeichert';
  }

  @override
  String get undo => 'Rückgängig';

  @override
  String romKeptInTemporary(String name) {
    return '$name im temporären Speicher behalten';
  }

  @override
  String romsCountWithSize(String count, String size) {
    return '$count ROMs • $size';
  }

  @override
  String get whatYouCanTry => 'Was Sie versuchen können:';

  @override
  String get tips => 'Tipps';

  @override
  String get helpNavigateItems => 'Durch Elemente navigieren';

  @override
  String get helpGamepadNavigation => 'Gamepad-Navigation';

  @override
  String get helpQuickNavigation =>
      'Schnellnavigation (mehrere Elemente überspringen)';

  @override
  String get helpGamepadPageNavigation => 'Gamepad-Seitennavigation';

  @override
  String get helpGoToFirst => 'Zum ersten Element gehen';

  @override
  String get helpGoToLast => 'Zum letzten Element gehen';

  @override
  String get helpJumpToLetter =>
      'Zum Element springen, das mit diesem Buchstaben beginnt';

  @override
  String get helpSelectItem => 'Element auswählen';

  @override
  String get helpGamepadSelect => 'Gamepad-Auswahl';

  @override
  String get helpGoBackCloseDialogs => 'Zurück / Dialoge schließen';

  @override
  String get helpExitApplication => 'Anwendung beenden';

  @override
  String get helpGamepadBackClose => 'Gamepad Zurück / Dialoge schließen';

  @override
  String get helpToggleViewMode =>
      'Ansichtsmodus umschalten (Raster/Liste/Karussell)';

  @override
  String get helpGamepadViewToggle => 'Ansicht mit Gamepad umschalten';

  @override
  String get helpRefreshView => 'Aktuelle Ansicht aktualisieren';

  @override
  String get helpShowPlatformInfo => 'Plattforminformationen anzeigen';

  @override
  String get helpActivateSearch => 'Suche aktivieren';

  @override
  String get helpGamepadSearch => 'Gamepad-Suche';

  @override
  String get helpShowHelpDialog => 'Dieses Hilpedialog anzeigen';

  @override
  String get helpGamepadHelp => 'Gamepad-Hilfe';

  @override
  String get tipUseKeyboardOrGamepad =>
      'Verwenden Sie Tastatur oder Gamepad zur Navigation';

  @override
  String get tipAlphabeticalJump =>
      'Alphabetischer Sprung funktioniert in allen Ansichtsmodi';

  @override
  String get tipPressQuestionMark => 'Drücken Sie ? jederzeit für diese Hilfe';

  @override
  String get tipGamepadAlongside =>
      'Gamepad funktioniert zusammen mit Tastatursteuerung';

  @override
  String get configurePathsDescription =>
      'Konfigurieren Sie die Pfade, die die Anwendung verwendet, um ROMs, Medien und Emulatoren zu finden.';

  @override
  String get romListsAutoManaged =>
      'ROM-Listen werden jetzt automatisch verwaltet. Laden Sie sie von Einstellungen > ROM-Datenbank herunter.';

  @override
  String get romStorage => 'ROM-Speicher';

  @override
  String get configureRomStorageDescription =>
      'Konfigurieren Sie, wo heruntergeladene ROMs temporär und dauerhaft gespeichert werden.';

  @override
  String get resetToDefaults => 'Auf Standard zurücksetzen';

  @override
  String get mediaPathLabel => 'Medienpfad';

  @override
  String get mediaPathHint => 'Verzeichnis mit Medien (Bilder, Videos)';

  @override
  String get emulatorsPathLabel => 'Emulatorenpfad';

  @override
  String get emulatorsPathHint => 'Verzeichnis mit Emulator-Binärdateien';

  @override
  String get gamelistPathAutomatic => 'Gamelist-Pfad (Automatisch)';

  @override
  String get gamelistAutoDescription =>
      'Gamelists werden jetzt automatisch im App-Datenverzeichnis verwaltet. Dies macht die App vollständig unabhängig und bereitet die zukünftige GitHub-basierte Gamelist-Verteilung vor.';

  @override
  String get tempRomStorageLabel => 'Temporärer ROM-Speicher (Optional)';

  @override
  String get tempRomStorageDescription =>
      'ROMs werden zuerst hier heruntergeladen. Sie können nach dem Spielen in den dauerhaften Speicher befördert werden.';

  @override
  String get permanentRomStorageLabel => 'Permanenter ROM-Speicher (Optional)';

  @override
  String get permanentRomStorageDescription =>
      'Dauerhaft gespeicherte ROMs werden hier gespeichert. Diese werden nicht automatisch bereinigt.';

  @override
  String get defaultAppSupportDir => 'Standard: App-Support-Verzeichnis';

  @override
  String currentPathDisplay(String path) {
    return 'Aktuell: $path';
  }

  @override
  String get configurationFile => 'Konfigurationsdatei';

  @override
  String get source => 'Quelle:';

  @override
  String get customConfigActive => 'Benutzerdefinierte Konfiguration aktiv';

  @override
  String get pathStructure => 'Pfadstruktur';

  @override
  String get pathStructureDescription =>
      'Medienpfad: MEDIA_PATH/plattform/boxart|screenshots|videos/rom.png\nGamelist-Pfad: ~/.local/share/com.example.emulator/gamelists/plattform/gamelist.xml (automatisch)\nEmulatorenpfad: EMULATORS_PATH/emulator_binary';

  @override
  String get errorCheckingSystem => 'Fehler bei der Systemprüfung';

  @override
  String get recheckR => 'Erneut prüfen (R)';

  @override
  String get allRequiredToolsInstalled =>
      'Alle erforderlichen Werkzeuge installiert';

  @override
  String get missingRequiredTools => 'Erforderliche Werkzeuge fehlen';

  @override
  String get systemReadyToUse =>
      'Ihr System ist bereit, den Emulator zu verwenden';

  @override
  String get someRequiredToolsMissing =>
      'Einige erforderliche Werkzeuge fehlen';

  @override
  String get requiredTools => 'Erforderliche Werkzeuge';

  @override
  String get requiredToolsDescription =>
      'Diese Werkzeuge sind erforderlich zum Herunterladen und Extrahieren von Emulatoren';

  @override
  String get installationInstructions => 'Installationsanleitung';

  @override
  String get installed => 'Installiert';

  @override
  String get missing => 'Fehlt';

  @override
  String get downloadEmulatorsAndGameLists =>
      'Emulatoren und Spielelisten herunterladen';

  @override
  String get quickActions => 'Schnellaktionen';

  @override
  String get downloadAll => 'Alle herunterladen';

  @override
  String get byCategory => 'Nach Kategorie';

  @override
  String get downloadQueue => 'Download-Warteschlange';

  @override
  String get noDownloadsInProgress => 'Keine Downloads in Bearbeitung';

  @override
  String get selectQuickActionToStart =>
      'Wählen Sie eine Schnellaktion oben, um mit dem Herunterladen zu beginnen';

  @override
  String get categorySony => 'Sony (PS1-PS4)';

  @override
  String get categoryNintendo => 'Nintendo (GC, Wii, Switch)';

  @override
  String get categoryMicrosoft => 'Microsoft (Xbox, Xbox 360)';

  @override
  String get categoryMultiPlatform => 'Multi-Plattform (RetroArch)';

  @override
  String get categoryOtherEmulators => 'Andere Emulatoren';

  @override
  String get categoryUtilities => 'Werkzeuge';

  @override
  String confirmDownloadDescription(String count, String size) {
    return '$count Emulator(en) herunterladen?\nGeschätzte Größe: ~$size MB\n\nDies kann je nach Ihrer Internetverbindung eine Weile dauern.';
  }

  @override
  String get alreadyInstalled => 'Bereits installiert';

  @override
  String get starting => 'Starten...';

  @override
  String get completed => 'Abgeschlossen';

  @override
  String get gameListsAlreadyDownloaded =>
      'Spielelisten bereits heruntergeladen';

  @override
  String get redownload => 'Erneut herunterladen';

  @override
  String get gameListsFromGitHub => 'Spielelisten (von GitHub)';

  @override
  String get downloaded => 'Heruntergeladen';

  @override
  String get cancelled => 'Abgebrochen';

  @override
  String get missingFor => 'Fehlt für:';

  @override
  String get noCustomConfigToBackup =>
      'Keine benutzerdefinierte Konfiguration zu sichern. Verwende Standardwerte.';

  @override
  String get saveConfigurationBackup => 'Konfigurations-Backup speichern';

  @override
  String get refreshStatsR => 'Statistiken aktualisieren (R)';

  @override
  String get systemStatistics => 'Systemstatistiken';

  @override
  String get romFiles => 'ROM-Dateien';

  @override
  String get maintenanceTools => 'Wartungswerkzeuge';

  @override
  String get cleanupTemporaryRoms => 'Temporäre ROMs bereinigen';

  @override
  String get cleanupTemporaryRomsDescription =>
      'Temporäre ROM-Dateien aus dem System-Temp-Verzeichnis entfernen';

  @override
  String get verifyRomFiles => 'ROM-Dateien verifizieren';

  @override
  String get verifyRomFilesDescription =>
      'Prüfen, dass alle ROM-Dateien existieren und gültig sind';

  @override
  String get checkMissingGamelists => 'Fehlende Gamelists prüfen';

  @override
  String get checkMissingGamelistsDescription =>
      'Plattformen ohne gamelist.xml-Datei finden';

  @override
  String get backupConfiguration => 'Konfiguration sichern';

  @override
  String get backupConfigurationDescription =>
      'Eine Sicherung von config.json erstellen';

  @override
  String get downloadingRomDatabase => 'ROM-Datenbank wird heruntergeladen...';

  @override
  String get downloadMayTakeMinutes =>
      'Dies kann je nach Ihrer Verbindung einige Minuten dauern...';

  @override
  String get databaseStatus => 'Datenbankstatus';

  @override
  String get notDownloaded => 'Nicht heruntergeladen';

  @override
  String get aboutRomDatabase => 'Über ROM-Datenbank';

  @override
  String get aboutRomDatabaseDescription =>
      'Die ROM-Datenbank enthält Listen verfügbarer ROMs, organisiert nach Plattform. Sie wird aus dem Forsaken romList-Repository auf GitHub heruntergeladen.';

  @override
  String get romDatabaseSource => 'Quelle: github.com/ForsakenStation/romList';

  @override
  String get downloadRomDatabaseDescription =>
      'Dies wird ROM-Listen aus dem Forsaken romList-Repository auf GitHub herunterladen.';

  @override
  String get downloadRomDatabaseStats =>
      'Größe: ~7 MB\nPlattformen: 138\nGesamt ROMs: ~240.000';

  @override
  String get downloadWillOverwrite =>
      'Hinweis: Dies überschreibt vorhandene Daten.';

  @override
  String get clearRomDatabaseDescription =>
      'Dies löscht alle heruntergeladenen ROM-Listen und setzt die Datenbank auf ihren ursprünglichen Zustand zurück.';

  @override
  String get gamelistsStatus => 'Gamelists-Status';

  @override
  String get gamelistsDownloaded => 'Heruntergeladen';

  @override
  String get gamelistsNotDownloaded => 'Nicht heruntergeladen';

  @override
  String get aboutGamelists => 'Über Gamelists';

  @override
  String get aboutGamelistsDescription =>
      'Gamelists enthalten Spiele-Metadaten (Namen, Beschreibungen, Bewertungen) für jede Plattform. Sie werden aus dem Forsaken gamelists-Repository auf GitHub heruntergeladen.';

  @override
  String get gamelistsSource => 'Quelle: github.com/ForsakenStation/gamelists';

  @override
  String get downloadGamelists => 'Gamelists herunterladen';

  @override
  String get downloadGamelistsDescription =>
      'Dies wird gamelist.xml-Dateien aus dem Forsaken gamelists-Repository auf GitHub herunterladen.';

  @override
  String get downloadGamelistsWillOverwrite =>
      'Hinweis: Dies überschreitet vorhandene Gamelist-Dateien.';

  @override
  String get downloadingGamelists => 'Gamelists werden heruntergeladen...';

  @override
  String get gamelistsDownloadedSuccess =>
      'Gamelists erfolgreich heruntergeladen';

  @override
  String get failedDownloadGamelists => 'Gamelists-Download fehlgeschlagen';

  @override
  String get clearGamelists => 'Gamelists löschen';

  @override
  String get clearGamelistsDescription =>
      'Dies löscht alle heruntergeladenen Gamelist-Dateien.';

  @override
  String get gamelistsCleared => 'Gamelists gelöscht';

  @override
  String get failedClearGamelists => 'Gamelists-Löschung fehlgeschlagen';

  @override
  String get rebuildMediaCache => 'Medien-Cache neu erstellen';

  @override
  String get rebuildMediaCacheDescription =>
      'Medienverzeichnisse scannen und Pfade in Gamelists zwischenspeichern für schnelleres Laden';

  @override
  String get rebuildMediaCacheConfirmTitle => 'Medien-Cache neu erstellen?';

  @override
  String get rebuildMediaCacheConfirmBody =>
      'Dies scannt alle Medienverzeichnisse und aktualisiert gamelist.xml-Dateien mit Medienpfaden. Dies kann bei großen Sammlungen eine Weile dauern.';

  @override
  String get rebuildMediaCacheProgress => 'Medien-Cache wird neu erstellt...';

  @override
  String rebuildMediaCacheProcessingPlatform(
    String platform,
    String current,
    String total,
  ) {
    return 'Verarbeite $platform ($current/$total)';
  }

  @override
  String get rebuildMediaCacheComplete => 'Medien-Cache neu erstellt';

  @override
  String rebuildMediaCacheSummary(
    String platforms,
    String games,
    String updated,
    String paths,
  ) {
    return '$platforms Plattformen, $games Spiele gescannt, $updated aktualisiert, $paths Medienpfade zwischengespeichert';
  }

  @override
  String get rebuildMediaCacheError =>
      'Medien-Cache konnte nicht neu erstellt werden';

  @override
  String rebuildMediaCacheErrors(String count) {
    return '$count Fehler während der Neu-Erstellung aufgetreten';
  }

  @override
  String get description => 'Beschreibung';

  @override
  String get noDescriptionAvailable =>
      'Keine Beschreibung für dieses ROM verfügbar.';

  @override
  String get releaseDate => 'Veröffentlichungsdatum';

  @override
  String get players => 'Spieler';

  @override
  String get rating => 'Bewertung';

  @override
  String get regions => 'Regionen';

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
    return '$name - Handbuch';
  }

  @override
  String get playInBrowser => 'Im Browser spielen';

  @override
  String downloadingPlatformBios(String platformName) {
    return '$platformName-BIOS wird heruntergeladen';
  }

  @override
  String get downloadingAllMissingBios => 'Alle fehlenden BIOS herunterladen';

  @override
  String biosFileLabel(String filename) {
    return 'Datei: $filename';
  }

  @override
  String batchProgressLabel(String completed, String total) {
    return 'Fortschritt: $completed/$total Dateien';
  }

  @override
  String get fileDetails => 'Dateidetails:';

  @override
  String get waiting => 'Warten...';

  @override
  String get verifying => 'Überprüfen...';

  @override
  String get failed => 'Fehlgeschlagen';

  @override
  String get preparing => 'Vorbereiten...';

  @override
  String get downloadingFiles => 'Dateien werden heruntergeladen...';

  @override
  String get someDownloadsFailed => 'Einige Downloads sind fehlgeschlagen';

  @override
  String get downloadsCancelled => 'Downloads abgebrochen';

  @override
  String get calculating => 'Berechne...';

  @override
  String secondsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sekunden',
      one: '1 Sekunde',
    );
    return '$_temp0';
  }

  @override
  String minutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Minuten',
      one: '1 Minute',
    );
    return '$_temp0';
  }

  @override
  String hoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Stunden',
      one: '1 Stunde',
    );
    return '$_temp0';
  }

  @override
  String get downloadingAndLaunching => 'Herunterladen & Starten...';

  @override
  String get launching => 'Starten...';

  @override
  String emulatorLabel(String name) {
    return 'Emulator: $name';
  }

  @override
  String get generalInformation => 'Allgemeine Informationen';

  @override
  String get manufacturer => 'Hersteller';

  @override
  String get releaseYear => 'Erscheinungsjahr';

  @override
  String get generation => 'Generation';

  @override
  String get technicalSpecifications => 'Technische Spezifikationen';

  @override
  String get resolution => 'Auflösung';

  @override
  String get colors => 'Farben';

  @override
  String get notNow => 'Nicht jetzt';

  @override
  String get saveRomPermanently => 'ROM dauerhaft speichern?';

  @override
  String get keepRomOfflineQuestion =>
      'Möchtest du dieses ROM heruntergeladen behalten, um offline zu spielen?';

  @override
  String get deletedToSaveSpace =>
      'Andernfalls wird es später gelöscht, um Speicherplatz zu sparen.';
}
