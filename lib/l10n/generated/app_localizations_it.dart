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
  String get biosRequired => 'BIOS richiesto';

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
  String get biosMissing => 'BIOS mancante';

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
  String get gamepadConnected => 'Gamepad connesso';

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
  String get rightStick => 'Levetta Destra';

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
}
