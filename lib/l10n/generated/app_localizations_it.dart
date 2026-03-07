// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Forsaken Emulator';

  @override
  String get retroGamingFrontend => 'Frontend di Gioco Retro';

  @override
  String get platforms => 'Piattaforme';

  @override
  String get roms => 'ROM';

  @override
  String get settings => 'Impostazioni';

  @override
  String get settingsAndConfiguration => 'Impostazioni e Configurazione';

  @override
  String get aboutForsakenEmulator => 'Info su Forsaken Emulator';

  @override
  String get version => 'Versione';

  @override
  String get appDescription =>
      'Un moderno frontend emulator multi-piattaforma costruito con Flutter.';

  @override
  String get emulators => 'Emulatori';

  @override
  String get ready => 'Pronto';

  @override
  String get back => 'Indietro';

  @override
  String get select => 'Seleziona';

  @override
  String get search => 'Cerca';

  @override
  String get refresh => 'Aggiorna';

  @override
  String get loading => 'Caricamento...';

  @override
  String get error => 'Errore';

  @override
  String get initializationError => 'Errore di Inizializzazione';

  @override
  String get retry => 'Riprova';

  @override
  String get cancel => 'Annulla';

  @override
  String get ok => 'OK';

  @override
  String get save => 'Salva';

  @override
  String get delete => 'Elimina';

  @override
  String get confirm => 'Conferma';

  @override
  String get yes => 'Sì';

  @override
  String get no => 'No';

  @override
  String get close => 'Chiudi';

  @override
  String get noRomsFound => 'No ROMs found';

  @override
  String get noPlatformsFound => 'Nessuna piattaforma trovata';

  @override
  String get checkRomsPath => 'Controlla la variabile d\'ambiente ROMS_PATH';

  @override
  String get downloading => 'Download in corso...';

  @override
  String get downloadComplete => 'Download completato';

  @override
  String get downloadFailed => 'Download fallito';

  @override
  String get emulatorNotFound => 'Emulatore non trovato';

  @override
  String get romNotFound => 'ROM non trovata';

  @override
  String get biosRequired => 'OBBLIGATORIO';

  @override
  String get systemCheck => 'Controllo Sistema';

  @override
  String get language => 'Lingua';

  @override
  String get theme => 'Tema';

  @override
  String get systemDefault => 'Predefinito del sistema';

  @override
  String get help => 'Aiuto';

  @override
  String get keyboardAndGamepadControls => 'Controlli Tastiera e Gamepad';

  @override
  String get navigation => 'Navigazione';

  @override
  String get actions => 'Azioni';

  @override
  String get viewControls => 'Controlli Vista';

  @override
  String get gotIt => 'Capito!';

  @override
  String get exit => 'Esci';

  @override
  String get exitApplication => 'Esci dall\'Applicazione';

  @override
  String get exitConfirm => 'Sei sicuro di voler uscire?';

  @override
  String get downloadManager => 'Gestore Download';

  @override
  String get clearCompleted => 'Copia Completati';

  @override
  String get selectCategory => 'Seleziona Categoria';

  @override
  String get confirmDownload => 'Conferma Download';

  @override
  String get downloadGameLists => 'Scarica Liste Giochi';

  @override
  String get downloadGameListsDescription =>
      'Questo scaricherà le liste ROM da GitHub.';

  @override
  String get gameListsDownloaded => 'Liste giochi scaricate!';

  @override
  String get romStorageManagement => 'Gestione Archiviazione ROM';

  @override
  String get deleteRom => 'Elimina ROM?';

  @override
  String deleteRomConfirm(String fileName) {
    return 'Eliminare $fileName?';
  }

  @override
  String get actionCannotBeUndone => 'Questa azione non può essere annullata.';

  @override
  String deleted(String fileName) {
    return 'Eliminato: $fileName';
  }

  @override
  String get savePermanently => 'Salva Permanentemente?';

  @override
  String moveRomConfirm(String fileName) {
    return 'Spostare $fileName nell\'archiviazione permanente?';
  }

  @override
  String saved(String fileName) {
    return 'Salvato: $fileName';
  }

  @override
  String get clearAll => 'Cancella Tutto?';

  @override
  String get clearAllConfirm => 'Eliminare tutte le ROM temporanee?';

  @override
  String get allCleared => 'Tutte le ROM temporanee cancellate';

  @override
  String get systemPathsConfiguration => 'Configurazione Percorsi Sistema';

  @override
  String get migrateRoms => 'Migra ROM?';

  @override
  String get migrateRomsDescription =>
      'Il percorso di archiviazione permanente delle ROM è cambiato da \$oldPath a \$newPath. Vuoi migrare le ROM esistenti nella nuova posizione?';

  @override
  String get noKeepThem => 'No, conservale';

  @override
  String get yesMigrateRoms => 'Sì, migra ROM';

  @override
  String get migratingRoms => 'Migrazione ROM...';

  @override
  String get romMigrationFailed => 'Avviso: Migrazione ROM fallita';

  @override
  String get pathsSaved => 'Percorsi salvati con successo';

  @override
  String get errorSavingPaths => 'Errore nel salvataggio dei percorsi:';

  @override
  String get resetConfiguration => 'Reimposta Configurazione';

  @override
  String get resetConfigDescription =>
      'Questo reimposterà tutti i percorsi ai valori predefiniti. Le ROM ei file multimediali non saranno interessati.';

  @override
  String get configurationReset =>
      'Configurazione reimpostata ai valori predefiniti';

  @override
  String get errorResettingConfiguration =>
      'Errore nel reimpostare la configurazione:';

  @override
  String get savePaths => 'Salva Percorsi';

  @override
  String get saving => 'Salvataggio...';

  @override
  String get emulatorManagement => 'Gestione Emulatori';

  @override
  String get configurationReloaded => 'Configurazione ricaricata';

  @override
  String get errorLoadingEmulators => 'Errore nel caricamento degli emulatori:';

  @override
  String get emulatorAdded => 'Emulatore aggiunto con successo';

  @override
  String get errorAddingEmulator => 'Errore nell\'aggiunta dell\'emulatore:';

  @override
  String get emulatorUpdated => 'Emulatore aggiornato con successo';

  @override
  String get errorUpdatingEmulator =>
      'Errore nell\'aggiornamento dell\'emulatore:';

  @override
  String get deleteEmulator => 'Elimina Emulatore';

  @override
  String get emulatorDeleted => 'Emulatore eliminato';

  @override
  String get errorDeletingEmulator =>
      'Errore nell\'eliminazione dell\'emulatore:';

  @override
  String get configurationSource => 'Fonte di Configurazione';

  @override
  String get addEmulator => 'Aggiungi Emulatore';

  @override
  String get systemNameRequired => 'Il nome del sistema è obbligatorio';

  @override
  String get commandRequired => 'È richiesto almeno un comando';

  @override
  String get addCommand => 'Aggiungi Comando';

  @override
  String get acceptZipFiles => 'Accetta file ZIP';

  @override
  String get acceptZipSubtitle => 'Consenti l\'avvio delle ROM da archivi ZIP';

  @override
  String get useForeverMode => 'Usa Modalità Forever';

  @override
  String get useForeverSubtitle => 'Mantieni l\'emulatore in esecuzione';

  @override
  String get workInProgress => 'Lavoro in Corso';

  @override
  String get wipSubtitle => 'Segna come non ancora completamente configurato';

  @override
  String get biosFirmwareHelp => 'Aiuto BIOS e Firmware';

  @override
  String get downloadMissingFiles => 'Scarica File Mancanti';

  @override
  String get showOnlyMissing => 'Mostra solo mancanti';

  @override
  String get downloadAllMissingBios => 'Scarica tutti i BIOS mancanti';

  @override
  String get configurationError => 'Errore di Configurazione';

  @override
  String get configurationErrorDescription =>
      'L\'applicazione non ha trovato la configurazione richiesta.\nPer favore configura i tuoi percorsi in Impostazioni > Percorsi Sistema.';

  @override
  String get configurationRequired =>
      'Richiesto:\n- Percorso Media: directory contenente asset multimediali\n- Percorso Emulatori: directory contenente file binari emulatori\n\nOpzionale:\n- Percorsi archiviazione ROM per download temporanei/permanenti';

  @override
  String get goToSettingsToConfigure =>
      'Vai a Impostazioni > Percorsi Sistema per configurare';

  @override
  String get noDownloadableBios => 'Nessun file BIOS scaricabile mancante';

  @override
  String get allDownloadsCompleted =>
      'Tutti i download completati con successo!';

  @override
  String get batchDownloadFailed => 'Download batch fallito:';

  @override
  String get download => 'Scarica';

  @override
  String get downloadCancelled => 'Download annullato';

  @override
  String get launched => 'Avviato:';

  @override
  String get failedToSave => 'Impossibile salvare la ROM permanentemente';

  @override
  String get failedToSaveRom => 'Impossibile salvare la ROM permanentemente';

  @override
  String get errorSaving => 'Errore nel salvataggio della ROM:';

  @override
  String errorSavingRom(String error) {
    return 'Errore nel salvataggio della ROM: $error';
  }

  @override
  String get openFolder => 'Apri Cartella';

  @override
  String get viewManual => 'Vedi Manuale';

  @override
  String get play => 'Gioca';

  @override
  String get goBack => 'Torna Indietro';

  @override
  String get clearSearch => 'Cancella Ricerca';

  @override
  String get iUnderstand => 'Capisco e accetto questi termini';

  @override
  String get start => 'Inizia';

  @override
  String get debugMode => 'Modalità Debug: ';

  @override
  String get toggleDebugMode => 'Attiva/Disattiva Modalità Debug';

  @override
  String get preparingDownload => 'Preparazione download...';

  @override
  String get noEmulatorsAvailable =>
      'Nessun emulatore disponibile per questa categoria';

  @override
  String get failedToLaunch => 'Impossibile avviare l\'emulatore web:';

  @override
  String get platformInfo => 'Info Piattaforma';

  @override
  String get emulatorPlatformInfo => 'Info Piattaforma Emulatore';

  @override
  String get favorites => 'Preferiti';

  @override
  String get all => 'Tutto';

  @override
  String get collections => 'Collezioni';

  @override
  String get searchRoms => 'Cerca ROM...';

  @override
  String get searchPlatforms => 'Cerca piattaforme...';

  @override
  String romsCount(int count) {
    return '$count ROM';
  }

  @override
  String platformsCount(int count) {
    return '$count piattaforme';
  }

  @override
  String get region => 'Regione';

  @override
  String get genre => 'Genere';

  @override
  String get year => 'Anno';

  @override
  String get publisher => 'Editore';

  @override
  String get developer => 'Sviluppatore';

  @override
  String get playWithNetplay => 'Gioca con Netplay';

  @override
  String get downloadBios => 'Scarica BIOS';

  @override
  String get viewDetails => 'Vedi Dettagli';

  @override
  String get addToFavorites => 'Aggiungi ai Preferiti';

  @override
  String get removeFromFavorites => 'Rimuovi dai Preferiti';

  @override
  String get biosMissing => 'Mancante';

  @override
  String get biosPresent => 'BIOS presente';

  @override
  String get checkingBios => 'Controllo BIOS...';

  @override
  String get emulatorDownloading => 'Download emulatore...';

  @override
  String get emulatorDownloadComplete => 'Emulatore scaricato';

  @override
  String get emulatorDownloadFailed => 'Download emulatore fallito';

  @override
  String get installingEmulator => 'Installazione emulatore...';

  @override
  String get emulatorReady => 'Emulatore pronto';

  @override
  String get configuration => 'Configurazione';

  @override
  String get paths => 'Percorsi';

  @override
  String get storage => 'Archiviazione';

  @override
  String get emulatorsPath => 'Percorso Emulatori';

  @override
  String get romsPath => 'Percorso ROM';

  @override
  String get mediaPath => 'Percorso Media';

  @override
  String get biosPath => 'Percorso BIOS';

  @override
  String get tempPath => 'Percorso Temporaneo';

  @override
  String get browse => 'Sfoglia';

  @override
  String get apply => 'Applica';

  @override
  String get reset => 'Reimposta';

  @override
  String get clear => 'Cancella';

  @override
  String get scan => 'Scansiona';

  @override
  String get scanForRoms => 'Scansiona ROM';

  @override
  String get scanningRoms => 'Scansione ROM...';

  @override
  String get scanComplete => 'Scansione completata';

  @override
  String romsFound(int count) {
    return '$count ROM trovate';
  }

  @override
  String get noNewRomsFound => 'Nessuna nuova ROM trovata';

  @override
  String get launchEmulator => 'Avvia Emulatore';

  @override
  String get emulatorError => 'Errore Emulatore';

  @override
  String get gamepadConnected => 'Gamepad collegato';

  @override
  String get gamepadDisconnected => 'Gamepad disconnesso';

  @override
  String get gamepadTest => 'Test Gamepad';

  @override
  String get pressAnyButton => 'Premi qualsiasi pulsante per testare';

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
  String get dpadUp => 'D-Pad Su';

  @override
  String get dpadDown => 'D-Pad Giù';

  @override
  String get dpadLeft => 'D-Pad Sinistra';

  @override
  String get dpadRight => 'D-Pad Destra';

  @override
  String get leftShoulder => 'L1';

  @override
  String get rightShoulder => 'R1';

  @override
  String get leftTrigger => 'L2';

  @override
  String get rightTrigger => 'R2';

  @override
  String get leftStick => 'Levetta Sinistra';

  @override
  String get rightStick => 'Stick destro';

  @override
  String get setupWizard => 'Configurazione Guidata';

  @override
  String get welcome => 'Benvenuto';

  @override
  String get welcomeMessage => 'Benvenuto in Forsaken Emulator';

  @override
  String get next => 'Avanti';

  @override
  String get previous => 'Precedente';

  @override
  String get finish => 'Fine';

  @override
  String get skip => 'Salta';

  @override
  String get setupComplete => 'Configurazione Completata';

  @override
  String get selectLanguage => 'Seleziona Lingua';

  @override
  String get selectEmulatorsPath => 'Seleziona Percorso Emulatori';

  @override
  String get selectRomsPath => 'Seleziona Percorso ROM';

  @override
  String get selectMediaPath => 'Seleziona Percorso Media';

  @override
  String get allSettingsConfigured => 'Tutte le impostazioni configurate';

  @override
  String get darkTheme => 'Scuro';

  @override
  String get lightTheme => 'Chiaro';

  @override
  String get systemTheme => 'Sistema';

  @override
  String get about => 'Info';

  @override
  String get checkForUpdates => 'Cerca Aggiornamenti';

  @override
  String get noUpdatesAvailable => 'Nessun aggiornamento disponibile';

  @override
  String get updateAvailable => 'Aggiornamento disponibile';

  @override
  String get downloadingUpdate => 'Download aggiornamento...';

  @override
  String get installingUpdate => 'Installazione aggiornamento...';

  @override
  String get updateComplete => 'Aggiornamento completato';

  @override
  String get updateFailed => 'Aggiornamento fallito';

  @override
  String get networkError => 'Errore di rete';

  @override
  String get connectionError => 'Errore di connessione';

  @override
  String get timeoutError => 'Errore di timeout';

  @override
  String get unknownError => 'Errore sconosciuto';

  @override
  String get permissionDenied => 'Permesso negato';

  @override
  String get fileNotFound => 'File non trovato';

  @override
  String get directoryNotFound => 'Directory non trovata';

  @override
  String get diskFull => 'Disco pieno';

  @override
  String get invalidPath => 'Percorso non valido';

  @override
  String get pathNotWritable => 'Percorso non scrivibile';

  @override
  String get romCorrupted => 'Il file ROM potrebbe essere corrotto';

  @override
  String get zipError => 'Errore archivio ZIP';

  @override
  String get extractionFailed => 'Estrazione fallita';

  @override
  String get checksumMismatch => 'Discrepanza checksum';

  @override
  String get biosCheckFailed => 'Controllo BIOS fallito';

  @override
  String get continueAnyway => 'Continua comunque';

  @override
  String get reportIssue => 'Segnala Problema';

  @override
  String get copyToClipboard => 'Copia negli appunti';

  @override
  String get copiedToClipboard => 'Copiato negli appunti';

  @override
  String get share => 'Condividi';

  @override
  String get hide => 'Nascondi';

  @override
  String get show => 'Mostra';

  @override
  String get toggleView => 'Cambia Vista';

  @override
  String get gridView => 'Vista a Griglia';

  @override
  String get listView => 'Vista a Lista';

  @override
  String get carouselView => 'Vista Carosello';

  @override
  String get sortBy => 'Ordina per';

  @override
  String get sortByName => 'Nome';

  @override
  String get sortByDate => 'Data';

  @override
  String get sortBySize => 'Dimensione';

  @override
  String get sortByRegion => 'Regione';

  @override
  String get ascending => 'Crescente';

  @override
  String get descending => 'Decrescente';

  @override
  String get filter => 'Filtra';

  @override
  String get filterByRegion => 'Filtra per Regione';

  @override
  String get filterByGenre => 'Filtra per Genere';

  @override
  String get filterByYear => 'Filtra per Anno';

  @override
  String get clearFilters => 'Cancella Filtri';

  @override
  String get systemInfo => 'Info Sistema';

  @override
  String get cpu => 'CPU';

  @override
  String get memory => 'Memoria';

  @override
  String get storageInfo => 'Archiviazione';

  @override
  String get os => 'Sistema Operativo';

  @override
  String get emulatorVersion => 'Versione Emulatore';

  @override
  String get totalRoms => 'Totale ROM';

  @override
  String get totalSize => 'Dimensione Totale';

  @override
  String get freeSpace => 'Spazio Libero';

  @override
  String get usedSpace => 'Spazio Usato';

  @override
  String get systemUtilities => 'Utilità Sistema';

  @override
  String get romVerificationResults => 'Risultati Verifica ROM';

  @override
  String get totalRomFiles => 'Totale file ROM';

  @override
  String get emptyRomFiles => 'File ROM vuoti';

  @override
  String get validRomFiles => 'File ROM validi';

  @override
  String get romsDirectoryDoesNotExist => 'La directory ROM non esiste';

  @override
  String get gamelistCheckResults => 'Risultati Controllo Gamelist';

  @override
  String get totalPlatforms => 'Totale piattaforme';

  @override
  String get missingGamelists => 'Gamelist mancanti';

  @override
  String get configurationBackup => 'Backup Configurazione';

  @override
  String get configurationBackedUp => 'Configurazione salvata in:';

  @override
  String get errorBackingUp => 'Errore nel backup della configurazione:';

  @override
  String get romDatabase => 'Database ROM';

  @override
  String get romDatabaseDownloaded => 'Database ROM scaricato con successo';

  @override
  String get failedDownloadRomDatabase => 'Download database ROM fallito';

  @override
  String get romDatabaseCleared => 'Database ROM cancellato';

  @override
  String get failedClearDatabase => 'Cancellazione database fallita';

  @override
  String get downloadRomDatabase => 'Scarica Database ROM';

  @override
  String get clearRomDatabase => 'Cancella Database ROM';

  @override
  String get systemRequirements => 'Requisiti Sistema';

  @override
  String get failedToCheckSystem => 'Controllo sistema fallito';

  @override
  String cleanedUpTempFiles(String deletedCount) {
    return 'Puliti $deletedCount file ROM temporanei';
  }

  @override
  String get errorCleaningTempFiles =>
      'Errore nella pulizia dei file temporanei:';

  @override
  String get errorVerifyingRomFiles => 'Errore nella verifica dei file ROM:';

  @override
  String get errorCheckingGamelists => 'Errore nel controllo dei gamelist:';

  @override
  String get cancelDownload => 'Annulla Download';

  @override
  String get selectEmulator => 'Seleziona Emulatore';

  @override
  String get biosStatusDashboard => 'Dashboard Stato BIOS';

  @override
  String get webSettings => 'Impostazioni Web';

  @override
  String get saveSettings => 'Salva Impostazioni';

  @override
  String get errorSavingSettings =>
      'Errore nel salvataggio delle impostazioni:';

  @override
  String romsCountItems(String count) {
    return '$count ROM';
  }

  @override
  String get savedPermanently => 'salvato permanentemente';

  @override
  String get keptInTemporary => 'mantenuto nell\'archiviazione temporanea';

  @override
  String get tryAgain => 'Riprova';

  @override
  String get allDownloads => 'Tutti i download completati';

  @override
  String romSavedPermanently(String name) {
    return '$name salvato permanentemente';
  }

  @override
  String get undo => 'Annulla';

  @override
  String romKeptInTemporary(String name) {
    return '$name mantenuto nell\'archiviazione temporanea';
  }

  @override
  String romsCountWithSize(String count, String size) {
    return '$count ROM • $size';
  }

  @override
  String get whatYouCanTry => 'Cosa puoi provare:';

  @override
  String get tips => 'Consigli';

  @override
  String get helpNavigateItems => 'Naviga tra gli elementi';

  @override
  String get helpGamepadNavigation => 'Navigazione gamepad';

  @override
  String get helpQuickNavigation => 'Navigazione rapida (salta più elementi)';

  @override
  String get helpGamepadPageNavigation => 'Navigazione pagine gamepad';

  @override
  String get helpGoToFirst => 'Vai al primo elemento';

  @override
  String get helpGoToLast => 'Vai all\'ultimo elemento';

  @override
  String get helpJumpToLetter =>
      'Salta all\'elemento che inizia con quella lettera';

  @override
  String get helpSelectItem => 'Seleziona elemento';

  @override
  String get helpGamepadSelect => 'Seleziona gamepad';

  @override
  String get helpGoBackCloseDialogs => 'Torna indietro / Chiudi dialoghi';

  @override
  String get helpExitApplication => 'Esci dall\'applicazione';

  @override
  String get helpGamepadBackClose => 'Gamepad indietro / Chiudi dialoghi';

  @override
  String get helpToggleViewMode =>
      'Cambia modalità vista (Griglia/Lista/Carosello)';

  @override
  String get helpGamepadViewToggle => 'Cambia vista con gamepad';

  @override
  String get helpRefreshView => 'Aggiorna vista corrente';

  @override
  String get helpShowPlatformInfo => 'Mostra informazioni piattaforma';

  @override
  String get helpActivateSearch => 'Attiva ricerca';

  @override
  String get helpGamepadSearch => 'Ricerca gamepad';

  @override
  String get helpShowHelpDialog => 'Mostra questo dialogo di aiuto';

  @override
  String get helpGamepadHelp => 'Aiuto gamepad';

  @override
  String get tipUseKeyboardOrGamepad => 'Usa tastiera o gamepad per navigare';

  @override
  String get tipAlphabeticalJump =>
      'Il salto alfabetico funziona in tutte le modalità vista';

  @override
  String get tipPressQuestionMark =>
      'Premi ? in qualsiasi momento per vedere questo aiuto';

  @override
  String get tipGamepadAlongside =>
      'Il gamepad funziona insieme ai controlli tastiera';

  @override
  String get configurePathsDescription =>
      'Configura i percorsi usati dall\'applicazione per trovare ROM, media e emulatori.';

  @override
  String get romListsAutoManaged =>
      'Le liste ROM sono ora gestite automaticamente. Scaricale da Impostazioni > Database ROM.';

  @override
  String get romStorage => 'Archiviazione ROM';

  @override
  String get configureRomStorageDescription =>
      'Configura dove le ROM scaricate sono archiviate temporaneamente e permanentemente.';

  @override
  String get resetToDefaults => 'Reimposta ai predefiniti';

  @override
  String get mediaPathLabel => 'Percorso Media';

  @override
  String get mediaPathHint => 'Directory contenente media (immagini, video)';

  @override
  String get emulatorsPathLabel => 'Percorso Emulatori';

  @override
  String get emulatorsPathHint => 'Directory contenente file binari emulatori';

  @override
  String get gamelistPathAutomatic => 'Percorso Gamelist (Automatico)';

  @override
  String get gamelistAutoDescription =>
      'I gamelist sono ora gestiti automaticamente nella directory dei dati dell\'app. Questo rende l\'app completamente indipendente e prepara per la futura distribuzione gamelist da GitHub.';

  @override
  String get tempRomStorageLabel => 'Archiviazione ROM Temporanea (Opzionale)';

  @override
  String get tempRomStorageDescription =>
      'Le ROM sono scaricate qui prima. Possono essere promosse all\'archiviazione permanente dopo aver giocato.';

  @override
  String get permanentRomStorageLabel =>
      'Archiviazione ROM Permanente (Opzionale)';

  @override
  String get permanentRomStorageDescription =>
      'Le ROM salvate permanentemente sono archiviate qui. Queste non vengono pulite automaticamente.';

  @override
  String get defaultAppSupportDir => 'Predefinito: directory supporto app';

  @override
  String currentPathDisplay(String path) {
    return 'Attuale: $path';
  }

  @override
  String get configurationFile => 'File di Configurazione';

  @override
  String get source => 'Fonte:';

  @override
  String get customConfigActive => 'Configurazione personalizzata attiva';

  @override
  String get pathStructure => 'Struttura Percorsi';

  @override
  String get pathStructureDescription =>
      'Percorso Media: MEDIA_PATH/piattaforma/boxart|screenshots|videos/rom.png\nPercorso Gamelist: ~/.local/share/com.example.emulator/gamelists/piattaforma/gamelist.xml (automatico)\nPercorso Emulatori: EMULATORS_PATH/emulatore_binario';

  @override
  String get errorCheckingSystem => 'Errore nel controllo del sistema';

  @override
  String get recheckR => 'Ricontrolla (R)';

  @override
  String get allRequiredToolsInstalled =>
      'Tutti gli Strumenti Richiesti Installati';

  @override
  String get missingRequiredTools => 'Strumenti Richiesti Mancanti';

  @override
  String get systemReadyToUse =>
      'Il tuo sistema è pronto per usare l\'emulatore';

  @override
  String get someRequiredToolsMissing => 'Alcuni strumenti richiesti mancano';

  @override
  String get requiredTools => 'Strumenti Richiesti';

  @override
  String get requiredToolsDescription =>
      'Questi strumenti sono necessari per scaricare ed estrarre emulatori';

  @override
  String get installationInstructions => 'Istruzioni di Installazione';

  @override
  String get installed => 'Installato';

  @override
  String get missing => 'Mancante';

  @override
  String get downloadEmulatorsAndGameLists =>
      'Scarica emulatori e liste giochi';

  @override
  String get quickActions => 'Azioni Rapide';

  @override
  String get downloadAll => 'Scarica Tutto';

  @override
  String get byCategory => 'Per Categoria';

  @override
  String get downloadQueue => 'Coda Download';

  @override
  String get noDownloadsInProgress => 'Nessun download in corso';

  @override
  String get selectQuickActionToStart =>
      'Seleziona un\'azione rapida sopra per iniziare a scaricare';

  @override
  String get categorySony => 'Sony (PS1-PS4)';

  @override
  String get categoryNintendo => 'Nintendo (GC, Wii, Switch)';

  @override
  String get categoryMicrosoft => 'Microsoft (Xbox, Xbox 360)';

  @override
  String get categoryMultiPlatform => 'Multi-Piattaforma (RetroArch)';

  @override
  String get categoryOtherEmulators => 'Altri Emulatori';

  @override
  String get categoryUtilities => 'Utilità';

  @override
  String confirmDownloadDescription(String count, String size) {
    return 'Scaricare $count emulatore/i?\nDimensione stimata: ~$size MB\n\nQuesto può richiedere un po\' a seconda della connessione internet.';
  }

  @override
  String get alreadyInstalled => 'Già installato';

  @override
  String get starting => 'Avvio...';

  @override
  String get completed => 'Completato';

  @override
  String get gameListsAlreadyDownloaded => 'Liste giochi già scaricate';

  @override
  String get redownload => 'Riscrica';

  @override
  String get gameListsFromGitHub => 'Liste Giochi (da GitHub)';

  @override
  String get downloaded => 'Scaricato';

  @override
  String get cancelled => 'Annullato';

  @override
  String get missingFor => 'Mancante per:';

  @override
  String get noCustomConfigToBackup =>
      'Nessuna configurazione personalizzata da salvare. Usando i predefiniti.';

  @override
  String get saveConfigurationBackup => 'Salva Backup Configurazione';

  @override
  String get refreshStatsR => 'Aggiorna statistiche (R)';

  @override
  String get systemStatistics => 'Statistiche Sistema';

  @override
  String get romFiles => 'File ROM';

  @override
  String get maintenanceTools => 'Strumenti di Manutenzione';

  @override
  String get cleanupTemporaryRoms => 'Pulisci ROM Temporanee';

  @override
  String get cleanupTemporaryRomsDescription =>
      'Rimuovi file ROM temporanei dalla directory temporanea del sistema';

  @override
  String get verifyRomFiles => 'Verifica File ROM';

  @override
  String get verifyRomFilesDescription =>
      'Controlla che tutti i file ROM esistano e siano validi';

  @override
  String get checkMissingGamelists => 'Controlla Gamelist Mancanti';

  @override
  String get checkMissingGamelistsDescription =>
      'Trova piattaforme senza file gamelist.xml';

  @override
  String get backupConfiguration => 'Backup Configurazione';

  @override
  String get backupConfigurationDescription => 'Crea un backup di config.json';

  @override
  String get downloadingRomDatabase => 'Download Database ROM...';

  @override
  String get downloadMayTakeMinutes =>
      'Questo può richiedere qualche minuto a seconda della connessione...';

  @override
  String get databaseStatus => 'Stato Database';

  @override
  String get notDownloaded => 'Non Scaricato';

  @override
  String get aboutRomDatabase => 'Info Database ROM';

  @override
  String get aboutRomDatabaseDescription =>
      'Il database ROM contiene liste di ROM disponibili organizzate per piattaforma. Viene scaricato dal repository romList di Forsaken su GitHub.';

  @override
  String get romDatabaseSource => 'Fonte: github.com/ForsakenStation/romList';

  @override
  String get downloadRomDatabaseDescription =>
      'Questo scaricherà le liste ROM dal repository romList di Forsaken su GitHub.';

  @override
  String get downloadRomDatabaseStats =>
      'Dimensione: ~7 MB\nPiattaforme: 138\nTotale ROM: ~240.000';

  @override
  String get downloadWillOverwrite =>
      'Nota: Questo sovrascriverà i dati esistenti.';

  @override
  String get clearRomDatabaseDescription =>
      'Questo eliminerà tutte le liste ROM scaricate e reimposterà il database allo stato iniziale.';

  @override
  String get gamelistsStatus => 'Stato Gamelists';

  @override
  String get gamelistsDownloaded => 'Scaricate';

  @override
  String get gamelistsNotDownloaded => 'Non Scaricate';

  @override
  String get aboutGamelists => 'Info Gamelists';

  @override
  String get aboutGamelistsDescription =>
      'Le gamelist contengono metadati dei giochi (nomi, descrizioni, valutazioni) per ogni piattaforma. Vengono scaricate dal repository gamelists di Forsaken su GitHub.';

  @override
  String get gamelistsSource => 'Fonte: github.com/ForsakenStation/gamelists';

  @override
  String get downloadGamelists => 'Scarica Gamelists';

  @override
  String get downloadGamelistsDescription =>
      'Questo scaricherà i file gamelist.xml dal repository gamelists di Forsaken su GitHub.';

  @override
  String get downloadGamelistsWillOverwrite =>
      'Nota: Questo sovrascriverà i file gamelist esistenti.';

  @override
  String get downloadingGamelists => 'Download Gamelists...';

  @override
  String get gamelistsDownloadedSuccess => 'Gamelists scaricate con successo';

  @override
  String get failedDownloadGamelists => 'Download gamelists fallito';

  @override
  String get clearGamelists => 'Cancella Gamelists';

  @override
  String get clearGamelistsDescription =>
      'Questo eliminerà tutti i file gamelist scaricati.';

  @override
  String get gamelistsCleared => 'Gamelists cancellate';

  @override
  String get failedClearGamelists => 'Cancellazione gamelists fallita';

  @override
  String get rebuildMediaCache => 'Ricostruisci Cache Media';

  @override
  String get rebuildMediaCacheDescription =>
      'Scansiona le directory media e cachea i percorsi nei gamelist per un caricamento più veloce';

  @override
  String get rebuildMediaCacheConfirmTitle => 'Ricostruire Cache Media?';

  @override
  String get rebuildMediaCacheConfirmBody =>
      'Questo scansionerà tutte le directory media e aggiornerà i file gamelist.xml con i percorsi media. Questo può richiedere un po\' per collezioni grandi.';

  @override
  String get rebuildMediaCacheProgress => 'Ricostruzione cache media...';

  @override
  String rebuildMediaCacheProcessingPlatform(
    String platform,
    String current,
    String total,
  ) {
    return 'Elaborazione $platform ($current/$total)';
  }

  @override
  String get rebuildMediaCacheComplete => 'Cache Media Ricostruita';

  @override
  String rebuildMediaCacheSummary(
    String platforms,
    String games,
    String updated,
    String paths,
  ) {
    return '$platforms piattaforme, $games giochi scansionati, $updated aggiornati, $paths percorsi media cachati';
  }

  @override
  String get rebuildMediaCacheError => 'Ricostruzione cache media fallita';

  @override
  String rebuildMediaCacheErrors(String count) {
    return '$count errori durante la ricostruzione';
  }

  @override
  String get description => 'Descrizione';

  @override
  String get noDescriptionAvailable =>
      'Nessuna descrizione disponibile per questa ROM.';

  @override
  String get releaseDate => 'Data di uscita';

  @override
  String get players => 'Giocatori';

  @override
  String get rating => 'Valutazione';

  @override
  String get regions => 'Regioni';

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
    return '$name - Manuale';
  }

  @override
  String get playInBrowser => 'Gioca nel browser';

  @override
  String downloadingPlatformBios(String platformName) {
    return 'Download BIOS di $platformName';
  }

  @override
  String get downloadingAllMissingBios => 'Download di tutti i BIOS mancanti';

  @override
  String biosFileLabel(String filename) {
    return 'File: $filename';
  }

  @override
  String batchProgressLabel(String completed, String total) {
    return 'Progresso: $completed/$total file';
  }

  @override
  String get fileDetails => 'Dettagli del file:';

  @override
  String get waiting => 'In attesa...';

  @override
  String get verifying => 'Verifica...';

  @override
  String get failed => 'Fallito';

  @override
  String get preparing => 'Preparazione...';

  @override
  String get downloadingFiles => 'Download dei file...';

  @override
  String get someDownloadsFailed => 'Alcuni download sono falliti';

  @override
  String get downloadsCancelled => 'Download annullati';

  @override
  String get calculating => 'Calcolo...';

  @override
  String secondsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count secondi',
      one: '1 secondo',
    );
    return '$_temp0';
  }

  @override
  String minutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuti',
      one: '1 minuto',
    );
    return '$_temp0';
  }

  @override
  String hoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ore',
      one: '1 ora',
    );
    return '$_temp0';
  }

  @override
  String get downloadingAndLaunching => 'Download e avvio...';

  @override
  String get launching => 'Avvio...';

  @override
  String emulatorLabel(String name) {
    return 'Emulatore: $name';
  }

  @override
  String get generalInformation => 'Informazioni generali';

  @override
  String get manufacturer => 'Produttore';

  @override
  String get releaseYear => 'Anno di uscita';

  @override
  String get generation => 'Generazione';

  @override
  String get technicalSpecifications => 'Specifiche tecniche';

  @override
  String get resolution => 'Risoluzione';

  @override
  String get colors => 'Colori';

  @override
  String get notNow => 'Non ora';

  @override
  String get saveRomPermanently => 'Salvare la ROM permanentemente?';

  @override
  String get keepRomOfflineQuestion =>
      'Vuoi conservare questa ROM scaricata per giocare offline?';

  @override
  String get deletedToSaveSpace =>
      'In caso contrario, verrà eliminata in seguito per risparmiare spazio.';

  @override
  String get view => 'Visualizza';

  @override
  String get media => 'Media';

  @override
  String get navigate => 'Naviga';

  @override
  String get info => 'Info';

  @override
  String get toggleFilter => 'Alterna filtro';

  @override
  String get changeTheme => 'Cambia tema';

  @override
  String get keyboard => 'Tastiera';

  @override
  String get gamepad => 'Gamepad';

  @override
  String get hideKeyboard => 'Nascondi tastiera';

  @override
  String get gameManual => 'Manuale del Gioco';

  @override
  String get pdfDocument => 'Documento PDF';

  @override
  String get manual => 'Manuale';

  @override
  String get video => 'Video';

  @override
  String get zoomOut => 'Riduci zoom';

  @override
  String get zoomIn => 'Aumenta zoom';

  @override
  String pageCounter(String current, String total) {
    return 'Pagina $current / $total';
  }

  @override
  String get zoom => 'Zoom';

  @override
  String get firstLast => 'Primo/Ultimo';

  @override
  String get scroll => 'Scorri';

  @override
  String get loadingVideo => 'Caricamento video...';

  @override
  String get playPause => 'Play/Pausa';

  @override
  String get useArrowKeysToNavigate =>
      'Usa i tasti freccia o scorri per navigare';

  @override
  String get searchRomsHint => 'Cerca ROM...';

  @override
  String get cancelSearch => 'Annulla Ricerca';

  @override
  String get virtualKeyboard => 'Tastiera Virtuale';

  @override
  String get noRomsAvailable => 'Nessuna ROM disponibile';

  @override
  String get noRomsForPlatformMessage =>
      'Nessun file ROM trovato per questa piattaforma. I file ROM devono essere inseriti come file .txt contenenti URL di download nella directory della piattaforma.';

  @override
  String get noMatchingRoms => 'Nessuna ROM corrispondente';

  @override
  String get tryDifferentSearch => 'Prova con un termine di ricerca diverso';

  @override
  String get saveToPermanentStorage => 'Salva nello storage permanente';

  @override
  String get temporary => 'Temporaneo';

  @override
  String get permanent => 'Permanente';

  @override
  String get tempPathLabel => 'Temp';

  @override
  String get foreverPathLabel => 'Forever';

  @override
  String get storageOverview => 'Panoramica dello Storage';

  @override
  String get clearTemporaryStorage => 'Cancella storage temporaneo';

  @override
  String filesCount(String count) {
    return '$count file';
  }

  @override
  String pathDisplay(String label, String path) {
    return 'Percorso $label: $path';
  }

  @override
  String get unknown => 'Sconosciuto';

  @override
  String get tagVerifiedGoodDump =>
      'Dump verificato e corretto - funzionamento confermato';

  @override
  String get tagBadDump =>
      'Dump errato - potrebbe non funzionare correttamente';

  @override
  String get tagAlternateVersion => 'Versione alternativa';

  @override
  String get tagOverdump => 'Overdump - contiene dati aggiuntivi';

  @override
  String get tagModifiedHacked => 'ROM modificata/hackerata';

  @override
  String get tagFanTranslation => 'Traduzione amatoriale';

  @override
  String get tagPirateBootleg => 'Versione pirata/bootleg';

  @override
  String get tagFixedVersion => 'Versione corretta';

  @override
  String get tagCheatTrainer => 'Include un trainer per trucchi';

  @override
  String tagVersion(String text) {
    return 'Versione: $text';
  }

  @override
  String tagSpecialRelease(String text) {
    return 'Uscita speciale: $text';
  }

  @override
  String tagMediaInfo(String text) {
    return 'Info media: $text';
  }

  @override
  String noEmulatorConfigured(
    String displayName,
    String platform,
    String configPath,
  ) {
    return 'Nessun emulatore configurato per $displayName.\n\nAggiungi la configurazione per \"$platform\" in:\n$configPath';
  }

  @override
  String get noEmulatorCommandAvailable =>
      'Nessun comando emulatore disponibile';

  @override
  String platformNotSupportedWeb(String platform, String supportedPlatforms) {
    return 'La piattaforma \"$platform\" non è ancora supportata nel browser web.\n\nPiattaforme supportate: $supportedPlatforms';
  }

  @override
  String failedToLaunchWebEmulator(String error) {
    return 'Impossibile avviare l\'emulatore web: $error';
  }

  @override
  String failedToLaunchRom(String error) {
    return 'Impossibile avviare la ROM.\n\nVerifica che:\n• L\'emulatore sia installato correttamente\n• Il file ROM sia valido\n• La configurazione sia corretta\n\nErrore: $error';
  }

  @override
  String errorLaunchingRom(String error) {
    return 'Errore durante l\'avvio della ROM: $error';
  }

  @override
  String noInfoAvailable(String platformName) {
    return 'Nessuna informazione disponibile per $platformName';
  }

  @override
  String get platformInfoTooltip => 'Info piattaforma (I)';

  @override
  String get navigationHint => 'Usa i tasti freccia o scorri per navigare';

  @override
  String get noGamesFound => 'Nessun gioco trovato';

  @override
  String get noGamesFoundForSearch => 'Nessun gioco trovato per la ricerca';

  @override
  String get tryDifferentSearchOrClear =>
      'Prova con un altro termine di ricerca o cancella il filtro';

  @override
  String get checkStorageOrDownload =>
      'Controlla le impostazioni di archiviazione o scarica delle ROM';

  @override
  String get searchGamesHint => 'Cerca giochi...';

  @override
  String get settingsHeaderTitle => 'Configurazione dell\'Emulatore Forsaken';

  @override
  String get settingsHeaderSubtitle =>
      'Configurare emulatori, percorsi e scaricare contenuti';

  @override
  String get emulatorManagementDesc =>
      'Aggiungere, modificare e configurare comandi degli emulatori';

  @override
  String get systemPaths => 'Percorsi di sistema';

  @override
  String get systemPathsDesc =>
      'Configurare percorsi di ROMs, media ed emulatori';

  @override
  String get romDatabaseDesc => 'Scaricare e gestire elenchi di ROMs da GitHub';

  @override
  String get romStorageDesc =>
      'Gestire ROMs scaricate, archiviazione e pulizia dei file temporanei';

  @override
  String get downloadManagerDesc =>
      'Scaricare emulatori, elenchi di ROMs e dati di gioco';

  @override
  String get systemRequirementsDesc =>
      'Verificare strumenti e dipendenze richieste';

  @override
  String get gamepadTestDebug => 'Test e debug del gamepad';

  @override
  String get gamepadTestDebugDesc =>
      'Testare pulsanti del gamepad, assi e risolvere problemi';

  @override
  String get biosFirmwareHelpDesc =>
      'Verificare file BIOS e requisiti del firmware';

  @override
  String get webSettingsDesc =>
      'Proxy CORS e configurazione della piattaforma web';

  @override
  String get setupWizardDesc =>
      'Rieseguire la procedura guidata di configurazione iniziale';

  @override
  String get languageDesc => 'Selezionare la lingua dell\'applicazione';

  @override
  String get aboutDebug => 'Informazioni e debug';

  @override
  String get aboutDebugDesc => 'Informazioni sull\'app e impostazioni di debug';

  @override
  String get legalDisclaimer => 'Avviso legale';

  @override
  String get romDatabaseCredits =>
      'Gli elenchi di ROMs provengono originariamente dal repository AndroidRoms di Arley4d:';

  @override
  String get romDatabaseThanks =>
      'Ringraziamento speciale al progetto AndroidRoms per il mantenimento di database completi di ROMs a scopo di preservazione.';

  @override
  String get biosFilesSection => 'File BIOS';

  @override
  String get biosFilesCredits =>
      'I file BIOS provengono dal repository retroarch_system di Abdess:';

  @override
  String get biosFilesThanks =>
      'Questo repository contiene file di sistema e BIOS richiesti da varie piattaforme di emulazione. Ringraziamento speciale ai manutentori per la preservazione di questi file essenziali.';

  @override
  String get amigaCopyProtection =>
      'Supporto alla protezione dalla copia Amiga fornito dalla libreria capsimg:';

  @override
  String get amigaCopyProtectionThanks =>
      'Ringraziamento speciale a rsn8887 per il mantenimento della libreria capsimg che consente il supporto delle immagini disco IPF (protette dalla copia) per l\'emulazione Amiga.';

  @override
  String get additionalBiosFiles =>
      'File BIOS aggiuntivi forniti dal progetto RetroPieBios:';

  @override
  String get additionalBiosThanks =>
      'Grazie a PIBSAS/RetroPieBios per aver fornito varianti BIOS aggiuntive e file regionali che migliorano la compatibilità tra diversi sistemi e regioni.';

  @override
  String get enabled => 'Attivato';

  @override
  String get disabled => 'Disattivato';

  @override
  String get disclaimerRequired =>
      'Devi accettare la dichiarazione di non responsabilità per continuare.';

  @override
  String get emulatorsPathRequired =>
      'Il percorso della directory degli emulatori è obbligatorio.';

  @override
  String get emulatorConfigPathRequired =>
      'Il percorso del file di configurazione dell\'emulatore è obbligatorio.';

  @override
  String get mediaPathRequired => 'Il percorso dei media è obbligatorio.';

  @override
  String get tempRomPathRequired =>
      'Il percorso dell\'archiviazione temporanea delle ROM è obbligatorio.';

  @override
  String get permanentRomPathRequired =>
      'Il percorso dell\'archiviazione permanente delle ROM è obbligatorio.';

  @override
  String wizardStepCounter(int current, int total) {
    return 'Passaggio $current / $total';
  }

  @override
  String get emulatorConfiguration => 'Configurazione dell\'emulatore';

  @override
  String get emulatorConfigStepDesc =>
      'Imposta i percorsi dove sono installati i tuoi emulatori. Puoi cambiarli in seguito in Impostazioni > Percorsi di sistema.';

  @override
  String get emulatorsDirectory => 'Directory degli emulatori';

  @override
  String get pathToEmulatorBinaries => 'Percorso dei binari degli emulatori';

  @override
  String get emulatorConfigFile => 'File di configurazione dell\'emulatore';

  @override
  String get pathToEmulatorConfig =>
      'Percorso del JSON di configurazione dell\'emulatore';

  @override
  String get storagePaths => 'Percorsi di archiviazione';

  @override
  String get storagePathsStepDesc =>
      'Configura dove vengono archiviati i file multimediali e i file ROM. Puoi cambiarli in seguito in Impostazioni > Percorsi di sistema.';

  @override
  String get wizardMediaPathHint => 'Copertine, screenshot e video';

  @override
  String get temporaryRomStorage => 'Archiviazione temporanea delle ROM';

  @override
  String get temporaryRomStorageHint =>
      'ROM scaricate per sessioni di gioco singole';

  @override
  String get permanentRomStorage => 'Archiviazione permanente delle ROM';

  @override
  String get permanentRomStorageHint => 'ROM salvate per il gioco offline';

  @override
  String get allSet => 'Tutto pronto!';

  @override
  String get wizardEmulatorReady => 'L\'emulatore Forsaken è pronto all\'uso.';

  @override
  String get changeSettingsLater =>
      'Puoi modificare queste impostazioni in seguito dalla schermata delle Impostazioni.';

  @override
  String get configurationSummary => 'Riepilogo della configurazione';

  @override
  String get summaryEmulators => 'Emulatori';

  @override
  String get summaryMedia => 'Media';

  @override
  String get summaryTempRoms => 'ROM temporanee';

  @override
  String get summarySavedRoms => 'ROM salvate';

  @override
  String get defaultValue => '(predefinito)';

  @override
  String pdfPageIndicator(int current, int total) {
    return 'Pagina $current di $total';
  }

  @override
  String get pdfZoomOut => 'Riduci zoom (-)';

  @override
  String get pdfZoomIn => 'Ingrandisci zoom (+)';

  @override
  String get pdfResetZoom => 'Reimposta zoom (0)';

  @override
  String get pdfFirstPage => 'Prima pagina (Home)';

  @override
  String get pdfPreviousPage => 'Pagina precedente (←/PgUp)';

  @override
  String get pdfNextPage => 'Pagina successiva (→/PgDn)';

  @override
  String get pdfLastPage => 'Ultima pagina (End)';

  @override
  String get pdfFileNotFound => 'File PDF non trovato';

  @override
  String confirmDeleteEmulator(String system) {
    return 'Sei sicuro di voler eliminare la configurazione dell\'emulatore per $system?';
  }

  @override
  String commandsConfigured(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comandi configurati',
      one: '1 comando configurato',
    );
    return '$_temp0';
  }

  @override
  String get noCommand => 'Nessun comando';

  @override
  String get reloadConfigTooltip => 'Ricarica configurazione (R)';

  @override
  String get configurationInfo => 'Informazioni configurazione';

  @override
  String get configLocation => 'Posizione configurazione:';

  @override
  String get hasLocalOverridesYes => 'Ha sostituzioni locali: Sì';

  @override
  String get hasLocalOverridesNo => 'Ha sostituzioni locali: No';

  @override
  String get changesSavedToDevice =>
      'Le modifiche vengono salvate nella memoria del dispositivo.';

  @override
  String get usingBundledConfig =>
      'Configurazione inclusa in uso. Modifica per creare sostituzioni locali.';

  @override
  String get noEmulatorsConfigured => 'Nessun emulatore configurato';

  @override
  String get addFirstEmulator => 'Aggiungi il tuo primo emulatore per iniziare';

  @override
  String get edit => 'Modifica';

  @override
  String get editEmulator => 'Modifica emulatore';

  @override
  String get system => 'Sistema';

  @override
  String get systemHint => 'e.g., nes, snes, ps1';

  @override
  String get commands => 'Comandi';

  @override
  String commandNumber(int number) {
    return 'Comando $number';
  }

  @override
  String get commandHint => 'e.g., ../retroarch.AppImage -f -L core.so';

  @override
  String get remove => 'Rimuovi';

  @override
  String get options => 'Opzioni';

  @override
  String get biosDownloading => 'Download in corso...';

  @override
  String downloadRequiredAndExtras(int requiredCount, int optionalCount) {
    return 'Scarica $requiredCount obbligatori + $optionalCount extra';
  }

  @override
  String downloadRequiredFiles(int requiredCount) {
    return 'Scarica $requiredCount file obbligatori';
  }

  @override
  String downloadOptionalExtras(int optionalCount) {
    return 'Scarica $optionalCount extra opzionali';
  }

  @override
  String get downloadFiles => 'Scarica file';

  @override
  String batchDownloadConfirmation(int totalFiles, int platformCount) {
    return 'Verranno scaricati $totalFiles file BIOS per $platformCount piattaforme:';
  }

  @override
  String get downloadSourceNote =>
      'I file verranno scaricati dal repository retroarch_system.';

  @override
  String get biosOptional => 'OPZIONALE';

  @override
  String biosFilesFound(int foundCount, int totalCount) {
    return '$foundCount/$totalCount file trovati';
  }

  @override
  String optionalExtrasAvailable(int count) {
    return '+$count extra opzionali disponibili';
  }

  @override
  String get biosLocations => 'Posizioni:';

  @override
  String get availableForDownload => 'Disponibile per il download da più fonti';

  @override
  String get summary => 'Riepilogo';

  @override
  String get biosComplete => 'Completo';

  @override
  String get biosPartial => 'Parziale';

  @override
  String get biosFiles => 'File';

  @override
  String get biosDownloadable => 'Scaricabile';

  @override
  String get refreshF5Tooltip => 'Aggiorna (F5)';

  @override
  String get allBiosFilesFound => 'Tutti i file BIOS trovati!';

  @override
  String get noBiosRequirements => 'Nessun requisito BIOS trovato';

  @override
  String platformCount(int count) {
    return '$count piattaforme';
  }

  @override
  String failedToLoadBiosStatus(String error) {
    return 'Impossibile caricare lo stato BIOS: $error';
  }

  @override
  String get refreshStatus => 'Aggiorna stato';

  @override
  String platformsCompleteCount(int complete, int total) {
    return '$complete/$total piattaforme complete';
  }

  @override
  String get platformStatusHeader => 'Stato delle piattaforme';

  @override
  String filesVerifiedStatus(
    int presentFiles,
    int totalFiles,
    int verifiedFiles,
  ) {
    return '$presentFiles/$totalFiles file ($verifiedFiles verificati)';
  }

  @override
  String get biosCollectionOverview => 'Panoramica della collezione BIOS';

  @override
  String get biosVerified => 'Verificato';

  @override
  String downloadComingSoon(String platformName) {
    return 'Funzionalità di download per $platformName - In arrivo!';
  }

  @override
  String get noGamepadConnected => 'Nessun gamepad collegato';

  @override
  String get connectGamepadPrompt =>
      'Collega un gamepad e premi qualsiasi pulsante';

  @override
  String get pressButtonToTest =>
      'Premi qualsiasi pulsante per testare (azioni disabilitate)';

  @override
  String get buttonFunctionTests => 'Test funzioni pulsanti';

  @override
  String get gamepadASelect => 'A (Seleziona)';

  @override
  String get gamepadBBack => 'B (Indietro)';

  @override
  String get gamepadXSearch => 'X (Cerca)';

  @override
  String get gamepadYHelp => 'Y (Aiuto)';

  @override
  String get gamepadLBPageDown => 'LB (Pagina giù)';

  @override
  String get gamepadRBPageUp => 'RB (Pagina su)';

  @override
  String get gamepadStartMenu => 'Start (Menu)';

  @override
  String get gamepadSelectSettings => 'Select (Impostazioni)';

  @override
  String get gamepadLSClick => 'LS Clic';

  @override
  String get gamepadRSView => 'RS Clic (Vista)';

  @override
  String get gamepadLTTrigger => 'LT (Grilletto)';

  @override
  String get gamepadRTTrigger => 'RT (Grilletto)';

  @override
  String get rawButtonStates => 'Stati grezzi dei pulsanti';

  @override
  String get noButtonsPressed => 'Nessun pulsante premuto';

  @override
  String get axisValues => 'Valori degli assi';

  @override
  String get noAxisMovement => 'Nessun movimento degli assi';

  @override
  String get dpadLeftStick => 'D-Pad + Stick sinistro';

  @override
  String get webSettingsDescription =>
      'Configura le impostazioni specifiche della piattaforma web';

  @override
  String get corsProxyWhyNeeded => 'Perché è necessario un proxy CORS?';

  @override
  String get corsProxyExplanation =>
      'I browser bloccano i download di ROM da server esterni a causa delle restrizioni di sicurezza CORS. Un proxy CORS inoltra la richiesta da un server che controlli, aggiungendo gli header necessari.\n\nForsaken include un Cloudflare Worker che puoi distribuire gratuitamente (100k richieste/giorno). Consulta la directory tools/cors-proxy-worker/ per le istruzioni di configurazione.';

  @override
  String get corsProxyUrl => 'URL del proxy CORS';

  @override
  String get corsProxyHelperText =>
      'Lasciare vuoto per disabilitare il proxy CORS (le ROM da server senza CORS falliranno)';

  @override
  String get testingProxy => 'Test del proxy...';

  @override
  String get testProxyConnection => 'Testa connessione proxy';

  @override
  String get noProxyUrlConfigured => 'Nessun URL proxy configurato';

  @override
  String proxyWorking(int statusCode) {
    return 'Il proxy funziona (HTTP $statusCode)';
  }

  @override
  String proxyReturnedHttp(int statusCode) {
    return 'Il proxy ha restituito HTTP $statusCode';
  }

  @override
  String get connectionTimedOut => 'Connessione scaduta';

  @override
  String get corsProxySettingsSaved =>
      'Impostazioni proxy CORS salvate. Ha effetto immediato per i nuovi avvii di ROM.';

  @override
  String get quickDeploy => 'Distribuzione rapida';

  @override
  String get corsProxyDeploySteps =>
      '1. Registrati su dash.cloudflare.com (gratuito)\n2. Installa Wrangler: npm install -g wrangler\n3. Accedi: wrangler login\n4. cd tools/cors-proxy-worker\n5. npx wrangler deploy\n6. Incolla l\'URL del worker sopra';

  @override
  String get permanentStorage => 'Archiviazione permanente';

  @override
  String get temporaryStorage => 'Archiviazione temporanea';

  @override
  String get noDownloadedRoms => 'Nessuna ROM scaricata';

  @override
  String get biosErrorNetworkMessage => 'Connessione di rete fallita';

  @override
  String get biosErrorNetworkSuggestions =>
      'Controlla la tua connessione Internet\nRiprova tra qualche istante\nVerifica le impostazioni DNS\nProva a utilizzare una VPN se l\'accesso è limitato';

  @override
  String get biosErrorFileNotFoundMessage => 'File non trovato sul server';

  @override
  String get biosErrorFileNotFoundSuggestions =>
      'Il file BIOS potrebbe essere stato spostato o rinominato\nProva a scaricare da una fonte alternativa\nVerifica se il file esiste in un altro branch/repository\nSegnala questo problema se persiste';

  @override
  String get biosErrorAccessDeniedMessage => 'Accesso negato dal server';

  @override
  String get biosErrorAccessDeniedSuggestions =>
      'Il server potrebbe bloccare i download\nRiprova più tardi - il server potrebbe essere temporaneamente limitato\nUsa una VPN se l\'accesso è limitato per regione\nVerifica se è richiesta l\'autenticazione';

  @override
  String get biosErrorRateLimitedMessage => 'Limite di richieste superato';

  @override
  String get biosErrorRateLimitedSuggestions =>
      'Attendi qualche minuto prima di riprovare\nRiduci il numero di download simultanei\nIl server si protegge da richieste eccessive';

  @override
  String get biosErrorChecksumMessage =>
      'Verifica dell\'integrità del file fallita';

  @override
  String get biosErrorChecksumSuggestions =>
      'Il file potrebbe essersi corrotto durante il download\nProva a scaricare di nuovo\nVerifica se il file è stato aggiornato sul server\nControlla la stabilità della tua connessione Internet';

  @override
  String get biosErrorSizeMismatchMessage => 'Dimensione del file imprevista';

  @override
  String get biosErrorSizeMismatchSuggestions =>
      'Il file potrebbe essere di una versione diversa da quella prevista\nIl download potrebbe essere incompleto\nProva a scaricare di nuovo\nControlla lo spazio disponibile su disco';

  @override
  String get biosErrorStorageMessage => 'Errore di archiviazione';

  @override
  String get biosErrorStorageSuggestions =>
      'Libera spazio su disco\nControlla i permessi dei file\nAssicurati che la directory di destinazione sia scrivibile\nProva a scaricare in una posizione diversa';

  @override
  String get biosErrorTimeoutMessage => 'Timeout del download';

  @override
  String get biosErrorTimeoutSuggestions =>
      'La connessione Internet potrebbe essere lenta\nIl server potrebbe essere sovraccarico\nRiprova con una connessione stabile\nVerifica se il firewall sta bloccando la connessione';

  @override
  String get biosErrorArchiveMessage => 'Estrazione dell\'archivio fallita';

  @override
  String get biosErrorArchiveSuggestions =>
      'L\'archivio scaricato potrebbe essere corrotto\nProva a scaricare il file di nuovo\nVerifica se lo strumento di estrazione corretto è disponibile\nAssicurati che il file sia in un formato di archivio valido';

  @override
  String get biosErrorUnknownMessage => 'Download fallito';

  @override
  String get biosErrorUnknownSuggestions =>
      'Prova a scaricare di nuovo\nControlla la tua connessione Internet\nVerifica che il file sia ancora disponibile\nContatta il supporto se il problema persiste';

  @override
  String get wizardDownloadEmulators => 'Scarica emulatori';

  @override
  String get wizardDownloadEmulatorsDesc =>
      'Scarica i binari degli emulatori preconfigurati per la tua piattaforma. Puoi scaricare tutto o selezionare per categoria.';

  @override
  String get wizardDownloadRomLists => 'Scarica elenchi ROM';

  @override
  String get wizardDownloadRomListsDesc =>
      'Scarica i file del database ROM da GitHub. Contengono metadati per organizzare la tua libreria di giochi.';

  @override
  String get wizardDownloadGamelists => 'Scarica gamelist';

  @override
  String get wizardDownloadGamelistsDesc =>
      'Scarica i file gamelist.xml da GitHub. Contengono nomi dei giochi, descrizioni, valutazioni e altri metadati.';

  @override
  String get wizardSkipStep => 'Salta';

  @override
  String get wizardDownloadComplete => 'Download completato!';

  @override
  String wizardDownloadFailed(String error) {
    return 'Download fallito: $error';
  }

  @override
  String get wizardAlreadyDownloaded => 'Già scaricato';

  @override
  String get wizardSelectCategory =>
      'Seleziona una categoria da scaricare, o scarica tutto:';

  @override
  String get wizardDownloading => 'Download in corso...';

  @override
  String get wizardDownloadOptional =>
      'Questo passaggio è facoltativo. Puoi scaricare più tardi dalle Impostazioni.';
}
