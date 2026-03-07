// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Galician (`gl`).
class AppLocalizationsGl extends AppLocalizations {
  AppLocalizationsGl([String locale = 'gl']) : super(locale);

  @override
  String get appTitle => 'Forsaken Emulator';

  @override
  String get retroGamingFrontend => 'Interface de Xogos Retro';

  @override
  String get platforms => 'Plataformas';

  @override
  String get roms => 'ROMs';

  @override
  String get settings => 'Configuración';

  @override
  String get settingsAndConfiguration => 'Configuración e Axustes';

  @override
  String get aboutForsakenEmulator => 'Sobre Forsaken Emulator';

  @override
  String get version => 'Versión';

  @override
  String get appDescription =>
      'Un interface de emulador multiplataforma moderno construído con Flutter.';

  @override
  String get emulators => 'Emuladores';

  @override
  String get ready => 'Listo';

  @override
  String get back => 'Atrás';

  @override
  String get select => 'Seleccionar';

  @override
  String get search => 'Buscar';

  @override
  String get refresh => 'Actualizar';

  @override
  String get loading => 'Cargando...';

  @override
  String get error => 'Erro';

  @override
  String get initializationError => 'Erro de Inicialización';

  @override
  String get retry => 'Reintentar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get ok => 'Aceptar';

  @override
  String get save => 'Gardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get yes => 'Si';

  @override
  String get no => 'Non';

  @override
  String get close => 'Pechar';

  @override
  String get noRomsFound => 'Non se atoparon ROMs';

  @override
  String get noPlatformsFound => 'Non se atoparon plataformas';

  @override
  String get checkRomsPath => 'Comproba a variable de contorno ROMS_PATH';

  @override
  String get downloading => 'Descargando...';

  @override
  String get downloadComplete => 'Descarga completada';

  @override
  String get downloadFailed => 'Descarga fallida';

  @override
  String get emulatorNotFound => 'Emulador non atopado';

  @override
  String get romNotFound => 'ROM non atopada';

  @override
  String get biosRequired => 'OBRIGATORIO';

  @override
  String get systemCheck => 'Comprobación do Sistema';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get systemDefault => 'Predeterminado do sistema';

  @override
  String get help => 'Axuda';

  @override
  String get keyboardAndGamepadControls => 'Controis de Teclado e Mando';

  @override
  String get navigation => 'Navegación';

  @override
  String get actions => 'Accións';

  @override
  String get viewControls => 'Controis de Vista';

  @override
  String get gotIt => 'Entendido!';

  @override
  String get exit => 'Saír';

  @override
  String get exitApplication => 'Saír da Aplicación';

  @override
  String get exitConfirm => 'Estás seguro de que queres saír?';

  @override
  String get downloadManager => 'Xestor de Descargas';

  @override
  String get clearCompleted => 'Limpar Completados';

  @override
  String get selectCategory => 'Seleccionar Categoría';

  @override
  String get confirmDownload => 'Confirmar Descarga';

  @override
  String get downloadGameLists => 'Descargar Listas de Xogos';

  @override
  String get downloadGameListsDescription =>
      'Isto descargará as listas de ROMs desde GitHub.';

  @override
  String get gameListsDownloaded => 'Listas de xogos descargadas!';

  @override
  String get romStorageManagement => 'Xestión de Almacenamento de ROMs';

  @override
  String get deleteRom => 'Eliminar ROM?';

  @override
  String deleteRomConfirm(String fileName) {
    return 'Eliminar $fileName?';
  }

  @override
  String get actionCannotBeUndone => 'Esta acción non se pode desfacer.';

  @override
  String deleted(String fileName) {
    return 'Eliminado: $fileName';
  }

  @override
  String get savePermanently => 'Gardar Permanentemente?';

  @override
  String moveRomConfirm(String fileName) {
    return 'Mover $fileName ao almacenamento permanente?';
  }

  @override
  String saved(String fileName) {
    return 'Gardado: $fileName';
  }

  @override
  String get clearAll => 'Limpar Todo?';

  @override
  String get clearAllConfirm => 'Eliminar todas as ROMs temporais?';

  @override
  String get allCleared => 'Todas as ROMs temporais limpas';

  @override
  String get systemPathsConfiguration => 'Configuración de Rutas do Sistema';

  @override
  String get migrateRoms => 'Migrar ROMs?';

  @override
  String get migrateRomsDescription =>
      'A ruta de almacenamento permanente das ROMs cambiou de \$oldPath a \$newPath. Queres migrar as ROMs existentes ao novo lugar?';

  @override
  String get noKeepThem => 'Non, mantelas';

  @override
  String get yesMigrateRoms => 'Si, migrar ROMs';

  @override
  String get migratingRoms => 'Migrando ROMs...';

  @override
  String get romMigrationFailed => 'Aviso: A migración de ROMs fallou';

  @override
  String get pathsSaved => 'Rutas gardadas exitosamente';

  @override
  String get errorSavingPaths => 'Erro ao gardar rutas:';

  @override
  String get resetConfiguration => 'Restablecer Configuración';

  @override
  String get resetConfigDescription =>
      'Isto restablecerá todas as rutas aos seus valores predeterminados. As túas ROMs e ficheiros multimedia non se verás afectados.';

  @override
  String get configurationReset =>
      'Configuración restablecida aos valores predeterminados';

  @override
  String get errorResettingConfiguration =>
      'Erro ao restablecer a configuración:';

  @override
  String get savePaths => 'Gardar Rutas';

  @override
  String get saving => 'Gardando...';

  @override
  String get emulatorManagement => 'Xestión de Emuladores';

  @override
  String get configurationReloaded => 'Configuración recargada';

  @override
  String get errorLoadingEmulators => 'Erro ao cargar emuladores:';

  @override
  String get emulatorAdded => 'Emulador engadido exitosamente';

  @override
  String get errorAddingEmulator => 'Erro ao engadir emulador:';

  @override
  String get emulatorUpdated => 'Emulador actualizado exitosamente';

  @override
  String get errorUpdatingEmulator => 'Erro ao actualizar emulador:';

  @override
  String get deleteEmulator => 'Eliminar Emulador';

  @override
  String get emulatorDeleted => 'Emulador eliminado';

  @override
  String get errorDeletingEmulator => 'Erro ao eliminar emulador:';

  @override
  String get configurationSource => 'Fonte de Configuración';

  @override
  String get addEmulator => 'Engadir Emulador';

  @override
  String get systemNameRequired => 'O nome do sistema é necesario';

  @override
  String get commandRequired => 'Falta polo menos un comando';

  @override
  String get addCommand => 'Engadir Comando';

  @override
  String get acceptZipFiles => 'Aceptar ficheiros ZIP';

  @override
  String get acceptZipSubtitle => 'Permitir lanzar ROMs desde arquivos ZIP';

  @override
  String get useForeverMode => 'Usar Modo Forever';

  @override
  String get useForeverSubtitle => 'Manter emulador executándose';

  @override
  String get workInProgress => 'Traballo en Progreso';

  @override
  String get wipSubtitle => 'Marcar como aínda non completamente configurado';

  @override
  String get biosFirmwareHelp => 'Axuda de BIOS e Firmware';

  @override
  String get downloadMissingFiles => 'Descargar Ficheiros Faltantes';

  @override
  String get showOnlyMissing => 'Mostrar só faltantes';

  @override
  String get downloadAllMissingBios => 'Descargar Todos os BIOS Faltantes';

  @override
  String get configurationError => 'Erro de Configuración';

  @override
  String get configurationErrorDescription =>
      'A aplicación non puido atopar a configuración requirida.\nPor favor configura as túas rutas en Configuración > Rutas do Sistema.';

  @override
  String get configurationRequired =>
      'Requirido:\n- Ruta de Multimedia: directorio con activos multimedia\n- Ruta de Emuladores: directorio con binarios de emuladores\n\nOpcional:\n- Rutas de almacenamento de ROMs para descargas temporais/permanentes';

  @override
  String get goToSettingsToConfigure =>
      'Ir a Configuración > Rutas do Sistema para configurar';

  @override
  String get noDownloadableBios => 'Non faltan ficheiros BIOS baixables';

  @override
  String get allDownloadsCompleted =>
      'Todas as descargas completadas exitosamente!';

  @override
  String get batchDownloadFailed => 'Descarga por lotes fallida:';

  @override
  String get download => 'Descargar';

  @override
  String get downloadCancelled => 'Descarga cancelada';

  @override
  String get launched => 'Lanzado:';

  @override
  String get failedToSave => 'Erro ao gardar a ROM permanentemente';

  @override
  String get failedToSaveRom => 'Erro ao gardar a ROM permanentemente';

  @override
  String get errorSaving => 'Erro ao gardar a ROM:';

  @override
  String errorSavingRom(String error) {
    return 'Erro ao gardar a ROM: $error';
  }

  @override
  String get openFolder => 'Abrir Cartafol';

  @override
  String get viewManual => 'Ver Manual';

  @override
  String get play => 'Xogar';

  @override
  String get goBack => 'Voltar';

  @override
  String get clearSearch => 'Limpar Busca';

  @override
  String get iUnderstand => 'Entendo e acepto estes termos';

  @override
  String get start => 'Iniciar';

  @override
  String get debugMode => 'Modo Depuración: ';

  @override
  String get toggleDebugMode => 'Alternar Modo Depuración';

  @override
  String get preparingDownload => 'Preparando descarga...';

  @override
  String get noEmulatorsAvailable =>
      'Non hai emuladores dispoñibles para esta categoría';

  @override
  String get failedToLaunch => 'Erro ao lanzar o emulador web:';

  @override
  String get platformInfo => 'Info de Plataforma';

  @override
  String get emulatorPlatformInfo => 'Info de Plataforma do Emulador';

  @override
  String get favorites => 'Favoritos';

  @override
  String get all => 'Todo';

  @override
  String get collections => 'Coleccións';

  @override
  String get searchRoms => 'Buscar ROMs...';

  @override
  String get searchPlatforms => 'Buscar plataformas...';

  @override
  String romsCount(int count) {
    return '$count ROMs';
  }

  @override
  String platformsCount(int count) {
    return '$count plataformas';
  }

  @override
  String get region => 'Rexión';

  @override
  String get genre => 'Xénero';

  @override
  String get year => 'Ano';

  @override
  String get publisher => 'Editor';

  @override
  String get developer => 'Desenvolvedor';

  @override
  String get playWithNetplay => 'Xogar con Netplay';

  @override
  String get downloadBios => 'Descargar BIOS';

  @override
  String get viewDetails => 'Ver Detalles';

  @override
  String get addToFavorites => 'Engadir aos Favoritos';

  @override
  String get removeFromFavorites => 'Quitar dos Favoritos';

  @override
  String get biosMissing => 'Ausente';

  @override
  String get biosPresent => 'BIOS presente';

  @override
  String get checkingBios => 'Comprobando BIOS...';

  @override
  String get emulatorDownloading => 'Descargando emulador...';

  @override
  String get emulatorDownloadComplete => 'Emulador descargado';

  @override
  String get emulatorDownloadFailed => 'Erro ao descargar emulador';

  @override
  String get installingEmulator => 'Instalando emulador...';

  @override
  String get emulatorReady => 'Emulador listo';

  @override
  String get configuration => 'Configuración';

  @override
  String get paths => 'Rutas';

  @override
  String get storage => 'Almacenamento';

  @override
  String get emulatorsPath => 'Ruta de Emuladores';

  @override
  String get romsPath => 'Ruta de ROMs';

  @override
  String get mediaPath => 'Ruta de Multimedia';

  @override
  String get biosPath => 'Ruta de BIOS';

  @override
  String get tempPath => 'Ruta Temporal';

  @override
  String get browse => 'Examinar';

  @override
  String get apply => 'Aplicar';

  @override
  String get reset => 'Restablecer';

  @override
  String get clear => 'Limpar';

  @override
  String get scan => 'Escanear';

  @override
  String get scanForRoms => 'Escanear ROMs';

  @override
  String get scanningRoms => 'Escaneando ROMs...';

  @override
  String get scanComplete => 'Escaneo completado';

  @override
  String romsFound(int count) {
    return '$count ROMs atopadas';
  }

  @override
  String get noNewRomsFound => 'Non se atoparon novas ROMs';

  @override
  String get launchEmulator => 'Lanzar Emulador';

  @override
  String get emulatorError => 'Erro do Emulador';

  @override
  String get gamepadConnected => 'Mando conectado';

  @override
  String get gamepadDisconnected => 'Mando desconectado';

  @override
  String get gamepadTest => 'Probar Mando';

  @override
  String get pressAnyButton => 'Preme calquera botón para probar';

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
  String get dpadUp => 'D-Pad Arriba';

  @override
  String get dpadDown => 'D-Pad Abaixo';

  @override
  String get dpadLeft => 'D-Pad Esquerda';

  @override
  String get dpadRight => 'D-Pad Dereita';

  @override
  String get leftShoulder => 'L1';

  @override
  String get rightShoulder => 'R1';

  @override
  String get leftTrigger => 'L2';

  @override
  String get rightTrigger => 'R2';

  @override
  String get leftStick => 'Stick Esquerdo';

  @override
  String get rightStick => 'Stick dereito';

  @override
  String get setupWizard => 'Asistente de Configuración';

  @override
  String get welcome => 'Benvido';

  @override
  String get welcomeMessage => 'Benvido a Forsaken Emulator';

  @override
  String get next => 'Seguinte';

  @override
  String get previous => 'Anterior';

  @override
  String get finish => 'Finalizar';

  @override
  String get skip => 'Omitir';

  @override
  String get setupComplete => 'Configuración Completada';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get selectEmulatorsPath => 'Seleccionar Ruta de Emuladores';

  @override
  String get selectRomsPath => 'Seleccionar Ruta de ROMs';

  @override
  String get selectMediaPath => 'Seleccionar Ruta de Multimedia';

  @override
  String get allSettingsConfigured => 'Todas as configuracións configuradas';

  @override
  String get darkTheme => 'Escuro';

  @override
  String get lightTheme => 'Claro';

  @override
  String get systemTheme => 'Sistema';

  @override
  String get about => 'Sobre';

  @override
  String get checkForUpdates => 'Buscar Actualizacións';

  @override
  String get noUpdatesAvailable => 'Non hai actualizacións dispoñibles';

  @override
  String get updateAvailable => 'Actualización dispoñible';

  @override
  String get downloadingUpdate => 'Descargando actualización...';

  @override
  String get installingUpdate => 'Instalando actualización...';

  @override
  String get updateComplete => 'Actualización completada';

  @override
  String get updateFailed => 'Actualización fallida';

  @override
  String get networkError => 'Erro de rede';

  @override
  String get connectionError => 'Erro de conexión';

  @override
  String get timeoutError => 'Erro de tempo de espera';

  @override
  String get unknownError => 'Erro descoñecido';

  @override
  String get permissionDenied => 'Permiso denegado';

  @override
  String get fileNotFound => 'Ficheiro non atopado';

  @override
  String get directoryNotFound => 'Directorio non atopado';

  @override
  String get diskFull => 'Disco cheo';

  @override
  String get invalidPath => 'Ruta inválida';

  @override
  String get pathNotWritable => 'Ruta non escribible';

  @override
  String get romCorrupted => 'O ficheiro ROM pode estar corrupto';

  @override
  String get zipError => 'Erro de arquivo ZIP';

  @override
  String get extractionFailed => 'Extracción fallida';

  @override
  String get checksumMismatch => 'Discrepancia de suma de verificación';

  @override
  String get biosCheckFailed => 'Comprobación de BIOS fallida';

  @override
  String get continueAnyway => 'Continuar de todos xeitos';

  @override
  String get reportIssue => 'Reportar Problema';

  @override
  String get copyToClipboard => 'Copiar ao portapapeis';

  @override
  String get copiedToClipboard => 'Copiado ao portapapeis';

  @override
  String get share => 'Compartir';

  @override
  String get hide => 'Ocultar';

  @override
  String get show => 'Mostrar';

  @override
  String get toggleView => 'Alternar Vista';

  @override
  String get gridView => 'Vista de Grade';

  @override
  String get listView => 'Vista de Lista';

  @override
  String get carouselView => 'Vista de Carrousel';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get sortByName => 'Nome';

  @override
  String get sortByDate => 'Data';

  @override
  String get sortBySize => 'Tamaño';

  @override
  String get sortByRegion => 'Rexión';

  @override
  String get ascending => 'Ascendente';

  @override
  String get descending => 'Descendente';

  @override
  String get filter => 'Filtrar';

  @override
  String get filterByRegion => 'Filtrar por Rexión';

  @override
  String get filterByGenre => 'Filtrar por Xénero';

  @override
  String get filterByYear => 'Filtrar por Ano';

  @override
  String get clearFilters => 'Limpar Filtros';

  @override
  String get systemInfo => 'Info do Sistema';

  @override
  String get cpu => 'CPU';

  @override
  String get memory => 'Memoria';

  @override
  String get storageInfo => 'Almacenamento';

  @override
  String get os => 'Sistema Operativo';

  @override
  String get emulatorVersion => 'Versión do Emulador';

  @override
  String get totalRoms => 'Total de ROMs';

  @override
  String get totalSize => 'Tamaño Total';

  @override
  String get freeSpace => 'Espazo Libre';

  @override
  String get usedSpace => 'Espazo Usado';

  @override
  String get systemUtilities => 'Utilidades do Sistema';

  @override
  String get romVerificationResults => 'Resultados de Verificación de ROMs';

  @override
  String get totalRomFiles => 'Total de ficheiros ROM';

  @override
  String get emptyRomFiles => 'Ficheiros ROM baleiros';

  @override
  String get validRomFiles => 'Ficheiros ROM válidos';

  @override
  String get romsDirectoryDoesNotExist => 'O directorio de ROMs non existe';

  @override
  String get gamelistCheckResults => 'Resultados de Comprobación de Gamelists';

  @override
  String get totalPlatforms => 'Total de plataformas';

  @override
  String get missingGamelists => 'Gamelists faltantes';

  @override
  String get configurationBackup => 'Copia de Seguridade de Configuración';

  @override
  String get configurationBackedUp => 'Configuración gardada en:';

  @override
  String get errorBackingUp => 'Erro ao facer copia de seguridade:';

  @override
  String get romDatabase => 'Base de Datos de ROMs';

  @override
  String get romDatabaseDownloaded =>
      'Base de datos de ROMs descargada exitosamente';

  @override
  String get failedDownloadRomDatabase =>
      'Erro ao descargar a base de datos de ROMs';

  @override
  String get romDatabaseCleared => 'Base de datos de ROMs limpa';

  @override
  String get failedClearDatabase => 'Erro ao limpar a base de datos';

  @override
  String get downloadRomDatabase => 'Descargar Base de Datos de ROMs';

  @override
  String get clearRomDatabase => 'Limpar Base de Datos de ROMs';

  @override
  String get systemRequirements => 'Requisitos do Sistema';

  @override
  String get failedToCheckSystem => 'Erro ao comprobar o sistema';

  @override
  String cleanedUpTempFiles(String deletedCount) {
    return 'Limpados $deletedCount ficheiros ROM temporais';
  }

  @override
  String get errorCleaningTempFiles => 'Erro ao limpar ficheiros temporais:';

  @override
  String get errorVerifyingRomFiles => 'Erro ao verificar ficheiros ROM:';

  @override
  String get errorCheckingGamelists => 'Erro ao comprobar gamelists:';

  @override
  String get cancelDownload => 'Cancelar Descarga';

  @override
  String get selectEmulator => 'Seleccionar Emulador';

  @override
  String get biosStatusDashboard => 'Panel de Estado de BIOS';

  @override
  String get webSettings => 'Axustes Web';

  @override
  String get saveSettings => 'Gardar Axustes';

  @override
  String get errorSavingSettings => 'Erro ao gardar axustes:';

  @override
  String romsCountItems(String count) {
    return '$count ROMs';
  }

  @override
  String get savedPermanently => 'gardado permanentemente';

  @override
  String get keptInTemporary => 'mantido no almacenamento temporal';

  @override
  String get tryAgain => 'Tentar de Novo';

  @override
  String get allDownloads => 'Todas as descargas completadas';

  @override
  String romSavedPermanently(String name) {
    return '$name gardado permanentemente';
  }

  @override
  String get undo => 'Desfacer';

  @override
  String romKeptInTemporary(String name) {
    return '$name mantido no almacenamento temporal';
  }

  @override
  String romsCountWithSize(String count, String size) {
    return '$count ROMs • $size';
  }

  @override
  String get whatYouCanTry => 'O que podes intentar:';

  @override
  String get tips => 'Consellos';

  @override
  String get helpNavigateItems => 'Navegar entre elementos';

  @override
  String get helpGamepadNavigation => 'Navegación con mando';

  @override
  String get helpQuickNavigation =>
      'Navegación rápida (saltar varios elementos)';

  @override
  String get helpGamepadPageNavigation => 'Navegación de páxinas con mando';

  @override
  String get helpGoToFirst => 'Ir ao primeiro elemento';

  @override
  String get helpGoToLast => 'Ir ao último elemento';

  @override
  String get helpJumpToLetter => 'Saltar ao elemento quecomece con esa letra';

  @override
  String get helpSelectItem => 'Seleccionar elemento';

  @override
  String get helpGamepadSelect => 'Seleccionar con mando';

  @override
  String get helpGoBackCloseDialogs => 'Voltar / Pechar diálogos';

  @override
  String get helpExitApplication => 'Saír da aplicación';

  @override
  String get helpGamepadBackClose => 'Mando atrás / Pechar diálogos';

  @override
  String get helpToggleViewMode =>
      'Alternar modo de vista (Grade/Lista/Carrousel)';

  @override
  String get helpGamepadViewToggle => 'Cambiar vista con mando';

  @override
  String get helpRefreshView => 'Actualizar vista actual';

  @override
  String get helpShowPlatformInfo => 'Mostrar información de plataforma';

  @override
  String get helpActivateSearch => 'Activar busca';

  @override
  String get helpGamepadSearch => 'Busca con mando';

  @override
  String get helpShowHelpDialog => 'Mostrar este diálogo de axuda';

  @override
  String get helpGamepadHelp => 'Axuda do mando';

  @override
  String get tipUseKeyboardOrGamepad => 'Usa teclado ou mando para navegar';

  @override
  String get tipAlphabeticalJump =>
      'O salto alfabético funciona en todos os modos de vista';

  @override
  String get tipPressQuestionMark =>
      'Preme ? en calquera momento para ver esta axuda';

  @override
  String get tipGamepadAlongside =>
      'O mando funciona xunto cos controis de teclado';

  @override
  String get configurePathsDescription =>
      'Configura as rutas que usa a aplicación para localizar ROMs, multimedia e emuladores.';

  @override
  String get romListsAutoManaged =>
      'As listas de ROMs xestiónanse automaticamente agora. Descarégueas desde Configuración > Base de Datos de ROMs.';

  @override
  String get romStorage => 'Almacenamento de ROMs';

  @override
  String get configureRomStorageDescription =>
      'Configura onde se almacenan as ROMs descargadas temporal e permanentemente.';

  @override
  String get resetToDefaults => 'Restablecer aos predeterminados';

  @override
  String get mediaPathLabel => 'Ruta de Multimedia';

  @override
  String get mediaPathHint => 'Directorio con multimedia ()';

  @override
  String get emulatorsPathLabel => 'Ruta deimaxes, vídeos Emuladores';

  @override
  String get emulatorsPathHint => 'Directorio con binarios de emuladores';

  @override
  String get gamelistPathAutomatic => 'Ruta de Gamelist (Automática)';

  @override
  String get gamelistAutoDescription =>
      'As gamelists xestiónanse automaticamente no directorio de datos da app. Isto fai a app completamente independente e prepáraa para a futura distribución de gamelists desde GitHub.';

  @override
  String get tempRomStorageLabel => 'Almacenamento Temporal de ROMs (Opcional)';

  @override
  String get tempRomStorageDescription =>
      'As ROMs descárganse aquí primeiro. Poden promocionarse ao almacenamento permanente despois de xogar.';

  @override
  String get permanentRomStorageLabel =>
      'Almacenamento Permanente de ROMs (Opcional)';

  @override
  String get permanentRomStorageDescription =>
      'As ROMs gardadas永久mente almacénense aquí. Estas non se limpian automaticamente.';

  @override
  String get defaultAppSupportDir =>
      'Predeterminado: directorio de soporte da app';

  @override
  String currentPathDisplay(String path) {
    return 'Actual: $path';
  }

  @override
  String get configurationFile => 'Ficheiro de Configuración';

  @override
  String get source => 'Fonte:';

  @override
  String get customConfigActive => 'Configuración personalizada activa';

  @override
  String get pathStructure => 'Estrutura de Rutas';

  @override
  String get pathStructureDescription =>
      'Ruta de Multimedia: MEDIA_PATH/plataforma/boxart|screenshots|videos/rom.png\nRuta de Gamelist: ~/.local/share/com.example.emulator/gamelists/plataforma/gamelist.xml (automática)\nRuta de Emuladores: EMULATORS_PATH/emulador_binario';

  @override
  String get errorCheckingSystem => 'Erro ao comprobar o sistema';

  @override
  String get recheckR => 'Re-comprobar (R)';

  @override
  String get allRequiredToolsInstalled =>
      'Todas as Ferramentas Requiridas Instaladas';

  @override
  String get missingRequiredTools => 'Ferramentas Requiridas Faltantes';

  @override
  String get systemReadyToUse =>
      'O teu sistema está listo para usar o emulador';

  @override
  String get someRequiredToolsMissing =>
      'Faltan algunas ferramientas requiridas';

  @override
  String get requiredTools => 'Ferramentas Requiridas';

  @override
  String get requiredToolsDescription =>
      'Estas ferramientas son necesarias para descargar e extraer emuladores';

  @override
  String get installationInstructions => 'Instrucións de Instalación';

  @override
  String get installed => 'Instalado';

  @override
  String get missing => 'Faltante';

  @override
  String get downloadEmulatorsAndGameLists =>
      'Descargar emuladores e listas de xogos';

  @override
  String get quickActions => 'Accións Rápidas';

  @override
  String get downloadAll => 'Descargar Todo';

  @override
  String get byCategory => 'Por Categoría';

  @override
  String get downloadQueue => 'Cola de Descarga';

  @override
  String get noDownloadsInProgress => 'Non hai descargas en progreso';

  @override
  String get selectQuickActionToStart =>
      'Selecciona unha acción rápida enriba para empezar a descargar';

  @override
  String get categorySony => 'Sony (PS1-PS4)';

  @override
  String get categoryNintendo => 'Nintendo (GC, Wii, Switch)';

  @override
  String get categoryMicrosoft => 'Microsoft (Xbox, Xbox 360)';

  @override
  String get categoryMultiPlatform => 'Multi-Plataforma (RetroArch)';

  @override
  String get categoryOtherEmulators => 'Outros Emuladores';

  @override
  String get categoryUtilities => 'Utilidades';

  @override
  String confirmDownloadDescription(String count, String size) {
    return 'Descargar $count emulador(es)?\nTamaño estimado: ~$size MB\n\nIsto pode levar un tempo dependendo da túa conexión a internet.';
  }

  @override
  String get alreadyInstalled => 'Xa instalado';

  @override
  String get starting => 'Iniciando...';

  @override
  String get completed => 'Completado';

  @override
  String get gameListsAlreadyDownloaded => 'Listas de xogos xa descargadas';

  @override
  String get redownload => 'Re-Descargar';

  @override
  String get gameListsFromGitHub => 'Listas de Xogos (desde GitHub)';

  @override
  String get downloaded => 'Descargado';

  @override
  String get cancelled => 'Cancelado';

  @override
  String get missingFor => 'Faltante para:';

  @override
  String get noCustomConfigToBackup =>
      'Non hai configuración personalizada para facer copia. Usando predeterminados.';

  @override
  String get saveConfigurationBackup =>
      'Gardar Copia de Seguridade de Configuración';

  @override
  String get refreshStatsR => 'Actualizar estatísticas (R)';

  @override
  String get systemStatistics => 'Estatísticas do Sistema';

  @override
  String get romFiles => 'Ficheiros ROM';

  @override
  String get maintenanceTools => 'Ferramentas de Mantemento';

  @override
  String get cleanupTemporaryRoms => 'Limpar ROMs Temporais';

  @override
  String get cleanupTemporaryRomsDescription =>
      'Eliminar ficheiros ROM temporais do directorio temporal do sistema';

  @override
  String get verifyRomFiles => 'Verificar Ficheiros ROM';

  @override
  String get verifyRomFilesDescription =>
      'Comprobar que todos os ficheiros ROM existen e son válidos';

  @override
  String get checkMissingGamelists => 'Comprobar Gamelists Faltantes';

  @override
  String get checkMissingGamelistsDescription =>
      'Atopar plataformas sen ficheiro gamelist.xml';

  @override
  String get backupConfiguration => 'Copia de Seguridade de Configuración';

  @override
  String get backupConfigurationDescription =>
      'Crear unha copia de seguridade de config.json';

  @override
  String get downloadingRomDatabase => 'Descargando Base de Datos de ROMs...';

  @override
  String get downloadMayTakeMinutes =>
      'Isto pode levar uns minutos dependendo da túa conexión...';

  @override
  String get databaseStatus => 'Estado da Base de Datos';

  @override
  String get notDownloaded => 'Non Descargada';

  @override
  String get aboutRomDatabase => 'Sobre a Base de Datos de ROMs';

  @override
  String get aboutRomDatabaseDescription =>
      'A base de datos de ROMs contén listas de ROMs dispoñibles organizadas por plataforma. Descárgase desde o repositorio romList de Forsaken en GitHub.';

  @override
  String get romDatabaseSource => 'Fonte: github.com/ForsakenStation/romList';

  @override
  String get downloadRomDatabaseDescription =>
      'Isto descargará as listas de ROMs desde o repositorio romList de Forsaken en GitHub.';

  @override
  String get downloadRomDatabaseStats =>
      'Tamaño: ~7 MB\nPlataformas: 138\nTotal de ROMs: ~240,000';

  @override
  String get downloadWillOverwrite =>
      'Nota: Isto sobrescribirá os datos existentes.';

  @override
  String get clearRomDatabaseDescription =>
      'Isto eliminará todas as listas de ROMs descargadas e restablecerá a base de datos ao seu estado inicial.';

  @override
  String get gamelistsStatus => 'Estado das Gamelists';

  @override
  String get gamelistsDownloaded => 'Descargadas';

  @override
  String get gamelistsNotDownloaded => 'Non Descargadas';

  @override
  String get aboutGamelists => 'Sobre as Gamelists';

  @override
  String get aboutGamelistsDescription =>
      'As gamelists conteñen metadatos de xogos (nomes, descricións, valoracións) para cada plataforma. Descárganse desde o repositorio gamelists de Forsaken en GitHub.';

  @override
  String get gamelistsSource => 'Fonte: github.com/ForsakenStation/gamelists';

  @override
  String get downloadGamelists => 'Descargar Gamelists';

  @override
  String get downloadGamelistsDescription =>
      'Isto descargará ficheiros gamelist.xml desde o repositorio gamelists de Forsaken en GitHub.';

  @override
  String get downloadGamelistsWillOverwrite =>
      'Nota: Isto sobrescribirá os ficheiros gamelist existentes.';

  @override
  String get downloadingGamelists => 'Descargando Gamelists...';

  @override
  String get gamelistsDownloadedSuccess => 'Gamelists descargadas exitosamente';

  @override
  String get failedDownloadGamelists => 'Erro ao descargar gamelists';

  @override
  String get clearGamelists => 'Limpar Gamelists';

  @override
  String get clearGamelistsDescription =>
      'Isto eliminará todos os ficheiros gamelist descargados.';

  @override
  String get gamelistsCleared => 'Gamelists limpas';

  @override
  String get failedClearGamelists => 'Erro ao limpar gamelists';

  @override
  String get rebuildMediaCache => 'Reconstruír Cache de Multimedia';

  @override
  String get rebuildMediaCacheDescription =>
      'Escanear directorios multimedia e cachear rutas nas gamelists para unha carga máis rápida';

  @override
  String get rebuildMediaCacheConfirmTitle =>
      'Reconstruír Cache de Multimedia?';

  @override
  String get rebuildMediaCacheConfirmBody =>
      'Isto escaneará todos os directorios multimedia e actualizará ficheiros gamelist.xml con rutas multimedia. Isto pode levar un momento para coleccións grandes.';

  @override
  String get rebuildMediaCacheProgress =>
      'Reconstruíndo cache de multimedia...';

  @override
  String rebuildMediaCacheProcessingPlatform(
    String platform,
    String current,
    String total,
  ) {
    return 'Procesando $platform ($current/$total)';
  }

  @override
  String get rebuildMediaCacheComplete => 'Cache de Multimedia Reconstruída';

  @override
  String rebuildMediaCacheSummary(
    String platforms,
    String games,
    String updated,
    String paths,
  ) {
    return '$platforms plataformas, $games xogos escaneados, $updated actualizados, $paths rutas multimedia cacheadas';
  }

  @override
  String get rebuildMediaCacheError =>
      'Erro ao reconstruír cache de multimedia';

  @override
  String rebuildMediaCacheErrors(String count) {
    return '$count erros ocorreron durante a reconstrución';
  }

  @override
  String get description => 'Descrición';

  @override
  String get noDescriptionAvailable =>
      'Non hai descrición dispoñible para esta ROM.';

  @override
  String get releaseDate => 'Data de lanzamento';

  @override
  String get players => 'Xogadores';

  @override
  String get rating => 'Valoración';

  @override
  String get regions => 'Rexións';

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
  String get playInBrowser => 'Xogar no navegador';

  @override
  String downloadingPlatformBios(String platformName) {
    return 'Descargando BIOS de $platformName';
  }

  @override
  String get downloadingAllMissingBios =>
      'Descargando todas as BIOS que faltan';

  @override
  String biosFileLabel(String filename) {
    return 'Ficheiro: $filename';
  }

  @override
  String batchProgressLabel(String completed, String total) {
    return 'Progreso: $completed/$total ficheiros';
  }

  @override
  String get fileDetails => 'Detalles do ficheiro:';

  @override
  String get waiting => 'Agardando...';

  @override
  String get verifying => 'Verificando...';

  @override
  String get failed => 'Fallou';

  @override
  String get preparing => 'Preparando...';

  @override
  String get downloadingFiles => 'Descargando ficheiros...';

  @override
  String get someDownloadsFailed => 'Algunhas descargas fallaron';

  @override
  String get downloadsCancelled => 'Descargas canceladas';

  @override
  String get calculating => 'Calculando...';

  @override
  String secondsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count segundos',
      one: '1 segundo',
    );
    return '$_temp0';
  }

  @override
  String minutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutos',
      one: '1 minuto',
    );
    return '$_temp0';
  }

  @override
  String hoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count horas',
      one: '1 hora',
    );
    return '$_temp0';
  }

  @override
  String get downloadingAndLaunching => 'Descargando e lanzando...';

  @override
  String get launching => 'Lanzando...';

  @override
  String emulatorLabel(String name) {
    return 'Emulador: $name';
  }

  @override
  String get generalInformation => 'Información xeral';

  @override
  String get manufacturer => 'Fabricante';

  @override
  String get releaseYear => 'Ano de lanzamento';

  @override
  String get generation => 'Xeración';

  @override
  String get technicalSpecifications => 'Especificacións técnicas';

  @override
  String get resolution => 'Resolución';

  @override
  String get colors => 'Cores';

  @override
  String get notNow => 'Agora non';

  @override
  String get saveRomPermanently => 'Gardar ROM permanentemente?';

  @override
  String get keepRomOfflineQuestion =>
      'Queres conservar esta ROM descargada para xogar sen conexión?';

  @override
  String get deletedToSaveSpace =>
      'Se non, eliminarase máis tarde para aforrar espazo.';

  @override
  String get view => 'Ver';

  @override
  String get media => 'Multimedia';

  @override
  String get navigate => 'Navegar';

  @override
  String get info => 'Info';

  @override
  String get toggleFilter => 'Alternar filtro';

  @override
  String get changeTheme => 'Cambiar tema';

  @override
  String get keyboard => 'Teclado';

  @override
  String get gamepad => 'Mando';

  @override
  String get hideKeyboard => 'Ocultar teclado';

  @override
  String get gameManual => 'Manual do Xogo';

  @override
  String get pdfDocument => 'Documento PDF';

  @override
  String get manual => 'Manual';

  @override
  String get video => 'Vídeo';

  @override
  String get zoomOut => 'Afastar';

  @override
  String get zoomIn => 'Achegar';

  @override
  String pageCounter(String current, String total) {
    return 'Páxina $current / $total';
  }

  @override
  String get zoom => 'Zoom';

  @override
  String get firstLast => 'Primeiro/Último';

  @override
  String get scroll => 'Desprazar';

  @override
  String get loadingVideo => 'Cargando vídeo...';

  @override
  String get playPause => 'Reproducir/Pausar';

  @override
  String get useArrowKeysToNavigate =>
      'Usa as teclas de dirección ou desliza para navegar';

  @override
  String get searchRomsHint => 'Buscar ROMs...';

  @override
  String get cancelSearch => 'Cancelar Busca';

  @override
  String get virtualKeyboard => 'Teclado Virtual';

  @override
  String get noRomsAvailable => 'Non hai ROMs dispoñibles';

  @override
  String get noRomsForPlatformMessage =>
      'Non se atoparon ficheiros ROM para esta plataforma. Os ficheiros ROM deben colocarse como ficheiros .txt que conteñan URLs de descarga no directorio da plataforma.';

  @override
  String get noMatchingRoms => 'Non hai ROMs coincidentes';

  @override
  String get tryDifferentSearch => 'Proba cun termo de busca diferente';

  @override
  String get saveToPermanentStorage => 'Gardar no almacenamento permanente';

  @override
  String get temporary => 'Temporal';

  @override
  String get permanent => 'Permanente';

  @override
  String get tempPathLabel => 'Temp';

  @override
  String get foreverPathLabel => 'Forever';

  @override
  String get storageOverview => 'Resumo de Almacenamento';

  @override
  String get clearTemporaryStorage => 'Limpar almacenamento temporal';

  @override
  String filesCount(String count) {
    return '$count ficheiros';
  }

  @override
  String pathDisplay(String label, String path) {
    return 'Ruta de $label: $path';
  }

  @override
  String get unknown => 'Descoñecido';

  @override
  String get tagVerifiedGoodDump =>
      'Volcado verificado e correcto - funcionamento confirmado';

  @override
  String get tagBadDump =>
      'Volcado defectuoso - pode non funcionar correctamente';

  @override
  String get tagAlternateVersion => 'Versión alternativa';

  @override
  String get tagOverdump => 'Sobrevolcado - contén datos adicionais';

  @override
  String get tagModifiedHacked => 'ROM modificada/hackeada';

  @override
  String get tagFanTranslation => 'Tradución de fans';

  @override
  String get tagPirateBootleg => 'Versión pirata/bootleg';

  @override
  String get tagFixedVersion => 'Versión corrixida';

  @override
  String get tagCheatTrainer => 'Inclúe trainer de trucos';

  @override
  String tagVersion(String text) {
    return 'Versión: $text';
  }

  @override
  String tagSpecialRelease(String text) {
    return 'Lanzamento especial: $text';
  }

  @override
  String tagMediaInfo(String text) {
    return 'Info multimedia: $text';
  }

  @override
  String noEmulatorConfigured(
    String displayName,
    String platform,
    String configPath,
  ) {
    return 'Non hai ningún emulador configurado para $displayName.\n\nEngade a configuración para \"$platform\" en:\n$configPath';
  }

  @override
  String get noEmulatorCommandAvailable =>
      'Non hai ningún comando de emulador dispoñible';

  @override
  String platformNotSupportedWeb(String platform, String supportedPlatforms) {
    return 'A plataforma \"$platform\" aínda non é compatible co navegador web.\n\nPlataformas compatibles: $supportedPlatforms';
  }

  @override
  String failedToLaunchWebEmulator(String error) {
    return 'Non se puido iniciar o emulador web: $error';
  }

  @override
  String failedToLaunchRom(String error) {
    return 'Non se puido iniciar a ROM.\n\nComprobe que:\n• O emulador está instalado correctamente\n• O ficheiro ROM é válido\n• A configuración é correcta\n\nErro: $error';
  }

  @override
  String errorLaunchingRom(String error) {
    return 'Erro ao iniciar a ROM: $error';
  }

  @override
  String noInfoAvailable(String platformName) {
    return 'Non hai información dispoñible para $platformName';
  }

  @override
  String get platformInfoTooltip => 'Info da plataforma (I)';

  @override
  String get navigationHint =>
      'Usa as teclas de frecha ou desliza para navegar';

  @override
  String get noGamesFound => 'Non se atoparon xogos';

  @override
  String get noGamesFoundForSearch => 'Non se atoparon xogos para a busca';

  @override
  String get tryDifferentSearchOrClear =>
      'Proba cun termo de busca diferente ou borra o filtro';

  @override
  String get checkStorageOrDownload =>
      'Comproba a configuración de almacenamento ou descarga algunhas ROMs';

  @override
  String get searchGamesHint => 'Buscar xogos...';

  @override
  String get settingsHeaderTitle => 'Configuración do Emulador Forsaken';

  @override
  String get settingsHeaderSubtitle =>
      'Configurar emuladores, rutas e descargar contido';

  @override
  String get emulatorManagementDesc =>
      'Engadir, editar e configurar comandos de emuladores';

  @override
  String get systemPaths => 'Rutas do sistema';

  @override
  String get systemPathsDesc => 'Configurar rutas de ROMs, medios e emuladores';

  @override
  String get romDatabaseDesc =>
      'Descargar e xestionar listas de ROMs desde GitHub';

  @override
  String get romStorageDesc =>
      'Xestionar ROMs descargadas, almacenamento e limpeza de ficheiros temporais';

  @override
  String get downloadManagerDesc =>
      'Descargar emuladores, listas de ROMs e datos de xogos';

  @override
  String get systemRequirementsDesc =>
      'Verificar ferramentas e dependencias requiridas';

  @override
  String get gamepadTestDebug => 'Proba e depuración do mando';

  @override
  String get gamepadTestDebugDesc =>
      'Probar botóns do mando, eixes e solucionar problemas';

  @override
  String get biosFirmwareHelpDesc =>
      'Verificar ficheiros BIOS e requisitos de firmware';

  @override
  String get webSettingsDesc => 'Proxy CORS e configuración da plataforma web';

  @override
  String get setupWizardDesc =>
      'Volver a executar o asistente de configuración inicial';

  @override
  String get languageDesc => 'Seleccionar o idioma da aplicación';

  @override
  String get aboutDebug => 'Acerca de e depuración';

  @override
  String get aboutDebugDesc =>
      'Información da aplicación e configuración de depuración';

  @override
  String get legalDisclaimer => 'Aviso legal';

  @override
  String get romDatabaseCredits =>
      'As listas de ROMs proveñen orixinalmente do repositorio AndroidRoms de Arley4d:';

  @override
  String get romDatabaseThanks =>
      'Agradecemento especial ao proxecto AndroidRoms por manter bases de datos completas de ROMs con fins de preservación.';

  @override
  String get biosFilesSection => 'Ficheiros BIOS';

  @override
  String get biosFilesCredits =>
      'Os ficheiros BIOS proveñen do repositorio retroarch_system de Abdess:';

  @override
  String get biosFilesThanks =>
      'Este repositorio contén ficheiros de sistema e BIOS requiridos por varias plataformas de emulación. Agradecemento especial aos mantedores por preservar estes ficheiros esenciais.';

  @override
  String get amigaCopyProtection =>
      'Soporte de protección contra copia de Amiga proporcionado pola biblioteca capsimg:';

  @override
  String get amigaCopyProtectionThanks =>
      'Agradecemento especial a rsn8887 por manter a biblioteca capsimg que permite o soporte de imaxes de disco IPF (protexidas contra copia) para emulación de Amiga.';

  @override
  String get additionalBiosFiles =>
      'Ficheiros BIOS adicionais proporcionados polo proxecto RetroPieBios:';

  @override
  String get additionalBiosThanks =>
      'Grazas a PIBSAS/RetroPieBios por proporcionar variantes adicionais de BIOS e ficheiros rexionais que melloran a compatibilidade entre diferentes sistemas e rexións.';

  @override
  String get enabled => 'Activado';

  @override
  String get disabled => 'Desactivado';

  @override
  String get disclaimerRequired =>
      'Debes aceptar a exención de responsabilidade para continuar.';

  @override
  String get emulatorsPathRequired =>
      'A ruta do directorio de emuladores é necesaria.';

  @override
  String get emulatorConfigPathRequired =>
      'A ruta do ficheiro de configuración do emulador é necesaria.';

  @override
  String get mediaPathRequired => 'A ruta de medios é necesaria.';

  @override
  String get tempRomPathRequired =>
      'A ruta de almacenamento temporal de ROMs é necesaria.';

  @override
  String get permanentRomPathRequired =>
      'A ruta de almacenamento permanente de ROMs é necesaria.';

  @override
  String wizardStepCounter(int current, int total) {
    return 'Paso $current / $total';
  }

  @override
  String get emulatorConfiguration => 'Configuración do emulador';

  @override
  String get emulatorConfigStepDesc =>
      'Establece as rutas onde están instalados os teus emuladores. Podes cambialas máis tarde en Axustes > Rutas do sistema.';

  @override
  String get emulatorsDirectory => 'Directorio de emuladores';

  @override
  String get pathToEmulatorBinaries => 'Ruta aos binarios dos emuladores';

  @override
  String get emulatorConfigFile => 'Ficheiro de configuración do emulador';

  @override
  String get pathToEmulatorConfig =>
      'Ruta ao JSON de configuración do emulador';

  @override
  String get storagePaths => 'Rutas de almacenamento';

  @override
  String get storagePathsStepDesc =>
      'Configura onde se almacenan os recursos multimedia e os ficheiros ROM. Podes cambialas máis tarde en Axustes > Rutas do sistema.';

  @override
  String get wizardMediaPathHint => 'Portadas, capturas de pantalla e vídeos';

  @override
  String get temporaryRomStorage => 'Almacenamento temporal de ROMs';

  @override
  String get temporaryRomStorageHint =>
      'ROMs descargadas para sesións de xogo únicas';

  @override
  String get permanentRomStorage => 'Almacenamento permanente de ROMs';

  @override
  String get permanentRomStorageHint => 'ROMs gardadas para xogar sen conexión';

  @override
  String get allSet => 'Todo listo!';

  @override
  String get wizardEmulatorReady => 'O emulador Forsaken está listo para usar.';

  @override
  String get changeSettingsLater =>
      'Podes cambiar calquera destes axustes máis tarde desde a pantalla de Axustes.';

  @override
  String get configurationSummary => 'Resumo da configuración';

  @override
  String get summaryEmulators => 'Emuladores';

  @override
  String get summaryMedia => 'Medios';

  @override
  String get summaryTempRoms => 'ROMs temporais';

  @override
  String get summarySavedRoms => 'ROMs gardadas';

  @override
  String get defaultValue => '(predeterminado)';

  @override
  String pdfPageIndicator(int current, int total) {
    return 'Páxina $current de $total';
  }

  @override
  String get pdfZoomOut => 'Reducir zoom (-)';

  @override
  String get pdfZoomIn => 'Ampliar zoom (+)';

  @override
  String get pdfResetZoom => 'Restablecer zoom (0)';

  @override
  String get pdfFirstPage => 'Primeira páxina (Home)';

  @override
  String get pdfPreviousPage => 'Páxina anterior (←/PgUp)';

  @override
  String get pdfNextPage => 'Páxina seguinte (→/PgDn)';

  @override
  String get pdfLastPage => 'Última páxina (End)';

  @override
  String get pdfFileNotFound => 'Ficheiro PDF non atopado';

  @override
  String confirmDeleteEmulator(String system) {
    return 'Está seguro de que quere eliminar a configuración do emulador para $system?';
  }

  @override
  String commandsConfigured(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comandos configurados',
      one: '1 comando configurado',
    );
    return '$_temp0';
  }

  @override
  String get noCommand => 'Sen comando';

  @override
  String get reloadConfigTooltip => 'Recargar configuración (R)';

  @override
  String get configurationInfo => 'Información de configuración';

  @override
  String get configLocation => 'Localización da configuración:';

  @override
  String get hasLocalOverridesYes => 'Ten substitucións locais: Si';

  @override
  String get hasLocalOverridesNo => 'Ten substitucións locais: Non';

  @override
  String get changesSavedToDevice =>
      'Os seus cambios gárdanse no almacenamento do dispositivo.';

  @override
  String get usingBundledConfig =>
      'Usando configuración incluída. Edite para crear substitucións locais.';

  @override
  String get noEmulatorsConfigured => 'Non hai emuladores configurados';

  @override
  String get addFirstEmulator => 'Engada o seu primeiro emulador para comezar';

  @override
  String get edit => 'Editar';

  @override
  String get editEmulator => 'Editar emulador';

  @override
  String get system => 'Sistema';

  @override
  String get systemHint => 'e.g., nes, snes, ps1';

  @override
  String get commands => 'Comandos';

  @override
  String commandNumber(int number) {
    return 'Comando $number';
  }

  @override
  String get commandHint => 'e.g., ../retroarch.AppImage -f -L core.so';

  @override
  String get remove => 'Eliminar';

  @override
  String get options => 'Opcións';

  @override
  String get biosDownloading => 'Descargando...';

  @override
  String downloadRequiredAndExtras(int requiredCount, int optionalCount) {
    return 'Descargar $requiredCount obrigatorios + $optionalCount extras';
  }

  @override
  String downloadRequiredFiles(int requiredCount) {
    return 'Descargar $requiredCount ficheiros obrigatorios';
  }

  @override
  String downloadOptionalExtras(int optionalCount) {
    return 'Descargar $optionalCount extras opcionais';
  }

  @override
  String get downloadFiles => 'Descargar ficheiros';

  @override
  String batchDownloadConfirmation(int totalFiles, int platformCount) {
    return 'Descargaranse $totalFiles ficheiros BIOS para $platformCount plataformas:';
  }

  @override
  String get downloadSourceNote =>
      'Os ficheiros descargaranse do repositorio retroarch_system.';

  @override
  String get biosOptional => 'OPCIONAL';

  @override
  String biosFilesFound(int foundCount, int totalCount) {
    return '$foundCount/$totalCount ficheiros atopados';
  }

  @override
  String optionalExtrasAvailable(int count) {
    return '+$count extras opcionais dispoñibles';
  }

  @override
  String get biosLocations => 'Localizacións:';

  @override
  String get availableForDownload =>
      'Dispoñible para descarga desde múltiples fontes';

  @override
  String get summary => 'Resumo';

  @override
  String get biosComplete => 'Completo';

  @override
  String get biosPartial => 'Parcial';

  @override
  String get biosFiles => 'Ficheiros';

  @override
  String get biosDownloadable => 'Descargable';

  @override
  String get refreshF5Tooltip => 'Actualizar (F5)';

  @override
  String get allBiosFilesFound => 'Todos os ficheiros BIOS atopados!';

  @override
  String get noBiosRequirements => 'Non se atoparon requisitos de BIOS';

  @override
  String platformCount(int count) {
    return '$count plataformas';
  }

  @override
  String failedToLoadBiosStatus(String error) {
    return 'Erro ao cargar o estado de BIOS: $error';
  }

  @override
  String get refreshStatus => 'Actualizar estado';

  @override
  String platformsCompleteCount(int complete, int total) {
    return '$complete/$total plataformas completas';
  }

  @override
  String get platformStatusHeader => 'Estado das plataformas';

  @override
  String filesVerifiedStatus(
    int presentFiles,
    int totalFiles,
    int verifiedFiles,
  ) {
    return '$presentFiles/$totalFiles ficheiros ($verifiedFiles verificados)';
  }

  @override
  String get biosCollectionOverview => 'Resumo da colección BIOS';

  @override
  String get biosVerified => 'Verificado';

  @override
  String downloadComingSoon(String platformName) {
    return 'Funcionalidade de descarga para $platformName - En breve!';
  }

  @override
  String get noGamepadConnected => 'Non hai mando conectado';

  @override
  String get connectGamepadPrompt => 'Conecta un mando e preme calquera botón';

  @override
  String get pressButtonToTest =>
      'Preme calquera botón para probar (accións desactivadas)';

  @override
  String get buttonFunctionTests => 'Probas de funcións de botóns';

  @override
  String get gamepadASelect => 'A (Seleccionar)';

  @override
  String get gamepadBBack => 'B (Atrás)';

  @override
  String get gamepadXSearch => 'X (Buscar)';

  @override
  String get gamepadYHelp => 'Y (Axuda)';

  @override
  String get gamepadLBPageDown => 'LB (Páxina abaixo)';

  @override
  String get gamepadRBPageUp => 'RB (Páxina arriba)';

  @override
  String get gamepadStartMenu => 'Start (Menú)';

  @override
  String get gamepadSelectSettings => 'Select (Axustes)';

  @override
  String get gamepadLSClick => 'LS Clic';

  @override
  String get gamepadRSView => 'RS Clic (Vista)';

  @override
  String get gamepadLTTrigger => 'LT (Gatillo)';

  @override
  String get gamepadRTTrigger => 'RT (Gatillo)';

  @override
  String get rawButtonStates => 'Estados de botóns sen procesar';

  @override
  String get noButtonsPressed => 'Ningún botón premido';

  @override
  String get axisValues => 'Valores dos eixes';

  @override
  String get noAxisMovement => 'Sen movemento de eixes';

  @override
  String get dpadLeftStick => 'D-Pad + Stick esquerdo';

  @override
  String get webSettingsDescription =>
      'Configurar axustes específicos da plataforma web';

  @override
  String get corsProxyWhyNeeded => 'Por que se precisa un proxy CORS?';

  @override
  String get corsProxyExplanation =>
      'Os navegadores bloquean as descargas de ROM desde servidores externos debido ás restricións de seguridade CORS. Un proxy CORS retransmite a solicitude desde un servidor que controlas, engadindo as cabeceiras necesarias.\n\nForsaken inclúe un Cloudflare Worker que podes despregar de balde (100k solicitudes/día). Consulta o directorio tools/cors-proxy-worker/ para instrucións de configuración.';

  @override
  String get corsProxyUrl => 'URL do proxy CORS';

  @override
  String get corsProxyHelperText =>
      'Deixar baleiro para desactivar o proxy CORS (as ROM de servidores sen CORS fallarán)';

  @override
  String get testingProxy => 'Probando proxy...';

  @override
  String get testProxyConnection => 'Probar conexión do proxy';

  @override
  String get noProxyUrlConfigured => 'Non hai URL de proxy configurada';

  @override
  String proxyWorking(int statusCode) {
    return 'O proxy funciona (HTTP $statusCode)';
  }

  @override
  String proxyReturnedHttp(int statusCode) {
    return 'O proxy devolveu HTTP $statusCode';
  }

  @override
  String get connectionTimedOut => 'Conexión esgotada';

  @override
  String get corsProxySettingsSaved =>
      'Configuración do proxy CORS gardada. Aplícase inmediatamente para novos lanzamentos de ROM.';

  @override
  String get quickDeploy => 'Despregamento rápido';

  @override
  String get corsProxyDeploySteps =>
      '1. Rexístrate en dash.cloudflare.com (gratis)\n2. Instala Wrangler: npm install -g wrangler\n3. Inicia sesión: wrangler login\n4. cd tools/cors-proxy-worker\n5. npx wrangler deploy\n6. Pega a URL do worker arriba';

  @override
  String get permanentStorage => 'Almacenamento permanente';

  @override
  String get temporaryStorage => 'Almacenamento temporal';

  @override
  String get noDownloadedRoms => 'Non hai ROM descargadas';

  @override
  String get biosErrorNetworkMessage => 'Fallou a conexión de rede';

  @override
  String get biosErrorNetworkSuggestions =>
      'Comprobe a súa conexión a Internet\nTente de novo nuns momentos\nVerifique a configuración de DNS\nProbe a usar unha VPN se o acceso está restrinxido';

  @override
  String get biosErrorFileNotFoundMessage => 'Ficheiro non atopado no servidor';

  @override
  String get biosErrorFileNotFoundSuggestions =>
      'O ficheiro BIOS puido ser movido ou renomeado\nProbe a descargar desde unha fonte alternativa\nComprobe se o ficheiro existe noutra rama/repositorio\nInforme deste problema se persiste';

  @override
  String get biosErrorAccessDeniedMessage => 'Acceso denegado polo servidor';

  @override
  String get biosErrorAccessDeniedSuggestions =>
      'O servidor pode estar a bloquear as descargas\nTente de novo máis tarde - o servidor pode estar temporalmente restrinxido\nUse unha VPN se o acceso está restrinxido por rexión\nComprobe se se require autenticación';

  @override
  String get biosErrorRateLimitedMessage => 'Límite de solicitudes excedido';

  @override
  String get biosErrorRateLimitedSuggestions =>
      'Agarde uns minutos antes de tentar de novo\nReducia o número de descargas simultáneas\nO servidor protéxese contra solicitudes excesivas';

  @override
  String get biosErrorChecksumMessage =>
      'Fallou a verificación de integridade do ficheiro';

  @override
  String get biosErrorChecksumSuggestions =>
      'O ficheiro puido corromperse durante a descarga\nProbe a descargar de novo\nComprobe se o ficheiro foi actualizado no servidor\nVerifique a estabilidade da súa conexión a Internet';

  @override
  String get biosErrorSizeMismatchMessage => 'Tamaño de ficheiro inesperado';

  @override
  String get biosErrorSizeMismatchSuggestions =>
      'O ficheiro pode ser dunha versión diferente á esperada\nA descarga pode estar incompleta\nProbe a descargar de novo\nComprobe o espazo dispoñible no disco';

  @override
  String get biosErrorStorageMessage => 'Erro de almacenamento';

  @override
  String get biosErrorStorageSuggestions =>
      'Libere espazo no disco\nComprobe os permisos dos ficheiros\nAsegúrese de que o directorio de destino permite a escritura\nProbe a descargar noutro lugar';

  @override
  String get biosErrorTimeoutMessage => 'Tempo de espera de descarga esgotado';

  @override
  String get biosErrorTimeoutSuggestions =>
      'A conexión a Internet pode ser lenta\nO servidor pode estar sobrecargado\nTente de novo cunha conexión estable\nComprobe se o cortalumes está a bloquear a conexión';

  @override
  String get biosErrorArchiveMessage => 'Fallou a extracción do arquivo';

  @override
  String get biosErrorArchiveSuggestions =>
      'O arquivo descargado pode estar corrompido\nProbe a descargar o ficheiro de novo\nComprobe se a ferramenta de extracción correcta está dispoñible\nVerifique que o ficheiro ten un formato de arquivo válido';

  @override
  String get biosErrorUnknownMessage => 'Fallou a descarga';

  @override
  String get biosErrorUnknownSuggestions =>
      'Probe a descargar de novo\nComprobe a súa conexión a Internet\nVerifique que o ficheiro aínda está dispoñible\nContacte co soporte se o problema persiste';

  @override
  String get wizardDownloadEmulators => 'Descargar emuladores';

  @override
  String get wizardDownloadEmulatorsDesc =>
      'Descarga os binarios de emuladores preconfigurados para a túa plataforma. Podes descargar todos ou seleccionar por categoría.';

  @override
  String get wizardDownloadRomLists => 'Descargar listas de ROMs';

  @override
  String get wizardDownloadRomListsDesc =>
      'Descarga os ficheiros de base de datos de ROMs dende GitHub. Conteñen metadatos para organizar a túa biblioteca de xogos.';

  @override
  String get wizardDownloadGamelists => 'Descargar gamelists';

  @override
  String get wizardDownloadGamelistsDesc =>
      'Descarga ficheiros gamelist.xml dende GitHub. Conteñen nomes de xogos, descricións, puntuacións e outros metadatos.';

  @override
  String get wizardSkipStep => 'Omitir';

  @override
  String get wizardDownloadComplete => 'Descarga completada!';

  @override
  String wizardDownloadFailed(String error) {
    return 'Erro na descarga: $error';
  }

  @override
  String get wizardAlreadyDownloaded => 'Xa descargado';

  @override
  String get wizardSelectCategory =>
      'Selecciona unha categoría para descargar, ou descarga todo:';

  @override
  String get wizardDownloading => 'Descargando...';

  @override
  String get wizardDownloadOptional =>
      'Este paso é opcional. Podes descargar máis tarde dende Axustes.';
}
