// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Forsaken Emulator';

  @override
  String get retroGamingFrontend => '复古游戏前端';

  @override
  String get platforms => '平台';

  @override
  String get roms => 'ROM';

  @override
  String get settings => '设置';

  @override
  String get settingsAndConfiguration => '设置和配置';

  @override
  String get aboutForsakenEmulator => '关于 Forsaken Emulator';

  @override
  String get version => '版本';

  @override
  String get appDescription => '使用Flutter构建的现代多平台模拟器前端。';

  @override
  String get emulators => '模拟器';

  @override
  String get ready => '就绪';

  @override
  String get back => '返回';

  @override
  String get select => '选择';

  @override
  String get search => '搜索';

  @override
  String get refresh => '刷新';

  @override
  String get loading => '加载中...';

  @override
  String get error => '错误';

  @override
  String get initializationError => '初始化错误';

  @override
  String get retry => '重试';

  @override
  String get cancel => '取消';

  @override
  String get ok => '确定';

  @override
  String get save => '保存';

  @override
  String get delete => '删除';

  @override
  String get confirm => '确认';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get close => '关闭';

  @override
  String get noRomsFound => '未找到ROM';

  @override
  String get noPlatformsFound => '未找到平台';

  @override
  String get checkRomsPath => '检查ROMS_PATH环境变量';

  @override
  String get downloading => '下载中...';

  @override
  String get downloadComplete => '下载完成';

  @override
  String get downloadFailed => '下载失败';

  @override
  String get emulatorNotFound => '未找到模拟器';

  @override
  String get romNotFound => '未找到ROM';

  @override
  String get biosRequired => '需要BIOS';

  @override
  String get systemCheck => '系统检查';

  @override
  String get language => '语言';

  @override
  String get theme => '主题';

  @override
  String get systemDefault => '系统默认';

  @override
  String get help => '帮助';

  @override
  String get keyboardAndGamepadControls => '键盘和手柄控制';

  @override
  String get navigation => '导航';

  @override
  String get actions => '操作';

  @override
  String get viewControls => '视图控制';

  @override
  String get gotIt => '知道了!';

  @override
  String get exit => '退出';

  @override
  String get exitApplication => '退出应用';

  @override
  String get exitConfirm => '确定要退出吗?';

  @override
  String get downloadManager => '下载管理器';

  @override
  String get clearCompleted => '清除已完成';

  @override
  String get selectCategory => '选择类别';

  @override
  String get confirmDownload => '确认下载';

  @override
  String get downloadGameLists => '下载游戏列表';

  @override
  String get downloadGameListsDescription => '这将从GitHub下载ROM列表。';

  @override
  String get gameListsDownloaded => '游戏列表已下载!';

  @override
  String get romStorageManagement => 'ROM存储管理';

  @override
  String get deleteRom => '删除ROM?';

  @override
  String deleteRomConfirm(String fileName) {
    return '删除 $fileName?';
  }

  @override
  String get actionCannotBeUndone => '此操作无法撤销。';

  @override
  String deleted(String fileName) {
    return '已删除: $fileName';
  }

  @override
  String get savePermanently => '永久保存?';

  @override
  String moveRomConfirm(String fileName) {
    return '将 $fileName 移动到永久存储?';
  }

  @override
  String saved(String fileName) {
    return '已保存: $fileName';
  }

  @override
  String get clearAll => '全部清除?';

  @override
  String get clearAllConfirm => '删除所有临时ROM?';

  @override
  String get allCleared => '所有临时ROM已清除';

  @override
  String get systemPathsConfiguration => '系统路径配置';

  @override
  String get migrateRoms => '迁移ROM?';

  @override
  String get migrateRomsDescription =>
      'ROM永久存储路径已从 \$oldPath 更改为 \$newPath。是否要将现有ROM迁移到新位置?';

  @override
  String get noKeepThem => '不,保留它们';

  @override
  String get yesMigrateRoms => '是,迁移ROM';

  @override
  String get migratingRoms => '正在迁移ROM...';

  @override
  String get romMigrationFailed => '警告: ROM迁移失败';

  @override
  String get pathsSaved => '路径保存成功';

  @override
  String get errorSavingPaths => '保存路径时出错:';

  @override
  String get resetConfiguration => '重置配置';

  @override
  String get resetConfigDescription => '这将把所有路径重置为默认值。您的ROM和媒体文件不会受到影响。';

  @override
  String get configurationReset => '配置已重置为默认值';

  @override
  String get errorResettingConfiguration => '重置配置时出错:';

  @override
  String get savePaths => '保存路径';

  @override
  String get saving => '保存中...';

  @override
  String get emulatorManagement => '模拟器管理';

  @override
  String get configurationReloaded => '配置已重新加载';

  @override
  String get errorLoadingEmulators => '加载模拟器时出错:';

  @override
  String get emulatorAdded => '模拟器添加成功';

  @override
  String get errorAddingEmulator => '添加模拟器时出错:';

  @override
  String get emulatorUpdated => '模拟器更新成功';

  @override
  String get errorUpdatingEmulator => '更新模拟器时出错:';

  @override
  String get deleteEmulator => '删除模拟器';

  @override
  String get emulatorDeleted => '模拟器已删除';

  @override
  String get errorDeletingEmulator => '删除模拟器时出错:';

  @override
  String get configurationSource => '配置来源';

  @override
  String get addEmulator => '添加模拟器';

  @override
  String get systemNameRequired => '系统名称为必填项';

  @override
  String get commandRequired => '至少需要一个命令';

  @override
  String get addCommand => '添加命令';

  @override
  String get acceptZipFiles => '接受ZIP文件';

  @override
  String get acceptZipSubtitle => '允许从ZIP存档启动ROM';

  @override
  String get useForeverMode => '使用Forever模式';

  @override
  String get useForeverSubtitle => '保持模拟器运行';

  @override
  String get workInProgress => '进行中的工作';

  @override
  String get wipSubtitle => '标记为尚未完全配置';

  @override
  String get biosFirmwareHelp => 'BIOS和固件帮助';

  @override
  String get downloadMissingFiles => '下载缺失文件';

  @override
  String get showOnlyMissing => '仅显示缺失';

  @override
  String get downloadAllMissingBios => '下载所有缺失的BIOS';

  @override
  String get configurationError => '配置错误';

  @override
  String get configurationErrorDescription =>
      '应用程序找不到所需的配置。\n请在设置 > 系统路径中配置您的路径。';

  @override
  String get configurationRequired =>
      '必需:\n- 媒体路径: 包含媒体资产的目录\n- 模拟器路径: 包含模拟器可执行文件的目录\n\n可选:\n- 用于临时/永久下载的ROM存储路径';

  @override
  String get goToSettingsToConfigure => '前往设置 > 系统路径进行配置';

  @override
  String get noDownloadableBios => '没有缺失的可下载BIOS文件';

  @override
  String get allDownloadsCompleted => '所有下载已成功完成!';

  @override
  String get batchDownloadFailed => '批量下载失败:';

  @override
  String get download => '下载';

  @override
  String get downloadCancelled => '下载已取消';

  @override
  String get launched => '已启动:';

  @override
  String get failedToSave => '无法永久保存ROM';

  @override
  String get failedToSaveRom => '无法永久保存ROM';

  @override
  String get errorSaving => '保存ROM时出错:';

  @override
  String errorSavingRom(String error) {
    return '保存ROM时出错: $error';
  }

  @override
  String get openFolder => '打开文件夹';

  @override
  String get viewManual => '查看手册';

  @override
  String get play => '玩';

  @override
  String get goBack => '返回';

  @override
  String get clearSearch => '清除搜索';

  @override
  String get iUnderstand => '我理解并同意这些条款';

  @override
  String get start => '开始';

  @override
  String get debugMode => '调试模式: ';

  @override
  String get toggleDebugMode => '切换调试模式';

  @override
  String get preparingDownload => '准备下载...';

  @override
  String get noEmulatorsAvailable => '此类别没有可用的模拟器';

  @override
  String get failedToLaunch => '无法启动网络模拟器:';

  @override
  String get platformInfo => '平台信息';

  @override
  String get emulatorPlatformInfo => '模拟器平台信息';

  @override
  String get favorites => '收藏';

  @override
  String get all => '全部';

  @override
  String get collections => '收藏集';

  @override
  String get searchRoms => '搜索ROM...';

  @override
  String get searchPlatforms => '搜索平台...';

  @override
  String romsCount(int count) {
    return '$count 个ROM';
  }

  @override
  String platformsCount(int count) {
    return '$count 个平台';
  }

  @override
  String get region => '地区';

  @override
  String get genre => '类型';

  @override
  String get year => '年份';

  @override
  String get publisher => '发行商';

  @override
  String get developer => '开发商';

  @override
  String get playWithNetplay => '使用网络对战游玩';

  @override
  String get downloadBios => '下载BIOS';

  @override
  String get viewDetails => '查看详情';

  @override
  String get addToFavorites => '添加到收藏';

  @override
  String get removeFromFavorites => '从收藏中移除';

  @override
  String get biosMissing => 'BIOS缺失';

  @override
  String get biosPresent => 'BIOS存在';

  @override
  String get checkingBios => '正在检查BIOS...';

  @override
  String get emulatorDownloading => '正在下载模拟器...';

  @override
  String get emulatorDownloadComplete => '模拟器已下载';

  @override
  String get emulatorDownloadFailed => '下载模拟器失败';

  @override
  String get installingEmulator => '正在安装模拟器...';

  @override
  String get emulatorReady => '模拟器就绪';

  @override
  String get configuration => '配置';

  @override
  String get paths => '路径';

  @override
  String get storage => '存储';

  @override
  String get emulatorsPath => '模拟器路径';

  @override
  String get romsPath => 'ROM路径';

  @override
  String get mediaPath => '媒体路径';

  @override
  String get biosPath => 'BIOS路径';

  @override
  String get tempPath => '临时路径';

  @override
  String get browse => '浏览';

  @override
  String get apply => '应用';

  @override
  String get reset => '重置';

  @override
  String get clear => '清除';

  @override
  String get scan => '扫描';

  @override
  String get scanForRoms => '扫描ROM';

  @override
  String get scanningRoms => '正在扫描ROM...';

  @override
  String get scanComplete => '扫描完成';

  @override
  String romsFound(int count) {
    return '找到 $count 个ROM';
  }

  @override
  String get noNewRomsFound => '未找到新的ROM';

  @override
  String get launchEmulator => '启动模拟器';

  @override
  String get emulatorError => '模拟器错误';

  @override
  String get gamepadConnected => '手柄已连接';

  @override
  String get gamepadDisconnected => '手柄已断开';

  @override
  String get gamepadTest => '测试手柄';

  @override
  String get pressAnyButton => '按任意按钮进行测试';

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
  String get dpadUp => 'D-Pad 上';

  @override
  String get dpadDown => 'D-Pad 下';

  @override
  String get dpadLeft => 'D-Pad 左';

  @override
  String get dpadRight => 'D-Pad 右';

  @override
  String get leftShoulder => 'L1';

  @override
  String get rightShoulder => 'R1';

  @override
  String get leftTrigger => 'L2';

  @override
  String get rightTrigger => 'R2';

  @override
  String get leftStick => '左摇杆';

  @override
  String get rightStick => '右摇杆';

  @override
  String get setupWizard => '设置向导';

  @override
  String get welcome => '欢迎';

  @override
  String get welcomeMessage => '欢迎使用 Forsaken Emulator';

  @override
  String get next => '下一步';

  @override
  String get previous => '上一步';

  @override
  String get finish => '完成';

  @override
  String get skip => '跳过';

  @override
  String get setupComplete => '设置完成';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get selectEmulatorsPath => '选择模拟器路径';

  @override
  String get selectRomsPath => '选择ROM路径';

  @override
  String get selectMediaPath => '选择媒体路径';

  @override
  String get allSettingsConfigured => '所有设置已配置';

  @override
  String get darkTheme => '深色';

  @override
  String get lightTheme => '浅色';

  @override
  String get systemTheme => '系统';

  @override
  String get about => '关于';

  @override
  String get checkForUpdates => '检查更新';

  @override
  String get noUpdatesAvailable => '没有可用的更新';

  @override
  String get updateAvailable => '有可用更新';

  @override
  String get downloadingUpdate => '正在下载更新...';

  @override
  String get installingUpdate => '正在安装更新...';

  @override
  String get updateComplete => '更新完成';

  @override
  String get updateFailed => '更新失败';

  @override
  String get networkError => '网络错误';

  @override
  String get connectionError => '连接错误';

  @override
  String get timeoutError => '超时错误';

  @override
  String get unknownError => '未知错误';

  @override
  String get permissionDenied => '权限被拒绝';

  @override
  String get fileNotFound => '文件未找到';

  @override
  String get directoryNotFound => '目录未找到';

  @override
  String get diskFull => '磁盘已满';

  @override
  String get invalidPath => '无效路径';

  @override
  String get pathNotWritable => '路径不可写';

  @override
  String get romCorrupted => 'ROM文件可能已损坏';

  @override
  String get zipError => 'ZIP存档错误';

  @override
  String get extractionFailed => '解压失败';

  @override
  String get checksumMismatch => '校验和不匹配';

  @override
  String get biosCheckFailed => 'BIOS检查失败';

  @override
  String get continueAnyway => '仍然继续';

  @override
  String get reportIssue => '报告问题';

  @override
  String get copyToClipboard => '复制到剪贴板';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get share => '分享';

  @override
  String get hide => '隐藏';

  @override
  String get show => '显示';

  @override
  String get toggleView => '切换视图';

  @override
  String get gridView => '网格视图';

  @override
  String get listView => '列表视图';

  @override
  String get carouselView => '轮播视图';

  @override
  String get sortBy => '排序方式';

  @override
  String get sortByName => '名称';

  @override
  String get sortByDate => '日期';

  @override
  String get sortBySize => '大小';

  @override
  String get sortByRegion => '地区';

  @override
  String get ascending => '升序';

  @override
  String get descending => '降序';

  @override
  String get filter => '筛选';

  @override
  String get filterByRegion => '按地区筛选';

  @override
  String get filterByGenre => '按类型筛选';

  @override
  String get filterByYear => '按年份筛选';

  @override
  String get clearFilters => '清除筛选';

  @override
  String get systemInfo => '系统信息';

  @override
  String get cpu => 'CPU';

  @override
  String get memory => '内存';

  @override
  String get storageInfo => '存储';

  @override
  String get os => '操作系统';

  @override
  String get emulatorVersion => '模拟器版本';

  @override
  String get totalRoms => 'ROM总数';

  @override
  String get totalSize => '总大小';

  @override
  String get freeSpace => '可用空间';

  @override
  String get usedSpace => '已用空间';

  @override
  String get systemUtilities => '系统工具';

  @override
  String get romVerificationResults => 'ROM验证结果';

  @override
  String get totalRomFiles => 'ROM文件总数';

  @override
  String get emptyRomFiles => '空ROM文件';

  @override
  String get validRomFiles => '有效ROM文件';

  @override
  String get romsDirectoryDoesNotExist => 'ROM目录不存在';

  @override
  String get gamelistCheckResults => '游戏列表检查结果';

  @override
  String get totalPlatforms => '平台总数';

  @override
  String get missingGamelists => '缺失的游戏列表';

  @override
  String get configurationBackup => '配置备份';

  @override
  String get configurationBackedUp => '配置已备份到:';

  @override
  String get errorBackingUp => '备份配置时出错:';

  @override
  String get romDatabase => 'ROM数据库';

  @override
  String get romDatabaseDownloaded => 'ROM数据库下载成功';

  @override
  String get failedDownloadRomDatabase => '下载ROM数据库失败';

  @override
  String get romDatabaseCleared => 'ROM数据库已清除';

  @override
  String get failedClearDatabase => '清除数据库失败';

  @override
  String get downloadRomDatabase => '下载ROM数据库';

  @override
  String get clearRomDatabase => '清除ROM数据库';

  @override
  String get systemRequirements => '系统要求';

  @override
  String get failedToCheckSystem => '检查系统失败';

  @override
  String cleanedUpTempFiles(String deletedCount) {
    return '已清理 $deletedCount 个临时ROM文件';
  }

  @override
  String get errorCleaningTempFiles => '清理临时文件时出错:';

  @override
  String get errorVerifyingRomFiles => '验证ROM文件时出错:';

  @override
  String get errorCheckingGamelists => '检查游戏列表时出错:';

  @override
  String get cancelDownload => '取消下载';

  @override
  String get selectEmulator => '选择模拟器';

  @override
  String get biosStatusDashboard => 'BIOS状态仪表板';

  @override
  String get webSettings => '网络设置';

  @override
  String get saveSettings => '保存设置';

  @override
  String get errorSavingSettings => '保存设置时出错:';

  @override
  String romsCountItems(String count) {
    return '$count 个ROM';
  }

  @override
  String get savedPermanently => '已永久保存';

  @override
  String get keptInTemporary => '保留在临时存储中';

  @override
  String get tryAgain => '重试';

  @override
  String get allDownloads => '所有下载已完成';

  @override
  String romSavedPermanently(String name) {
    return '$name 已永久保存';
  }

  @override
  String get undo => '撤销';

  @override
  String romKeptInTemporary(String name) {
    return '$name 保留在临时存储中';
  }

  @override
  String romsCountWithSize(String count, String size) {
    return '$count 个ROM • $size';
  }

  @override
  String get whatYouCanTry => '您可以尝试:';

  @override
  String get tips => '提示';

  @override
  String get helpNavigateItems => '在项目间导航';

  @override
  String get helpGamepadNavigation => '手柄导航';

  @override
  String get helpQuickNavigation => '快速导航 (跳过多个项目)';

  @override
  String get helpGamepadPageNavigation => '手柄页面导航';

  @override
  String get helpGoToFirst => '转到第一个项目';

  @override
  String get helpGoToLast => '转到最后一个项目';

  @override
  String get helpJumpToLetter => '跳转到以该字母开头的项目';

  @override
  String get helpSelectItem => '选择项目';

  @override
  String get helpGamepadSelect => '手柄选择';

  @override
  String get helpGoBackCloseDialogs => '返回 / 关闭对话框';

  @override
  String get helpExitApplication => '退出应用';

  @override
  String get helpGamepadBackClose => '手柄返回 / 关闭对话框';

  @override
  String get helpToggleViewMode => '切换视图模式 (网格/列表/轮播)';

  @override
  String get helpGamepadViewToggle => '使用手柄切换视图';

  @override
  String get helpRefreshView => '刷新当前视图';

  @override
  String get helpShowPlatformInfo => '显示平台信息';

  @override
  String get helpActivateSearch => '激活搜索';

  @override
  String get helpGamepadSearch => '手柄搜索';

  @override
  String get helpShowHelpDialog => '显示此帮助对话框';

  @override
  String get helpGamepadHelp => '手柄帮助';

  @override
  String get tipUseKeyboardOrGamepad => '使用键盘或手柄导航';

  @override
  String get tipAlphabeticalJump => '字母跳转在所有视图模式下都有效';

  @override
  String get tipPressQuestionMark => '随时按 ? 查看此帮助';

  @override
  String get tipGamepadAlongside => '手柄可与键盘控制配合使用';

  @override
  String get configurePathsDescription => '配置应用程序用于定位ROM、媒体和模拟器的路径。';

  @override
  String get romListsAutoManaged => 'ROM列表现在自动管理。请从设置 > ROM数据库下载。';

  @override
  String get romStorage => 'ROM存储';

  @override
  String get configureRomStorageDescription => '配置下载的ROM的临时和永久存储位置。';

  @override
  String get resetToDefaults => '重置为默认值';

  @override
  String get mediaPathLabel => '媒体路径';

  @override
  String get mediaPathHint => '包含媒体 (图片、视频) 的目录';

  @override
  String get emulatorsPathLabel => '模拟器路径';

  @override
  String get emulatorsPathHint => '包含模拟器可执行文件的目录';

  @override
  String get gamelistPathAutomatic => '游戏列表路径 (自动)';

  @override
  String get gamelistAutoDescription =>
      '游戏列表现在在应用数据目录中自动管理。这使应用完全独立，并为未来基于GitHub的游戏列表分发做好准备。';

  @override
  String get tempRomStorageLabel => '临时ROM存储 (可选)';

  @override
  String get tempRomStorageDescription => 'ROM首先下载到这里。可以在玩完后升级到永久存储。';

  @override
  String get permanentRomStorageLabel => '永久ROM存储 (可选)';

  @override
  String get permanentRomStorageDescription => '永久保存的ROM存储在这里。这些不会自动清理。';

  @override
  String get defaultAppSupportDir => '默认: 应用支持目录';

  @override
  String currentPathDisplay(String path) {
    return '当前: $path';
  }

  @override
  String get configurationFile => '配置文件';

  @override
  String get source => '来源:';

  @override
  String get customConfigActive => '自定义配置已激活';

  @override
  String get pathStructure => '路径结构';

  @override
  String get pathStructureDescription =>
      '媒体路径: MEDIA_PATH/平台/boxart|screenshots|videos/rom.png\n游戏列表路径: ~/.local/share/com.example.emulator/gamelists/平台/gamelist.xml (自动)\n模拟器路径: EMULATORS_PATH/emulator_binary';

  @override
  String get errorCheckingSystem => '检查系统时出错';

  @override
  String get recheckR => '重新检查 (R)';

  @override
  String get allRequiredToolsInstalled => '所有必需工具已安装';

  @override
  String get missingRequiredTools => '缺少必需工具';

  @override
  String get systemReadyToUse => '您的系统已准备好使用模拟器';

  @override
  String get someRequiredToolsMissing => '一些必需工具缺失';

  @override
  String get requiredTools => '必需工具';

  @override
  String get requiredToolsDescription => '这些工具是下载和解压模拟器所必需的';

  @override
  String get installationInstructions => '安装说明';

  @override
  String get installed => '已安装';

  @override
  String get missing => '缺失';

  @override
  String get downloadEmulatorsAndGameLists => '下载模拟器和游戏列表';

  @override
  String get quickActions => '快速操作';

  @override
  String get downloadAll => '下载全部';

  @override
  String get byCategory => '按类别';

  @override
  String get downloadQueue => '下载队列';

  @override
  String get noDownloadsInProgress => '没有正在进行的下载';

  @override
  String get selectQuickActionToStart => '选择上面的快速操作开始下载';

  @override
  String get categorySony => 'Sony (PS1-PS4)';

  @override
  String get categoryNintendo => 'Nintendo (GC, Wii, Switch)';

  @override
  String get categoryMicrosoft => 'Microsoft (Xbox, Xbox 360)';

  @override
  String get categoryMultiPlatform => '多平台 (RetroArch)';

  @override
  String get categoryOtherEmulators => '其他模拟器';

  @override
  String get categoryUtilities => '工具';

  @override
  String confirmDownloadDescription(String count, String size) {
    return '下载 $count 个模拟器?\n估计大小: ~$size MB\n\n根据您的网络连接,这可能需要一些时间。';
  }

  @override
  String get alreadyInstalled => '已安装';

  @override
  String get starting => '正在启动...';

  @override
  String get completed => '已完成';

  @override
  String get gameListsAlreadyDownloaded => '游戏列表已下载';

  @override
  String get redownload => '重新下载';

  @override
  String get gameListsFromGitHub => '游戏列表 (来自GitHub)';

  @override
  String get downloaded => '已下载';

  @override
  String get cancelled => '已取消';

  @override
  String get missingFor => '缺失于:';

  @override
  String get noCustomConfigToBackup => '没有要备份的自定义配置。使用默认设置。';

  @override
  String get saveConfigurationBackup => '保存配置备份';

  @override
  String get refreshStatsR => '刷新统计 (R)';

  @override
  String get systemStatistics => '系统统计';

  @override
  String get romFiles => 'ROM文件';

  @override
  String get maintenanceTools => '维护工具';

  @override
  String get cleanupTemporaryRoms => '清理临时ROM';

  @override
  String get cleanupTemporaryRomsDescription => '从系统临时目录中删除临时ROM文件';

  @override
  String get verifyRomFiles => '验证ROM文件';

  @override
  String get verifyRomFilesDescription => '检查所有ROM文件是否存在且有效';

  @override
  String get checkMissingGamelists => '检查缺失的游戏列表';

  @override
  String get checkMissingGamelistsDescription => '查找没有gamelist.xml文件的平台';

  @override
  String get backupConfiguration => '备份配置';

  @override
  String get backupConfigurationDescription => '创建config.json的备份';

  @override
  String get downloadingRomDatabase => '正在下载ROM数据库...';

  @override
  String get downloadMayTakeMinutes => '根据您的连接,这可能需要几分钟...';

  @override
  String get databaseStatus => '数据库状态';

  @override
  String get notDownloaded => '未下载';

  @override
  String get aboutRomDatabase => '关于ROM数据库';

  @override
  String get aboutRomDatabaseDescription =>
      'ROM数据库包含按平台组织的可用ROM列表。它从GitHub上的Forsaken romList仓库下载。';

  @override
  String get romDatabaseSource => '来源: github.com/ForsakenStation/romList';

  @override
  String get downloadRomDatabaseDescription =>
      '这将从GitHub上的Forsaken romList仓库下载ROM列表。';

  @override
  String get downloadRomDatabaseStats => '大小: ~7 MB\n平台: 138\nROM总数: ~240,000';

  @override
  String get downloadWillOverwrite => '注意: 这将覆盖现有数据。';

  @override
  String get clearRomDatabaseDescription => '这将删除所有下载的ROM列表并将数据库重置为初始状态。';

  @override
  String get gamelistsStatus => '游戏列表状态';

  @override
  String get gamelistsDownloaded => '已下载';

  @override
  String get gamelistsNotDownloaded => '未下载';

  @override
  String get aboutGamelists => '关于游戏列表';

  @override
  String get aboutGamelistsDescription =>
      '游戏列表包含每个平台的游戏元数据 (名称、描述、评分)。它们从GitHub上的Forsaken gamelists仓库下载。';

  @override
  String get gamelistsSource => '来源: github.com/ForsakenStation/gamelists';

  @override
  String get downloadGamelists => '下载游戏列表';

  @override
  String get downloadGamelistsDescription =>
      '这将从GitHub上的Forsaken gamelists仓库下载gamelist.xml文件。';

  @override
  String get downloadGamelistsWillOverwrite => '注意: 这将覆盖现有的游戏列表文件。';

  @override
  String get downloadingGamelists => '正在下载游戏列表...';

  @override
  String get gamelistsDownloadedSuccess => '游戏列表下载成功';

  @override
  String get failedDownloadGamelists => '下载游戏列表失败';

  @override
  String get clearGamelists => '清除游戏列表';

  @override
  String get clearGamelistsDescription => '这将删除所有下载的游戏列表文件。';

  @override
  String get gamelistsCleared => '游戏列表已清除';

  @override
  String get failedClearGamelists => '清除游戏列表失败';

  @override
  String get rebuildMediaCache => '重建媒体缓存';

  @override
  String get rebuildMediaCacheDescription => '扫描媒体目录并将路径缓存到游戏列表中以加快加载速度';

  @override
  String get rebuildMediaCacheConfirmTitle => '重建媒体缓存?';

  @override
  String get rebuildMediaCacheConfirmBody =>
      '这将扫描所有媒体目录并用媒体路径更新gamelist.xml文件。对于大型收藏集,这可能需要一些时间。';

  @override
  String get rebuildMediaCacheProgress => '正在重建媒体缓存...';

  @override
  String rebuildMediaCacheProcessingPlatform(
    String platform,
    String current,
    String total,
  ) {
    return '正在处理 $platform ($current/$total)';
  }

  @override
  String get rebuildMediaCacheComplete => '媒体缓存已重建';

  @override
  String rebuildMediaCacheSummary(
    String platforms,
    String games,
    String updated,
    String paths,
  ) {
    return '$platforms 个平台,$games 个游戏已扫描,$updated 个已更新,$paths 个媒体路径已缓存';
  }

  @override
  String get rebuildMediaCacheError => '重建媒体缓存失败';

  @override
  String rebuildMediaCacheErrors(String count) {
    return '重建过程中发生 $count 个错误';
  }

  @override
  String get description => '描述';

  @override
  String get noDescriptionAvailable => '此ROM没有可用的描述。';

  @override
  String get releaseDate => '发行日期';

  @override
  String get players => '玩家数';

  @override
  String get rating => '评分';

  @override
  String get regions => '地区';

  @override
  String folderRomCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个ROM',
    );
    return '$_temp0';
  }

  @override
  String manualTitle(String name) {
    return '$name - 手册';
  }

  @override
  String get playInBrowser => '在浏览器中游玩';

  @override
  String downloadingPlatformBios(String platformName) {
    return '正在下载 $platformName BIOS';
  }

  @override
  String get downloadingAllMissingBios => '正在下载所有缺失的 BIOS';

  @override
  String biosFileLabel(String filename) {
    return '文件：$filename';
  }

  @override
  String batchProgressLabel(String completed, String total) {
    return '进度：$completed/$total 个文件';
  }

  @override
  String get fileDetails => '文件详情：';

  @override
  String get waiting => '等待中...';

  @override
  String get verifying => '验证中...';

  @override
  String get failed => '失败';

  @override
  String get preparing => '准备中...';

  @override
  String get downloadingFiles => '正在下载文件...';

  @override
  String get someDownloadsFailed => '部分下载失败';

  @override
  String get downloadsCancelled => '下载已取消';

  @override
  String get calculating => '计算中...';

  @override
  String secondsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count秒',
    );
    return '$_temp0';
  }

  @override
  String minutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count分钟',
    );
    return '$_temp0';
  }

  @override
  String hoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count小时',
    );
    return '$_temp0';
  }

  @override
  String get downloadingAndLaunching => '正在下载并启动...';

  @override
  String get launching => '正在启动...';

  @override
  String emulatorLabel(String name) {
    return '模拟器：$name';
  }

  @override
  String get generalInformation => '基本信息';

  @override
  String get manufacturer => '制造商';

  @override
  String get releaseYear => '发行年份';

  @override
  String get generation => '世代';

  @override
  String get technicalSpecifications => '技术规格';

  @override
  String get resolution => '分辨率';

  @override
  String get colors => '色彩';

  @override
  String get notNow => '暂不';

  @override
  String get saveRomPermanently => '永久保存 ROM？';

  @override
  String get keepRomOfflineQuestion => '您想保留已下载的 ROM 以便离线游玩吗？';

  @override
  String get deletedToSaveSpace => '否则，稍后将删除以节省空间。';
}
