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
  String get biosRequired => 'OBLIGATORIO';

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
  String get launchFile => 'Archivo de inicio';

  @override
  String get launchFileSubtitle =>
      'Archivo a buscar dentro del ZIP extraído (ej. eboot.bin)';

  @override
  String get launchFileHint => 'ej. eboot.bin';

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
  String get biosMissing => 'Faltante';

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
  String get rightStick => 'Stick derecho';

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

  @override
  String get description => 'Descripción';

  @override
  String get noDescriptionAvailable =>
      'No hay descripción disponible para esta ROM.';

  @override
  String get releaseDate => 'Fecha de lanzamiento';

  @override
  String get players => 'Jugadores';

  @override
  String get rating => 'Valoración';

  @override
  String get regions => 'Regiones';

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
  String get playInBrowser => 'Jugar en el navegador';

  @override
  String downloadingPlatformBios(String platformName) {
    return 'Descargando BIOS de $platformName';
  }

  @override
  String get downloadingAllMissingBios =>
      'Descargando todas las BIOS faltantes';

  @override
  String biosFileLabel(String filename) {
    return 'Archivo: $filename';
  }

  @override
  String batchProgressLabel(String completed, String total) {
    return 'Progreso: $completed/$total archivos';
  }

  @override
  String get fileDetails => 'Detalles del archivo:';

  @override
  String get waiting => 'Esperando...';

  @override
  String get verifying => 'Verificando...';

  @override
  String get failed => 'Fallido';

  @override
  String get preparing => 'Preparando...';

  @override
  String get downloadingFiles => 'Descargando archivos...';

  @override
  String get someDownloadsFailed => 'Algunas descargas fallaron';

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
  String get downloadingAndLaunching => 'Descargando y lanzando...';

  @override
  String get launching => 'Lanzando...';

  @override
  String emulatorLabel(String name) {
    return 'Emulador: $name';
  }

  @override
  String get generalInformation => 'Información general';

  @override
  String get manufacturer => 'Fabricante';

  @override
  String get releaseYear => 'Año de lanzamiento';

  @override
  String get generation => 'Generación';

  @override
  String get technicalSpecifications => 'Especificaciones técnicas';

  @override
  String get resolution => 'Resolución';

  @override
  String get colors => 'Colores';

  @override
  String get notNow => 'Ahora no';

  @override
  String get saveRomPermanently => '¿Guardar ROM permanentemente?';

  @override
  String get keepRomOfflineQuestion =>
      '¿Te gustaría conservar esta ROM descargada para jugar sin conexión?';

  @override
  String get deletedToSaveSpace =>
      'Si no, se eliminará más tarde para ahorrar espacio.';

  @override
  String get view => 'Ver';

  @override
  String get media => 'Medios';

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
  String get gameManual => 'Manual del Juego';

  @override
  String get pdfDocument => 'Documento PDF';

  @override
  String get manual => 'Manual';

  @override
  String get video => 'Vídeo';

  @override
  String get zoomOut => 'Alejar';

  @override
  String get zoomIn => 'Acercar';

  @override
  String pageCounter(String current, String total) {
    return 'Página $current / $total';
  }

  @override
  String get zoom => 'Zoom';

  @override
  String get firstLast => 'Primero/Último';

  @override
  String get scroll => 'Desplazar';

  @override
  String get loadingVideo => 'Cargando vídeo...';

  @override
  String get playPause => 'Reproducir/Pausar';

  @override
  String get useArrowKeysToNavigate =>
      'Usa las teclas de dirección o desliza para navegar';

  @override
  String get searchRomsHint => 'Buscar ROMs...';

  @override
  String get cancelSearch => 'Cancelar Búsqueda';

  @override
  String get virtualKeyboard => 'Teclado Virtual';

  @override
  String get noRomsAvailable => 'No hay ROMs disponibles';

  @override
  String get noRomsForPlatformMessage =>
      'No se encontraron archivos ROM para esta plataforma. Los archivos ROM deben colocarse como archivos .txt que contengan URLs de descarga en el directorio de la plataforma.';

  @override
  String get noMatchingRoms => 'No hay ROMs coincidentes';

  @override
  String get tryDifferentSearch =>
      'Intenta con un término de búsqueda diferente';

  @override
  String get saveToPermanentStorage => 'Guardar en almacenamiento permanente';

  @override
  String get temporary => 'Temporal';

  @override
  String get permanent => 'Permanente';

  @override
  String get tempPathLabel => 'Temp';

  @override
  String get foreverPathLabel => 'Forever';

  @override
  String get storageOverview => 'Resumen de Almacenamiento';

  @override
  String get clearTemporaryStorage => 'Limpiar almacenamiento temporal';

  @override
  String filesCount(String count) {
    return '$count archivos';
  }

  @override
  String pathDisplay(String label, String path) {
    return 'Ruta de $label: $path';
  }

  @override
  String get unknown => 'Desconocido';

  @override
  String get tagVerifiedGoodDump =>
      'Volcado verificado y correcto - funcionamiento confirmado';

  @override
  String get tagBadDump =>
      'Volcado defectuoso - puede no funcionar correctamente';

  @override
  String get tagAlternateVersion => 'Versión alternativa';

  @override
  String get tagOverdump => 'Sobrevolcado - contiene datos adicionales';

  @override
  String get tagModifiedHacked => 'ROM modificada/hackeada';

  @override
  String get tagFanTranslation => 'Traducción de fans';

  @override
  String get tagPirateBootleg => 'Versión pirata/bootleg';

  @override
  String get tagFixedVersion => 'Versión corregida';

  @override
  String get tagCheatTrainer => 'Incluye trainer de trucos';

  @override
  String tagVersion(String text) {
    return 'Versión: $text';
  }

  @override
  String tagSpecialRelease(String text) {
    return 'Lanzamiento especial: $text';
  }

  @override
  String tagMediaInfo(String text) {
    return 'Info de medios: $text';
  }

  @override
  String noEmulatorConfigured(
    String displayName,
    String platform,
    String configPath,
  ) {
    return 'No hay emulador configurado para $displayName.\n\nPor favor, añade la configuración para \"$platform\" en:\n$configPath';
  }

  @override
  String get noEmulatorCommandAvailable =>
      'No hay ningún comando de emulador disponible';

  @override
  String platformNotSupportedWeb(String platform, String supportedPlatforms) {
    return 'La plataforma \"$platform\" aún no es compatible con el navegador web.\n\nPlataformas compatibles: $supportedPlatforms';
  }

  @override
  String failedToLaunchWebEmulator(String error) {
    return 'Error al iniciar el emulador web: $error';
  }

  @override
  String failedToLaunchRom(String error) {
    return 'Error al iniciar la ROM.\n\nComprueba que:\n• El emulador está instalado correctamente\n• El archivo ROM es válido\n• La configuración es correcta\n\nError: $error';
  }

  @override
  String errorLaunchingRom(String error) {
    return 'Error al iniciar la ROM: $error';
  }

  @override
  String noInfoAvailable(String platformName) {
    return 'No hay información disponible para $platformName';
  }

  @override
  String get platformInfoTooltip => 'Info de plataforma (I)';

  @override
  String get navigationHint =>
      'Usa las teclas de flecha o desliza para navegar';

  @override
  String get noGamesFound => 'No se encontraron juegos';

  @override
  String get noGamesFoundForSearch =>
      'No se encontraron juegos para la búsqueda';

  @override
  String get tryDifferentSearchOrClear =>
      'Prueba con otro término de búsqueda o borra el filtro';

  @override
  String get checkStorageOrDownload =>
      'Revisa la configuración de almacenamiento o descarga algunas ROMs';

  @override
  String get searchGamesHint => 'Buscar juegos...';

  @override
  String get settingsHeaderTitle => 'Configuración del Emulador Forsaken';

  @override
  String get settingsHeaderSubtitle =>
      'Configurar emuladores, rutas y descargar contenido';

  @override
  String get emulatorManagementDesc =>
      'Agregar, editar y configurar comandos de emuladores';

  @override
  String get systemPaths => 'Rutas del sistema';

  @override
  String get systemPathsDesc => 'Configurar rutas de ROMs, medios y emuladores';

  @override
  String get romDatabaseDesc =>
      'Descargar y gestionar listas de ROMs desde GitHub';

  @override
  String get romStorageDesc =>
      'Gestionar ROMs descargadas, almacenamiento y limpieza de archivos temporales';

  @override
  String get downloadManagerDesc =>
      'Descargar emuladores, listas de ROMs y datos de juegos';

  @override
  String get systemRequirementsDesc =>
      'Verificar herramientas y dependencias requeridas';

  @override
  String get gamepadTestDebug => 'Prueba y depuración de gamepad';

  @override
  String get gamepadTestDebugDesc =>
      'Probar botones del gamepad, ejes y solucionar problemas';

  @override
  String get biosFirmwareHelpDesc =>
      'Verificar archivos BIOS y requisitos de firmware';

  @override
  String get webSettingsDesc => 'Proxy CORS y configuración de plataforma web';

  @override
  String get setupWizardDesc =>
      'Volver a ejecutar el asistente de configuración inicial';

  @override
  String get languageDesc => 'Seleccionar idioma de la aplicación';

  @override
  String get aboutDebug => 'Acerca de y depuración';

  @override
  String get aboutDebugDesc =>
      'Información de la aplicación y configuración de depuración';

  @override
  String get legalDisclaimer => 'Aviso legal';

  @override
  String get romDatabaseCredits =>
      'Las listas de ROMs provienen originalmente del repositorio AndroidRoms de Arley4d:';

  @override
  String get romDatabaseThanks =>
      'Agradecimiento especial al proyecto AndroidRoms por mantener bases de datos completas de ROMs con fines de preservación.';

  @override
  String get biosFilesSection => 'Archivos BIOS';

  @override
  String get biosFilesCredits =>
      'Los archivos BIOS provienen del repositorio retroarch_system de Abdess:';

  @override
  String get biosFilesThanks =>
      'Este repositorio contiene archivos de sistema y BIOS requeridos por varias plataformas de emulación. Agradecimiento especial a los mantenedores por preservar estos archivos esenciales.';

  @override
  String get amigaCopyProtection =>
      'Soporte de protección contra copia de Amiga proporcionado por la biblioteca capsimg:';

  @override
  String get amigaCopyProtectionThanks =>
      'Agradecimiento especial a rsn8887 por mantener la biblioteca capsimg que permite el soporte de imágenes de disco IPF (protegidas contra copia) para emulación de Amiga.';

  @override
  String get additionalBiosFiles =>
      'Archivos BIOS adicionales proporcionados por el proyecto RetroPieBios:';

  @override
  String get additionalBiosThanks =>
      'Gracias a PIBSAS/RetroPieBios por proporcionar variantes adicionales de BIOS y archivos regionales que mejoran la compatibilidad entre diferentes sistemas y regiones.';

  @override
  String get enabled => 'Activado';

  @override
  String get disabled => 'Desactivado';

  @override
  String get disclaimerRequired =>
      'Debes aceptar el aviso legal para continuar.';

  @override
  String get emulatorsPathRequired =>
      'La ruta del directorio de emuladores es obligatoria.';

  @override
  String get emulatorConfigPathRequired =>
      'La ruta del archivo de configuración del emulador es obligatoria.';

  @override
  String get mediaPathRequired => 'La ruta de medios es obligatoria.';

  @override
  String get tempRomPathRequired =>
      'La ruta de almacenamiento temporal de ROMs es obligatoria.';

  @override
  String get permanentRomPathRequired =>
      'La ruta de almacenamiento permanente de ROMs es obligatoria.';

  @override
  String wizardStepCounter(int current, int total) {
    return 'Paso $current / $total';
  }

  @override
  String get emulatorConfiguration => 'Configuración del emulador';

  @override
  String get emulatorConfigStepDesc =>
      'Establece las rutas donde están instalados tus emuladores. Puedes cambiarlas más tarde en Ajustes > Rutas del sistema.';

  @override
  String get emulatorsDirectory => 'Directorio de emuladores';

  @override
  String get pathToEmulatorBinaries => 'Ruta a los binarios del emulador';

  @override
  String get emulatorConfigFile => 'Archivo de configuración del emulador';

  @override
  String get pathToEmulatorConfig =>
      'Ruta al JSON de configuración del emulador';

  @override
  String get storagePaths => 'Rutas de almacenamiento';

  @override
  String get storagePathsStepDesc =>
      'Configura dónde se almacenan los recursos multimedia y los archivos ROM. Puedes cambiarlas más tarde en Ajustes > Rutas del sistema.';

  @override
  String get wizardMediaPathHint => 'Carátulas, capturas de pantalla y vídeos';

  @override
  String get temporaryRomStorage => 'Almacenamiento temporal de ROMs';

  @override
  String get temporaryRomStorageHint =>
      'ROMs descargadas para sesiones de juego únicas';

  @override
  String get permanentRomStorage => 'Almacenamiento permanente de ROMs';

  @override
  String get permanentRomStorageHint =>
      'ROMs guardadas para jugar sin conexión';

  @override
  String get allSet => '¡Todo listo!';

  @override
  String get wizardEmulatorReady =>
      'El emulador Forsaken está listo para usar.';

  @override
  String get changeSettingsLater =>
      'Puedes cambiar cualquiera de estos ajustes más tarde desde la pantalla de Ajustes.';

  @override
  String get configurationSummary => 'Resumen de configuración';

  @override
  String get summaryEmulators => 'Emuladores';

  @override
  String get summaryMedia => 'Medios';

  @override
  String get summaryTempRoms => 'ROMs temporales';

  @override
  String get summarySavedRoms => 'ROMs guardadas';

  @override
  String get defaultValue => '(predeterminado)';

  @override
  String pdfPageIndicator(int current, int total) {
    return 'Página $current de $total';
  }

  @override
  String get pdfZoomOut => 'Reducir zoom (-)';

  @override
  String get pdfZoomIn => 'Ampliar zoom (+)';

  @override
  String get pdfResetZoom => 'Restablecer zoom (0)';

  @override
  String get pdfFirstPage => 'Primera página (Home)';

  @override
  String get pdfPreviousPage => 'Página anterior (←/PgUp)';

  @override
  String get pdfNextPage => 'Página siguiente (→/PgDn)';

  @override
  String get pdfLastPage => 'Última página (End)';

  @override
  String get pdfFileNotFound => 'Archivo PDF no encontrado';

  @override
  String confirmDeleteEmulator(String system) {
    return '¿Está seguro de que desea eliminar la configuración del emulador para $system?';
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
  String get noCommand => 'Sin comando';

  @override
  String get reloadConfigTooltip => 'Recargar configuración (R)';

  @override
  String get configurationInfo => 'Información de configuración';

  @override
  String get configLocation => 'Ubicación de la configuración:';

  @override
  String get hasLocalOverridesYes => 'Tiene sustituciones locales: Sí';

  @override
  String get hasLocalOverridesNo => 'Tiene sustituciones locales: No';

  @override
  String get changesSavedToDevice =>
      'Sus cambios se guardan en el almacenamiento del dispositivo.';

  @override
  String get usingBundledConfig =>
      'Usando configuración incluida. Edite para crear sustituciones locales.';

  @override
  String get noEmulatorsConfigured => 'No hay emuladores configurados';

  @override
  String get addFirstEmulator => 'Añada su primer emulador para empezar';

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
  String get options => 'Opciones';

  @override
  String get biosDownloading => 'Descargando...';

  @override
  String downloadRequiredAndExtras(int requiredCount, int optionalCount) {
    return 'Descargar $requiredCount obligatorios + $optionalCount extras';
  }

  @override
  String downloadRequiredFiles(int requiredCount) {
    return 'Descargar $requiredCount archivos obligatorios';
  }

  @override
  String downloadOptionalExtras(int optionalCount) {
    return 'Descargar $optionalCount extras opcionales';
  }

  @override
  String get downloadFiles => 'Descargar archivos';

  @override
  String batchDownloadConfirmation(int totalFiles, int platformCount) {
    return 'Se descargarán $totalFiles archivos BIOS para $platformCount plataformas:';
  }

  @override
  String get downloadSourceNote =>
      'Los archivos se descargarán del repositorio retroarch_system.';

  @override
  String get biosOptional => 'OPCIONAL';

  @override
  String biosFilesFound(int foundCount, int totalCount) {
    return '$foundCount/$totalCount archivos encontrados';
  }

  @override
  String optionalExtrasAvailable(int count) {
    return '+$count extras opcionales disponibles';
  }

  @override
  String get biosLocations => 'Ubicaciones:';

  @override
  String get availableForDownload =>
      'Disponible para descarga desde múltiples fuentes';

  @override
  String get summary => 'Resumen';

  @override
  String get biosComplete => 'Completo';

  @override
  String get biosPartial => 'Parcial';

  @override
  String get biosFiles => 'Archivos';

  @override
  String get biosDownloadable => 'Descargable';

  @override
  String get refreshF5Tooltip => 'Actualizar (F5)';

  @override
  String get allBiosFilesFound => '¡Todos los archivos BIOS encontrados!';

  @override
  String get noBiosRequirements => 'No se encontraron requisitos de BIOS';

  @override
  String platformCount(int count) {
    return '$count plataformas';
  }

  @override
  String failedToLoadBiosStatus(String error) {
    return 'Error al cargar el estado de BIOS: $error';
  }

  @override
  String get refreshStatus => 'Actualizar estado';

  @override
  String platformsCompleteCount(int complete, int total) {
    return '$complete/$total plataformas completas';
  }

  @override
  String get platformStatusHeader => 'Estado de plataformas';

  @override
  String filesVerifiedStatus(
    int presentFiles,
    int totalFiles,
    int verifiedFiles,
  ) {
    return '$presentFiles/$totalFiles archivos ($verifiedFiles verificados)';
  }

  @override
  String get biosCollectionOverview => 'Resumen de colección BIOS';

  @override
  String get biosVerified => 'Verificado';

  @override
  String downloadComingSoon(String platformName) {
    return 'Funcionalidad de descarga para $platformName - ¡Próximamente!';
  }

  @override
  String get noGamepadConnected => 'Mando no conectado';

  @override
  String get connectGamepadPrompt => 'Conecta un mando y pulsa cualquier botón';

  @override
  String get pressButtonToTest =>
      'Pulsa cualquier botón para probar (acciones desactivadas)';

  @override
  String get buttonFunctionTests => 'Pruebas de funciones de botones';

  @override
  String get gamepadASelect => 'A (Seleccionar)';

  @override
  String get gamepadBBack => 'B (Atrás)';

  @override
  String get gamepadXSearch => 'X (Buscar)';

  @override
  String get gamepadYHelp => 'Y (Ayuda)';

  @override
  String get gamepadLBPageDown => 'LB (Página abajo)';

  @override
  String get gamepadRBPageUp => 'RB (Página arriba)';

  @override
  String get gamepadStartMenu => 'Start (Menú)';

  @override
  String get gamepadSelectSettings => 'Select (Ajustes)';

  @override
  String get gamepadLSClick => 'LS Clic';

  @override
  String get gamepadRSView => 'RS Clic (Vista)';

  @override
  String get gamepadLTTrigger => 'LT (Gatillo)';

  @override
  String get gamepadRTTrigger => 'RT (Gatillo)';

  @override
  String get rawButtonStates => 'Estados de botones sin procesar';

  @override
  String get noButtonsPressed => 'Ningún botón pulsado';

  @override
  String get axisValues => 'Valores de ejes';

  @override
  String get noAxisMovement => 'Sin movimiento de ejes';

  @override
  String get dpadLeftStick => 'D-Pad + Stick izquierdo';

  @override
  String get webSettingsDescription =>
      'Configurar ajustes específicos de la plataforma web';

  @override
  String get corsProxyWhyNeeded => '¿Por qué se necesita un proxy CORS?';

  @override
  String get corsProxyExplanation =>
      'Los navegadores bloquean las descargas de ROM desde servidores externos debido a restricciones de seguridad CORS. Un proxy CORS retransmite la solicitud desde un servidor que controlas, añadiendo las cabeceras necesarias.\n\nForsaken incluye un Cloudflare Worker que puedes desplegar gratis (100k solicitudes/día). Consulta el directorio tools/cors-proxy-worker/ para instrucciones de configuración.';

  @override
  String get corsProxyUrl => 'URL del proxy CORS';

  @override
  String get corsProxyHelperText =>
      'Dejar vacío para desactivar el proxy CORS (las ROM de servidores sin CORS fallarán)';

  @override
  String get testingProxy => 'Probando proxy...';

  @override
  String get testProxyConnection => 'Probar conexión del proxy';

  @override
  String get noProxyUrlConfigured => 'No hay URL de proxy configurada';

  @override
  String proxyWorking(int statusCode) {
    return 'El proxy funciona (HTTP $statusCode)';
  }

  @override
  String proxyReturnedHttp(int statusCode) {
    return 'El proxy devolvió HTTP $statusCode';
  }

  @override
  String get connectionTimedOut => 'Conexión agotada';

  @override
  String get corsProxySettingsSaved =>
      'Configuración del proxy CORS guardada. Se aplica inmediatamente para nuevos lanzamientos de ROM.';

  @override
  String get quickDeploy => 'Despliegue rápido';

  @override
  String get corsProxyDeploySteps =>
      '1. Regístrate en dash.cloudflare.com (gratis)\n2. Instala Wrangler: npm install -g wrangler\n3. Inicia sesión: wrangler login\n4. cd tools/cors-proxy-worker\n5. npx wrangler deploy\n6. Pega la URL del worker arriba';

  @override
  String get permanentStorage => 'Almacenamiento permanente';

  @override
  String get temporaryStorage => 'Almacenamiento temporal';

  @override
  String get noDownloadedRoms => 'No hay ROMs descargadas';

  @override
  String get biosErrorNetworkMessage => 'Error de conexión de red';

  @override
  String get biosErrorNetworkSuggestions =>
      'Comprueba tu conexión a internet\nInténtalo de nuevo en unos momentos\nVerifica la configuración DNS\nIntenta usar una VPN si el acceso está restringido';

  @override
  String get biosErrorFileNotFoundMessage =>
      'Archivo no encontrado en el servidor';

  @override
  String get biosErrorFileNotFoundSuggestions =>
      'El archivo BIOS puede haber sido movido o renombrado\nIntenta descargarlo desde una fuente alternativa\nComprueba si el archivo existe en otra rama/repositorio\nInforma de este problema si persiste';

  @override
  String get biosErrorAccessDeniedMessage => 'Acceso denegado por el servidor';

  @override
  String get biosErrorAccessDeniedSuggestions =>
      'El servidor puede estar bloqueando las descargas\nInténtalo más tarde - el servidor puede estar temporalmente restringido\nUsa VPN si el acceso está restringido por región\nComprueba si se requiere autenticación';

  @override
  String get biosErrorRateLimitedMessage => 'Límite de solicitudes excedido';

  @override
  String get biosErrorRateLimitedSuggestions =>
      'Espera unos minutos antes de intentarlo de nuevo\nReduce el número de descargas simultáneas\nEl servidor se está protegiendo contra solicitudes excesivas';

  @override
  String get biosErrorChecksumMessage =>
      'Error en la verificación de integridad del archivo';

  @override
  String get biosErrorChecksumSuggestions =>
      'El archivo puede haberse dañado durante la descarga\nIntenta descargarlo de nuevo\nComprueba si el archivo fue actualizado en el servidor\nVerifica la estabilidad de tu conexión a internet';

  @override
  String get biosErrorSizeMismatchMessage => 'Tamaño de archivo inesperado';

  @override
  String get biosErrorSizeMismatchSuggestions =>
      'El archivo puede ser una versión diferente a la esperada\nLa descarga puede estar incompleta\nIntenta descargarlo de nuevo\nComprueba el espacio disponible en disco';

  @override
  String get biosErrorStorageMessage => 'Error de almacenamiento';

  @override
  String get biosErrorStorageSuggestions =>
      'Libera espacio en disco\nComprueba los permisos de archivo\nAsegúrate de que el directorio de destino es escribible\nIntenta descargar en otra ubicación';

  @override
  String get biosErrorTimeoutMessage => 'Tiempo de descarga agotado';

  @override
  String get biosErrorTimeoutSuggestions =>
      'La conexión a internet puede ser lenta\nEl servidor puede estar sobrecargado\nInténtalo de nuevo con una conexión estable\nComprueba si el cortafuegos está bloqueando la conexión';

  @override
  String get biosErrorArchiveMessage => 'Error al extraer el archivo';

  @override
  String get biosErrorArchiveSuggestions =>
      'El archivo descargado puede estar dañado\nIntenta descargar el archivo de nuevo\nComprueba si la herramienta de extracción correcta está disponible\nVerifica que el archivo tiene un formato de archivo válido';

  @override
  String get biosErrorUnknownMessage => 'Descarga fallida';

  @override
  String get biosErrorUnknownSuggestions =>
      'Intenta descargarlo de nuevo\nComprueba tu conexión a internet\nVerifica que el archivo sigue disponible\nContacta con soporte si el problema persiste';

  @override
  String get wizardDownloadEmulators => 'Descargar emuladores';

  @override
  String get wizardDownloadEmulatorsDesc =>
      'Descarga los binarios de emuladores preconfigurados para tu plataforma. Puedes descargar todos o seleccionar por categoría.';

  @override
  String get wizardDownloadRomLists => 'Descargar listas de ROMs';

  @override
  String get wizardDownloadRomListsDesc =>
      'Descarga los archivos de base de datos de ROMs desde GitHub. Contienen metadatos para organizar tu biblioteca de juegos.';

  @override
  String get wizardDownloadGamelists => 'Descargar gamelists';

  @override
  String get wizardDownloadGamelistsDesc =>
      'Descarga archivos gamelist.xml desde GitHub. Contienen nombres de juegos, descripciones, puntuaciones y otros metadatos.';

  @override
  String get wizardSkipStep => 'Omitir';

  @override
  String get wizardDownloadComplete => '¡Descarga completada!';

  @override
  String wizardDownloadFailed(String error) {
    return 'Error en la descarga: $error';
  }

  @override
  String get wizardAlreadyDownloaded => 'Ya descargado';

  @override
  String get wizardSelectCategory =>
      'Selecciona una categoría para descargar, o descarga todo:';

  @override
  String get wizardDownloading => 'Descargando...';

  @override
  String get wizardDownloadOptional =>
      'Este paso es opcional. Puedes descargar más tarde desde Ajustes.';

  @override
  String get archiveOrgSettings => 'Cuenta de Archive.org';

  @override
  String get archiveOrgSettingsDesc =>
      'Configurar credenciales de Archive.org para descargar ROMs';

  @override
  String get archiveOrgSettingsDescription =>
      'Algunas ROMs están alojadas en Archive.org y requieren autenticación para descargarlas. Configura tus claves API S3 aquí.';

  @override
  String get archiveOrgWhyNeeded => '¿Por qué se necesitan credenciales?';

  @override
  String get archiveOrgExplanation =>
      'Algunos archivos en Archive.org requieren una cuenta con sesión iniciada para descargarlos. Forsaken usa claves API estilo S3 para que tu contraseña nunca se almacene.\n\nGenera tus claves en:\nhttps://archive.org/account/s3.php';

  @override
  String get archiveOrgAccessKey => 'Clave de acceso';

  @override
  String get archiveOrgSecretKey => 'Clave secreta';

  @override
  String get archiveOrgAccessKeyHint => 'Tu clave de acceso estilo S3';

  @override
  String get archiveOrgSecretKeyHint => 'Tu clave secreta estilo S3';

  @override
  String get archiveOrgSettingsSaved =>
      'Credenciales de Archive.org guardadas.';

  @override
  String get archiveOrgAuthRequired => 'Autenticación requerida';

  @override
  String get archiveOrgAuthRequiredMessage =>
      'Este archivo requiere una cuenta de Archive.org para descargarlo.\n\nPor favor, configura tus claves API S3 de Archive.org en Ajustes para continuar.';

  @override
  String get goToSettings => 'Ir a Ajustes';
}
