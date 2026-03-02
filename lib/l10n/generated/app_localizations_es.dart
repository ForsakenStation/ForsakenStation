// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Forsaken Emulator';

  @override
  String get retroGamingFrontend => 'Frontend de Juegos Retro';

  @override
  String get platforms => 'Plataformas';

  @override
  String get roms => 'ROMs';

  @override
  String get settings => 'Ajustes';

  @override
  String get settingsAndConfiguration => 'Ajustes y Configuración';

  @override
  String get aboutForsakenEmulator => 'Acerca de Forsaken Emulator';

  @override
  String get version => 'Versión';

  @override
  String get appDescription =>
      'Un frontend de emulador multiplataforma moderno construido con Flutter.';

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
  String get error => 'Error';

  @override
  String get initializationError => 'Error de Inicialización';

  @override
  String get retry => 'Reintentar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get ok => 'Aceptar';

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
  String get close => 'Cerrar';

  @override
  String get noRomsFound => 'No se encontraron ROMs';

  @override
  String get noPlatformsFound => 'No se encontraron plataformas';

  @override
  String get checkRomsPath => 'Verifica la variable de entorno ROMS_PATH';

  @override
  String get downloading => 'Descargando...';

  @override
  String get downloadComplete => 'Descarga completada';

  @override
  String get downloadFailed => 'Descarga fallida';

  @override
  String get emulatorNotFound => 'Emulador no encontrado';

  @override
  String get romNotFound => 'ROM no encontrada';

  @override
  String get biosRequired => 'BIOS requerido';

  @override
  String get systemCheck => 'Verificación del Sistema';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get systemDefault => 'Predeterminado del sistema';

  @override
  String get help => 'Ayuda';

  @override
  String get keyboardAndGamepadControls => 'Controles de Teclado y Mando';

  @override
  String get navigation => 'Navegación';

  @override
  String get actions => 'Acciones';

  @override
  String get viewControls => 'Controles de Vista';

  @override
  String get gotIt => '¡Entendido!';

  @override
  String get exit => 'Salir';

  @override
  String get exitApplication => 'Salir de la Aplicación';

  @override
  String get exitConfirm => '¿Estás seguro de que quieres salir?';

  @override
  String get downloadManager => 'Gestor de Descargas';

  @override
  String get clearCompleted => 'Limpiar Completados';

  @override
  String get selectCategory => 'Seleccionar Categoría';

  @override
  String get confirmDownload => 'Confirmar Descarga';

  @override
  String get downloadGameLists => 'Descargar Listas de Juegos';

  @override
  String get downloadGameListsDescription =>
      'Esto descargará las listas de ROMs desde GitHub.';

  @override
  String get gameListsDownloaded => '¡Listas de juegos descargadas!';

  @override
  String get romStorageManagement => 'Gestión de Almacenamiento de ROMs';

  @override
  String get deleteRom => '¿Eliminar ROM?';

  @override
  String deleteRomConfirm(String fileName) {
    return '¿Eliminar $fileName?';
  }

  @override
  String get actionCannotBeUndone => 'Esta acción no se puede deshacer.';

  @override
  String deleted(String fileName) {
    return 'Eliminado: $fileName';
  }

  @override
  String get savePermanently => '¿Guardar Permanentemente?';

  @override
  String moveRomConfirm(String fileName) {
    return '¿Mover $fileName al almacenamiento permanente?';
  }

  @override
  String saved(String fileName) {
    return 'Guardado: $fileName';
  }

  @override
  String get clearAll => '¿Limpiar Todo?';

  @override
  String get clearAllConfirm => '¿Eliminar todas las ROMs temporales?';

  @override
  String get allCleared => 'Todas las ROMs temporales eliminadas';

  @override
  String get systemPathsConfiguration => 'Configuración de Rutas del Sistema';

  @override
  String get migrateRoms => '¿Migrar ROMs?';

  @override
  String get migrateRomsDescription =>
      'La ruta de almacenamiento permanente de ROMs ha cambiado de \$oldPath a \$newPath. ¿Desea migrar las ROMs existentes a la nueva ubicación?';

  @override
  String get noKeepThem => 'No, mantenerlas';

  @override
  String get yesMigrateRoms => 'Sí, migrar ROMs';

  @override
  String get migratingRoms => 'Migrando ROMs...';

  @override
  String get romMigrationFailed => 'Advertencia: La migración de ROMs falló';

  @override
  String get pathsSaved => 'Rutas guardadas exitosamente';

  @override
  String get errorSavingPaths => 'Error al guardar rutas:';

  @override
  String get resetConfiguration => 'Restablecer Configuración';

  @override
  String get resetConfigDescription =>
      'Esto restablecerá todas las rutas a sus valores predeterminados. Sus ROMs y archivos de medios no se verán afectados.';

  @override
  String get configurationReset =>
      'Configuración restablecida a valores predeterminados';

  @override
  String get errorResettingConfiguration =>
      'Error al restablecer la configuración:';

  @override
  String get savePaths => 'Guardar Rutas';

  @override
  String get saving => 'Guardando...';

  @override
  String get emulatorManagement => 'Gestión de Emuladores';

  @override
  String get configurationReloaded => 'Configuración recargada';

  @override
  String get errorLoadingEmulators => 'Error al cargar emuladores:';

  @override
  String get emulatorAdded => 'Emulador añadido exitosamente';

  @override
  String get errorAddingEmulator => 'Error al añadir emulador:';

  @override
  String get emulatorUpdated => 'Emulador actualizado exitosamente';

  @override
  String get errorUpdatingEmulator => 'Error al actualizar emulador:';

  @override
  String get deleteEmulator => 'Eliminar Emulador';

  @override
  String get emulatorDeleted => 'Emulador eliminado';

  @override
  String get errorDeletingEmulator => 'Error al eliminar emulador:';

  @override
  String get configurationSource => 'Fuente de Configuración';

  @override
  String get addEmulator => 'Añadir Emulador';

  @override
  String get systemNameRequired => 'El nombre del sistema es obligatorio';

  @override
  String get commandRequired => 'Se requiere al menos un comando';

  @override
  String get addCommand => 'Añadir Comando';

  @override
  String get acceptZipFiles => 'Aceptar archivos ZIP';

  @override
  String get acceptZipSubtitle => 'Permitir lanzar ROMs desde archivos ZIP';

  @override
  String get useForeverMode => 'Usar Modo Permanente';

  @override
  String get useForeverSubtitle => 'Mantener emulador ejecutándose';

  @override
  String get workInProgress => 'Trabajo en Progreso';

  @override
  String get wipSubtitle => 'Marcar como no completamente configurado';

  @override
  String get biosFirmwareHelp => 'Ayuda de BIOS y Firmware';

  @override
  String get downloadMissingFiles => 'Descargar Archivos Faltantes';

  @override
  String get showOnlyMissing => 'Mostrar solo faltantes';

  @override
  String get downloadAllMissingBios => 'Descargar Todos los BIOS Faltantes';

  @override
  String get configurationError => 'Error de Configuración';

  @override
  String get configurationErrorDescription =>
      'La aplicación no pudo encontrar la configuración requerida.\nPor favor configure sus rutas en Ajustes > Rutas del Sistema.';

  @override
  String get configurationRequired =>
      'Requerido:\n- Ruta de Medios: directorio con recursos multimedia\n- Ruta de Emuladores: directorio con binarios de emuladores\n\nOpcional:\n- Rutas de almacenamiento de ROMs para descargas temporales/permanentes';

  @override
  String get goToSettingsToConfigure =>
      'Ir a Ajustes > Rutas del Sistema para configurar';

  @override
  String get noDownloadableBios => 'No faltan archivos BIOS descargables';

  @override
  String get allDownloadsCompleted =>
      '¡Todas las descargas completadas exitosamente!';

  @override
  String get batchDownloadFailed => 'Descarga por lotes fallida:';

  @override
  String get download => 'Descargar';

  @override
  String get downloadCancelled => 'Descarga cancelada';

  @override
  String get launched => 'Lanzado:';

  @override
  String get failedToSave => 'Error al guardar ROM permanentemente';

  @override
  String get failedToSaveRom => 'Error al guardar ROM permanentemente';

  @override
  String get errorSaving => 'Error al guardar ROM:';

  @override
  String errorSavingRom(String error) {
    return 'Error al guardar ROM: $error';
  }

  @override
  String get openFolder => 'Abrir Carpeta';

  @override
  String get viewManual => 'Ver Manual';

  @override
  String get play => 'Jugar';

  @override
  String get goBack => 'Volver';

  @override
  String get clearSearch => 'Limpiar Búsqueda';

  @override
  String get iUnderstand => 'Entiendo y acepto estos términos';

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
      'No hay emuladores disponibles para esta categoría';

  @override
  String get failedToLaunch => 'Error al lanzar emulador web:';

  @override
  String get platformInfo => 'Info de Plataforma';

  @override
  String get emulatorPlatformInfo => 'Info de Plataforma del Emulador';

  @override
  String get favorites => 'Favoritos';

  @override
  String get all => 'Todo';

  @override
  String get collections => 'Colecciones';

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
  String get region => 'Región';

  @override
  String get genre => 'Género';

  @override
  String get year => 'Año';

  @override
  String get publisher => 'Editor';

  @override
  String get developer => 'Desarrollador';

  @override
  String get playWithNetplay => 'Jugar con Netplay';

  @override
  String get downloadBios => 'Descargar BIOS';

  @override
  String get viewDetails => 'Ver Detalles';

  @override
  String get addToFavorites => 'Añadir a Favoritos';

  @override
  String get removeFromFavorites => 'Quitar de Favoritos';

  @override
  String get biosMissing => 'BIOS faltante';

  @override
  String get biosPresent => 'BIOS presente';

  @override
  String get checkingBios => 'Verificando BIOS...';

  @override
  String get emulatorDownloading => 'Descargando emulador...';

  @override
  String get emulatorDownloadComplete => 'Emulador descargado';

  @override
  String get emulatorDownloadFailed => 'Error al descargar emulador';

  @override
  String get installingEmulator => 'Instalando emulador...';

  @override
  String get emulatorReady => 'Emulador listo';

  @override
  String get configuration => 'Configuración';

  @override
  String get paths => 'Rutas';

  @override
  String get storage => 'Almacenamiento';

  @override
  String get emulatorsPath => 'Ruta de Emuladores';

  @override
  String get romsPath => 'Ruta de ROMs';

  @override
  String get mediaPath => 'Ruta de Medios';

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
  String get clear => 'Limpiar';

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
    return '$count ROMs encontradas';
  }

  @override
  String get noNewRomsFound => 'No se encontraron nuevas ROMs';

  @override
  String get launchEmulator => 'Iniciar Emulador';

  @override
  String get emulatorError => 'Error del Emulador';

  @override
  String get gamepadConnected => 'Mando conectado';

  @override
  String get gamepadDisconnected => 'Mando desconectado';

  @override
  String get gamepadTest => 'Probar Mando';

  @override
  String get pressAnyButton => 'Pulsa cualquier botón para probar';

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
  String get dpadDown => 'D-Pad Abajo';

  @override
  String get dpadLeft => 'D-Pad Izquierda';

  @override
  String get dpadRight => 'D-Pad Derecha';

  @override
  String get leftShoulder => 'L1';

  @override
  String get rightShoulder => 'R1';

  @override
  String get leftTrigger => 'L2';

  @override
  String get rightTrigger => 'R2';

  @override
  String get leftStick => 'Stick Izquierdo';

  @override
  String get rightStick => 'Stick Derecho';

  @override
  String get setupWizard => 'Asistente de Configuración';

  @override
  String get welcome => 'Bienvenido';

  @override
  String get welcomeMessage => 'Bienvenido a Forsaken Emulator';

  @override
  String get next => 'Siguiente';

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
  String get selectMediaPath => 'Seleccionar Ruta de Medios';

  @override
  String get allSettingsConfigured => 'Todos los ajustes configurados';

  @override
  String get darkTheme => 'Oscuro';

  @override
  String get lightTheme => 'Claro';

  @override
  String get systemTheme => 'Sistema';

  @override
  String get about => 'Acerca de';

  @override
  String get checkForUpdates => 'Buscar Actualizaciones';

  @override
  String get noUpdatesAvailable => 'No hay actualizaciones disponibles';

  @override
  String get updateAvailable => 'Actualización disponible';

  @override
  String get downloadingUpdate => 'Descargando actualización...';

  @override
  String get installingUpdate => 'Instalando actualización...';

  @override
  String get updateComplete => 'Actualización completada';

  @override
  String get updateFailed => 'Actualización fallida';

  @override
  String get networkError => 'Error de red';

  @override
  String get connectionError => 'Error de conexión';

  @override
  String get timeoutError => 'Error de tiempo de espera';

  @override
  String get unknownError => 'Error desconocido';

  @override
  String get permissionDenied => 'Permiso denegado';

  @override
  String get fileNotFound => 'Archivo no encontrado';

  @override
  String get directoryNotFound => 'Directorio no encontrado';

  @override
  String get diskFull => 'Disco lleno';

  @override
  String get invalidPath => 'Ruta inválida';

  @override
  String get pathNotWritable => 'Ruta no escribible';

  @override
  String get romCorrupted => 'El archivo ROM puede estar dañado';

  @override
  String get zipError => 'Error de archivo ZIP';

  @override
  String get extractionFailed => 'Extracción fallida';

  @override
  String get checksumMismatch => 'Discrepancia de suma de verificación';

  @override
  String get biosCheckFailed => 'Verificación de BIOS fallida';

  @override
  String get continueAnyway => 'Continuar de todos modos';

  @override
  String get reportIssue => 'Reportar Problema';

  @override
  String get copyToClipboard => 'Copiar al portapapeles';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get share => 'Compartir';

  @override
  String get hide => 'Ocultar';

  @override
  String get show => 'Mostrar';

  @override
  String get toggleView => 'Cambiar Vista';

  @override
  String get gridView => 'Vista de Cuadrícula';

  @override
  String get listView => 'Vista de Lista';

  @override
  String get carouselView => 'Vista de Carrusel';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get sortByName => 'Nombre';

  @override
  String get sortByDate => 'Fecha';

  @override
  String get sortBySize => 'Tamaño';

  @override
  String get sortByRegion => 'Región';

  @override
  String get ascending => 'Ascendente';

  @override
  String get descending => 'Descendente';

  @override
  String get filter => 'Filtrar';

  @override
  String get filterByRegion => 'Filtrar por Región';

  @override
  String get filterByGenre => 'Filtrar por Género';

  @override
  String get filterByYear => 'Filtrar por Año';

  @override
  String get clearFilters => 'Limpiar Filtros';

  @override
  String get systemInfo => 'Info del Sistema';

  @override
  String get cpu => 'CPU';

  @override
  String get memory => 'Memoria';

  @override
  String get storageInfo => 'Almacenamiento';

  @override
  String get os => 'Sistema Operativo';

  @override
  String get emulatorVersion => 'Versión del Emulador';

  @override
  String get totalRoms => 'Total de ROMs';

  @override
  String get totalSize => 'Tamaño Total';

  @override
  String get freeSpace => 'Espacio Libre';

  @override
  String get usedSpace => 'Espacio Usado';

  @override
  String get systemUtilities => 'Utilidades del Sistema';

  @override
  String get romVerificationResults => 'Resultados de Verificación de ROMs';

  @override
  String get totalRomFiles => 'Total de archivos ROM';

  @override
  String get emptyRomFiles => 'Archivos ROM vacíos';

  @override
  String get validRomFiles => 'Archivos ROM válidos';

  @override
  String get romsDirectoryDoesNotExist => 'El directorio de ROMs no existe';

  @override
  String get gamelistCheckResults => 'Resultados de Verificación de Gamelists';

  @override
  String get totalPlatforms => 'Total de plataformas';

  @override
  String get missingGamelists => 'Gamelists faltantes';

  @override
  String get configurationBackup => 'Copia de Seguridad de Configuración';

  @override
  String get configurationBackedUp => 'Configuración respaldada en:';

  @override
  String get errorBackingUp => 'Error al respaldar configuración:';

  @override
  String get romDatabase => 'Base de Datos de ROMs';

  @override
  String get romDatabaseDownloaded =>
      'Base de datos de ROMs descargada exitosamente';

  @override
  String get failedDownloadRomDatabase =>
      'Error al descargar la base de datos de ROMs';

  @override
  String get romDatabaseCleared => 'Base de datos de ROMs limpiada';

  @override
  String get failedClearDatabase => 'Error al limpiar la base de datos';

  @override
  String get downloadRomDatabase => 'Descargar Base de Datos de ROMs';

  @override
  String get clearRomDatabase => 'Limpiar Base de Datos de ROMs';

  @override
  String get systemRequirements => 'Requisitos del Sistema';

  @override
  String get failedToCheckSystem => 'Error al verificar el sistema';

  @override
  String cleanedUpTempFiles(String deletedCount) {
    return 'Se limpiaron $deletedCount archivos ROM temporales';
  }

  @override
  String get errorCleaningTempFiles => 'Error al limpiar archivos temporales:';

  @override
  String get errorVerifyingRomFiles => 'Error al verificar archivos ROM:';

  @override
  String get errorCheckingGamelists => 'Error al verificar gamelists:';

  @override
  String get cancelDownload => 'Cancelar Descarga';

  @override
  String get selectEmulator => 'Seleccionar Emulador';

  @override
  String get biosStatusDashboard => 'Panel de Estado de BIOS';

  @override
  String get webSettings => 'Ajustes Web';

  @override
  String get saveSettings => 'Guardar Ajustes';

  @override
  String get errorSavingSettings => 'Error al guardar ajustes:';

  @override
  String romsCountItems(String count) {
    return '$count ROMs';
  }

  @override
  String get savedPermanently => 'guardado permanentemente';

  @override
  String get keptInTemporary => 'mantenido en almacenamiento temporal';

  @override
  String get tryAgain => 'Intentar de Nuevo';

  @override
  String get allDownloads => 'Todas las descargas completadas';

  @override
  String romSavedPermanently(String name) {
    return '$name guardado permanentemente';
  }

  @override
  String get undo => 'Deshacer';

  @override
  String romKeptInTemporary(String name) {
    return '$name mantenido en almacenamiento temporal';
  }

  @override
  String romsCountWithSize(String count, String size) {
    return '$count ROMs • $size';
  }

  @override
  String get whatYouCanTry => 'Lo que puedes intentar:';

  @override
  String get tips => 'Consejos';

  @override
  String get helpNavigateItems => 'Navegar entre elementos';

  @override
  String get helpGamepadNavigation => 'Navegación con mando';

  @override
  String get helpQuickNavigation =>
      'Navegación rápida (saltar varios elementos)';

  @override
  String get helpGamepadPageNavigation => 'Navegación de páginas con mando';

  @override
  String get helpGoToFirst => 'Ir al primer elemento';

  @override
  String get helpGoToLast => 'Ir al último elemento';

  @override
  String get helpJumpToLetter => 'Saltar al elemento que empiece con esa letra';

  @override
  String get helpSelectItem => 'Seleccionar elemento';

  @override
  String get helpGamepadSelect => 'Seleccionar con mando';

  @override
  String get helpGoBackCloseDialogs => 'Volver / Cerrar diálogos';

  @override
  String get helpExitApplication => 'Salir de la aplicación';

  @override
  String get helpGamepadBackClose => 'Volver con mando / Cerrar diálogos';

  @override
  String get helpToggleViewMode =>
      'Cambiar modo de vista (Cuadrícula/Lista/Carrusel)';

  @override
  String get helpGamepadViewToggle => 'Cambiar vista con mando';

  @override
  String get helpRefreshView => 'Actualizar vista actual';

  @override
  String get helpShowPlatformInfo => 'Mostrar información de plataforma';

  @override
  String get helpActivateSearch => 'Activar búsqueda';

  @override
  String get helpGamepadSearch => 'Buscar con mando';

  @override
  String get helpShowHelpDialog => 'Mostrar este diálogo de ayuda';

  @override
  String get helpGamepadHelp => 'Ayuda con mando';

  @override
  String get tipUseKeyboardOrGamepad => 'Usa teclado o mando para navegar';

  @override
  String get tipAlphabeticalJump =>
      'El salto alfabético funciona en todos los modos de vista';

  @override
  String get tipPressQuestionMark =>
      'Presiona ? en cualquier momento para ver esta ayuda';

  @override
  String get tipGamepadAlongside =>
      'El mando funciona junto con los controles de teclado';

  @override
  String get configurePathsDescription =>
      'Configura las rutas que usa la aplicación para localizar ROMs, medios y emuladores.';

  @override
  String get romListsAutoManaged =>
      'Las listas de ROMs ahora se gestionan automáticamente. Descárgalas desde Ajustes > Base de Datos de ROMs.';

  @override
  String get romStorage => 'Almacenamiento de ROMs';

  @override
  String get configureRomStorageDescription =>
      'Configura dónde se almacenan las ROMs descargadas temporal y permanentemente.';

  @override
  String get resetToDefaults => 'Restablecer valores predeterminados';

  @override
  String get mediaPathLabel => 'Ruta de Medios';

  @override
  String get mediaPathHint => 'Directorio con medios (imágenes, videos)';

  @override
  String get emulatorsPathLabel => 'Ruta de Emuladores';

  @override
  String get emulatorsPathHint => 'Directorio con binarios de emuladores';

  @override
  String get gamelistPathAutomatic => 'Ruta de Gamelist (Automática)';

  @override
  String get gamelistAutoDescription =>
      'Las gamelists ahora se gestionan automáticamente en el directorio de datos de la app. Esto hace la app completamente independiente y prepara para la distribución futura de gamelists desde GitHub.';

  @override
  String get tempRomStorageLabel =>
      'Almacenamiento Temporal de ROMs (Opcional)';

  @override
  String get tempRomStorageDescription =>
      'Las ROMs se descargan aquí primero. Pueden promoverse a almacenamiento permanente después de jugar.';

  @override
  String get permanentRomStorageLabel =>
      'Almacenamiento Permanente de ROMs (Opcional)';

  @override
  String get permanentRomStorageDescription =>
      'Las ROMs guardadas permanentemente se almacenan aquí. No se limpian automáticamente.';

  @override
  String get defaultAppSupportDir =>
      'Predeterminado: directorio de soporte de la app';

  @override
  String currentPathDisplay(String path) {
    return 'Actual: $path';
  }

  @override
  String get configurationFile => 'Archivo de Configuración';

  @override
  String get source => 'Fuente:';

  @override
  String get customConfigActive => 'Configuración personalizada activa';

  @override
  String get pathStructure => 'Estructura de Rutas';

  @override
  String get pathStructureDescription =>
      'Ruta de Medios: MEDIA_PATH/plataforma/boxart|screenshots|videos/rom.png\nRuta de Gamelist: ~/.local/share/com.example.emulator/gamelists/plataforma/gamelist.xml (automática)\nRuta de Emuladores: EMULATORS_PATH/binario_emulador';

  @override
  String get errorCheckingSystem => 'Error al verificar el sistema';

  @override
  String get recheckR => 'Re-verificar (R)';

  @override
  String get allRequiredToolsInstalled =>
      'Todas las Herramientas Requeridas Instaladas';

  @override
  String get missingRequiredTools => 'Herramientas Requeridas Faltantes';

  @override
  String get systemReadyToUse => 'Tu sistema está listo para usar el emulador';

  @override
  String get someRequiredToolsMissing =>
      'Faltan algunas herramientas requeridas';

  @override
  String get requiredTools => 'Herramientas Requeridas';

  @override
  String get requiredToolsDescription =>
      'Estas herramientas son necesarias para descargar y extraer emuladores';

  @override
  String get installationInstructions => 'Instrucciones de Instalación';

  @override
  String get installed => 'Instalado';

  @override
  String get missing => 'Faltante';

  @override
  String get downloadEmulatorsAndGameLists =>
      'Descargar emuladores y listas de juegos';

  @override
  String get quickActions => 'Acciones Rápidas';

  @override
  String get downloadAll => 'Descargar Todo';

  @override
  String get byCategory => 'Por Categoría';

  @override
  String get downloadQueue => 'Cola de Descargas';

  @override
  String get noDownloadsInProgress => 'No hay descargas en progreso';

  @override
  String get selectQuickActionToStart =>
      'Selecciona una acción rápida arriba para empezar a descargar';

  @override
  String get categorySony => 'Sony (PS1-PS4)';

  @override
  String get categoryNintendo => 'Nintendo (GC, Wii, Switch)';

  @override
  String get categoryMicrosoft => 'Microsoft (Xbox, Xbox 360)';

  @override
  String get categoryMultiPlatform => 'Multi-Plataforma (RetroArch)';

  @override
  String get categoryOtherEmulators => 'Otros Emuladores';

  @override
  String get categoryUtilities => 'Utilidades';

  @override
  String confirmDownloadDescription(String count, String size) {
    return '¿Descargar $count emulador(es)?\nTamaño estimado: ~$size MB\n\nEsto puede tardar dependiendo de tu conexión a internet.';
  }

  @override
  String get alreadyInstalled => 'Ya instalado';

  @override
  String get starting => 'Iniciando...';

  @override
  String get completed => 'Completado';

  @override
  String get gameListsAlreadyDownloaded => 'Listas de juegos ya descargadas';

  @override
  String get redownload => 'Re-Descargar';

  @override
  String get gameListsFromGitHub => 'Listas de Juegos (desde GitHub)';

  @override
  String get downloaded => 'Descargado';

  @override
  String get cancelled => 'Cancelado';

  @override
  String get missingFor => 'Faltante para:';

  @override
  String get noCustomConfigToBackup =>
      'No hay configuración personalizada para respaldar. Usando valores predeterminados.';

  @override
  String get saveConfigurationBackup =>
      'Guardar Copia de Seguridad de Configuración';

  @override
  String get refreshStatsR => 'Actualizar estadísticas (R)';

  @override
  String get systemStatistics => 'Estadísticas del Sistema';

  @override
  String get romFiles => 'Archivos ROM';

  @override
  String get maintenanceTools => 'Herramientas de Mantenimiento';

  @override
  String get cleanupTemporaryRoms => 'Limpiar ROMs Temporales';

  @override
  String get cleanupTemporaryRomsDescription =>
      'Eliminar archivos ROM temporales del directorio temporal del sistema';

  @override
  String get verifyRomFiles => 'Verificar Archivos ROM';

  @override
  String get verifyRomFilesDescription =>
      'Comprobar que todos los archivos ROM existen y son válidos';

  @override
  String get checkMissingGamelists => 'Verificar Gamelists Faltantes';

  @override
  String get checkMissingGamelistsDescription =>
      'Encontrar plataformas sin archivo gamelist.xml';

  @override
  String get backupConfiguration => 'Respaldar Configuración';

  @override
  String get backupConfigurationDescription =>
      'Crear una copia de seguridad de config.json';

  @override
  String get downloadingRomDatabase => 'Descargando Base de Datos de ROMs...';

  @override
  String get downloadMayTakeMinutes =>
      'Esto puede tardar unos minutos dependiendo de tu conexión...';

  @override
  String get databaseStatus => 'Estado de la Base de Datos';

  @override
  String get notDownloaded => 'No Descargada';

  @override
  String get aboutRomDatabase => 'Acerca de la Base de Datos de ROMs';

  @override
  String get aboutRomDatabaseDescription =>
      'La base de datos de ROMs contiene listas de ROMs disponibles organizadas por plataforma. Se descarga del repositorio romList de Forsaken en GitHub.';

  @override
  String get romDatabaseSource => 'Fuente: github.com/ForsakenStation/romList';

  @override
  String get downloadRomDatabaseDescription =>
      'Esto descargará las listas de ROMs del repositorio romList de Forsaken en GitHub.';

  @override
  String get downloadRomDatabaseStats =>
      'Tamaño: ~7 MB\nPlataformas: 138\nTotal de ROMs: ~240,000';

  @override
  String get downloadWillOverwrite =>
      'Nota: Esto sobrescribirá los datos existentes.';

  @override
  String get clearRomDatabaseDescription =>
      'Esto eliminará todas las listas de ROMs descargadas y restablecerá la base de datos a su estado inicial.';

  @override
  String get gamelistsStatus => 'Estado de Gamelists';

  @override
  String get gamelistsDownloaded => 'Descargadas';

  @override
  String get gamelistsNotDownloaded => 'No Descargadas';

  @override
  String get aboutGamelists => 'Acerca de las Gamelists';

  @override
  String get aboutGamelistsDescription =>
      'Las gamelists contienen metadatos de juegos (nombres, descripciones, puntuaciones) para cada plataforma. Se descargan del repositorio gamelists de Forsaken en GitHub.';

  @override
  String get gamelistsSource => 'Fuente: github.com/ForsakenStation/gamelists';

  @override
  String get downloadGamelists => 'Descargar Gamelists';

  @override
  String get downloadGamelistsDescription =>
      'Esto descargará archivos gamelist.xml del repositorio gamelists de Forsaken en GitHub.';

  @override
  String get downloadGamelistsWillOverwrite =>
      'Nota: Esto sobrescribirá los archivos gamelist existentes.';

  @override
  String get downloadingGamelists => 'Descargando Gamelists...';

  @override
  String get gamelistsDownloadedSuccess => 'Gamelists descargadas exitosamente';

  @override
  String get failedDownloadGamelists => 'Error al descargar gamelists';

  @override
  String get clearGamelists => 'Limpiar Gamelists';

  @override
  String get clearGamelistsDescription =>
      'Esto eliminará todos los archivos gamelist descargados.';

  @override
  String get gamelistsCleared => 'Gamelists limpiadas';

  @override
  String get failedClearGamelists => 'Error al limpiar gamelists';

  @override
  String get rebuildMediaCache => 'Reconstruir Caché de Media';

  @override
  String get rebuildMediaCacheDescription =>
      'Escanear directorios de media y cachear rutas en gamelists para carga más rápida';

  @override
  String get rebuildMediaCacheConfirmTitle => '¿Reconstruir Caché de Media?';

  @override
  String get rebuildMediaCacheConfirmBody =>
      'Esto escaneará todos los directorios de media y actualizará los archivos gamelist.xml con las rutas de media. Puede tardar un momento para colecciones grandes.';

  @override
  String get rebuildMediaCacheProgress => 'Reconstruyendo caché de media...';

  @override
  String rebuildMediaCacheProcessingPlatform(
    String platform,
    String current,
    String total,
  ) {
    return 'Procesando $platform ($current/$total)';
  }

  @override
  String get rebuildMediaCacheComplete => 'Caché de Media Reconstruido';

  @override
  String rebuildMediaCacheSummary(
    String platforms,
    String games,
    String updated,
    String paths,
  ) {
    return '$platforms plataformas, $games juegos escaneados, $updated actualizados, $paths rutas de media cacheadas';
  }

  @override
  String get rebuildMediaCacheError => 'Error al reconstruir caché de media';

  @override
  String rebuildMediaCacheErrors(String count) {
    return '$count errores ocurrieron durante la reconstrucción';
  }
}
