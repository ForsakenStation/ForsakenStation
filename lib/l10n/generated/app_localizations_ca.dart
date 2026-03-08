// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get appTitle => 'Forsaken Emulator';

  @override
  String get retroGamingFrontend => 'Frontend de Jocs Retro';

  @override
  String get platforms => 'Plataformes';

  @override
  String get roms => 'ROMs';

  @override
  String get settings => 'Configuració';

  @override
  String get settingsAndConfiguration => 'Configuració i Ajustos';

  @override
  String get aboutForsakenEmulator => 'Sobre Forsaken Emulator';

  @override
  String get version => 'Versió';

  @override
  String get appDescription =>
      'Un modern frontend d\'emulador multiplataforma construït amb Flutter.';

  @override
  String get emulators => 'Emuladors';

  @override
  String get ready => 'Llest';

  @override
  String get back => 'Enrere';

  @override
  String get select => 'Seleccionar';

  @override
  String get search => 'Buscar';

  @override
  String get refresh => 'Actualitzar';

  @override
  String get loading => 'Carregant...';

  @override
  String get error => 'Error';

  @override
  String get initializationError => 'Error d\'Inicialització';

  @override
  String get retry => 'Reintentar';

  @override
  String get cancel => 'Cancel·lar';

  @override
  String get ok => 'D\'acord';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get close => 'Tancar';

  @override
  String get noRomsFound => 'No s\'han trobat ROMs';

  @override
  String get noPlatformsFound => 'No s\'han trobat plataformes';

  @override
  String get checkRomsPath => 'Comprova la variable d\'entorn ROMS_PATH';

  @override
  String get downloading => 'Descarregant...';

  @override
  String get downloadComplete => 'Descàrrega completada';

  @override
  String get downloadFailed => 'Descàrrega fallida';

  @override
  String get emulatorNotFound => 'Emulador no trobat';

  @override
  String get romNotFound => 'ROM no trobada';

  @override
  String get biosRequired => 'OBLIGATORI';

  @override
  String get systemCheck => 'Comprovació del Sistema';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get systemDefault => 'Predeterminat del sistema';

  @override
  String get help => 'Ajuda';

  @override
  String get keyboardAndGamepadControls => 'Controls de Teclat i Mando';

  @override
  String get navigation => 'Navegació';

  @override
  String get actions => 'Accions';

  @override
  String get viewControls => 'Controls de Vista';

  @override
  String get gotIt => 'Entès!';

  @override
  String get exit => 'Sortir';

  @override
  String get exitApplication => 'Sortir de l\'Aplicació';

  @override
  String get exitConfirm => 'Segur que vols sortir?';

  @override
  String get downloadManager => 'Gestor de Descàrregues';

  @override
  String get clearCompleted => 'Netejar Completats';

  @override
  String get selectCategory => 'Seleccionar Categoria';

  @override
  String get confirmDownload => 'Confirmar Descàrrega';

  @override
  String get downloadGameLists => 'Descarregar Llistes de Jocs';

  @override
  String get downloadGameListsDescription =>
      'Això descarregarà les llistes de ROMs des de GitHub.';

  @override
  String get gameListsDownloaded => 'Llistes de jocs descarregades!';

  @override
  String get romStorageManagement => 'Gestió d\'Emmagatzematge de ROMs';

  @override
  String get deleteRom => 'Eliminar ROM?';

  @override
  String deleteRomConfirm(String fileName) {
    return 'Eliminar $fileName?';
  }

  @override
  String get actionCannotBeUndone => 'Aquesta acció no es pot desfer.';

  @override
  String deleted(String fileName) {
    return 'Eliminat: $fileName';
  }

  @override
  String get savePermanently => 'Guardar Permanents?';

  @override
  String moveRomConfirm(String fileName) {
    return 'Moure $fileName a l\'emmagatzematge permanent?';
  }

  @override
  String saved(String fileName) {
    return 'Guardat: $fileName';
  }

  @override
  String get clearAll => 'Netejar Tot?';

  @override
  String get clearAllConfirm => 'Eliminar totes les ROMs temporals?';

  @override
  String get allCleared => 'Totes les ROMs temporals netejades';

  @override
  String get systemPathsConfiguration => 'Configuració de Rutes del Sistema';

  @override
  String get migrateRoms => 'Migrar ROMs?';

  @override
  String get migrateRomsDescription =>
      'La ruta d\'emmagatzematge permanent de les ROMs ha canviat de \$oldPath a \$newPath. Voleu migrar les ROMs existents a la nova ubicació?';

  @override
  String get noKeepThem => 'No, mantenir-les';

  @override
  String get yesMigrateRoms => 'Sí, migrar ROMs';

  @override
  String get migratingRoms => 'Migrant ROMs...';

  @override
  String get romMigrationFailed => 'Avís: La migració de ROMs ha fallat';

  @override
  String get pathsSaved => 'Rutes guardades correctament';

  @override
  String get errorSavingPaths => 'Error en guardar les rutes:';

  @override
  String get resetConfiguration => 'Restablir Configuració';

  @override
  String get resetConfigDescription =>
      'Això restablirà totes les rutes als seus valors predeterminats. Les vostres ROMs i fitxers multimèdia no es veuran afectats.';

  @override
  String get configurationReset =>
      'Configuració restablerta als valors predeterminats';

  @override
  String get errorResettingConfiguration =>
      'Error en restablir la configuració:';

  @override
  String get savePaths => 'Guardar Rutes';

  @override
  String get saving => 'Guardant...';

  @override
  String get emulatorManagement => 'Gestió d\'Emuladors';

  @override
  String get configurationReloaded => 'Configuració recarregada';

  @override
  String get errorLoadingEmulators => 'Error en carregar emuladors:';

  @override
  String get emulatorAdded => 'Emulador afegit correctament';

  @override
  String get errorAddingEmulator => 'Error en afegir emulador:';

  @override
  String get emulatorUpdated => 'Emulador actualitzat correctament';

  @override
  String get errorUpdatingEmulator => 'Error en actualitzar emulador:';

  @override
  String get deleteEmulator => 'Eliminar Emulador';

  @override
  String get emulatorDeleted => 'Emulador eliminat';

  @override
  String get errorDeletingEmulator => 'Error en eliminar emulador:';

  @override
  String get configurationSource => 'Font de Configuració';

  @override
  String get addEmulator => 'Afegir Emulador';

  @override
  String get systemNameRequired => 'El nom del sistema és obligatori';

  @override
  String get commandRequired => 'Cal almenys una ordre';

  @override
  String get addCommand => 'Afegir Ordre';

  @override
  String get acceptZipFiles => 'Acceptar fitxers ZIP';

  @override
  String get acceptZipSubtitle => 'Permetre llançar ROMs des d\'arxius ZIP';

  @override
  String get useForeverMode => 'Usar Mode Forever';

  @override
  String get useForeverSubtitle => 'Mantenir l\'emulador en execució';

  @override
  String get launchFile => 'Fitxer d\'inici';

  @override
  String get launchFileSubtitle =>
      'Fitxer a cercar dins del ZIP extret (ex. eboot.bin)';

  @override
  String get launchFileHint => 'ex. eboot.bin';

  @override
  String get workInProgress => 'Treball en Curs';

  @override
  String get wipSubtitle => 'Marcar com no encara completament configurat';

  @override
  String get biosFirmwareHelp => 'Ajuda de BIOS i Firmware';

  @override
  String get downloadMissingFiles => 'Descarregar Fitxers Faltants';

  @override
  String get showOnlyMissing => 'Mostrar només faltants';

  @override
  String get downloadAllMissingBios => 'Descarregar Tots els BIOS Faltants';

  @override
  String get configurationError => 'Error de Configuració';

  @override
  String get configurationErrorDescription =>
      'L\'aplicació no ha pogut trobar la configuració requerida.\nSi us plau configureu les vostres rutes a Configuració > Rutes del Sistema.';

  @override
  String get configurationRequired =>
      'Requerit:\n- Ruta de Mitjans: directori amb actius multimèdia\n- Ruta d\'Emuladors: directori amb binaris d\'emuladors\n\nOpcional:\n- Rutes d\'emmagatzematge de ROMs per descàrregues temporals/permanents';

  @override
  String get goToSettingsToConfigure =>
      'Anar a Configuració > Rutes del Sistema per configurar';

  @override
  String get noDownloadableBios => 'No falten fitxers BIOS baixables';

  @override
  String get allDownloadsCompleted =>
      'Totes les descàrregues completades amb èxit!';

  @override
  String get batchDownloadFailed => 'Descàrrega per lots fallida:';

  @override
  String get download => 'Descarregar';

  @override
  String get downloadCancelled => 'Descàrrega cancel·lada';

  @override
  String get launched => 'Llançat:';

  @override
  String get failedToSave => 'Error en guardar la ROM permanentment';

  @override
  String get failedToSaveRom => 'Error en guardar la ROM permanentment';

  @override
  String get errorSaving => 'Error en guardar la ROM:';

  @override
  String errorSavingRom(String error) {
    return 'Error en guardar la ROM: $error';
  }

  @override
  String get openFolder => 'Obrir Carpeta';

  @override
  String get viewManual => 'Veure Manual';

  @override
  String get play => 'Jugar';

  @override
  String get goBack => 'Tornar';

  @override
  String get clearSearch => 'Netejar Cerca';

  @override
  String get iUnderstand => 'Entenc i accepto aquests termes';

  @override
  String get start => 'Iniciar';

  @override
  String get debugMode => 'Mode Depuració: ';

  @override
  String get toggleDebugMode => 'Alternar Mode Depuració';

  @override
  String get preparingDownload => 'Preparant descàrrega...';

  @override
  String get noEmulatorsAvailable =>
      'No hi ha emuladors disponibles per aquesta categoria';

  @override
  String get failedToLaunch => 'Error en llançar l\'emulador web:';

  @override
  String get platformInfo => 'Info de Plataforma';

  @override
  String get emulatorPlatformInfo => 'Info de Plataforma de l\'Emulador';

  @override
  String get favorites => 'Favorits';

  @override
  String get all => 'Tot';

  @override
  String get collections => 'Col·leccions';

  @override
  String get searchRoms => 'Buscar ROMs...';

  @override
  String get searchPlatforms => 'Buscar plataformes...';

  @override
  String romsCount(int count) {
    return '$count ROMs';
  }

  @override
  String platformsCount(int count) {
    return '$count plataformes';
  }

  @override
  String get region => 'Regió';

  @override
  String get genre => 'Gènere';

  @override
  String get year => 'Any';

  @override
  String get publisher => 'Editor';

  @override
  String get developer => 'Desenvolupador';

  @override
  String get playWithNetplay => 'Jugar amb Netplay';

  @override
  String get downloadBios => 'Descarregar BIOS';

  @override
  String get viewDetails => 'Veure Detalls';

  @override
  String get addToFavorites => 'Afegir a Favorits';

  @override
  String get removeFromFavorites => 'Treure de Favorits';

  @override
  String get biosMissing => 'Absent';

  @override
  String get biosPresent => 'BIOS present';

  @override
  String get checkingBios => 'Comprovant BIOS...';

  @override
  String get emulatorDownloading => 'Descarregant emulador...';

  @override
  String get emulatorDownloadComplete => 'Emulador descarregat';

  @override
  String get emulatorDownloadFailed => 'Error en baixar emulador';

  @override
  String get installingEmulator => 'Instal·lant emulador...';

  @override
  String get emulatorReady => 'Emulador llest';

  @override
  String get configuration => 'Configuració';

  @override
  String get paths => 'Rutes';

  @override
  String get storage => 'Emmagatzematge';

  @override
  String get emulatorsPath => 'Ruta d\'Emuladors';

  @override
  String get romsPath => 'Ruta de ROMs';

  @override
  String get mediaPath => 'Ruta de Mitjans';

  @override
  String get biosPath => 'Ruta de BIOS';

  @override
  String get tempPath => 'Ruta Temporal';

  @override
  String get browse => 'Explorar';

  @override
  String get apply => 'Aplicar';

  @override
  String get reset => 'Restablir';

  @override
  String get clear => 'Netejar';

  @override
  String get scan => 'Escanejar';

  @override
  String get scanForRoms => 'Escanejar ROMs';

  @override
  String get scanningRoms => 'Escanejant ROMs...';

  @override
  String get scanComplete => 'Escaneig completat';

  @override
  String romsFound(int count) {
    return '$count ROMs trobades';
  }

  @override
  String get noNewRomsFound => 'No s\'han trobat noves ROMs';

  @override
  String get launchEmulator => 'Llançar Emulador';

  @override
  String get emulatorError => 'Error de l\'Emulador';

  @override
  String get gamepadConnected => 'Comandament connectat';

  @override
  String get gamepadDisconnected => 'Mando desconnectat';

  @override
  String get gamepadTest => 'Provar Mando';

  @override
  String get pressAnyButton => 'Prem qualsevol botó per provar';

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
  String get dpadUp => 'D-Pad Amunt';

  @override
  String get dpadDown => 'D-Pad Avall';

  @override
  String get dpadLeft => 'D-Pad Esquerra';

  @override
  String get dpadRight => 'D-Pad Dreta';

  @override
  String get leftShoulder => 'L1';

  @override
  String get rightShoulder => 'R1';

  @override
  String get leftTrigger => 'L2';

  @override
  String get rightTrigger => 'R2';

  @override
  String get leftStick => 'Stick Esquerre';

  @override
  String get rightStick => 'Stick dret';

  @override
  String get setupWizard => 'Assistent de Configuració';

  @override
  String get welcome => 'Benvingut';

  @override
  String get welcomeMessage => 'Benvingut a Forsaken Emulator';

  @override
  String get next => 'Següent';

  @override
  String get previous => 'Anterior';

  @override
  String get finish => 'Finalitzar';

  @override
  String get skip => 'Ometre';

  @override
  String get setupComplete => 'Configuració Completada';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get selectEmulatorsPath => 'Seleccionar Ruta d\'Emuladors';

  @override
  String get selectRomsPath => 'Seleccionar Ruta de ROMs';

  @override
  String get selectMediaPath => 'Seleccionar Ruta de Mitjans';

  @override
  String get allSettingsConfigured => 'Tots els ajustos configurats';

  @override
  String get darkTheme => 'Fosc';

  @override
  String get lightTheme => 'Clar';

  @override
  String get systemTheme => 'Sistema';

  @override
  String get about => 'Sobre';

  @override
  String get checkForUpdates => 'Buscar Actualitzacions';

  @override
  String get noUpdatesAvailable => 'No hi ha actualitzacions disponibles';

  @override
  String get updateAvailable => 'Actualització disponible';

  @override
  String get downloadingUpdate => 'Descarregant actualització...';

  @override
  String get installingUpdate => 'Instal·lant actualització...';

  @override
  String get updateComplete => 'Actualització completada';

  @override
  String get updateFailed => 'Actualització fallida';

  @override
  String get networkError => 'Error de xarxa';

  @override
  String get connectionError => 'Error de connexió';

  @override
  String get timeoutError => 'Error de temps d\'espera';

  @override
  String get unknownError => 'Error desconegut';

  @override
  String get permissionDenied => 'Permís denegat';

  @override
  String get fileNotFound => 'Fitxer no trobat';

  @override
  String get directoryNotFound => 'Directori no trobat';

  @override
  String get diskFull => 'Disc ple';

  @override
  String get invalidPath => 'Ruta invàlida';

  @override
  String get pathNotWritable => 'Ruta no escrivible';

  @override
  String get romCorrupted => 'El fitxer ROM pot estar corrupte';

  @override
  String get zipError => 'Error d\'arxiu ZIP';

  @override
  String get extractionFailed => 'Extracció fallida';

  @override
  String get checksumMismatch => 'Discrepància de suma de verificació';

  @override
  String get biosCheckFailed => 'Comprovació de BIOS fallida';

  @override
  String get continueAnyway => 'Continuar de totes maneres';

  @override
  String get reportIssue => 'Reportar Problema';

  @override
  String get copyToClipboard => 'Copiar al porta-retalls';

  @override
  String get copiedToClipboard => 'Copiat al porta-retalls';

  @override
  String get share => 'Compartir';

  @override
  String get hide => 'Ocultar';

  @override
  String get show => 'Mostrar';

  @override
  String get toggleView => 'Alternar Vista';

  @override
  String get gridView => 'Vista de Quadrícula';

  @override
  String get listView => 'Vista de Llista';

  @override
  String get carouselView => 'Vista de Carrusel';

  @override
  String get sortBy => 'Ordenar per';

  @override
  String get sortByName => 'Nom';

  @override
  String get sortByDate => 'Data';

  @override
  String get sortBySize => 'Mida';

  @override
  String get sortByRegion => 'Regió';

  @override
  String get ascending => 'Ascendent';

  @override
  String get descending => 'Descendent';

  @override
  String get filter => 'Filtrar';

  @override
  String get filterByRegion => 'Filtrar per Regió';

  @override
  String get filterByGenre => 'Filtrar per Gènere';

  @override
  String get filterByYear => 'Filtrar per Any';

  @override
  String get clearFilters => 'Netejar Filtres';

  @override
  String get systemInfo => 'Info del Sistema';

  @override
  String get cpu => 'CPU';

  @override
  String get memory => 'Memòria';

  @override
  String get storageInfo => 'Emmagatzematge';

  @override
  String get os => 'Sistema Operatiu';

  @override
  String get emulatorVersion => 'Versió de l\'Emulador';

  @override
  String get totalRoms => 'Total de ROMs';

  @override
  String get totalSize => 'Mida Total';

  @override
  String get freeSpace => 'Espai Lliure';

  @override
  String get usedSpace => 'Espai Usat';

  @override
  String get systemUtilities => 'Utilitats del Sistema';

  @override
  String get romVerificationResults => 'Resultats de Verificació de ROMs';

  @override
  String get totalRomFiles => 'Total de fitxers ROM';

  @override
  String get emptyRomFiles => 'Fitxers ROM buits';

  @override
  String get validRomFiles => 'Fitxers ROM vàlids';

  @override
  String get romsDirectoryDoesNotExist => 'El directori de ROMs no existeix';

  @override
  String get gamelistCheckResults => 'Resultats de Comprovació de Gamelists';

  @override
  String get totalPlatforms => 'Total de plataformes';

  @override
  String get missingGamelists => 'Gamelists faltants';

  @override
  String get configurationBackup => 'Còpia de Seguretat de Configuració';

  @override
  String get configurationBackedUp => 'Configuració backupada a:';

  @override
  String get errorBackingUp => 'Error en fer backup de la configuració:';

  @override
  String get romDatabase => 'Base de Dades de ROMs';

  @override
  String get romDatabaseDownloaded =>
      'Base de dades de ROMs descarregada correctament';

  @override
  String get failedDownloadRomDatabase =>
      'Error en baixar la base de dades de ROMs';

  @override
  String get romDatabaseCleared => 'Base de dades de ROMs netejada';

  @override
  String get failedClearDatabase => 'Error en netejar la base de dades';

  @override
  String get downloadRomDatabase => 'Descarregar Base de Dades de ROMs';

  @override
  String get clearRomDatabase => 'Netejar Base de Dades de ROMs';

  @override
  String get systemRequirements => 'Requisits del Sistema';

  @override
  String get failedToCheckSystem => 'Error en comprovar el sistema';

  @override
  String cleanedUpTempFiles(String deletedCount) {
    return '$deletedCount fitxers ROM temporals netejats';
  }

  @override
  String get errorCleaningTempFiles => 'Error en netejar fitxers temporals:';

  @override
  String get errorVerifyingRomFiles => 'Error en verificar fitxers ROM:';

  @override
  String get errorCheckingGamelists => 'Error en comprovar gamelists:';

  @override
  String get cancelDownload => 'Cancel·lar Descàrrega';

  @override
  String get selectEmulator => 'Seleccionar Emulador';

  @override
  String get biosStatusDashboard => 'Tauler d\'Estat de BIOS';

  @override
  String get webSettings => 'Ajustos Web';

  @override
  String get saveSettings => 'Guardar Ajustos';

  @override
  String get errorSavingSettings => 'Error en guardar ajustos:';

  @override
  String romsCountItems(String count) {
    return '$count ROMs';
  }

  @override
  String get savedPermanently => 'guardat permanentment';

  @override
  String get keptInTemporary => 'mantingut a l\'emmagatzematge temporal';

  @override
  String get tryAgain => 'Tornar a Intentar';

  @override
  String get allDownloads => 'Totes les descàrregues completades';

  @override
  String romSavedPermanently(String name) {
    return '$name guardat permanentment';
  }

  @override
  String get undo => 'Desfer';

  @override
  String romKeptInTemporary(String name) {
    return '$name mantingut a l\'emmagatzematge temporal';
  }

  @override
  String romsCountWithSize(String count, String size) {
    return '$count ROMs • $size';
  }

  @override
  String get whatYouCanTry => 'El que pots provar:';

  @override
  String get tips => 'Consells';

  @override
  String get helpNavigateItems => 'Navegar entre elements';

  @override
  String get helpGamepadNavigation => 'Navegació amb mando';

  @override
  String get helpQuickNavigation =>
      'Navegació ràpida (saltar diversos elements)';

  @override
  String get helpGamepadPageNavigation => 'Navegació de pàgines amb mando';

  @override
  String get helpGoToFirst => 'Anar al primer element';

  @override
  String get helpGoToLast => 'Anar a l\'últim element';

  @override
  String get helpJumpToLetter =>
      'Saltar a l\'element que comenci amb aquesta lletra';

  @override
  String get helpSelectItem => 'Seleccionar element';

  @override
  String get helpGamepadSelect => 'Seleccionar amb mando';

  @override
  String get helpGoBackCloseDialogs => 'Tornar / Tancar diàlegs';

  @override
  String get helpExitApplication => 'Sortir de l\'aplicació';

  @override
  String get helpGamepadBackClose => 'Mando enrere / Tancar diàlegs';

  @override
  String get helpToggleViewMode =>
      'Alternar mode de vista (Quadrícula/Llista/Carrusel)';

  @override
  String get helpGamepadViewToggle => 'Canviar vista amb mando';

  @override
  String get helpRefreshView => 'Actualitzar vista actual';

  @override
  String get helpShowPlatformInfo => 'Mostrar informació de plataforma';

  @override
  String get helpActivateSearch => 'Activar cerca';

  @override
  String get helpGamepadSearch => 'Cerca amb mando';

  @override
  String get helpShowHelpDialog => 'Mostrar aquest diàleg d\'ajuda';

  @override
  String get helpGamepadHelp => 'Ajuda del mando';

  @override
  String get tipUseKeyboardOrGamepad => 'Utilitza teclat o mando per navegar';

  @override
  String get tipAlphabeticalJump =>
      'El salt alfabètic funciona a tots els modes de vista';

  @override
  String get tipPressQuestionMark =>
      'Prem ? en qualsevol moment per veure aquesta ajuda';

  @override
  String get tipGamepadAlongside =>
      'El mando funciona juntament amb els controls de teclat';

  @override
  String get configurePathsDescription =>
      'Configureu les rutes que fa servir l\'aplicació per localitzar ROMs, mitjans i emuladors.';

  @override
  String get romListsAutoManaged =>
      'Les llistes de ROMs ara es gestionen automàticament. Descarregueu-les de Configuració > Base de Dades de ROMs.';

  @override
  String get romStorage => 'Emmagatzematge de ROMs';

  @override
  String get configureRomStorageDescription =>
      'Configureu on s\'emmagatzemen les ROMs descarregades temporalment i permanentment.';

  @override
  String get resetToDefaults => 'Restablir a valors predeterminats';

  @override
  String get mediaPathLabel => 'Ruta de Mitjans';

  @override
  String get mediaPathHint => 'Directori amb mitjans (imatges, vídeos)';

  @override
  String get emulatorsPathLabel => 'Ruta d\'Emuladors';

  @override
  String get emulatorsPathHint => 'Directori amb binaris d\'emuladors';

  @override
  String get gamelistPathAutomatic => 'Ruta de Gamelist (Automàtica)';

  @override
  String get gamelistAutoDescription =>
      'Les gamelists ara es gestionen automàticament al directori de dades de l\'ap. Això fa l\'app completament independent i prepara per a la distribució futura de gamelists des de GitHub.';

  @override
  String get tempRomStorageLabel =>
      'Emmagatzematge Temporal de ROMs (Opcional)';

  @override
  String get tempRomStorageDescription =>
      'Les ROMs es descarreguen aquí primer. Poden promoure\'s a emmagatzematge permanent après de jugar.';

  @override
  String get permanentRomStorageLabel =>
      'Emmagatzematge Permanent de ROMs (Opcional)';

  @override
  String get permanentRomStorageDescription =>
      'Les ROMs guardades permanentment s\'emmagatzemen aquí. Aquestes no es netegen automàticament.';

  @override
  String get defaultAppSupportDir =>
      'Predeterminat: directori de suport de l\'app';

  @override
  String currentPathDisplay(String path) {
    return 'Actual: $path';
  }

  @override
  String get configurationFile => 'Fitxer de Configuració';

  @override
  String get source => 'Font:';

  @override
  String get customConfigActive => 'Configuració personalitzada activa';

  @override
  String get pathStructure => 'Estructura de Rutes';

  @override
  String get pathStructureDescription =>
      'Ruta de Mitjans: MEDIA_PATH/plataforma/boxart|screenshots|videos/rom.png\nRuta de Gamelist: ~/.local/share/com.example.emulator/gamelists/plataforma/gamelist.xml (automàtica)\nRuta d\'Emuladors: EMULATORS_PATH/emulador_binari';

  @override
  String get errorCheckingSystem => 'Error en comprovar el sistema';

  @override
  String get recheckR => 'Re-comprovar (R)';

  @override
  String get allRequiredToolsInstalled =>
      'Totes les Eines Requertes Instal·lades';

  @override
  String get missingRequiredTools => 'Eines Requertes Faltants';

  @override
  String get systemReadyToUse =>
      'El teu sistema està llest per usar l\'emulador';

  @override
  String get someRequiredToolsMissing => 'Falten algunes eines requerides';

  @override
  String get requiredTools => 'Eines Requertes';

  @override
  String get requiredToolsDescription =>
      'Aquestes eines són necessàries per baixar i extreure emuladors';

  @override
  String get installationInstructions => 'Instruccions d\'Instal·lació';

  @override
  String get installed => 'Instal·lat';

  @override
  String get missing => 'Faltant';

  @override
  String get downloadEmulatorsAndGameLists =>
      'Descarregar emuladors i llistes de jocs';

  @override
  String get quickActions => 'Accions Ràpides';

  @override
  String get downloadAll => 'Descarregar Tot';

  @override
  String get byCategory => 'Per Categoria';

  @override
  String get downloadQueue => 'Cua de Descàrrega';

  @override
  String get noDownloadsInProgress => 'No hi ha descàrregues en curs';

  @override
  String get selectQuickActionToStart =>
      'Selecciona una acció ràpida a dalt per començar a descarregar';

  @override
  String get categorySony => 'Sony (PS1-PS4)';

  @override
  String get categoryNintendo => 'Nintendo (GC, Wii, Switch)';

  @override
  String get categoryMicrosoft => 'Microsoft (Xbox, Xbox 360)';

  @override
  String get categoryMultiPlatform => 'Multi-Plataforma (RetroArch)';

  @override
  String get categoryOtherEmulators => 'Altres Emuladors';

  @override
  String get categoryUtilities => 'Utilitats';

  @override
  String confirmDownloadDescription(String count, String size) {
    return 'Descarregar $count emulador(s)?\nMida estimada: ~$size MB\n\nAixò pot trigar una estona depenent de la teva connexió a internet.';
  }

  @override
  String get alreadyInstalled => 'Ja instal·lat';

  @override
  String get starting => 'Iniciant...';

  @override
  String get completed => 'Completat';

  @override
  String get gameListsAlreadyDownloaded => 'Llistes de jocs ja descarregades';

  @override
  String get redownload => 'Re-Descarregar';

  @override
  String get gameListsFromGitHub => 'Llistes de Jocs (des de GitHub)';

  @override
  String get downloaded => 'Descarregat';

  @override
  String get cancelled => 'Cancel·lat';

  @override
  String get missingFor => 'Faltant per:';

  @override
  String get noCustomConfigToBackup =>
      'No hi ha configuració personalitzada per backup. Utilitzant valors predeterminats.';

  @override
  String get saveConfigurationBackup =>
      'Guardar Còpia de Seguretat de Configuració';

  @override
  String get refreshStatsR => 'Actualitzar estadístiques (R)';

  @override
  String get systemStatistics => 'Estadístiques del Sistema';

  @override
  String get romFiles => 'Fitxers ROM';

  @override
  String get maintenanceTools => 'Eines de Manteniment';

  @override
  String get cleanupTemporaryRoms => 'Netejar ROMs Temporals';

  @override
  String get cleanupTemporaryRomsDescription =>
      'Eliminar fitxers ROM temporals del directori temporal del sistema';

  @override
  String get verifyRomFiles => 'Verificar Fitxers ROM';

  @override
  String get verifyRomFilesDescription =>
      'Comprovar que tots els fitxers ROM existeixen i són vàlids';

  @override
  String get checkMissingGamelists => 'Comprovar Gamelists Faltants';

  @override
  String get checkMissingGamelistsDescription =>
      'Trobar plataformes sense fitxer gamelist.xml';

  @override
  String get backupConfiguration => 'Backup de Configuració';

  @override
  String get backupConfigurationDescription =>
      'Crear una còpia de seguretat de config.json';

  @override
  String get downloadingRomDatabase => 'Descarregant Base de Dades de ROMs...';

  @override
  String get downloadMayTakeMinutes =>
      'Això pot trigar uns minuts depenent de la teva connexió...';

  @override
  String get databaseStatus => 'Estat de la Base de Dades';

  @override
  String get notDownloaded => 'No Descarregada';

  @override
  String get aboutRomDatabase => 'Sobre la Base de Dades de ROMs';

  @override
  String get aboutRomDatabaseDescription =>
      'La base de dades de ROMs conté llistes de ROMs disponibles organitzades per plataforma. Es descarrega del repositori romList de Forsaken a GitHub.';

  @override
  String get romDatabaseSource => 'Font: github.com/ForsakenStation/romList';

  @override
  String get downloadRomDatabaseDescription =>
      'Això descarregarà les llistes de ROMs del repositori romList de Forsaken a GitHub.';

  @override
  String get downloadRomDatabaseStats =>
      'Mida: ~7 MB\nPlataformes: 138\nTotal de ROMs: ~240.000';

  @override
  String get downloadWillOverwrite =>
      'Nota: Això sobreescriurà les dades existents.';

  @override
  String get clearRomDatabaseDescription =>
      'Això eliminarà totes les llistes de ROMs descarregades i restablirà la base de dades al seu estat inicial.';

  @override
  String get gamelistsStatus => 'Estat de Gamelists';

  @override
  String get gamelistsDownloaded => 'Descarregades';

  @override
  String get gamelistsNotDownloaded => 'No Descarregades';

  @override
  String get aboutGamelists => 'Sobre les Gamelists';

  @override
  String get aboutGamelistsDescription =>
      'Les gamelists contenen metadades de jocs (noms, descripcions, valoracions) per a cada plataforma. Es descarreguen del repositori gamelists de Forsaken a GitHub.';

  @override
  String get gamelistsSource => 'Font: github.com/ForsakenStation/gamelists';

  @override
  String get downloadGamelists => 'Descarregar Gamelists';

  @override
  String get downloadGamelistsDescription =>
      'Això descarregarà fitxers gamelist.xml del repositori gamelists de Forsaken a GitHub.';

  @override
  String get downloadGamelistsWillOverwrite =>
      'Nota: Això sobreescriurà els fitxers gamelist existents.';

  @override
  String get downloadingGamelists => 'Descarregant Gamelists...';

  @override
  String get gamelistsDownloadedSuccess =>
      'Gamelists descarregades correctament';

  @override
  String get failedDownloadGamelists => 'Error en descarregar gamelists';

  @override
  String get clearGamelists => 'Netejar Gamelists';

  @override
  String get clearGamelistsDescription =>
      'Això eliminarà tots els fitxers gamelist descarregats.';

  @override
  String get gamelistsCleared => 'Gamelists netejades';

  @override
  String get failedClearGamelists => 'Error en netejar gamelists';

  @override
  String get rebuildMediaCache => 'Reconstruir Memòria Cau de Mitjans';

  @override
  String get rebuildMediaCacheDescription =>
      'Escanejar directoris de mitjans i emmagatzemar rutes a gamelists per a una càrrega més ràpida';

  @override
  String get rebuildMediaCacheConfirmTitle =>
      'Reconstruir Memòria Cau de Mitjans?';

  @override
  String get rebuildMediaCacheConfirmBody =>
      'Això escanejarà tots els directoris de mitjans i actualitzarà fitxers gamelist.xml amb rutes de mitjans. Això pot trigar un moment per a col·leccions grans.';

  @override
  String get rebuildMediaCacheProgress =>
      'Reconstruint memòria cau de mitjans...';

  @override
  String rebuildMediaCacheProcessingPlatform(
    String platform,
    String current,
    String total,
  ) {
    return 'Processant $platform ($current/$total)';
  }

  @override
  String get rebuildMediaCacheComplete => 'Memòria Cau de Mitjans Reconstruïda';

  @override
  String rebuildMediaCacheSummary(
    String platforms,
    String games,
    String updated,
    String paths,
  ) {
    return '$platforms plataformes, $games jocs escanejats, $updated actualitzats, $paths rutes de mitjans emmagatzemades';
  }

  @override
  String get rebuildMediaCacheError =>
      'Error en reconstruir la memòria cau de mitjans';

  @override
  String rebuildMediaCacheErrors(String count) {
    return '$count errors van ocórrer durant la reconstrucció';
  }

  @override
  String get description => 'Descripció';

  @override
  String get noDescriptionAvailable =>
      'No hi ha descripció disponible per a aquesta ROM.';

  @override
  String get releaseDate => 'Data de llançament';

  @override
  String get players => 'Jugadors';

  @override
  String get rating => 'Valoració';

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
  String get playInBrowser => 'Jugar al navegador';

  @override
  String downloadingPlatformBios(String platformName) {
    return 'Descarregant BIOS de $platformName';
  }

  @override
  String get downloadingAllMissingBios =>
      'Descarregant totes les BIOS que falten';

  @override
  String biosFileLabel(String filename) {
    return 'Fitxer: $filename';
  }

  @override
  String batchProgressLabel(String completed, String total) {
    return 'Progrés: $completed/$total fitxers';
  }

  @override
  String get fileDetails => 'Detalls del fitxer:';

  @override
  String get waiting => 'Esperant...';

  @override
  String get verifying => 'Verificant...';

  @override
  String get failed => 'Fallat';

  @override
  String get preparing => 'Preparant...';

  @override
  String get downloadingFiles => 'Descarregant fitxers...';

  @override
  String get someDownloadsFailed => 'Algunes descàrregues han fallat';

  @override
  String get downloadsCancelled => 'Descàrregues cancel·lades';

  @override
  String get calculating => 'Calculant...';

  @override
  String secondsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count segons',
      one: '1 segon',
    );
    return '$_temp0';
  }

  @override
  String minutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuts',
      one: '1 minut',
    );
    return '$_temp0';
  }

  @override
  String hoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hores',
      one: '1 hora',
    );
    return '$_temp0';
  }

  @override
  String get downloadingAndLaunching => 'Descarregant i llançant...';

  @override
  String get launching => 'Llançant...';

  @override
  String emulatorLabel(String name) {
    return 'Emulador: $name';
  }

  @override
  String get generalInformation => 'Informació general';

  @override
  String get manufacturer => 'Fabricant';

  @override
  String get releaseYear => 'Any de llançament';

  @override
  String get generation => 'Generació';

  @override
  String get technicalSpecifications => 'Especificacions tècniques';

  @override
  String get resolution => 'Resolució';

  @override
  String get colors => 'Colors';

  @override
  String get notNow => 'Ara no';

  @override
  String get saveRomPermanently => 'Desar ROM permanentment?';

  @override
  String get keepRomOfflineQuestion =>
      'Vols conservar aquesta ROM descarregada per jugar sense connexió?';

  @override
  String get deletedToSaveSpace =>
      'Si no, s\'eliminarà més tard per estalviar espai.';

  @override
  String get view => 'Veure';

  @override
  String get media => 'Mitjans';

  @override
  String get navigate => 'Navegar';

  @override
  String get info => 'Info';

  @override
  String get toggleFilter => 'Alternar filtre';

  @override
  String get changeTheme => 'Canviar tema';

  @override
  String get keyboard => 'Teclat';

  @override
  String get gamepad => 'Mando';

  @override
  String get hideKeyboard => 'Amagar teclat';

  @override
  String get gameManual => 'Manual del Joc';

  @override
  String get pdfDocument => 'Document PDF';

  @override
  String get manual => 'Manual';

  @override
  String get video => 'Vídeo';

  @override
  String get zoomOut => 'Allunyar';

  @override
  String get zoomIn => 'Apropar';

  @override
  String pageCounter(String current, String total) {
    return 'Pàgina $current / $total';
  }

  @override
  String get zoom => 'Zoom';

  @override
  String get firstLast => 'Primer/Últim';

  @override
  String get scroll => 'Desplaçar';

  @override
  String get loadingVideo => 'Carregant vídeo...';

  @override
  String get playPause => 'Reproduir/Pausar';

  @override
  String get useArrowKeysToNavigate =>
      'Usa les tecles de direcció o fes lliscar per navegar';

  @override
  String get searchRomsHint => 'Buscar ROMs...';

  @override
  String get cancelSearch => 'Cancel·lar Cerca';

  @override
  String get virtualKeyboard => 'Teclat Virtual';

  @override
  String get noRomsAvailable => 'No hi ha ROMs disponibles';

  @override
  String get noRomsForPlatformMessage =>
      'No s\'han trobat fitxers ROM per a aquesta plataforma. Els fitxers ROM s\'han de col·locar com a fitxers .txt que continguin URLs de descàrrega al directori de la plataforma.';

  @override
  String get noMatchingRoms => 'No hi ha ROMs coincidents';

  @override
  String get tryDifferentSearch => 'Prova amb un terme de cerca diferent';

  @override
  String get saveToPermanentStorage => 'Guardar a l\'emmagatzematge permanent';

  @override
  String get temporary => 'Temporal';

  @override
  String get permanent => 'Permanent';

  @override
  String get tempPathLabel => 'Temp';

  @override
  String get foreverPathLabel => 'Forever';

  @override
  String get storageOverview => 'Resum d\'Emmagatzematge';

  @override
  String get clearTemporaryStorage => 'Netejar emmagatzematge temporal';

  @override
  String filesCount(String count) {
    return '$count fitxers';
  }

  @override
  String pathDisplay(String label, String path) {
    return 'Ruta de $label: $path';
  }

  @override
  String get unknown => 'Desconegut';

  @override
  String get tagVerifiedGoodDump =>
      'Volcament verificat i correcte - funcionament confirmat';

  @override
  String get tagBadDump =>
      'Volcament defectuós - pot no funcionar correctament';

  @override
  String get tagAlternateVersion => 'Versió alternativa';

  @override
  String get tagOverdump => 'Sobrebolcament - conté dades addicionals';

  @override
  String get tagModifiedHacked => 'ROM modificada/hackejada';

  @override
  String get tagFanTranslation => 'Traducció de fans';

  @override
  String get tagPirateBootleg => 'Versió pirata/bootleg';

  @override
  String get tagFixedVersion => 'Versió corregida';

  @override
  String get tagCheatTrainer => 'Inclou trainer de trucs';

  @override
  String tagVersion(String text) {
    return 'Versió: $text';
  }

  @override
  String tagSpecialRelease(String text) {
    return 'Llançament especial: $text';
  }

  @override
  String tagMediaInfo(String text) {
    return 'Info de mitjans: $text';
  }

  @override
  String noEmulatorConfigured(
    String displayName,
    String platform,
    String configPath,
  ) {
    return 'No hi ha cap emulador configurat per a $displayName.\n\nSi us plau, afegiu la configuració per a \"$platform\" a:\n$configPath';
  }

  @override
  String get noEmulatorCommandAvailable =>
      'No hi ha cap ordre d\'emulador disponible';

  @override
  String platformNotSupportedWeb(String platform, String supportedPlatforms) {
    return 'La plataforma \"$platform\" encara no és compatible amb el navegador web.\n\nPlataformes compatibles: $supportedPlatforms';
  }

  @override
  String failedToLaunchWebEmulator(String error) {
    return 'No s\'ha pogut iniciar l\'emulador web: $error';
  }

  @override
  String failedToLaunchRom(String error) {
    return 'No s\'ha pogut iniciar la ROM.\n\nComproveu que:\n• L\'emulador està instal·lat correctament\n• El fitxer ROM és vàlid\n• La configuració és correcta\n\nError: $error';
  }

  @override
  String errorLaunchingRom(String error) {
    return 'Error en iniciar la ROM: $error';
  }

  @override
  String noInfoAvailable(String platformName) {
    return 'No hi ha informació disponible per a $platformName';
  }

  @override
  String get platformInfoTooltip => 'Info de la plataforma (I)';

  @override
  String get navigationHint =>
      'Utilitza les tecles de fletxa o llisca per navegar';

  @override
  String get noGamesFound => 'No s\'han trobat jocs';

  @override
  String get noGamesFoundForSearch => 'No s\'han trobat jocs per a la cerca';

  @override
  String get tryDifferentSearchOrClear =>
      'Prova amb un altre terme de cerca o esborra el filtre';

  @override
  String get checkStorageOrDownload =>
      'Comprova la configuració d\'emmagatzematge o descarrega algunes ROMs';

  @override
  String get searchGamesHint => 'Cercar jocs...';

  @override
  String get settingsHeaderTitle => 'Configuració de l\'Emulador Forsaken';

  @override
  String get settingsHeaderSubtitle =>
      'Configurar emuladors, rutes i descarregar contingut';

  @override
  String get emulatorManagementDesc =>
      'Afegir, editar i configurar ordres d\'emuladors';

  @override
  String get systemPaths => 'Rutes del sistema';

  @override
  String get systemPathsDesc => 'Configurar rutes de ROMs, mitjans i emuladors';

  @override
  String get romDatabaseDesc =>
      'Descarregar i gestionar llistes de ROMs des de GitHub';

  @override
  String get romStorageDesc =>
      'Gestionar ROMs descarregades, emmagatzematge i neteja de fitxers temporals';

  @override
  String get downloadManagerDesc =>
      'Descarregar emuladors, llistes de ROMs i dades de jocs';

  @override
  String get systemRequirementsDesc =>
      'Comprovar eines i dependències requerides';

  @override
  String get gamepadTestDebug => 'Prova i depuració del comandament';

  @override
  String get gamepadTestDebugDesc =>
      'Provar botons del comandament, eixos i resoldre problemes';

  @override
  String get biosFirmwareHelpDesc =>
      'Comprovar fitxers BIOS i requisits de firmware';

  @override
  String get webSettingsDesc => 'Proxy CORS i configuració de plataforma web';

  @override
  String get setupWizardDesc =>
      'Tornar a executar l\'assistent de configuració inicial';

  @override
  String get languageDesc => 'Seleccionar l\'idioma de l\'aplicació';

  @override
  String get aboutDebug => 'Quant a i depuració';

  @override
  String get aboutDebugDesc =>
      'Informació de l\'aplicació i configuració de depuració';

  @override
  String get legalDisclaimer => 'Avís legal';

  @override
  String get romDatabaseCredits =>
      'Les llistes de ROMs provenen originalment del repositori AndroidRoms d\'Arley4d:';

  @override
  String get romDatabaseThanks =>
      'Agraïment especial al projecte AndroidRoms per mantenir bases de dades completes de ROMs amb finalitats de preservació.';

  @override
  String get biosFilesSection => 'Fitxers BIOS';

  @override
  String get biosFilesCredits =>
      'Els fitxers BIOS provenen del repositori retroarch_system d\'Abdess:';

  @override
  String get biosFilesThanks =>
      'Aquest repositori conté fitxers de sistema i BIOS requerits per diverses plataformes d\'emulació. Agraïment especial als mantenidors per preservar aquests fitxers essencials.';

  @override
  String get amigaCopyProtection =>
      'Suport de protecció contra còpia d\'Amiga proporcionat per la biblioteca capsimg:';

  @override
  String get amigaCopyProtectionThanks =>
      'Agraïment especial a rsn8887 per mantenir la biblioteca capsimg que permet el suport d\'imatges de disc IPF (protegides contra còpia) per a emulació d\'Amiga.';

  @override
  String get additionalBiosFiles =>
      'Fitxers BIOS addicionals proporcionats pel projecte RetroPieBios:';

  @override
  String get additionalBiosThanks =>
      'Gràcies a PIBSAS/RetroPieBios per proporcionar variants addicionals de BIOS i fitxers regionals que milloren la compatibilitat entre diferents sistemes i regions.';

  @override
  String get enabled => 'Activat';

  @override
  String get disabled => 'Desactivat';

  @override
  String get disclaimerRequired =>
      'Heu d\'acceptar l\'avís legal per continuar.';

  @override
  String get emulatorsPathRequired =>
      'La ruta del directori d\'emuladors és obligatòria.';

  @override
  String get emulatorConfigPathRequired =>
      'La ruta del fitxer de configuració de l\'emulador és obligatòria.';

  @override
  String get mediaPathRequired => 'La ruta dels mitjans és obligatòria.';

  @override
  String get tempRomPathRequired =>
      'La ruta d\'emmagatzematge temporal de ROMs és obligatòria.';

  @override
  String get permanentRomPathRequired =>
      'La ruta d\'emmagatzematge permanent de ROMs és obligatòria.';

  @override
  String wizardStepCounter(int current, int total) {
    return 'Pas $current / $total';
  }

  @override
  String get emulatorConfiguration => 'Configuració de l\'emulador';

  @override
  String get emulatorConfigStepDesc =>
      'Establiu les rutes on estan instal·lats els emuladors. Podeu canviar-les més tard a Configuració > Rutes del sistema.';

  @override
  String get emulatorsDirectory => 'Directori d\'emuladors';

  @override
  String get pathToEmulatorBinaries => 'Ruta als binaris de l\'emulador';

  @override
  String get emulatorConfigFile => 'Fitxer de configuració de l\'emulador';

  @override
  String get pathToEmulatorConfig =>
      'Ruta al JSON de configuració de l\'emulador';

  @override
  String get storagePaths => 'Rutes d\'emmagatzematge';

  @override
  String get storagePathsStepDesc =>
      'Configureu on s\'emmagatzemen els recursos multimèdia i els fitxers ROM. Podeu canviar-les més tard a Configuració > Rutes del sistema.';

  @override
  String get wizardMediaPathHint => 'Caràtules, captures de pantalla i vídeos';

  @override
  String get temporaryRomStorage => 'Emmagatzematge temporal de ROMs';

  @override
  String get temporaryRomStorageHint =>
      'ROMs descarregades per a sessions de joc úniques';

  @override
  String get permanentRomStorage => 'Emmagatzematge permanent de ROMs';

  @override
  String get permanentRomStorageHint => 'ROMs desades per jugar sense connexió';

  @override
  String get allSet => 'Tot llest!';

  @override
  String get wizardEmulatorReady =>
      'L\'emulador Forsaken està llest per utilitzar.';

  @override
  String get changeSettingsLater =>
      'Podeu canviar qualsevol d\'aquestes configuracions més tard des de la pantalla de Configuració.';

  @override
  String get configurationSummary => 'Resum de configuració';

  @override
  String get summaryEmulators => 'Emuladors';

  @override
  String get summaryMedia => 'Mitjans';

  @override
  String get summaryTempRoms => 'ROMs temporals';

  @override
  String get summarySavedRoms => 'ROMs desades';

  @override
  String get defaultValue => '(predeterminat)';

  @override
  String pdfPageIndicator(int current, int total) {
    return 'Pàgina $current de $total';
  }

  @override
  String get pdfZoomOut => 'Reduir zoom (-)';

  @override
  String get pdfZoomIn => 'Ampliar zoom (+)';

  @override
  String get pdfResetZoom => 'Restablir zoom (0)';

  @override
  String get pdfFirstPage => 'Primera pàgina (Home)';

  @override
  String get pdfPreviousPage => 'Pàgina anterior (←/PgUp)';

  @override
  String get pdfNextPage => 'Pàgina següent (→/PgDn)';

  @override
  String get pdfLastPage => 'Última pàgina (End)';

  @override
  String get pdfFileNotFound => 'Fitxer PDF no trobat';

  @override
  String confirmDeleteEmulator(String system) {
    return 'Esteu segur que voleu eliminar la configuració de l\'emulador per a $system?';
  }

  @override
  String commandsConfigured(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comandes configurades',
      one: '1 comanda configurada',
    );
    return '$_temp0';
  }

  @override
  String get noCommand => 'Cap comanda';

  @override
  String get reloadConfigTooltip => 'Recarregar configuració (R)';

  @override
  String get configurationInfo => 'Informació de configuració';

  @override
  String get configLocation => 'Ubicació de la configuració:';

  @override
  String get hasLocalOverridesYes => 'Té substitucions locals: Sí';

  @override
  String get hasLocalOverridesNo => 'Té substitucions locals: No';

  @override
  String get changesSavedToDevice =>
      'Els canvis es desen a l\'emmagatzematge del dispositiu.';

  @override
  String get usingBundledConfig =>
      'Usant configuració inclosa. Editeu per crear substitucions locals.';

  @override
  String get noEmulatorsConfigured => 'No hi ha emuladors configurats';

  @override
  String get addFirstEmulator =>
      'Afegiu el vostre primer emulador per començar';

  @override
  String get edit => 'Editar';

  @override
  String get editEmulator => 'Editar emulador';

  @override
  String get system => 'Sistema';

  @override
  String get systemHint => 'e.g., nes, snes, ps1';

  @override
  String get commands => 'Comandes';

  @override
  String commandNumber(int number) {
    return 'Comanda $number';
  }

  @override
  String get commandHint => 'e.g., ../retroarch.AppImage -f -L core.so';

  @override
  String get remove => 'Eliminar';

  @override
  String get options => 'Opcions';

  @override
  String get biosDownloading => 'Descarregant...';

  @override
  String downloadRequiredAndExtras(int requiredCount, int optionalCount) {
    return 'Descarregar $requiredCount obligatoris + $optionalCount extres';
  }

  @override
  String downloadRequiredFiles(int requiredCount) {
    return 'Descarregar $requiredCount fitxers obligatoris';
  }

  @override
  String downloadOptionalExtras(int optionalCount) {
    return 'Descarregar $optionalCount extres opcionals';
  }

  @override
  String get downloadFiles => 'Descarregar fitxers';

  @override
  String batchDownloadConfirmation(int totalFiles, int platformCount) {
    return 'Es descarregaran $totalFiles fitxers BIOS per a $platformCount plataformes:';
  }

  @override
  String get downloadSourceNote =>
      'Els fitxers es descarregaran del repositori retroarch_system.';

  @override
  String get biosOptional => 'OPCIONAL';

  @override
  String biosFilesFound(int foundCount, int totalCount) {
    return '$foundCount/$totalCount fitxers trobats';
  }

  @override
  String optionalExtrasAvailable(int count) {
    return '+$count extres opcionals disponibles';
  }

  @override
  String get biosLocations => 'Ubicacions:';

  @override
  String get availableForDownload =>
      'Disponible per descarregar de múltiples fonts';

  @override
  String get summary => 'Resum';

  @override
  String get biosComplete => 'Complet';

  @override
  String get biosPartial => 'Parcial';

  @override
  String get biosFiles => 'Fitxers';

  @override
  String get biosDownloadable => 'Descarregable';

  @override
  String get refreshF5Tooltip => 'Actualitzar (F5)';

  @override
  String get allBiosFilesFound => 'Tots els fitxers BIOS trobats!';

  @override
  String get noBiosRequirements => 'No s\'han trobat requisits de BIOS';

  @override
  String platformCount(int count) {
    return '$count plataformes';
  }

  @override
  String failedToLoadBiosStatus(String error) {
    return 'Error en carregar l\'estat de BIOS: $error';
  }

  @override
  String get refreshStatus => 'Actualitzar estat';

  @override
  String platformsCompleteCount(int complete, int total) {
    return '$complete/$total plataformes completes';
  }

  @override
  String get platformStatusHeader => 'Estat de les plataformes';

  @override
  String filesVerifiedStatus(
    int presentFiles,
    int totalFiles,
    int verifiedFiles,
  ) {
    return '$presentFiles/$totalFiles fitxers ($verifiedFiles verificats)';
  }

  @override
  String get biosCollectionOverview => 'Resum de la col·lecció BIOS';

  @override
  String get biosVerified => 'Verificat';

  @override
  String downloadComingSoon(String platformName) {
    return 'Funcionalitat de descàrrega per a $platformName - Properament!';
  }

  @override
  String get noGamepadConnected => 'Cap comandament connectat';

  @override
  String get connectGamepadPrompt =>
      'Connecta un comandament i prem qualsevol botó';

  @override
  String get pressButtonToTest =>
      'Prem qualsevol botó per provar (accions desactivades)';

  @override
  String get buttonFunctionTests => 'Proves de funcions de botons';

  @override
  String get gamepadASelect => 'A (Seleccionar)';

  @override
  String get gamepadBBack => 'B (Enrere)';

  @override
  String get gamepadXSearch => 'X (Cercar)';

  @override
  String get gamepadYHelp => 'Y (Ajuda)';

  @override
  String get gamepadLBPageDown => 'LB (Pàgina avall)';

  @override
  String get gamepadRBPageUp => 'RB (Pàgina amunt)';

  @override
  String get gamepadStartMenu => 'Start (Menú)';

  @override
  String get gamepadSelectSettings => 'Select (Configuració)';

  @override
  String get gamepadLSClick => 'LS Clic';

  @override
  String get gamepadRSView => 'RS Clic (Vista)';

  @override
  String get gamepadLTTrigger => 'LT (Gallet)';

  @override
  String get gamepadRTTrigger => 'RT (Gallet)';

  @override
  String get rawButtonStates => 'Estats dels botons sense processar';

  @override
  String get noButtonsPressed => 'Cap botó premut';

  @override
  String get axisValues => 'Valors dels eixos';

  @override
  String get noAxisMovement => 'Sense moviment d\'eixos';

  @override
  String get dpadLeftStick => 'D-Pad + Stick esquerre';

  @override
  String get webSettingsDescription =>
      'Configura els ajustos específics de la plataforma web';

  @override
  String get corsProxyWhyNeeded => 'Per què cal un proxy CORS?';

  @override
  String get corsProxyExplanation =>
      'Els navegadors bloquegen les descàrregues de ROM des de servidors externs a causa de les restriccions de seguretat CORS. Un proxy CORS retransmet la sol·licitud des d\'un servidor que controles, afegint les capçaleres necessàries.\n\nForsaken inclou un Cloudflare Worker que pots desplegar gratuïtament (100k sol·licituds/dia). Consulta el directori tools/cors-proxy-worker/ per a instruccions de configuració.';

  @override
  String get corsProxyUrl => 'URL del proxy CORS';

  @override
  String get corsProxyHelperText =>
      'Deixa buit per desactivar el proxy CORS (les ROM de servidors sense CORS fallaran)';

  @override
  String get testingProxy => 'Provant el proxy...';

  @override
  String get testProxyConnection => 'Prova la connexió del proxy';

  @override
  String get noProxyUrlConfigured => 'No hi ha URL de proxy configurada';

  @override
  String proxyWorking(int statusCode) {
    return 'El proxy funciona (HTTP $statusCode)';
  }

  @override
  String proxyReturnedHttp(int statusCode) {
    return 'El proxy ha retornat HTTP $statusCode';
  }

  @override
  String get connectionTimedOut => 'S\'ha esgotat el temps de connexió';

  @override
  String get corsProxySettingsSaved =>
      'Configuració del proxy CORS desada. S\'aplica immediatament per a nous llançaments de ROM.';

  @override
  String get quickDeploy => 'Desplegament ràpid';

  @override
  String get corsProxyDeploySteps =>
      '1. Registra\'t a dash.cloudflare.com (gratuït)\n2. Instal·la Wrangler: npm install -g wrangler\n3. Inicia sessió: wrangler login\n4. cd tools/cors-proxy-worker\n5. npx wrangler deploy\n6. Enganxa la URL del worker a dalt';

  @override
  String get permanentStorage => 'Emmagatzematge permanent';

  @override
  String get temporaryStorage => 'Emmagatzematge temporal';

  @override
  String get noDownloadedRoms => 'No hi ha ROM descarregades';

  @override
  String get biosErrorNetworkMessage => 'Ha fallat la connexió de xarxa';

  @override
  String get biosErrorNetworkSuggestions =>
      'Comproveu la vostra connexió a Internet\nTorneu a provar d\'aquí a uns moments\nVerifiqueu la configuració de DNS\nProveu d\'utilitzar una VPN si l\'accés està restringit';

  @override
  String get biosErrorFileNotFoundMessage => 'Fitxer no trobat al servidor';

  @override
  String get biosErrorFileNotFoundSuggestions =>
      'El fitxer BIOS pot haver estat mogut o reanomenat\nProveu de descarregar des d\'una font alternativa\nComproveu si el fitxer existeix en una branca/repositori diferent\nInformeu d\'aquest problema si persisteix';

  @override
  String get biosErrorAccessDeniedMessage => 'Accés denegat pel servidor';

  @override
  String get biosErrorAccessDeniedSuggestions =>
      'El servidor pot estar bloquejant les descàrregues\nTorneu a provar més tard - el servidor pot estar temporalment restringit\nUtilitzeu una VPN si l\'accés està restringit per regió\nComproveu si cal autenticació';

  @override
  String get biosErrorRateLimitedMessage =>
      'S\'ha excedit el límit de peticions';

  @override
  String get biosErrorRateLimitedSuggestions =>
      'Espereu uns minuts abans de tornar a provar\nReducïu el nombre de descàrregues simultànies\nEl servidor es protegeix contra peticions excessives';

  @override
  String get biosErrorChecksumMessage =>
      'Ha fallat la verificació d\'integritat del fitxer';

  @override
  String get biosErrorChecksumSuggestions =>
      'El fitxer pot haver-se corromput durant la descàrrega\nProveu de descarregar de nou\nComproveu si el fitxer s\'ha actualitzat al servidor\nVerifiqueu l\'estabilitat de la vostra connexió a Internet';

  @override
  String get biosErrorSizeMismatchMessage => 'Mida del fitxer inesperada';

  @override
  String get biosErrorSizeMismatchSuggestions =>
      'El fitxer pot ser una versió diferent de l\'esperada\nLa descàrrega pot estar incompleta\nProveu de descarregar de nou\nComproveu l\'espai disponible al disc';

  @override
  String get biosErrorStorageMessage => 'Error d\'emmagatzematge';

  @override
  String get biosErrorStorageSuggestions =>
      'Allibereu espai al disc\nComproveu els permisos dels fitxers\nAssegureu-vos que el directori de destinació permet l\'escriptura\nProveu de descarregar en una ubicació diferent';

  @override
  String get biosErrorTimeoutMessage => 'Temps d\'espera de descàrrega esgotat';

  @override
  String get biosErrorTimeoutSuggestions =>
      'La connexió a Internet pot ser lenta\nEl servidor pot estar sobrecarregat\nTorneu a provar amb una connexió estable\nComproveu si el tallafoc bloqueja la connexió';

  @override
  String get biosErrorArchiveMessage => 'Ha fallat l\'extracció de l\'arxiu';

  @override
  String get biosErrorArchiveSuggestions =>
      'L\'arxiu descarregat pot estar corromput\nProveu de descarregar el fitxer de nou\nComproveu si l\'eina d\'extracció correcta està disponible\nVerifiqueu que el fitxer té un format d\'arxiu vàlid';

  @override
  String get biosErrorUnknownMessage => 'Ha fallat la descàrrega';

  @override
  String get biosErrorUnknownSuggestions =>
      'Proveu de descarregar de nou\nComproveu la vostra connexió a Internet\nVerifiqueu que el fitxer encara està disponible\nContacteu amb el suport si el problema persisteix';

  @override
  String get wizardDownloadEmulators => 'Baixar emuladors';

  @override
  String get wizardDownloadEmulatorsDesc =>
      'Baixa els binaris d\'emuladors preconfigurats per a la teva plataforma. Pots baixar-los tots o seleccionar per categoria.';

  @override
  String get wizardDownloadRomLists => 'Baixar llistes de ROMs';

  @override
  String get wizardDownloadRomListsDesc =>
      'Baixa els fitxers de base de dades de ROMs des de GitHub. Contenen metadades per organitzar la teva biblioteca de jocs.';

  @override
  String get wizardDownloadGamelists => 'Baixar gamelists';

  @override
  String get wizardDownloadGamelistsDesc =>
      'Baixa fitxers gamelist.xml des de GitHub. Contenen noms de jocs, descripcions, puntuacions i altres metadades.';

  @override
  String get wizardSkipStep => 'Omet';

  @override
  String get wizardDownloadComplete => 'Baixada completada!';

  @override
  String wizardDownloadFailed(String error) {
    return 'Error en la baixada: $error';
  }

  @override
  String get wizardAlreadyDownloaded => 'Ja baixat';

  @override
  String get wizardSelectCategory =>
      'Selecciona una categoria per baixar, o baixa-ho tot:';

  @override
  String get wizardDownloading => 'Baixant...';

  @override
  String get wizardDownloadOptional =>
      'Aquest pas és opcional. Pots baixar-ho més tard des de Configuració.';

  @override
  String get archiveOrgSettings => 'Compte d\'Archive.org';

  @override
  String get archiveOrgSettingsDesc =>
      'Configurar credencials d\'Archive.org per a la descàrrega de ROMs';

  @override
  String get archiveOrgSettingsDescription =>
      'Algunes ROMs estan allotjades a Archive.org i requereixen autenticació per descarregar-les. Configureu les vostres claus API S3 aquí.';

  @override
  String get archiveOrgWhyNeeded => 'Per què calen les credencials?';

  @override
  String get archiveOrgExplanation =>
      'Alguns fitxers a Archive.org requereixen un compte amb sessió iniciada per descarregar-los. Forsaken utilitza claus API d\'estil S3 perquè la vostra contrasenya no s\'emmagatzemi mai.\n\nGenereu les vostres claus a:\nhttps://archive.org/account/s3.php';

  @override
  String get archiveOrgAccessKey => 'Clau d\'accés';

  @override
  String get archiveOrgSecretKey => 'Clau secreta';

  @override
  String get archiveOrgAccessKeyHint => 'La vostra clau d\'accés d\'estil S3';

  @override
  String get archiveOrgSecretKeyHint => 'La vostra clau secreta d\'estil S3';

  @override
  String get archiveOrgSettingsSaved => 'Credencials d\'Archive.org desades.';

  @override
  String get archiveOrgAuthRequired => 'Autenticació requerida';

  @override
  String get archiveOrgAuthRequiredMessage =>
      'Aquest fitxer requereix un compte d\'Archive.org per descarregar-lo.\n\nSi us plau, configureu les vostres claus API S3 d\'Archive.org a Configuració per continuar.';

  @override
  String get goToSettings => 'Anar a Configuració';
}
