// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Forsaken Emulator';

  @override
  String get retroGamingFrontend => 'レトロゲームフロントエンド';

  @override
  String get platforms => 'プラットフォーム';

  @override
  String get roms => 'ROM';

  @override
  String get settings => '設定';

  @override
  String get settingsAndConfiguration => '設定と構成';

  @override
  String get aboutForsakenEmulator => 'Forsaken Emulatorについて';

  @override
  String get version => 'バージョン';

  @override
  String get appDescription => 'Flutterで構築されたモダンなマルチプラットフォームエミュレーターフロントエンド。';

  @override
  String get emulators => 'エミュレーター';

  @override
  String get ready => '準備完了';

  @override
  String get back => '戻る';

  @override
  String get select => '選択';

  @override
  String get search => '検索';

  @override
  String get refresh => '更新';

  @override
  String get loading => '読み込み中...';

  @override
  String get error => 'エラー';

  @override
  String get initializationError => '初期化エラー';

  @override
  String get retry => '再試行';

  @override
  String get cancel => 'キャンセル';

  @override
  String get ok => 'OK';

  @override
  String get save => '保存';

  @override
  String get delete => '削除';

  @override
  String get confirm => '確認';

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

  @override
  String get close => '閉じる';

  @override
  String get noRomsFound => 'ROMが見つかりません';

  @override
  String get noPlatformsFound => 'プラットフォームが見つかりません';

  @override
  String get checkRomsPath => 'ROMS_PATH環境変数を 확인하세요';

  @override
  String get downloading => 'ダウンロード中...';

  @override
  String get downloadComplete => 'ダウンロード完了';

  @override
  String get downloadFailed => 'ダウンロード失敗';

  @override
  String get emulatorNotFound => 'エミュレーターが見つかりません';

  @override
  String get romNotFound => 'ROMが見つかりません';

  @override
  String get biosRequired => '必須';

  @override
  String get systemCheck => 'システムチェック';

  @override
  String get language => '言語';

  @override
  String get theme => 'テーマ';

  @override
  String get systemDefault => 'システムデフォルト';

  @override
  String get help => 'ヘルプ';

  @override
  String get keyboardAndGamepadControls => 'キーボードとゲームパッドの操作';

  @override
  String get navigation => 'ナビゲーション';

  @override
  String get actions => 'アクション';

  @override
  String get viewControls => '表示コントロール';

  @override
  String get gotIt => '了解!';

  @override
  String get exit => '終了';

  @override
  String get exitApplication => 'アプリケーションを終了';

  @override
  String get exitConfirm => '終了してもよろしいですか?';

  @override
  String get downloadManager => 'ダウンロードマネージャー';

  @override
  String get clearCompleted => '完了をクリア';

  @override
  String get selectCategory => 'カテゴリを選択';

  @override
  String get confirmDownload => 'ダウンロードを確認';

  @override
  String get downloadGameLists => 'ゲームリストをダウンロード';

  @override
  String get downloadGameListsDescription => 'GitHubからROMリストをダウンロードします。';

  @override
  String get gameListsDownloaded => 'ゲームリストをダウンロードしました!';

  @override
  String get romStorageManagement => 'ROMストレージ管理';

  @override
  String get deleteRom => 'ROMを削除?';

  @override
  String deleteRomConfirm(String fileName) {
    return '$fileNameを削除しますか?';
  }

  @override
  String get actionCannotBeUndone => 'この操作は元に戻せません。';

  @override
  String deleted(String fileName) {
    return '削除: $fileName';
  }

  @override
  String get savePermanently => '永久に保存?';

  @override
  String moveRomConfirm(String fileName) {
    return '$fileNameを永久ストレージに移動しますか?';
  }

  @override
  String saved(String fileName) {
    return '保存: $fileName';
  }

  @override
  String get clearAll => 'すべてクリア?';

  @override
  String get clearAllConfirm => 'すべての 임시ROMを削除しますか?';

  @override
  String get allCleared => 'すべての仮ROMをクリアしました';

  @override
  String get systemPathsConfiguration => 'システムパス構成';

  @override
  String get migrateRoms => 'ROMを移行?';

  @override
  String get migrateRomsDescription =>
      'ROMの永続ストレージパスが\$oldPathから\$newPathに変更されました。既存のROMを新しい場所に移行しますか?';

  @override
  String get noKeepThem => 'いいえ、保持';

  @override
  String get yesMigrateRoms => 'はい、ROMを移行';

  @override
  String get migratingRoms => 'ROMを移行中...';

  @override
  String get romMigrationFailed => '警告: ROMの移行に失敗しました';

  @override
  String get pathsSaved => 'パスが正常に保存されました';

  @override
  String get errorSavingPaths => 'パス保存エラー:';

  @override
  String get resetConfiguration => '構成をリセット';

  @override
  String get resetConfigDescription =>
      'すべてのパスをデフォルト値にリセットします。ROMとメディアファイルは影響を受けません。';

  @override
  String get configurationReset => '構成がデフォルトにリセットされました';

  @override
  String get errorResettingConfiguration => '構成リセットエラー:';

  @override
  String get savePaths => 'パスを保存';

  @override
  String get saving => '保存中...';

  @override
  String get emulatorManagement => 'エミュレーター管理';

  @override
  String get configurationReloaded => '構成が再読み込みされました';

  @override
  String get errorLoadingEmulators => 'エミュレーター読み込みエラー:';

  @override
  String get emulatorAdded => 'エミュレーターが正常に追加されました';

  @override
  String get errorAddingEmulator => 'エミュレーター追加エラー:';

  @override
  String get emulatorUpdated => 'エミュレーターが正常に更新されました';

  @override
  String get errorUpdatingEmulator => 'エミュレーター更新エラー:';

  @override
  String get deleteEmulator => 'エミュレーターを削除';

  @override
  String get emulatorDeleted => 'エミュレーターが削除されました';

  @override
  String get errorDeletingEmulator => 'エミュレーター削除エラー:';

  @override
  String get configurationSource => '構成ソース';

  @override
  String get addEmulator => 'エミュレーターを追加';

  @override
  String get systemNameRequired => 'システム名は必須です';

  @override
  String get commandRequired => '少なくとも1つのコマンドが必要です';

  @override
  String get addCommand => 'コマンドを追加';

  @override
  String get acceptZipFiles => 'ZIPファイルを受け入れる';

  @override
  String get acceptZipSubtitle => 'ZIPアーカイブからROMを起動することを許可';

  @override
  String get useForeverMode => 'Foreverモードを使用';

  @override
  String get useForeverSubtitle => 'エミュレーターを実行し続ける';

  @override
  String get workInProgress => '作業中';

  @override
  String get wipSubtitle => 'まだ完全に構成されていないとしてマーク';

  @override
  String get biosFirmwareHelp => 'BIOSとファームウェアのヘルプ';

  @override
  String get downloadMissingFiles => '欠落ファイルをダウンロード';

  @override
  String get showOnlyMissing => '欠落のみ表示';

  @override
  String get downloadAllMissingBios => 'すべての欠落BIOSをダウンロード';

  @override
  String get configurationError => '構成エラー';

  @override
  String get configurationErrorDescription =>
      'アプリケーションが必要な構成を見つけられませんでした。\n設定>システムパスでパスを構成してください。';

  @override
  String get configurationRequired =>
      '必須:\n- メデイアパス: メディアアセットを含むディレクトリ\n- エミュレーターパス: エミュレーターのバイナリを含むディレクトリ\n\nオプション:\n- 一時/永続的なダウンロード用のROMストレージパス';

  @override
  String get goToSettingsToConfigure => '設定>システムパスで構成するには移動';

  @override
  String get noDownloadableBios => 'ダウンロード可能なBIOSファイルは欠落していません';

  @override
  String get allDownloadsCompleted => 'すべてのダウンロードが正常に完了しました!';

  @override
  String get batchDownloadFailed => 'バッチダウンロード失敗:';

  @override
  String get download => 'ダウンロード';

  @override
  String get downloadCancelled => 'ダウンロードがキャンセルされました';

  @override
  String get launched => '起動:';

  @override
  String get failedToSave => 'ROMを永久に保存できませんでした';

  @override
  String get failedToSaveRom => 'ROMを永久に保存できませんでした';

  @override
  String get errorSaving => 'ROM保存エラー:';

  @override
  String errorSavingRom(String error) {
    return 'ROM保存エラー: $error';
  }

  @override
  String get openFolder => 'フォルダを開く';

  @override
  String get viewManual => 'マニュアルを見る';

  @override
  String get play => 'プレイ';

  @override
  String get goBack => '戻る';

  @override
  String get clearSearch => '検索をクリア';

  @override
  String get iUnderstand => '理解し、これらの条件に同意します';

  @override
  String get start => '開始';

  @override
  String get debugMode => 'デバッグモード: ';

  @override
  String get toggleDebugMode => 'デバッグモード切替';

  @override
  String get preparingDownload => 'ダウンロードを準備中...';

  @override
  String get noEmulatorsAvailable => 'このカテゴリには利用可能なエミュレーターがありません';

  @override
  String get failedToLaunch => 'Webエミュレーターの起動に失敗しました:';

  @override
  String get platformInfo => 'プラットフォーム情報';

  @override
  String get emulatorPlatformInfo => 'エミュレータープラットフォーム情報';

  @override
  String get favorites => 'お気に入り';

  @override
  String get all => 'すべて';

  @override
  String get collections => 'コレクション';

  @override
  String get searchRoms => 'ROMを検索...';

  @override
  String get searchPlatforms => 'プラットフォームを検索...';

  @override
  String romsCount(int count) {
    return '$count ROM';
  }

  @override
  String platformsCount(int count) {
    return '$count プラットフォーム';
  }

  @override
  String get region => '地域';

  @override
  String get genre => 'ジャンル';

  @override
  String get year => '年';

  @override
  String get publisher => '発売元';

  @override
  String get developer => '開発者';

  @override
  String get playWithNetplay => 'ネットプレイでプレイ';

  @override
  String get downloadBios => 'BIOSをダウンロード';

  @override
  String get viewDetails => '詳細を見る';

  @override
  String get addToFavorites => 'お気に入りに追加';

  @override
  String get removeFromFavorites => 'お気に入りから削除';

  @override
  String get biosMissing => '不足';

  @override
  String get biosPresent => 'BIOSが存在';

  @override
  String get checkingBios => 'BIOSを確認中...';

  @override
  String get emulatorDownloading => 'エミュレーターをダウンロード中...';

  @override
  String get emulatorDownloadComplete => 'エミュレーターがダウンロードされました';

  @override
  String get emulatorDownloadFailed => 'エミュレーターのダウンロードに失敗しました';

  @override
  String get installingEmulator => 'エミュレーターをインストール中...';

  @override
  String get emulatorReady => 'エミュレーター準備完了';

  @override
  String get configuration => '構成';

  @override
  String get paths => 'パス';

  @override
  String get storage => 'ストレージ';

  @override
  String get emulatorsPath => 'エミュレーターへのパス';

  @override
  String get romsPath => 'ROMへのパス';

  @override
  String get mediaPath => 'メディアへのパス';

  @override
  String get biosPath => 'BIOSへのパス';

  @override
  String get tempPath => '一時パス';

  @override
  String get browse => '参照';

  @override
  String get apply => '適用';

  @override
  String get reset => 'リセット';

  @override
  String get clear => 'クリア';

  @override
  String get scan => 'スキャン';

  @override
  String get scanForRoms => 'ROMをスキャン';

  @override
  String get scanningRoms => 'ROMをスキャン中...';

  @override
  String get scanComplete => 'スキャン完了';

  @override
  String romsFound(int count) {
    return '$count ROMが見つかりました';
  }

  @override
  String get noNewRomsFound => '新しいROMが見つかりません';

  @override
  String get launchEmulator => 'エミュレーターを起動';

  @override
  String get emulatorError => 'エミュレーターエラー';

  @override
  String get gamepadConnected => 'ゲームパッド接続済み';

  @override
  String get gamepadDisconnected => 'ゲームパッド切断';

  @override
  String get gamepadTest => 'ゲームパッドテスト';

  @override
  String get pressAnyButton => 'テストするには任意のボタンを押してください';

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
  String get leftStick => '左スティック';

  @override
  String get rightStick => '右スティック';

  @override
  String get setupWizard => 'セットアップウィザード';

  @override
  String get welcome => 'ようこそ';

  @override
  String get welcomeMessage => 'Forsaken Emulatorへようこそ';

  @override
  String get next => '次へ';

  @override
  String get previous => '前へ';

  @override
  String get finish => '完了';

  @override
  String get skip => 'スキップ';

  @override
  String get setupComplete => 'セットアップ完了';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get selectEmulatorsPath => 'エミュレーターパスを選択';

  @override
  String get selectRomsPath => 'ROMパスを選択';

  @override
  String get selectMediaPath => 'メディアパスを選択';

  @override
  String get allSettingsConfigured => 'すべての設定が完了しました';

  @override
  String get darkTheme => 'ダーク';

  @override
  String get lightTheme => 'ライト';

  @override
  String get systemTheme => 'システム';

  @override
  String get about => '概要';

  @override
  String get checkForUpdates => 'アップデートを確認';

  @override
  String get noUpdatesAvailable => '利用可能なアップデートはありません';

  @override
  String get updateAvailable => 'アップデートが利用可能です';

  @override
  String get downloadingUpdate => 'アップデートをダウンロード中...';

  @override
  String get installingUpdate => 'アップデートをインストール中...';

  @override
  String get updateComplete => 'アップデート完了';

  @override
  String get updateFailed => 'アップデート失敗';

  @override
  String get networkError => 'ネットワークエラー';

  @override
  String get connectionError => '接続エラー';

  @override
  String get timeoutError => 'タイムアウトエラー';

  @override
  String get unknownError => '不明なエラー';

  @override
  String get permissionDenied => '権限が拒否されました';

  @override
  String get fileNotFound => 'ファイルが見つかりません';

  @override
  String get directoryNotFound => 'ディレクトリが見つかりません';

  @override
  String get diskFull => 'ディスクがいっぱいです';

  @override
  String get invalidPath => '無効なパス';

  @override
  String get pathNotWritable => 'パスが書き込み不可';

  @override
  String get romCorrupted => 'ROMファイルが破損している可能性があります';

  @override
  String get zipError => 'ZIPアーカイブエラー';

  @override
  String get extractionFailed => '展開に失敗しました';

  @override
  String get checksumMismatch => 'チェックサム不一致';

  @override
  String get biosCheckFailed => 'BIOSチェックに失敗しました';

  @override
  String get continueAnyway => '関係なく続行';

  @override
  String get reportIssue => '問題を報告';

  @override
  String get copyToClipboard => 'クリップボードにコピー';

  @override
  String get copiedToClipboard => 'クリップボードにコピーしました';

  @override
  String get share => '共有';

  @override
  String get hide => '非表示';

  @override
  String get show => '表示';

  @override
  String get toggleView => '表示切替';

  @override
  String get gridView => 'グリッド表示';

  @override
  String get listView => 'リスト表示';

  @override
  String get carouselView => 'カルーセル表示';

  @override
  String get sortBy => '並び替え';

  @override
  String get sortByName => '名前';

  @override
  String get sortByDate => '日付';

  @override
  String get sortBySize => 'サイズ';

  @override
  String get sortByRegion => '地域';

  @override
  String get ascending => '昇順';

  @override
  String get descending => '降順';

  @override
  String get filter => 'フィルター';

  @override
  String get filterByRegion => '地域でフィルター';

  @override
  String get filterByGenre => 'ジャンルでフィルター';

  @override
  String get filterByYear => '年でフィルター';

  @override
  String get clearFilters => 'フィルターをクリア';

  @override
  String get systemInfo => 'システム情報';

  @override
  String get cpu => 'CPU';

  @override
  String get memory => 'メモリ';

  @override
  String get storageInfo => 'ストレージ';

  @override
  String get os => 'オペレーティングシステム';

  @override
  String get emulatorVersion => 'エミュレーターバージョン';

  @override
  String get totalRoms => 'ROM合計';

  @override
  String get totalSize => '合計サイズ';

  @override
  String get freeSpace => '空き容量';

  @override
  String get usedSpace => '使用容量';

  @override
  String get systemUtilities => 'システムユーティリティ';

  @override
  String get romVerificationResults => 'ROM検証結果';

  @override
  String get totalRomFiles => 'ROMファイル合計';

  @override
  String get emptyRomFiles => '空のROMファイル';

  @override
  String get validRomFiles => '有効なROMファイル';

  @override
  String get romsDirectoryDoesNotExist => 'ROMディレクトリが存在しません';

  @override
  String get gamelistCheckResults => 'ゲームリスト確認結果';

  @override
  String get totalPlatforms => 'プラットフォーム合計';

  @override
  String get missingGamelists => '欠落ゲームリスト';

  @override
  String get configurationBackup => '構成バックアップ';

  @override
  String get configurationBackedUp => '構成がバックアップされました:';

  @override
  String get errorBackingUp => '構成バックアップエラー:';

  @override
  String get romDatabase => 'ROMデータベース';

  @override
  String get romDatabaseDownloaded => 'ROMデータベースが正常にダウンロードされました';

  @override
  String get failedDownloadRomDatabase => 'ROMデータベースのダウンロードに失敗しました';

  @override
  String get romDatabaseCleared => 'ROMデータベースがクリアされました';

  @override
  String get failedClearDatabase => 'データベースのクリアに失敗しました';

  @override
  String get downloadRomDatabase => 'ROMデータベースをダウンロード';

  @override
  String get clearRomDatabase => 'ROMデータベースをクリア';

  @override
  String get systemRequirements => 'システム要件';

  @override
  String get failedToCheckSystem => 'システムチェックに失敗しました';

  @override
  String cleanedUpTempFiles(String deletedCount) {
    return '$deletedCountの一時ROMファイルをクリーンアップしました';
  }

  @override
  String get errorCleaningTempFiles => '一時ファイルクリーンアップエラー:';

  @override
  String get errorVerifyingRomFiles => 'ROMファイル検証エラー:';

  @override
  String get errorCheckingGamelists => 'ゲームリスト確認エラー:';

  @override
  String get cancelDownload => 'ダウンロードをキャンセル';

  @override
  String get selectEmulator => 'エミュレーターを選択';

  @override
  String get biosStatusDashboard => 'BIOSステータスパネル';

  @override
  String get webSettings => 'Web設定';

  @override
  String get saveSettings => '設定を保存';

  @override
  String get errorSavingSettings => '設定保存エラー:';

  @override
  String romsCountItems(String count) {
    return '$count ROM';
  }

  @override
  String get savedPermanently => '永久に保存されました';

  @override
  String get keptInTemporary => '一時ストレージに保持';

  @override
  String get tryAgain => '再試行';

  @override
  String get allDownloads => 'すべてのダウンロードが完了しました';

  @override
  String romSavedPermanently(String name) {
    return '$nameが永久に保存されました';
  }

  @override
  String get undo => '元に戻す';

  @override
  String romKeptInTemporary(String name) {
    return '$nameが一時ストレージに保持されました';
  }

  @override
  String romsCountWithSize(String count, String size) {
    return '$count ROM • $size';
  }

  @override
  String get whatYouCanTry => '試せること:';

  @override
  String get tips => 'ヒント';

  @override
  String get helpNavigateItems => 'アイテム間を移動';

  @override
  String get helpGamepadNavigation => 'ゲームパッドナビゲーション';

  @override
  String get helpQuickNavigation => 'クイックナビゲーション (複数アイテムをスキップ)';

  @override
  String get helpGamepadPageNavigation => 'ゲームパッドページナビゲーション';

  @override
  String get helpGoToFirst => '最初のアイテムへ移動';

  @override
  String get helpGoToLast => '最後のアイテムへ移動';

  @override
  String get helpJumpToLetter => 'その文字で始まるアイテムへスキップ';

  @override
  String get helpSelectItem => 'アイテムを選択';

  @override
  String get helpGamepadSelect => 'ゲームパッド選択';

  @override
  String get helpGoBackCloseDialogs => '戻る / ダイアログを閉じる';

  @override
  String get helpExitApplication => 'アプリケーションを終了';

  @override
  String get helpGamepadBackClose => 'ゲームパッド戻る / ダイアログを閉じる';

  @override
  String get helpToggleViewMode => '表示モード切替 (グリッド/リスト/カルーセル)';

  @override
  String get helpGamepadViewToggle => 'ゲームパッドで表示を切替';

  @override
  String get helpRefreshView => '現在の表示を更新';

  @override
  String get helpShowPlatformInfo => 'プラットフォーム情報を表示';

  @override
  String get helpActivateSearch => '検索をアクティブ化';

  @override
  String get helpGamepadSearch => 'ゲームパッド検索';

  @override
  String get helpShowHelpDialog => 'このヘルプダイアログを表示';

  @override
  String get helpGamepadHelp => 'ゲームパッドヘルプ';

  @override
  String get tipUseKeyboardOrGamepad => 'ナビゲーションにはキーボードまたはゲームパッドを使用';

  @override
  String get tipAlphabeticalJump => 'アルファベットスキップはすべての表示モードで機能します';

  @override
  String get tipPressQuestionMark => 'このヘルプを表示するには?を押してください';

  @override
  String get tipGamepadAlongside => 'ゲームパッドはキーボード操作と一緒に動作します';

  @override
  String get configurePathsDescription =>
      'ROM、メディア、エミュレーターを見つけるためにアプリケーションが使用するパスを構成します。';

  @override
  String get romListsAutoManaged =>
      'ROMリストは自動的に管理されるようになりました。設定>ROMデータベースからダウンロードしてください。';

  @override
  String get romStorage => 'ROMストレージ';

  @override
  String get configureRomStorageDescription =>
      'ダウンロードしたROMを一時的および永続的に保存する場所を構成します。';

  @override
  String get resetToDefaults => 'デフォルトにリセット';

  @override
  String get mediaPathLabel => 'メディアパス';

  @override
  String get mediaPathHint => 'メディア (画像、ビデオ) を含むディレクトリ';

  @override
  String get emulatorsPathLabel => 'エミュレーターパス';

  @override
  String get emulatorsPathHint => 'エミュレーターのバイナリを含むディレクトリ';

  @override
  String get gamelistPathAutomatic => 'ゲームリストパス (自動)';

  @override
  String get gamelistAutoDescription =>
      'ゲームリストはアプリのデータディレクトリで自動的に管理されるようになりました。これにより、アプリは完全に独立し、将来のGitHubベースのゲームリスト配布の準備ができます。';

  @override
  String get tempRomStorageLabel => '一時ROMストレージ (オプション)';

  @override
  String get tempRomStorageDescription =>
      'ROMはまずここにダウンロードされます。プレイ後に永続ストレージに昇格できます。';

  @override
  String get permanentRomStorageLabel => '永続ROMストレージ (オプション)';

  @override
  String get permanentRomStorageDescription =>
      '永久に保存されたROMはここに保存されます。これらは自動的にクリーンアップされません。';

  @override
  String get defaultAppSupportDir => 'デフォルト: アプリサポートディレクトリ';

  @override
  String currentPathDisplay(String path) {
    return '現在: $path';
  }

  @override
  String get configurationFile => '構成ファイル';

  @override
  String get source => 'ソース:';

  @override
  String get customConfigActive => 'カスタム構成アクティブ';

  @override
  String get pathStructure => 'パス構造';

  @override
  String get pathStructureDescription =>
      'メデイアパス: MEDIA_PATH/プラットフォーム/boxart|screenshots|videos/rom.png\nゲームリストパス: ~/.local/share/com.example.emulator/gamelists/プラットフォーム/gamelist.xml (自動)\nエミュレーターパス: EMULATORS_PATH/emulator_binary';

  @override
  String get errorCheckingSystem => 'システム確認エラー';

  @override
  String get recheckR => '再確認 (R)';

  @override
  String get allRequiredToolsInstalled => 'すべての必要なツールがインストール済み';

  @override
  String get missingRequiredTools => '必要なツールが欠落';

  @override
  String get systemReadyToUse => 'システムはエミュレーターを使用 готовです';

  @override
  String get someRequiredToolsMissing => '一部の必要なツールが欠落しています';

  @override
  String get requiredTools => '必要なツール';

  @override
  String get requiredToolsDescription => 'これらのツールはエミュレーターのダウンロードと展開に必要です';

  @override
  String get installationInstructions => 'インストール手順';

  @override
  String get installed => 'インストール済み';

  @override
  String get missing => '欠落';

  @override
  String get downloadEmulatorsAndGameLists => 'エミュレーターとゲームリストをダウンロード';

  @override
  String get quickActions => 'クイックアクション';

  @override
  String get downloadAll => 'すべてダウンロード';

  @override
  String get byCategory => 'カテゴリ別';

  @override
  String get downloadQueue => 'ダウンロードキュー';

  @override
  String get noDownloadsInProgress => '進行中のダウンロードはありません';

  @override
  String get selectQuickActionToStart => 'ダウンロードを開始するには上のクイックアクションを選択';

  @override
  String get categorySony => 'Sony (PS1-PS4)';

  @override
  String get categoryNintendo => 'Nintendo (GC, Wii, Switch)';

  @override
  String get categoryMicrosoft => 'Microsoft (Xbox, Xbox 360)';

  @override
  String get categoryMultiPlatform => 'マルチプラットフォーム (RetroArch)';

  @override
  String get categoryOtherEmulators => 'その他のエミュレーター';

  @override
  String get categoryUtilities => 'ユーティリティ';

  @override
  String confirmDownloadDescription(String count, String size) {
    return '$count個のエミュレーターをダウンロード?\n推定サイズ: ~$size MB\n\nインターネット接続によっては時間がかかる場合があります。';
  }

  @override
  String get alreadyInstalled => '既にインストール済み';

  @override
  String get starting => '起動中...';

  @override
  String get completed => '完了';

  @override
  String get gameListsAlreadyDownloaded => 'ゲームリストは既にダウンロード済みです';

  @override
  String get redownload => '再ダウンロード';

  @override
  String get gameListsFromGitHub => 'ゲームリスト (GitHubから)';

  @override
  String get downloaded => 'ダウンロード済み';

  @override
  String get cancelled => 'キャンセル済み';

  @override
  String get missingFor => '欠落:';

  @override
  String get noCustomConfigToBackup => 'バックアップするカスタム構成はありません。デフォルトを使用します。';

  @override
  String get saveConfigurationBackup => '構成バックアップを保存';

  @override
  String get refreshStatsR => '統計を更新 (R)';

  @override
  String get systemStatistics => 'システム統計';

  @override
  String get romFiles => 'ROMファイル';

  @override
  String get maintenanceTools => 'メンテナンスツール';

  @override
  String get cleanupTemporaryRoms => '一時ROMをクリーンアップ';

  @override
  String get cleanupTemporaryRomsDescription => 'システムの一時ディレクトリから一時ROMファイルを削除';

  @override
  String get verifyRomFiles => 'ROMファイルを検証';

  @override
  String get verifyRomFilesDescription => 'すべてのROMファイルが存在し、有効であることを確認';

  @override
  String get checkMissingGamelists => '欠落ゲームリストを確認';

  @override
  String get checkMissingGamelistsDescription =>
      'gamelist.xmlファイルがないプラットフォームを見つける';

  @override
  String get backupConfiguration => '構成をバックアップ';

  @override
  String get backupConfigurationDescription => 'config.jsonのバックアップを作成';

  @override
  String get downloadingRomDatabase => 'ROMデータベースをダウンロード中...';

  @override
  String get downloadMayTakeMinutes => '接続によっては数分かかる場合があります...';

  @override
  String get databaseStatus => 'データベースステータス';

  @override
  String get notDownloaded => '未ダウンロード';

  @override
  String get aboutRomDatabase => 'ROMデータベースについて';

  @override
  String get aboutRomDatabaseDescription =>
      'ROMデータベースには、プラットフォーム別に整理された利用可能なROMのリストが含まれています。GitHubのForsaken romListリポジトリからダウンロードされます。';

  @override
  String get romDatabaseSource => 'ソース: github.com/ForsakenStation/romList';

  @override
  String get downloadRomDatabaseDescription =>
      'GitHubのForsaken romListリポジトリからROMリストをダウンロードします。';

  @override
  String get downloadRomDatabaseStats =>
      'サイズ: ~7 MB\nプラットフォーム: 138\nROM合計: ~240,000';

  @override
  String get downloadWillOverwrite => '注意: 既存のデータが上書きされます。';

  @override
  String get clearRomDatabaseDescription =>
      'すべてのダウンロードされたROMリストが削除され、データベースが初期状態にリセットされます。';

  @override
  String get gamelistsStatus => 'ゲームリストステータス';

  @override
  String get gamelistsDownloaded => 'ダウンロード済み';

  @override
  String get gamelistsNotDownloaded => '未ダウンロード';

  @override
  String get aboutGamelists => 'ゲームリストについて';

  @override
  String get aboutGamelistsDescription =>
      'ゲームリストには、各プラットフォームのゲームメタデータ (名前、説明、評価) が含まれます。GitHubのForsaken gamelistsリポジトリからダウンロードされます。';

  @override
  String get gamelistsSource => 'ソース: github.com/ForsakenStation/gamelists';

  @override
  String get downloadGamelists => 'ゲームリストをダウンロード';

  @override
  String get downloadGamelistsDescription =>
      'GitHubのForsaken gamelistsリポジトリからgamelist.xmlファイルをダウンロードします。';

  @override
  String get downloadGamelistsWillOverwrite => '注意: 既存のゲームリストファイルが上書きされます。';

  @override
  String get downloadingGamelists => 'ゲームリストをダウンロード中...';

  @override
  String get gamelistsDownloadedSuccess => 'ゲームリストが正常にダウンロードされました';

  @override
  String get failedDownloadGamelists => 'ゲームリストのダウンロードに失敗しました';

  @override
  String get clearGamelists => 'ゲームリストをクリア';

  @override
  String get clearGamelistsDescription => 'すべてのダウンロードされたゲームリストファイルが削除されます。';

  @override
  String get gamelistsCleared => 'ゲームリストがクリアされました';

  @override
  String get failedClearGamelists => 'ゲームリストのクリアに失敗しました';

  @override
  String get rebuildMediaCache => 'メディアキャッシュを再構築';

  @override
  String get rebuildMediaCacheDescription =>
      'メディアディレクトリをスキャンし、ゲームリストにパスをキャッシュして高速読み込み';

  @override
  String get rebuildMediaCacheConfirmTitle => 'メディアキャッシュを再構築?';

  @override
  String get rebuildMediaCacheConfirmBody =>
      'すべてのメディアディレクトリをスキャンし、gamelist.xmlファイルをメディアパスで更新します。大きなコレクションには時間がかかる場合があります。';

  @override
  String get rebuildMediaCacheProgress => 'メディアキャッシュを再構築中...';

  @override
  String rebuildMediaCacheProcessingPlatform(
    String platform,
    String current,
    String total,
  ) {
    return '$platformを処理中 ($current/$total)';
  }

  @override
  String get rebuildMediaCacheComplete => 'メディアキャッシュ再構築完了';

  @override
  String rebuildMediaCacheSummary(
    String platforms,
    String games,
    String updated,
    String paths,
  ) {
    return '$platformsプラットフォーム、$gamesゲームスキャン、$updated更新、$pathsメデイアパスキャッシュ済み';
  }

  @override
  String get rebuildMediaCacheError => 'メディアキャッシュの再構築に失敗しました';

  @override
  String rebuildMediaCacheErrors(String count) {
    return '再構築中に$count個のエラーが発生しました';
  }

  @override
  String get description => '説明';

  @override
  String get noDescriptionAvailable => 'このROMの説明はありません。';

  @override
  String get releaseDate => '発売日';

  @override
  String get players => 'プレイヤー数';

  @override
  String get rating => '評価';

  @override
  String get regions => '地域';

  @override
  String folderRomCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ROM',
    );
    return '$_temp0';
  }

  @override
  String manualTitle(String name) {
    return '$name - マニュアル';
  }

  @override
  String get playInBrowser => 'ブラウザでプレイ';

  @override
  String downloadingPlatformBios(String platformName) {
    return '$platformName BIOSをダウンロード中';
  }

  @override
  String get downloadingAllMissingBios => '不足しているすべてのBIOSをダウンロード中';

  @override
  String biosFileLabel(String filename) {
    return 'ファイル: $filename';
  }

  @override
  String batchProgressLabel(String completed, String total) {
    return '進捗: $completed/$total ファイル';
  }

  @override
  String get fileDetails => 'ファイル詳細:';

  @override
  String get waiting => '待機中...';

  @override
  String get verifying => '検証中...';

  @override
  String get failed => '失敗';

  @override
  String get preparing => '準備中...';

  @override
  String get downloadingFiles => 'ファイルをダウンロード中...';

  @override
  String get someDownloadsFailed => '一部のダウンロードが失敗しました';

  @override
  String get downloadsCancelled => 'ダウンロードがキャンセルされました';

  @override
  String get calculating => '計算中...';

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
      other: '$count分',
    );
    return '$_temp0';
  }

  @override
  String hoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count時間',
    );
    return '$_temp0';
  }

  @override
  String get downloadingAndLaunching => 'ダウンロードして起動中...';

  @override
  String get launching => '起動中...';

  @override
  String emulatorLabel(String name) {
    return 'エミュレータ: $name';
  }

  @override
  String get generalInformation => '一般情報';

  @override
  String get manufacturer => 'メーカー';

  @override
  String get releaseYear => '発売年';

  @override
  String get generation => '世代';

  @override
  String get technicalSpecifications => '技術仕様';

  @override
  String get resolution => '解像度';

  @override
  String get colors => '色数';

  @override
  String get notNow => '今はしない';

  @override
  String get saveRomPermanently => 'ROMを永久に保存しますか？';

  @override
  String get keepRomOfflineQuestion => 'このROMをダウンロードしたままにしてオフラインでプレイしますか？';

  @override
  String get deletedToSaveSpace => 'そうでなければ、後で容量を節約するために削除されます。';

  @override
  String get view => '表示';

  @override
  String get media => 'メディア';

  @override
  String get navigate => 'ナビゲート';

  @override
  String get info => '情報';

  @override
  String get toggleFilter => 'フィルター切替';

  @override
  String get changeTheme => 'テーマ変更';

  @override
  String get keyboard => 'キーボード';

  @override
  String get gamepad => 'ゲームパッド';

  @override
  String get hideKeyboard => 'キーボードを隠す';

  @override
  String get gameManual => 'ゲームマニュアル';

  @override
  String get pdfDocument => 'PDFドキュメント';

  @override
  String get manual => 'マニュアル';

  @override
  String get video => 'ビデオ';

  @override
  String get zoomOut => '縮小';

  @override
  String get zoomIn => '拡大';

  @override
  String pageCounter(String current, String total) {
    return 'ページ $current / $total';
  }

  @override
  String get zoom => 'ズーム';

  @override
  String get firstLast => '最初/最後';

  @override
  String get scroll => 'スクロール';

  @override
  String get loadingVideo => '動画を読み込み中...';

  @override
  String get playPause => '再生/一時停止';

  @override
  String get useArrowKeysToNavigate => '矢印キーまたはスワイプで操作してください';

  @override
  String get searchRomsHint => 'ROMを検索...';

  @override
  String get cancelSearch => '検索をキャンセル';

  @override
  String get virtualKeyboard => '仮想キーボード';

  @override
  String get noRomsAvailable => '利用可能なROMがありません';

  @override
  String get noRomsForPlatformMessage =>
      'このプラットフォームのROMファイルが見つかりません。ROMファイルはダウンロードURLを含む.txtファイルとしてプラットフォームディレクトリに配置する必要があります。';

  @override
  String get noMatchingRoms => '一致するROMがありません';

  @override
  String get tryDifferentSearch => '別の検索語をお試しください';

  @override
  String get saveToPermanentStorage => '永続ストレージに保存';

  @override
  String get temporary => '一時';

  @override
  String get permanent => '永続';

  @override
  String get tempPathLabel => '一時';

  @override
  String get foreverPathLabel => '永続';

  @override
  String get storageOverview => 'ストレージ概要';

  @override
  String get clearTemporaryStorage => '一時ストレージをクリア';

  @override
  String filesCount(String count) {
    return '$count ファイル';
  }

  @override
  String pathDisplay(String label, String path) {
    return '$labelパス: $path';
  }

  @override
  String get unknown => '不明';

  @override
  String get tagVerifiedGoodDump => '検証済みの正常なダンプ - 動作確認済み';

  @override
  String get tagBadDump => '不良ダンプ - 正常に動作しない可能性があります';

  @override
  String get tagAlternateVersion => '代替バージョン';

  @override
  String get tagOverdump => 'オーバーダンプ - 余分なデータを含みます';

  @override
  String get tagModifiedHacked => '改造/ハックされたROM';

  @override
  String get tagFanTranslation => 'ファン翻訳';

  @override
  String get tagPirateBootleg => '海賊版/ブートレグ版';

  @override
  String get tagFixedVersion => '修正バージョン';

  @override
  String get tagCheatTrainer => 'チートトレーナー付き';

  @override
  String tagVersion(String text) {
    return 'バージョン: $text';
  }

  @override
  String tagSpecialRelease(String text) {
    return '特別リリース: $text';
  }

  @override
  String tagMediaInfo(String text) {
    return 'メディア情報: $text';
  }

  @override
  String noEmulatorConfigured(
    String displayName,
    String platform,
    String configPath,
  ) {
    return '$displayName用のエミュレーターが設定されていません。\n\n\"$platform\"の設定を以下に追加してください:\n$configPath';
  }

  @override
  String get noEmulatorCommandAvailable => '利用可能なエミュレーターコマンドがありません';

  @override
  String platformNotSupportedWeb(String platform, String supportedPlatforms) {
    return 'プラットフォーム「$platform」はまだWebブラウザでサポートされていません。\n\nサポートされているプラットフォーム: $supportedPlatforms';
  }

  @override
  String failedToLaunchWebEmulator(String error) {
    return 'Webエミュレーターの起動に失敗しました: $error';
  }

  @override
  String failedToLaunchRom(String error) {
    return 'ROMの起動に失敗しました。\n\n以下を確認してください:\n• エミュレーターが正しくインストールされていること\n• ROMファイルが有効であること\n• 設定が正しいこと\n\nエラー: $error';
  }

  @override
  String errorLaunchingRom(String error) {
    return 'ROM起動エラー: $error';
  }

  @override
  String noInfoAvailable(String platformName) {
    return '$platformNameの情報はありません';
  }

  @override
  String get platformInfoTooltip => 'プラットフォーム情報 (I)';

  @override
  String get navigationHint => '矢印キーまたはスワイプで移動';

  @override
  String get noGamesFound => 'ゲームが見つかりません';

  @override
  String get noGamesFoundForSearch => '検索に一致するゲームが見つかりません';

  @override
  String get tryDifferentSearchOrClear => '別の検索語を試すか、フィルターをクリアしてください';

  @override
  String get checkStorageOrDownload => 'ストレージ設定を確認するか、ROMをダウンロードしてください';

  @override
  String get searchGamesHint => 'ゲームを検索...';

  @override
  String get settingsHeaderTitle => 'Forsakenエミュレーター設定';

  @override
  String get settingsHeaderSubtitle => 'エミュレーター、パス設定、コンテンツのダウンロード';

  @override
  String get emulatorManagementDesc => 'エミュレーターコマンドの追加、編集、設定';

  @override
  String get systemPaths => 'システムパス';

  @override
  String get systemPathsDesc => 'ROM、メディア、エミュレーターのパスを設定';

  @override
  String get romDatabaseDesc => 'GitHubからROMリストをダウンロードして管理';

  @override
  String get romStorageDesc => 'ダウンロードしたROM、ストレージ、一時ファイルのクリーンアップを管理';

  @override
  String get downloadManagerDesc => 'エミュレーター、ROMリスト、ゲームデータのダウンロード';

  @override
  String get systemRequirementsDesc => '必要なツールと依存関係を確認';

  @override
  String get gamepadTestDebug => 'ゲームパッドテストとデバッグ';

  @override
  String get gamepadTestDebugDesc => 'ゲームパッドのボタン、軸のテストと問題のトラブルシューティング';

  @override
  String get biosFirmwareHelpDesc => 'BIOSファイルとファームウェア要件の確認';

  @override
  String get webSettingsDesc => 'CORSプロキシとWebプラットフォーム設定';

  @override
  String get setupWizardDesc => '初期セットアップウィザードを再実行';

  @override
  String get languageDesc => 'アプリケーション言語を選択';

  @override
  String get aboutDebug => '情報とデバッグ';

  @override
  String get aboutDebugDesc => 'アプリ情報とデバッグ設定';

  @override
  String get legalDisclaimer => '法的免責事項';

  @override
  String get romDatabaseCredits => 'ROMリストはArley4dのAndroidRomsリポジトリから提供されています：';

  @override
  String get romDatabaseThanks =>
      '保存目的で包括的なROMデータベースを維持しているAndroidRomsプロジェクトに特別な感謝を。';

  @override
  String get biosFilesSection => 'BIOSファイル';

  @override
  String get biosFilesCredits =>
      'BIOSファイルはAbdessのretrorch_systemリポジトリから提供されています：';

  @override
  String get biosFilesThanks =>
      'このリポジトリには、さまざまなエミュレーションプラットフォームに必要なシステムファイルとBIOSが含まれています。これらの重要なファイルを保存してくれたメンテナーに特別な感謝を。';

  @override
  String get amigaCopyProtection => 'Amigaのコピープロテクションサポートはcapsimgライブラリにより提供：';

  @override
  String get amigaCopyProtectionThanks =>
      'Amigaエミュレーション用のIPF（コピープロテクト）ディスクイメージサポートを可能にするcapsimgライブラリを維持しているrsn8887に特別な感謝を。';

  @override
  String get additionalBiosFiles => '追加のBIOSファイルはRetroPieBiosプロジェクトにより提供：';

  @override
  String get additionalBiosThanks =>
      '異なるシステムとリージョン間の互換性を向上させる追加のBIOSバリアントとリージョナルファイルを提供してくれたPIBSAS/RetroPieBiosに感謝。';

  @override
  String get enabled => '有効';

  @override
  String get disabled => '無効';

  @override
  String get disclaimerRequired => '続行するには免責事項に同意する必要があります。';

  @override
  String get emulatorsPathRequired => 'エミュレーターディレクトリのパスが必要です。';

  @override
  String get emulatorConfigPathRequired => 'エミュレーター設定ファイルのパスが必要です。';

  @override
  String get mediaPathRequired => 'メディアパスが必要です。';

  @override
  String get tempRomPathRequired => '一時ROMストレージのパスが必要です。';

  @override
  String get permanentRomPathRequired => '永続ROMストレージのパスが必要です。';

  @override
  String wizardStepCounter(int current, int total) {
    return 'ステップ $current / $total';
  }

  @override
  String get emulatorConfiguration => 'エミュレーター設定';

  @override
  String get emulatorConfigStepDesc =>
      'エミュレーターがインストールされているパスを設定してください。後から設定 > システムパスで変更できます。';

  @override
  String get emulatorsDirectory => 'エミュレーターディレクトリ';

  @override
  String get pathToEmulatorBinaries => 'エミュレーターバイナリのパス';

  @override
  String get emulatorConfigFile => 'エミュレーター設定ファイル';

  @override
  String get pathToEmulatorConfig => 'エミュレーター設定JSONのパス';

  @override
  String get storagePaths => 'ストレージパス';

  @override
  String get storagePathsStepDesc =>
      'メディアアセットとROMファイルの保存場所を設定してください。後から設定 > システムパスで変更できます。';

  @override
  String get wizardMediaPathHint => 'ボックスアート、スクリーンショット、動画';

  @override
  String get temporaryRomStorage => '一時ROMストレージ';

  @override
  String get temporaryRomStorageHint => '単一プレイセッション用にダウンロードされたROM';

  @override
  String get permanentRomStorage => '永続ROMストレージ';

  @override
  String get permanentRomStorageHint => 'オフラインプレイ用に保存されたROM';

  @override
  String get allSet => '準備完了！';

  @override
  String get wizardEmulatorReady => 'Forsakenエミュレーターの使用準備ができました。';

  @override
  String get changeSettingsLater => 'これらの設定は後から設定画面で変更できます。';

  @override
  String get configurationSummary => '設定概要';

  @override
  String get summaryEmulators => 'エミュレーター';

  @override
  String get summaryMedia => 'メディア';

  @override
  String get summaryTempRoms => '一時ROM';

  @override
  String get summarySavedRoms => '保存済みROM';

  @override
  String get defaultValue => '（デフォルト）';

  @override
  String pdfPageIndicator(int current, int total) {
    return '$totalページ中$currentページ';
  }

  @override
  String get pdfZoomOut => '縮小 (-)';

  @override
  String get pdfZoomIn => '拡大 (+)';

  @override
  String get pdfResetZoom => 'ズームリセット (0)';

  @override
  String get pdfFirstPage => '最初のページ (Home)';

  @override
  String get pdfPreviousPage => '前のページ (←/PgUp)';

  @override
  String get pdfNextPage => '次のページ (→/PgDn)';

  @override
  String get pdfLastPage => '最後のページ (End)';

  @override
  String get pdfFileNotFound => 'PDFファイルが見つかりません';

  @override
  String confirmDeleteEmulator(String system) {
    return '$systemのエミュレーター設定を削除してもよろしいですか？';
  }

  @override
  String commandsConfigured(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個のコマンド設定済み',
      one: '1個のコマンド設定済み',
    );
    return '$_temp0';
  }

  @override
  String get noCommand => 'コマンドなし';

  @override
  String get reloadConfigTooltip => '設定を再読み込み (R)';

  @override
  String get configurationInfo => '設定情報';

  @override
  String get configLocation => '設定ファイルの場所：';

  @override
  String get hasLocalOverridesYes => 'ローカル上書き：あり';

  @override
  String get hasLocalOverridesNo => 'ローカル上書き：なし';

  @override
  String get changesSavedToDevice => '変更はデバイスストレージに保存されます。';

  @override
  String get usingBundledConfig => 'バンドル設定を使用中。編集してローカル上書きを作成できます。';

  @override
  String get noEmulatorsConfigured => 'エミュレーターが設定されていません';

  @override
  String get addFirstEmulator => '最初のエミュレーターを追加して始めましょう';

  @override
  String get edit => '編集';

  @override
  String get editEmulator => 'エミュレーターを編集';

  @override
  String get system => 'システム';

  @override
  String get systemHint => 'e.g., nes, snes, ps1';

  @override
  String get commands => 'コマンド';

  @override
  String commandNumber(int number) {
    return 'コマンド $number';
  }

  @override
  String get commandHint => 'e.g., ../retroarch.AppImage -f -L core.so';

  @override
  String get remove => '削除';

  @override
  String get options => 'オプション';

  @override
  String get biosDownloading => 'ダウンロード中...';

  @override
  String downloadRequiredAndExtras(int requiredCount, int optionalCount) {
    return '必須$requiredCount件 + オプション$optionalCount件をダウンロード';
  }

  @override
  String downloadRequiredFiles(int requiredCount) {
    return '必須ファイル$requiredCount件をダウンロード';
  }

  @override
  String downloadOptionalExtras(int optionalCount) {
    return 'オプション$optionalCount件をダウンロード';
  }

  @override
  String get downloadFiles => 'ファイルをダウンロード';

  @override
  String batchDownloadConfirmation(int totalFiles, int platformCount) {
    return '$platformCountプラットフォームの$totalFiles個のBIOSファイルをダウンロードします：';
  }

  @override
  String get downloadSourceNote => 'ファイルはretroarch_systemリポジトリからダウンロードされます。';

  @override
  String get biosOptional => 'オプション';

  @override
  String biosFilesFound(int foundCount, int totalCount) {
    return '$foundCount/$totalCountファイル検出';
  }

  @override
  String optionalExtrasAvailable(int count) {
    return '+$count件のオプション追加ファイルが利用可能';
  }

  @override
  String get biosLocations => '場所：';

  @override
  String get availableForDownload => '複数のソースからダウンロード可能';

  @override
  String get summary => '概要';

  @override
  String get biosComplete => '完了';

  @override
  String get biosPartial => '一部';

  @override
  String get biosFiles => 'ファイル';

  @override
  String get biosDownloadable => 'ダウンロード可能';

  @override
  String get refreshF5Tooltip => '更新 (F5)';

  @override
  String get allBiosFilesFound => 'すべてのBIOSファイルが見つかりました！';

  @override
  String get noBiosRequirements => 'BIOS要件が見つかりません';

  @override
  String platformCount(int count) {
    return '$countプラットフォーム';
  }

  @override
  String failedToLoadBiosStatus(String error) {
    return 'BIOSステータスの読み込みに失敗しました：$error';
  }

  @override
  String get refreshStatus => 'ステータスを更新';

  @override
  String platformsCompleteCount(int complete, int total) {
    return '$complete/$totalプラットフォーム完了';
  }

  @override
  String get platformStatusHeader => 'プラットフォーム状態';

  @override
  String filesVerifiedStatus(
    int presentFiles,
    int totalFiles,
    int verifiedFiles,
  ) {
    return '$presentFiles/$totalFilesファイル（$verifiedFiles件検証済み）';
  }

  @override
  String get biosCollectionOverview => 'BIOSコレクション概要';

  @override
  String get biosVerified => '検証済み';

  @override
  String downloadComingSoon(String platformName) {
    return '$platformNameのダウンロード機能 - 近日公開！';
  }

  @override
  String get noGamepadConnected => 'ゲームパッドが接続されていません';

  @override
  String get connectGamepadPrompt => 'ゲームパッドを接続してボタンを押してください';

  @override
  String get pressButtonToTest => 'ボタンを押してテスト（アクション無効）';

  @override
  String get buttonFunctionTests => 'ボタン機能テスト';

  @override
  String get gamepadASelect => 'A（選択）';

  @override
  String get gamepadBBack => 'B（戻る）';

  @override
  String get gamepadXSearch => 'X（検索）';

  @override
  String get gamepadYHelp => 'Y（ヘルプ）';

  @override
  String get gamepadLBPageDown => 'LB（ページダウン）';

  @override
  String get gamepadRBPageUp => 'RB（ページアップ）';

  @override
  String get gamepadStartMenu => 'Start（メニュー）';

  @override
  String get gamepadSelectSettings => 'Select（設定）';

  @override
  String get gamepadLSClick => 'LS クリック';

  @override
  String get gamepadRSView => 'RS クリック（表示）';

  @override
  String get gamepadLTTrigger => 'LT（トリガー）';

  @override
  String get gamepadRTTrigger => 'RT（トリガー）';

  @override
  String get rawButtonStates => 'ボタン生データ';

  @override
  String get noButtonsPressed => 'ボタンが押されていません';

  @override
  String get axisValues => '軸の値';

  @override
  String get noAxisMovement => '軸の動きなし';

  @override
  String get dpadLeftStick => 'D-Pad + 左スティック';

  @override
  String get webSettingsDescription => 'Webプラットフォーム固有の設定を構成';

  @override
  String get corsProxyWhyNeeded => 'CORSプロキシが必要な理由';

  @override
  String get corsProxyExplanation =>
      'ブラウザはCORSセキュリティ制限により外部サーバーからのROMダウンロードをブロックします。CORSプロキシは、あなたが管理するサーバーからリクエストを中継し、必要なヘッダーを追加します。\n\nForsakenには無料でデプロイできるCloudflare Workerが含まれています（1日10万リクエスト）。設定手順はtools/cors-proxy-worker/ディレクトリを参照してください。';

  @override
  String get corsProxyUrl => 'CORSプロキシURL';

  @override
  String get corsProxyHelperText =>
      'CORSプロキシを無効にするには空のままにしてください（CORSなしのサーバーからのROMは失敗します）';

  @override
  String get testingProxy => 'プロキシをテスト中...';

  @override
  String get testProxyConnection => 'プロキシ接続テスト';

  @override
  String get noProxyUrlConfigured => 'プロキシURLが設定されていません';

  @override
  String proxyWorking(int statusCode) {
    return 'プロキシは動作中（HTTP $statusCode）';
  }

  @override
  String proxyReturnedHttp(int statusCode) {
    return 'プロキシがHTTP $statusCodeを返しました';
  }

  @override
  String get connectionTimedOut => '接続がタイムアウトしました';

  @override
  String get corsProxySettingsSaved =>
      'CORSプロキシ設定が保存されました。新しいROM起動時にすぐに反映されます。';

  @override
  String get quickDeploy => 'クイックデプロイ';

  @override
  String get corsProxyDeploySteps =>
      '1. dash.cloudflare.comでサインアップ（無料）\n2. Wranglerをインストール: npm install -g wrangler\n3. ログイン: wrangler login\n4. cd tools/cors-proxy-worker\n5. npx wrangler deploy\n6. 上にWorker URLを貼り付け';

  @override
  String get permanentStorage => '永続ストレージ';

  @override
  String get temporaryStorage => '一時ストレージ';

  @override
  String get noDownloadedRoms => 'ダウンロード済みROMはありません';

  @override
  String get biosErrorNetworkMessage => 'ネットワーク接続に失敗しました';

  @override
  String get biosErrorNetworkSuggestions =>
      'インターネット接続を確認してください\n数分後にもう一度お試しください\nDNS設定を確認してください\nアクセスが制限されている場合はVPNを使用してください';

  @override
  String get biosErrorFileNotFoundMessage => 'サーバーにファイルが見つかりません';

  @override
  String get biosErrorFileNotFoundSuggestions =>
      'BIOSファイルが移動または名前変更された可能性があります\n別のソースからダウンロードしてみてください\nファイルが別のブランチ/リポジトリに存在するか確認してください\n問題が続く場合は報告してください';

  @override
  String get biosErrorAccessDeniedMessage => 'サーバーによりアクセスが拒否されました';

  @override
  String get biosErrorAccessDeniedSuggestions =>
      'サーバーがダウンロードをブロックしている可能性があります\n後でもう一度お試しください - サーバーが一時的に制限されている場合があります\n地域制限がある場合はVPNを使用してください\n認証が必要か確認してください';

  @override
  String get biosErrorRateLimitedMessage => 'レート制限を超過しました';

  @override
  String get biosErrorRateLimitedSuggestions =>
      '数分待ってからもう一度お試しください\n同時ダウンロード数を減らしてください\nサーバーは過剰なリクエストから保護しています';

  @override
  String get biosErrorChecksumMessage => 'ファイル整合性の検証に失敗しました';

  @override
  String get biosErrorChecksumSuggestions =>
      'ダウンロード中にファイルが破損した可能性があります\nもう一度ダウンロードしてみてください\nサーバー上でファイルが更新されたか確認してください\nインターネット接続の安定性を確認してください';

  @override
  String get biosErrorSizeMismatchMessage => '予期しないファイルサイズです';

  @override
  String get biosErrorSizeMismatchSuggestions =>
      'ファイルが期待と異なるバージョンの可能性があります\nダウンロードが不完全な可能性があります\nもう一度ダウンロードしてみてください\n利用可能なディスク容量を確認してください';

  @override
  String get biosErrorStorageMessage => 'ストレージエラー';

  @override
  String get biosErrorStorageSuggestions =>
      'ディスク容量を解放してください\nファイルの権限を確認してください\n保存先ディレクトリが書き込み可能であることを確認してください\n別の場所にダウンロードしてみてください';

  @override
  String get biosErrorTimeoutMessage => 'ダウンロードタイムアウト';

  @override
  String get biosErrorTimeoutSuggestions =>
      'インターネット接続が遅い可能性があります\nサーバーが過負荷の可能性があります\n安定した接続で再試行してください\nファイアウォールが接続をブロックしていないか確認してください';

  @override
  String get biosErrorArchiveMessage => 'アーカイブの展開に失敗しました';

  @override
  String get biosErrorArchiveSuggestions =>
      'ダウンロードしたアーカイブが破損している可能性があります\nファイルをもう一度ダウンロードしてみてください\n正しい展開ツールが利用可能か確認してください\nファイルが有効なアーカイブ形式であることを確認してください';

  @override
  String get biosErrorUnknownMessage => 'ダウンロードに失敗しました';

  @override
  String get biosErrorUnknownSuggestions =>
      'もう一度ダウンロードしてみてください\nインターネット接続を確認してください\nファイルがまだ利用可能であることを確認してください\n問題が続く場合はサポートに連絡してください';
}
