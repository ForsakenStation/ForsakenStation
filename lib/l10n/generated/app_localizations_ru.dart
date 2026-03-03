// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Forsaken Emulator';

  @override
  String get retroGamingFrontend => 'Ретро-игровой интерфейс';

  @override
  String get platforms => 'Платформы';

  @override
  String get roms => 'РОМы';

  @override
  String get settings => 'Настройки';

  @override
  String get settingsAndConfiguration => 'Настройки и конфигурация';

  @override
  String get aboutForsakenEmulator => 'О Forsaken Emulator';

  @override
  String get version => 'Версия';

  @override
  String get appDescription =>
      'Современный мультиплатформенный эмуляторный интерфейс, построенный на Flutter.';

  @override
  String get emulators => 'Эмуляторы';

  @override
  String get ready => 'Готов';

  @override
  String get back => 'Назад';

  @override
  String get select => 'Выбрать';

  @override
  String get search => 'Поиск';

  @override
  String get refresh => 'Обновить';

  @override
  String get loading => 'Загрузка...';

  @override
  String get error => 'Ошибка';

  @override
  String get initializationError => 'Ошибка инициализации';

  @override
  String get retry => 'Повторить';

  @override
  String get cancel => 'Отмена';

  @override
  String get ok => 'ОК';

  @override
  String get save => 'Сохранить';

  @override
  String get delete => 'Удалить';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get close => 'Закрыть';

  @override
  String get noRomsFound => 'РОМы не найдены';

  @override
  String get noPlatformsFound => 'Платформы не найдены';

  @override
  String get checkRomsPath => 'Проверьте переменную окружения ROMS_PATH';

  @override
  String get downloading => 'Загрузка...';

  @override
  String get downloadComplete => 'Загрузка завершена';

  @override
  String get downloadFailed => 'Ошибка загрузки';

  @override
  String get emulatorNotFound => 'Эмулятор не найден';

  @override
  String get romNotFound => 'РОМ не найден';

  @override
  String get biosRequired => 'Требуется BIOS';

  @override
  String get systemCheck => 'Проверка системы';

  @override
  String get language => 'Язык';

  @override
  String get theme => 'Тема';

  @override
  String get systemDefault => 'Системная';

  @override
  String get help => 'Помощь';

  @override
  String get keyboardAndGamepadControls => 'Управление клавиатурой и геймпадом';

  @override
  String get navigation => 'Навигация';

  @override
  String get actions => 'Действия';

  @override
  String get viewControls => 'Управление вида';

  @override
  String get gotIt => 'Понятно!';

  @override
  String get exit => 'Выход';

  @override
  String get exitApplication => 'Выйти из приложения';

  @override
  String get exitConfirm => 'Вы уверены, что хотите выйти?';

  @override
  String get downloadManager => 'Менеджер загрузок';

  @override
  String get clearCompleted => 'Очистить завершённые';

  @override
  String get selectCategory => 'Выбрать категорию';

  @override
  String get confirmDownload => 'Подтвердить загрузку';

  @override
  String get downloadGameLists => 'Загрузить списки игр';

  @override
  String get downloadGameListsDescription =>
      'Это загрузит списки РОМов с GitHub.';

  @override
  String get gameListsDownloaded => 'Списки игр загружены!';

  @override
  String get romStorageManagement => 'Управление хранилищем РОМов';

  @override
  String get deleteRom => 'Удалить РОМ?';

  @override
  String deleteRomConfirm(String fileName) {
    return 'Удалить $fileName?';
  }

  @override
  String get actionCannotBeUndone => 'Это действие нельзя отменить.';

  @override
  String deleted(String fileName) {
    return 'Удалено: $fileName';
  }

  @override
  String get savePermanently => 'Сохранить навсегда?';

  @override
  String moveRomConfirm(String fileName) {
    return 'Переместить $fileName в постоянное хранилище?';
  }

  @override
  String saved(String fileName) {
    return 'Сохранено: $fileName';
  }

  @override
  String get clearAll => 'Очистить всё?';

  @override
  String get clearAllConfirm => 'Удалить все временные РОМы?';

  @override
  String get allCleared => 'Все временные РОМы очищены';

  @override
  String get systemPathsConfiguration => 'Конфигурация системных путей';

  @override
  String get migrateRoms => 'Мигрировать РОМы?';

  @override
  String get migrateRomsDescription =>
      'Путь постоянного хранения РОМов изменился с \$oldPath на \$newPath. Хотите перенести существующие РОМы в новое место?';

  @override
  String get noKeepThem => 'Нет, оставить';

  @override
  String get yesMigrateRoms => 'Да, мигрировать РОМы';

  @override
  String get migratingRoms => 'Миграция РОМов...';

  @override
  String get romMigrationFailed => 'Предупреждение: миграция РОМов не удалась';

  @override
  String get pathsSaved => 'Пути сохранены успешно';

  @override
  String get errorSavingPaths => 'Ошибка сохранения путей:';

  @override
  String get resetConfiguration => 'Сбросить конфигурацию';

  @override
  String get resetConfigDescription =>
      'Это сбросит все пути к значениям по умолчанию. Ваши РОМы и медиафайлы не будут затронуты.';

  @override
  String get configurationReset =>
      'Конфигурация сброшена к значениям по умолчанию';

  @override
  String get errorResettingConfiguration => 'Ошибка сброса конфигурации:';

  @override
  String get savePaths => 'Сохранить пути';

  @override
  String get saving => 'Сохранение...';

  @override
  String get emulatorManagement => 'Управление эмуляторами';

  @override
  String get configurationReloaded => 'Конфигурация перезагружена';

  @override
  String get errorLoadingEmulators => 'Ошибка загрузки эмуляторов:';

  @override
  String get emulatorAdded => 'Эмулятор успешно добавлен';

  @override
  String get errorAddingEmulator => 'Ошибка добавления эмулятора:';

  @override
  String get emulatorUpdated => 'Эмулятор успешно обновлён';

  @override
  String get errorUpdatingEmulator => 'Ошибка обновления эмулятора:';

  @override
  String get deleteEmulator => 'Удалить эмулятор';

  @override
  String get emulatorDeleted => 'Эмулятор удалён';

  @override
  String get errorDeletingEmulator => 'Ошибка удаления эмулятора:';

  @override
  String get configurationSource => 'Источник конфигурации';

  @override
  String get addEmulator => 'Добавить эмулятор';

  @override
  String get systemNameRequired => 'Имя системы обязательно';

  @override
  String get commandRequired => 'Требуется хотя бы одна команда';

  @override
  String get addCommand => 'Добавить команду';

  @override
  String get acceptZipFiles => 'Принимать ZIP-файлы';

  @override
  String get acceptZipSubtitle => 'Разрешить запуск РОМов из ZIP-архивов';

  @override
  String get useForeverMode => 'Использовать режим Forever';

  @override
  String get useForeverSubtitle => 'Держать эмулятор запущенным';

  @override
  String get workInProgress => 'В работе';

  @override
  String get wipSubtitle => 'Отметить как ещё не полностью настроенный';

  @override
  String get biosFirmwareHelp => 'Помощь по BIOS и прошивке';

  @override
  String get downloadMissingFiles => 'Загрузить отсутствующие файлы';

  @override
  String get showOnlyMissing => 'Показать только отсутствующие';

  @override
  String get downloadAllMissingBios => 'Загрузить все отсутствующие BIOS';

  @override
  String get configurationError => 'Ошибка конфигурации';

  @override
  String get configurationErrorDescription =>
      'Приложение не смогло найти требуемую конфигурацию.\nПожалуйста, настройте пути в Настройки > Системные пути.';

  @override
  String get configurationRequired =>
      'Требуется:\n- Путь к медиа: директория с медиа-ассетами\n- Путь к эмуляторам: директория с исполняемыми файлами эмуляторов\n\nНеобязательно:\n- Пути хранилища РОМов для временных/постоянных загрузок';

  @override
  String get goToSettingsToConfigure =>
      'Перейдите в Настройки > Системные пути для настройки';

  @override
  String get noDownloadableBios => 'Нет отсутствующих загружаемых BIOS-файлов';

  @override
  String get allDownloadsCompleted => 'Все загрузки успешно завершены!';

  @override
  String get batchDownloadFailed => 'Пакетная загрузка не удалась:';

  @override
  String get download => 'Загрузить';

  @override
  String get downloadCancelled => 'Загрузка отменена';

  @override
  String get launched => 'Запущен:';

  @override
  String get failedToSave => 'Не удалось сохранить РОМ навсегда';

  @override
  String get failedToSaveRom => 'Не удалось сохранить РОМ навсегда';

  @override
  String get errorSaving => 'Ошибка сохранения РОМа:';

  @override
  String errorSavingRom(String error) {
    return 'Ошибка сохранения РОМа: $error';
  }

  @override
  String get openFolder => 'Открыть папку';

  @override
  String get viewManual => 'Посмотреть руководство';

  @override
  String get play => 'Играть';

  @override
  String get goBack => 'Вернуться';

  @override
  String get clearSearch => 'Очистить поиск';

  @override
  String get iUnderstand => 'Я понимаю и согласен с этими условиями';

  @override
  String get start => 'Начать';

  @override
  String get debugMode => 'Режим отладки: ';

  @override
  String get toggleDebugMode => 'Переключить режим отладки';

  @override
  String get preparingDownload => 'Подготовка загрузки...';

  @override
  String get noEmulatorsAvailable =>
      'Нет доступных эмуляторов для этой категории';

  @override
  String get failedToLaunch => 'Не удалось запустить веб-эмулятор:';

  @override
  String get platformInfo => 'Информация о платформе';

  @override
  String get emulatorPlatformInfo => 'Информация о платформе эмулятора';

  @override
  String get favorites => 'Избранное';

  @override
  String get all => 'Все';

  @override
  String get collections => 'Коллекции';

  @override
  String get searchRoms => 'Поиск РОМов...';

  @override
  String get searchPlatforms => 'Поиск платформ...';

  @override
  String romsCount(int count) {
    return '$count РОМов';
  }

  @override
  String platformsCount(int count) {
    return '$count платформ';
  }

  @override
  String get region => 'Регион';

  @override
  String get genre => 'Жанр';

  @override
  String get year => 'Год';

  @override
  String get publisher => 'Издатель';

  @override
  String get developer => 'Разработчик';

  @override
  String get playWithNetplay => 'Играть по сети';

  @override
  String get downloadBios => 'Загрузить BIOS';

  @override
  String get viewDetails => 'Подробнее';

  @override
  String get addToFavorites => 'Добавить в избранное';

  @override
  String get removeFromFavorites => 'Удалить из избранного';

  @override
  String get biosMissing => 'BIOS отсутствует';

  @override
  String get biosPresent => 'BIOS присутствует';

  @override
  String get checkingBios => 'Проверка BIOS...';

  @override
  String get emulatorDownloading => 'Загрузка эмулятора...';

  @override
  String get emulatorDownloadComplete => 'Эмулятор загружен';

  @override
  String get emulatorDownloadFailed => 'Ошибка загрузки эмулятора';

  @override
  String get installingEmulator => 'Установка эмулятора...';

  @override
  String get emulatorReady => 'Эмулятор готов';

  @override
  String get configuration => 'Конфигурация';

  @override
  String get paths => 'Пути';

  @override
  String get storage => 'Хранилище';

  @override
  String get emulatorsPath => 'Путь к эмуляторам';

  @override
  String get romsPath => 'Путь к РОМам';

  @override
  String get mediaPath => 'Путь к медиа';

  @override
  String get biosPath => 'Путь к BIOS';

  @override
  String get tempPath => 'Временный путь';

  @override
  String get browse => 'Обзор';

  @override
  String get apply => 'Применить';

  @override
  String get reset => 'Сбросить';

  @override
  String get clear => 'Очистить';

  @override
  String get scan => 'Сканировать';

  @override
  String get scanForRoms => 'Сканировать РОМы';

  @override
  String get scanningRoms => 'Сканирование РОМов...';

  @override
  String get scanComplete => 'Сканирование завершено';

  @override
  String romsFound(int count) {
    return 'Найдено $count РОМов';
  }

  @override
  String get noNewRomsFound => 'Новые РОМы не найдены';

  @override
  String get launchEmulator => 'Запустить эмулятор';

  @override
  String get emulatorError => 'Ошибка эмулятора';

  @override
  String get gamepadConnected => 'Геймпад подключён';

  @override
  String get gamepadDisconnected => 'Геймпад отключён';

  @override
  String get gamepadTest => 'Тест геймпада';

  @override
  String get pressAnyButton => 'Нажмите любую кнопку для теста';

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
  String get dpadUp => 'D-Pad Вверх';

  @override
  String get dpadDown => 'D-Pad Вниз';

  @override
  String get dpadLeft => 'D-Pad Влево';

  @override
  String get dpadRight => 'D-Pad Вправо';

  @override
  String get leftShoulder => 'L1';

  @override
  String get rightShoulder => 'R1';

  @override
  String get leftTrigger => 'L2';

  @override
  String get rightTrigger => 'R2';

  @override
  String get leftStick => 'Левый стик';

  @override
  String get rightStick => 'Правый стик';

  @override
  String get setupWizard => 'Мастер настройки';

  @override
  String get welcome => 'Добро пожаловать';

  @override
  String get welcomeMessage => 'Добро пожаловать в Forsaken Emulator';

  @override
  String get next => 'Далее';

  @override
  String get previous => 'Назад';

  @override
  String get finish => 'Завершить';

  @override
  String get skip => 'Пропустить';

  @override
  String get setupComplete => 'Настройка завершена';

  @override
  String get selectLanguage => 'Выбрать язык';

  @override
  String get selectEmulatorsPath => 'Выбрать путь к эмуляторам';

  @override
  String get selectRomsPath => 'Выбрать путь к РОМам';

  @override
  String get selectMediaPath => 'Выбрать путь к медиа';

  @override
  String get allSettingsConfigured => 'Все настройки настроены';

  @override
  String get darkTheme => 'Тёмная';

  @override
  String get lightTheme => 'Светлая';

  @override
  String get systemTheme => 'Системная';

  @override
  String get about => 'О приложении';

  @override
  String get checkForUpdates => 'Проверить обновления';

  @override
  String get noUpdatesAvailable => 'Нет доступных обновлений';

  @override
  String get updateAvailable => 'Доступно обновление';

  @override
  String get downloadingUpdate => 'Загрузка обновления...';

  @override
  String get installingUpdate => 'Установка обновления...';

  @override
  String get updateComplete => 'Обновление завершено';

  @override
  String get updateFailed => 'Обновление не удалось';

  @override
  String get networkError => 'Ошибка сети';

  @override
  String get connectionError => 'Ошибка соединения';

  @override
  String get timeoutError => 'Превышен таймаут';

  @override
  String get unknownError => 'Неизвестная ошибка';

  @override
  String get permissionDenied => 'Доступ запрещён';

  @override
  String get fileNotFound => 'Файл не найден';

  @override
  String get directoryNotFound => 'Директория не найдена';

  @override
  String get diskFull => 'Диск заполнен';

  @override
  String get invalidPath => 'Неверный путь';

  @override
  String get pathNotWritable => 'Путь недоступен для записи';

  @override
  String get romCorrupted => 'Файл РОМа может быть повреждён';

  @override
  String get zipError => 'Ошибка ZIP-архива';

  @override
  String get extractionFailed => 'Ошибка извлечения';

  @override
  String get checksumMismatch => 'Несовпадение контрольной суммы';

  @override
  String get biosCheckFailed => 'Проверка BIOS не удалась';

  @override
  String get continueAnyway => 'Продолжить всё равно';

  @override
  String get reportIssue => 'Сообщить о проблеме';

  @override
  String get copyToClipboard => 'Копировать в буфер обмена';

  @override
  String get copiedToClipboard => 'Скопировано в буфер обмена';

  @override
  String get share => 'Поделиться';

  @override
  String get hide => 'Скрыть';

  @override
  String get show => 'Показать';

  @override
  String get toggleView => 'Переключить вид';

  @override
  String get gridView => 'Сетка';

  @override
  String get listView => 'Список';

  @override
  String get carouselView => 'Карусель';

  @override
  String get sortBy => 'Сортировать по';

  @override
  String get sortByName => 'Имя';

  @override
  String get sortByDate => 'Дата';

  @override
  String get sortBySize => 'Размер';

  @override
  String get sortByRegion => 'Регион';

  @override
  String get ascending => 'По возрастанию';

  @override
  String get descending => 'По убыванию';

  @override
  String get filter => 'Фильтр';

  @override
  String get filterByRegion => 'Фильтр по региону';

  @override
  String get filterByGenre => 'Фильтр по жанру';

  @override
  String get filterByYear => 'Фильтр по году';

  @override
  String get clearFilters => 'Очистить фильтры';

  @override
  String get systemInfo => 'Системная информация';

  @override
  String get cpu => 'ЦП';

  @override
  String get memory => 'Память';

  @override
  String get storageInfo => 'Хранилище';

  @override
  String get os => 'Операционная система';

  @override
  String get emulatorVersion => 'Версия эмулятора';

  @override
  String get totalRoms => 'Всего РОМов';

  @override
  String get totalSize => 'Общий размер';

  @override
  String get freeSpace => 'Свободно';

  @override
  String get usedSpace => 'Использовано';

  @override
  String get systemUtilities => 'Системные утилиты';

  @override
  String get romVerificationResults => 'Результаты проверки РОМов';

  @override
  String get totalRomFiles => 'Всего файлов РОМ';

  @override
  String get emptyRomFiles => 'Пустые файлы РОМ';

  @override
  String get validRomFiles => 'Валидные файлы РОМ';

  @override
  String get romsDirectoryDoesNotExist => 'Директория РОМов не существует';

  @override
  String get gamelistCheckResults => 'Результаты проверки списков игр';

  @override
  String get totalPlatforms => 'Всего платформ';

  @override
  String get missingGamelists => 'Отсутствующие списки игр';

  @override
  String get configurationBackup => 'Резервная копия конфигурации';

  @override
  String get configurationBackedUp => 'Конфигурация сохранена в:';

  @override
  String get errorBackingUp => 'Ошибка сохранения конфигурации:';

  @override
  String get romDatabase => 'База данных РОМов';

  @override
  String get romDatabaseDownloaded => 'База данных РОМов успешно загружена';

  @override
  String get failedDownloadRomDatabase => 'Ошибка загрузки базы данных РОМов';

  @override
  String get romDatabaseCleared => 'База данных РОМов очищена';

  @override
  String get failedClearDatabase => 'Ошибка очистки базы данных';

  @override
  String get downloadRomDatabase => 'Загрузить базу данных РОМов';

  @override
  String get clearRomDatabase => 'Очистить базу данных РОМов';

  @override
  String get systemRequirements => 'Системные требования';

  @override
  String get failedToCheckSystem => 'Не удалось проверить систему';

  @override
  String cleanedUpTempFiles(String deletedCount) {
    return 'Очищено $deletedCount временных файлов РОМ';
  }

  @override
  String get errorCleaningTempFiles => 'Ошибка очистки временных файлов:';

  @override
  String get errorVerifyingRomFiles => 'Ошибка проверки файлов РОМ:';

  @override
  String get errorCheckingGamelists => 'Ошибка проверки списков игр:';

  @override
  String get cancelDownload => 'Отменить загрузку';

  @override
  String get selectEmulator => 'Выбрать эмулятор';

  @override
  String get biosStatusDashboard => 'Панель статуса BIOS';

  @override
  String get webSettings => 'Веб-настройки';

  @override
  String get saveSettings => 'Сохранить настройки';

  @override
  String get errorSavingSettings => 'Ошибка сохранения настроек:';

  @override
  String romsCountItems(String count) {
    return '$count РОМов';
  }

  @override
  String get savedPermanently => 'сохранено навсегда';

  @override
  String get keptInTemporary => 'оставлено во временном хранилище';

  @override
  String get tryAgain => 'Повторить';

  @override
  String get allDownloads => 'Все загрузки завершены';

  @override
  String romSavedPermanently(String name) {
    return '$name сохранён навсегда';
  }

  @override
  String get undo => 'Отменить';

  @override
  String romKeptInTemporary(String name) {
    return '$name оставлен во временном хранилище';
  }

  @override
  String romsCountWithSize(String count, String size) {
    return '$count РОМов • $size';
  }

  @override
  String get whatYouCanTry => 'Что можно попробовать:';

  @override
  String get tips => 'Советы';

  @override
  String get helpNavigateItems => 'Навигация между элементами';

  @override
  String get helpGamepadNavigation => 'Навигация геймпадом';

  @override
  String get helpQuickNavigation =>
      'Быстрая навигация (пропуск нескольких элементов)';

  @override
  String get helpGamepadPageNavigation => 'Навигация по страницам геймпадом';

  @override
  String get helpGoToFirst => 'Перейти к первому элементу';

  @override
  String get helpGoToLast => 'Перейти к последнему элементу';

  @override
  String get helpJumpToLetter =>
      'Перейти к элементу, начинающемуся с этой буквы';

  @override
  String get helpSelectItem => 'Выбрать элемент';

  @override
  String get helpGamepadSelect => 'Выбор геймпадом';

  @override
  String get helpGoBackCloseDialogs => 'Назад / Закрыть диалоги';

  @override
  String get helpExitApplication => 'Выйти из приложения';

  @override
  String get helpGamepadBackClose => 'Геймпад назад / Закрыть диалоги';

  @override
  String get helpToggleViewMode =>
      'Переключить режим вида (Сетка/Список/Карусель)';

  @override
  String get helpGamepadViewToggle => 'Переключить вид геймпадом';

  @override
  String get helpRefreshView => 'Обновить текущий вид';

  @override
  String get helpShowPlatformInfo => 'Показать информацию о платформе';

  @override
  String get helpActivateSearch => 'Активировать поиск';

  @override
  String get helpGamepadSearch => 'Поиск геймпадом';

  @override
  String get helpShowHelpDialog => 'Показать это окно помощи';

  @override
  String get helpGamepadHelp => 'Помощь по геймпаду';

  @override
  String get tipUseKeyboardOrGamepad =>
      'Используйте клавиатуру или геймпад для навигации';

  @override
  String get tipAlphabeticalJump =>
      'Алфавитный прыжок работает во всех режимах вида';

  @override
  String get tipPressQuestionMark =>
      'Нажмите ? в любое время, чтобы увидеть эту помощь';

  @override
  String get tipGamepadAlongside => 'Геймпад работает вместе с клавиатурой';

  @override
  String get configurePathsDescription =>
      'Настройте пути, используемые приложением для поиска РОМов, медиа и эмуляторов.';

  @override
  String get romListsAutoManaged =>
      'Списки РОМов теперь управляются автоматически. Загрузите их в Настройки > База данных РОМов.';

  @override
  String get romStorage => 'Хранилище РОМов';

  @override
  String get configureRomStorageDescription =>
      'Настройте, где загруженные РОМы хранятся временно и постоянно.';

  @override
  String get resetToDefaults => 'Сбросить к значениям по умолчанию';

  @override
  String get mediaPathLabel => 'Путь к медиа';

  @override
  String get mediaPathHint => 'Директория с медиа (изображения, видео)';

  @override
  String get emulatorsPathLabel => 'Путь к эмуляторам';

  @override
  String get emulatorsPathHint =>
      'Директория с исполняемыми файлами эмуляторов';

  @override
  String get gamelistPathAutomatic => 'Путь к спискам игр (автоматически)';

  @override
  String get gamelistAutoDescription =>
      'Списки игр теперь автоматически управляются в директории данных приложения. Это делает приложение полностью автономным и готовит к будущему распространению списков игр через GitHub.';

  @override
  String get tempRomStorageLabel => 'Временное хранилище РОМов (опционально)';

  @override
  String get tempRomStorageDescription =>
      'РОМы сначала загружаются сюда. После игры их можно переместить в постоянное хранилище.';

  @override
  String get permanentRomStorageLabel =>
      'Постоянное хранилище РОМов (опционально)';

  @override
  String get permanentRomStorageDescription =>
      'РОМы, сохранённые навсегда, хранятся здесь. Они не очищаются автоматически.';

  @override
  String get defaultAppSupportDir =>
      'По умолчанию: директория поддержки приложения';

  @override
  String currentPathDisplay(String path) {
    return 'Текущий: $path';
  }

  @override
  String get configurationFile => 'Файл конфигурации';

  @override
  String get source => 'Источник:';

  @override
  String get customConfigActive => 'Пользовательская конфигурация активна';

  @override
  String get pathStructure => 'Структура путей';

  @override
  String get pathStructureDescription =>
      'Путь к медиа: MEDIA_PATH/платформа/boxart|screenshots|videos/rom.png\nПуть к спискам игр: ~/.local/share/com.example.emulator/gamelists/платформа/gamelist.xml (автоматически)\nПуть к эмуляторам: EMULATORS_PATH/emulator_binary';

  @override
  String get errorCheckingSystem => 'Ошибка проверки системы';

  @override
  String get recheckR => 'Перепроверить (R)';

  @override
  String get allRequiredToolsInstalled =>
      'Все необходимые инструменты установлены';

  @override
  String get missingRequiredTools => 'Отсутствуют необходимые инструменты';

  @override
  String get systemReadyToUse =>
      'Ваша система готова к использованию эмулятора';

  @override
  String get someRequiredToolsMissing =>
      'Некоторые необходимые инструменты отсутствуют';

  @override
  String get requiredTools => 'Необходимые инструменты';

  @override
  String get requiredToolsDescription =>
      'Эти инструменты необходимы для загрузки и распаковки эмуляторов';

  @override
  String get installationInstructions => 'Инструкции по установке';

  @override
  String get installed => 'Установлено';

  @override
  String get missing => 'Отсутствует';

  @override
  String get downloadEmulatorsAndGameLists =>
      'Загрузить эмуляторы и списки игр';

  @override
  String get quickActions => 'Быстрые действия';

  @override
  String get downloadAll => 'Загрузить всё';

  @override
  String get byCategory => 'По категориям';

  @override
  String get downloadQueue => 'Очередь загрузок';

  @override
  String get noDownloadsInProgress => 'Нет загрузок';

  @override
  String get selectQuickActionToStart =>
      'Выберите быстрое действие выше, чтобы начать загрузку';

  @override
  String get categorySony => 'Sony (PS1-PS4)';

  @override
  String get categoryNintendo => 'Nintendo (GC, Wii, Switch)';

  @override
  String get categoryMicrosoft => 'Microsoft (Xbox, Xbox 360)';

  @override
  String get categoryMultiPlatform => 'Мультиплатформенные (RetroArch)';

  @override
  String get categoryOtherEmulators => 'Другие эмуляторы';

  @override
  String get categoryUtilities => 'Утилиты';

  @override
  String confirmDownloadDescription(String count, String size) {
    return 'Загрузить $count эмулятор(ов)?\nПримерный размер: ~$size МБ\n\nЭто может занять некоторое время в зависимости от вашего интернет-соединения.';
  }

  @override
  String get alreadyInstalled => 'Уже установлено';

  @override
  String get starting => 'Запуск...';

  @override
  String get completed => 'Завершено';

  @override
  String get gameListsAlreadyDownloaded => 'Списки игр уже загружены';

  @override
  String get redownload => 'Перезагрузить';

  @override
  String get gameListsFromGitHub => 'Списки игр (с GitHub)';

  @override
  String get downloaded => 'Загружено';

  @override
  String get cancelled => 'Отменено';

  @override
  String get missingFor => 'Отсутствует для:';

  @override
  String get noCustomConfigToBackup =>
      'Нет пользовательской конфигурации для резервного копирования. Используются значения по умолчанию.';

  @override
  String get saveConfigurationBackup =>
      'Сохранить резервную копию конфигурации';

  @override
  String get refreshStatsR => 'Обновить статистику (R)';

  @override
  String get systemStatistics => 'Системная статистика';

  @override
  String get romFiles => 'Файлы РОМ';

  @override
  String get maintenanceTools => 'Инструменты обслуживания';

  @override
  String get cleanupTemporaryRoms => 'Очистить временные РОМы';

  @override
  String get cleanupTemporaryRomsDescription =>
      'Удалить временные файлы РОМ из системной временной директории';

  @override
  String get verifyRomFiles => 'Проверить файлы РОМ';

  @override
  String get verifyRomFilesDescription =>
      'Проверить, что все файлы РОМ существуют и валидны';

  @override
  String get checkMissingGamelists => 'Проверить отсутствующие списки игр';

  @override
  String get checkMissingGamelistsDescription =>
      'Найти платформы без файлов gamelist.xml';

  @override
  String get backupConfiguration => 'Резервная копия конфигурации';

  @override
  String get backupConfigurationDescription =>
      'Создать резервную копию config.json';

  @override
  String get downloadingRomDatabase => 'Загрузка базы данных РОМов...';

  @override
  String get downloadMayTakeMinutes =>
      'Это может занять несколько минут в зависимости от вашего соединения...';

  @override
  String get databaseStatus => 'Статус базы данных';

  @override
  String get notDownloaded => 'Не загружено';

  @override
  String get aboutRomDatabase => 'О базе данных РОМов';

  @override
  String get aboutRomDatabaseDescription =>
      'База данных РОМов содержит списки доступных РОМов, организованные по платформам. Она загружается из репозитория romList Forsaken на GitHub.';

  @override
  String get romDatabaseSource =>
      'Источник: github.com/ForsakenStation/romList';

  @override
  String get downloadRomDatabaseDescription =>
      'Это загрузит списки РОМов из репозитория romList Forsaken на GitHub.';

  @override
  String get downloadRomDatabaseStats =>
      'Размер: ~7 МБ\nПлатформ: 138\nВсего РОМов: ~240 000';

  @override
  String get downloadWillOverwrite =>
      'Примечание: это перезапишет существующие данные.';

  @override
  String get clearRomDatabaseDescription =>
      'Это удалит все загруженные списки РОМов и сбросит базу данных к начальному состоянию.';

  @override
  String get gamelistsStatus => 'Статус списков игр';

  @override
  String get gamelistsDownloaded => 'Загружено';

  @override
  String get gamelistsNotDownloaded => 'Не загружено';

  @override
  String get aboutGamelists => 'О списках игр';

  @override
  String get aboutGamelistsDescription =>
      'Списки игр содержат метаданные игр (названия, описания, рейтинги) для каждой платформы. Они загружаются из репозитория gamelists Forsaken на GitHub.';

  @override
  String get gamelistsSource =>
      'Источник: github.com/ForsakenStation/gamelists';

  @override
  String get downloadGamelists => 'Загрузить списки игр';

  @override
  String get downloadGamelistsDescription =>
      'Это загрузит файлы gamelist.xml из репозитория gamelists Forsaken на GitHub.';

  @override
  String get downloadGamelistsWillOverwrite =>
      'Примечание: это перезапишет существующие файлы списков игр.';

  @override
  String get downloadingGamelists => 'Загрузка списков игр...';

  @override
  String get gamelistsDownloadedSuccess => 'Списки игр успешно загружены';

  @override
  String get failedDownloadGamelists => 'Ошибка загрузки списков игр';

  @override
  String get clearGamelists => 'Очистить списки игр';

  @override
  String get clearGamelistsDescription =>
      'Это удалит все загруженные файлы списков игр.';

  @override
  String get gamelistsCleared => 'Списки игр очищены';

  @override
  String get failedClearGamelists => 'Ошибка очистки списков игр';

  @override
  String get rebuildMediaCache => 'Перестроить кэш медиа';

  @override
  String get rebuildMediaCacheDescription =>
      'Сканировать медиа-директории и кэшировать пути в списках игр для более быстрой загрузки';

  @override
  String get rebuildMediaCacheConfirmTitle => 'Перестроить кэш медиа?';

  @override
  String get rebuildMediaCacheConfirmBody =>
      'Это просканирует все медиа-директории и обновит файлы gamelist.xml путями к медиа. Это может занять некоторое время для больших коллекций.';

  @override
  String get rebuildMediaCacheProgress => 'Перестроение кэша медиа...';

  @override
  String rebuildMediaCacheProcessingPlatform(
    String platform,
    String current,
    String total,
  ) {
    return 'Обработка $platform ($current/$total)';
  }

  @override
  String get rebuildMediaCacheComplete => 'Кэш медиа перестроен';

  @override
  String rebuildMediaCacheSummary(
    String platforms,
    String games,
    String updated,
    String paths,
  ) {
    return '$platforms платформ, $games игр просканировано, $updated обновлено, $paths путей к медиа закэшировано';
  }

  @override
  String get rebuildMediaCacheError => 'Не удалось перестроить кэш медиа';

  @override
  String rebuildMediaCacheErrors(String count) {
    return 'Произошло $count ошибок при перестроении';
  }
}
