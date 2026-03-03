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
  String get biosRequired => 'BIOSが必要';

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
  String get biosMissing => 'BIOSが欠落';

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
}
