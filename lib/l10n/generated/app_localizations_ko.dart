// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Forsaken Emulator';

  @override
  String get retroGamingFrontend => '레트로 게임 프론트엔드';

  @override
  String get platforms => '플랫폼';

  @override
  String get roms => '롬';

  @override
  String get settings => '설정';

  @override
  String get settingsAndConfiguration => '설정 및 구성';

  @override
  String get aboutForsakenEmulator => 'Forsaken Emulator 정보';

  @override
  String get version => '버전';

  @override
  String get appDescription => 'Flutter로 구축된 최신 멀티 플랫폼 에뮬레이터 프론트엔드입니다.';

  @override
  String get emulators => '에뮬레이터';

  @override
  String get ready => '준비됨';

  @override
  String get back => '뒤로';

  @override
  String get select => '선택';

  @override
  String get search => '검색';

  @override
  String get refresh => '새로고침';

  @override
  String get loading => '로딩 중...';

  @override
  String get error => '오류';

  @override
  String get initializationError => '초기화 오류';

  @override
  String get retry => '다시 시도';

  @override
  String get cancel => '취소';

  @override
  String get ok => '확인';

  @override
  String get save => '저장';

  @override
  String get delete => '삭제';

  @override
  String get confirm => '확인';

  @override
  String get yes => '예';

  @override
  String get no => '아니오';

  @override
  String get close => '닫기';

  @override
  String get noRomsFound => '롬을 찾을 수 없습니다';

  @override
  String get noPlatformsFound => '플랫폼을 찾을 수 없습니다';

  @override
  String get checkRomsPath => 'ROMS_PATH 환경 변수를 확인하세요';

  @override
  String get downloading => '다운로드 중...';

  @override
  String get downloadComplete => '다운로드 완료';

  @override
  String get downloadFailed => '다운로드 실패';

  @override
  String get emulatorNotFound => '에뮬레이터를 찾을 수 없습니다';

  @override
  String get romNotFound => '롬을 찾을 수 없습니다';

  @override
  String get biosRequired => '필수';

  @override
  String get systemCheck => '시스템 검사';

  @override
  String get language => '언어';

  @override
  String get theme => '테마';

  @override
  String get systemDefault => '시스템 기본값';

  @override
  String get help => '도움말';

  @override
  String get keyboardAndGamepadControls => '키보드 및 게임패드 제어';

  @override
  String get navigation => '탐색';

  @override
  String get actions => '작업';

  @override
  String get viewControls => '보기 제어';

  @override
  String get gotIt => '알겠습니다!';

  @override
  String get exit => '종료';

  @override
  String get exitApplication => '앱 종료';

  @override
  String get exitConfirm => '종료하시겠습니까?';

  @override
  String get downloadManager => '다운로드 관리자';

  @override
  String get clearCompleted => '완료됨 지우기';

  @override
  String get selectCategory => '카테고리 선택';

  @override
  String get confirmDownload => '다운로드 확인';

  @override
  String get downloadGameLists => '게임 목록 다운로드';

  @override
  String get downloadGameListsDescription => 'GitHub에서롬 목록을 다운로드합니다.';

  @override
  String get gameListsDownloaded => '게임 목록이 다운로드되었습니다!';

  @override
  String get romStorageManagement => '롬 스토리지 관리';

  @override
  String get deleteRom => '롬 삭제?';

  @override
  String deleteRomConfirm(String fileName) {
    return '$fileName을(를) 삭제하시겠습니까?';
  }

  @override
  String get actionCannotBeUndone => '이 작업은 취소할 수 없습니다.';

  @override
  String deleted(String fileName) {
    return '삭제됨: $fileName';
  }

  @override
  String get savePermanently => '영구 저장?';

  @override
  String moveRomConfirm(String fileName) {
    return '$fileName을(를) 영구 스토리지로 이동하시겠습니까?';
  }

  @override
  String saved(String fileName) {
    return '저장됨: $fileName';
  }

  @override
  String get clearAll => '모두 지우기?';

  @override
  String get clearAllConfirm => '모든 임시롬을 삭제하시겠습니까?';

  @override
  String get allCleared => '모든 임시롬이 정리되었습니다';

  @override
  String get systemPathsConfiguration => '시스템 경로 구성';

  @override
  String get migrateRoms => '롬 마이그레이션?';

  @override
  String get migrateRomsDescription =>
      '롬 영구 스토리지 경로가 \$oldPath에서 \$newPath로 변경되었습니다. 기존롬을 새 위치로 마이그레이션하시겠습니까?';

  @override
  String get noKeepThem => '아니요, 유지';

  @override
  String get yesMigrateRoms => '예,롬 마이그레이션';

  @override
  String get migratingRoms => '롬 마이그레이션 중...';

  @override
  String get romMigrationFailed => '경고: 롬 마이그레이션 실패';

  @override
  String get pathsSaved => '경로가 성공적으로 저장되었습니다';

  @override
  String get errorSavingPaths => '경로 저장 오류:';

  @override
  String get resetConfiguration => '구성 재설정';

  @override
  String get resetConfigDescription =>
      '모든 경로를 기본값으로 재설정합니다.롬 및 미디어 파일은 영향을 받지 않습니다.';

  @override
  String get configurationReset => '구성이 기본값으로 재설정되었습니다';

  @override
  String get errorResettingConfiguration => '구성 재설정 오류:';

  @override
  String get savePaths => '경로 저장';

  @override
  String get saving => '저장 중...';

  @override
  String get emulatorManagement => '에뮬레이터 관리';

  @override
  String get configurationReloaded => '구성이 다시 로드되었습니다';

  @override
  String get errorLoadingEmulators => '에뮬레이터 로드 오류:';

  @override
  String get emulatorAdded => '에뮬레이터가 성공적으로 추가되었습니다';

  @override
  String get errorAddingEmulator => '에뮬레이터 추가 오류:';

  @override
  String get emulatorUpdated => '에뮬레이터가 성공적으로 업데이트되었습니다';

  @override
  String get errorUpdatingEmulator => '에뮬레이터 업데이트 오류:';

  @override
  String get deleteEmulator => '에뮬레이터 삭제';

  @override
  String get emulatorDeleted => '에뮬레이터가 삭제되었습니다';

  @override
  String get errorDeletingEmulator => '에뮬레이터 삭제 오류:';

  @override
  String get configurationSource => '구성 소스';

  @override
  String get addEmulator => '에뮬레이터 추가';

  @override
  String get systemNameRequired => '시스템 이름이 필요합니다';

  @override
  String get commandRequired => '최소 하나의 명령이 필요합니다';

  @override
  String get addCommand => '명령 추가';

  @override
  String get acceptZipFiles => 'ZIP 파일 수락';

  @override
  String get acceptZipSubtitle => 'ZIP 아카이브에서롬 실행 허용';

  @override
  String get useForeverMode => 'Forever 모드 사용';

  @override
  String get useForeverSubtitle => '에뮬레이터 계속 실행 유지';

  @override
  String get workInProgress => '진행 중인 작업';

  @override
  String get wipSubtitle => '아직 완전히 구성되지 않음으로 표시';

  @override
  String get biosFirmwareHelp => 'BIOS 및 펌웨어 도움말';

  @override
  String get downloadMissingFiles => '누락된 파일 다운로드';

  @override
  String get showOnlyMissing => '누락만 표시';

  @override
  String get downloadAllMissingBios => '모든 누락 BIOS 다운로드';

  @override
  String get configurationError => '구성 오류';

  @override
  String get configurationErrorDescription =>
      '애플리케이션이 필요한 구성을 찾을 수 없습니다.\n설정 > 시스템 경로에서 경로를 구성하세요.';

  @override
  String get configurationRequired =>
      '필수:\n- 미디어 경로: 미디어 에셋이 있는 디렉토리\n- 에뮬레이터 경로: 에뮬레이터 바이너리가 있는 디렉토리\n\n선택:\n- 일시적/영구적 다운로드용 롬 스토리지 경로';

  @override
  String get goToSettingsToConfigure => '구성하려면 설정 > 시스템 경로로 이동';

  @override
  String get noDownloadableBios => '다운로드 가능한 BIOS 파일이 누락되지 않았습니다';

  @override
  String get allDownloadsCompleted => '모든 다운로드가 성공적으로 완료되었습니다!';

  @override
  String get batchDownloadFailed => '일괄 다운로드 실패:';

  @override
  String get download => '다운로드';

  @override
  String get downloadCancelled => '다운로드가 취소되었습니다';

  @override
  String get launched => '실행됨:';

  @override
  String get failedToSave => '롬을 영구적으로 저장하지 못했습니다';

  @override
  String get failedToSaveRom => '롬을 영구적으로 저장하지 못했습니다';

  @override
  String get errorSaving => '롬 저장 오류:';

  @override
  String errorSavingRom(String error) {
    return '롬 저장 오류: $error';
  }

  @override
  String get openFolder => '폴더 열기';

  @override
  String get viewManual => '매뉴얼 보기';

  @override
  String get play => '플레이';

  @override
  String get goBack => '뒤로 가기';

  @override
  String get clearSearch => '검색 지우기';

  @override
  String get iUnderstand => '이 조건을 이해하고 동의합니다';

  @override
  String get start => '시작';

  @override
  String get debugMode => '디버그 모드: ';

  @override
  String get toggleDebugMode => '디버그 모드 전환';

  @override
  String get preparingDownload => '다운로드 준비 중...';

  @override
  String get noEmulatorsAvailable => '이 카테고리에 사용 가능한 에뮬레이터가 없습니다';

  @override
  String get failedToLaunch => '웹 에뮬레이터 실행 실패:';

  @override
  String get platformInfo => '플랫폼 정보';

  @override
  String get emulatorPlatformInfo => '에뮬레이터 플랫폼 정보';

  @override
  String get favorites => '즐겨찾기';

  @override
  String get all => '전체';

  @override
  String get collections => '컬렉션';

  @override
  String get searchRoms => '롬 검색...';

  @override
  String get searchPlatforms => '플랫폼 검색...';

  @override
  String romsCount(int count) {
    return '$count롬';
  }

  @override
  String platformsCount(int count) {
    return '$count플랫폼';
  }

  @override
  String get region => '지역';

  @override
  String get genre => '장르';

  @override
  String get year => '연도';

  @override
  String get publisher => '배급사';

  @override
  String get developer => '개발자';

  @override
  String get playWithNetplay => '넷플레이로 플레이';

  @override
  String get downloadBios => 'BIOS 다운로드';

  @override
  String get viewDetails => '세부정보 보기';

  @override
  String get addToFavorites => '즐겨찾기에 추가';

  @override
  String get removeFromFavorites => '즐겨찾기에서 제거';

  @override
  String get biosMissing => '누락';

  @override
  String get biosPresent => 'BIOS 존재함';

  @override
  String get checkingBios => 'BIOS 확인 중...';

  @override
  String get emulatorDownloading => '에뮬레이터 다운로드 중...';

  @override
  String get emulatorDownloadComplete => '에뮬레이터 다운로드됨';

  @override
  String get emulatorDownloadFailed => '에뮬레이터 다운로드 실패';

  @override
  String get installingEmulator => '에뮬레이터 설치 중...';

  @override
  String get emulatorReady => '에뮬레이터 준비됨';

  @override
  String get configuration => '구성';

  @override
  String get paths => '경로';

  @override
  String get storage => '스토리지';

  @override
  String get emulatorsPath => '에뮬레이터 경로';

  @override
  String get romsPath => '롬 경로';

  @override
  String get mediaPath => '미디어 경로';

  @override
  String get biosPath => 'BIOS 경로';

  @override
  String get tempPath => '임시 경로';

  @override
  String get browse => '찾아보기';

  @override
  String get apply => '적용';

  @override
  String get reset => '재설정';

  @override
  String get clear => '지우기';

  @override
  String get scan => '스캔';

  @override
  String get scanForRoms => '롬 스캔';

  @override
  String get scanningRoms => '롬 스캔 중...';

  @override
  String get scanComplete => '스캔 완료';

  @override
  String romsFound(int count) {
    return '$count롬을 찾았습니다';
  }

  @override
  String get noNewRomsFound => '새롬을 찾을 수 없습니다';

  @override
  String get launchEmulator => '에뮬레이터 실행';

  @override
  String get emulatorError => '에뮬레이터 오류';

  @override
  String get gamepadConnected => '게임패드 연결됨';

  @override
  String get gamepadDisconnected => '게임패드 연결 해제됨';

  @override
  String get gamepadTest => '게임패드 테스트';

  @override
  String get pressAnyButton => '테스트하려면 아무 버튼이나 누르세요';

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
  String get dpadUp => 'D-Pad 위';

  @override
  String get dpadDown => 'D-Pad 아래';

  @override
  String get dpadLeft => 'D-Pad 왼쪽';

  @override
  String get dpadRight => 'D-Pad 오른쪽';

  @override
  String get leftShoulder => 'L1';

  @override
  String get rightShoulder => 'R1';

  @override
  String get leftTrigger => 'L2';

  @override
  String get rightTrigger => 'R2';

  @override
  String get leftStick => '왼쪽 스틱';

  @override
  String get rightStick => '오른쪽 스틱';

  @override
  String get setupWizard => '설치 마법사';

  @override
  String get welcome => '환영합니다';

  @override
  String get welcomeMessage => 'Forsaken Emulator에 오신 것을 환영합니다';

  @override
  String get next => '다음';

  @override
  String get previous => '이전';

  @override
  String get finish => '완료';

  @override
  String get skip => '건너뛰기';

  @override
  String get setupComplete => '설치 완료';

  @override
  String get selectLanguage => '언어 선택';

  @override
  String get selectEmulatorsPath => '에뮬레이터 경로 선택';

  @override
  String get selectRomsPath => '롬 경로 선택';

  @override
  String get selectMediaPath => '미디어 경로 선택';

  @override
  String get allSettingsConfigured => '모든 설정이 구성되었습니다';

  @override
  String get darkTheme => '다크';

  @override
  String get lightTheme => '라이트';

  @override
  String get systemTheme => '시스템';

  @override
  String get about => '정보';

  @override
  String get checkForUpdates => '업데이트 확인';

  @override
  String get noUpdatesAvailable => '사용 가능한 업데이트가 없습니다';

  @override
  String get updateAvailable => '업데이트 사용 가능';

  @override
  String get downloadingUpdate => '업데이트 다운로드 중...';

  @override
  String get installingUpdate => '업데이트 설치 중...';

  @override
  String get updateComplete => '업데이트 완료';

  @override
  String get updateFailed => '업데이트 실패';

  @override
  String get networkError => '네트워크 오류';

  @override
  String get connectionError => '연결 오류';

  @override
  String get timeoutError => '시간 초과 오류';

  @override
  String get unknownError => '알 수 없는 오류';

  @override
  String get permissionDenied => '권한이 거부되었습니다';

  @override
  String get fileNotFound => '파일을 찾을 수 없습니다';

  @override
  String get directoryNotFound => '디렉토리를 찾을 수 없습니다';

  @override
  String get diskFull => '디스크가 가득 찼습니다';

  @override
  String get invalidPath => '잘못된 경로';

  @override
  String get pathNotWritable => '경로에 쓸 수 없습니다';

  @override
  String get romCorrupted => '롬 파일이 손상되었을 수 있습니다';

  @override
  String get zipError => 'ZIP 아카이브 오류';

  @override
  String get extractionFailed => '추출 실패';

  @override
  String get checksumMismatch => '체크섬 불일치';

  @override
  String get biosCheckFailed => 'BIOS 확인 실패';

  @override
  String get continueAnyway => '계속 진행';

  @override
  String get reportIssue => '문제 보고';

  @override
  String get copyToClipboard => '클립보드에 복사';

  @override
  String get copiedToClipboard => '클립보드에 복사됨';

  @override
  String get share => '공유';

  @override
  String get hide => '숨기기';

  @override
  String get show => '표시';

  @override
  String get toggleView => '보기 전환';

  @override
  String get gridView => '그리드 보기';

  @override
  String get listView => '목록 보기';

  @override
  String get carouselView => '캐러셀 보기';

  @override
  String get sortBy => '정렬 기준';

  @override
  String get sortByName => '이름';

  @override
  String get sortByDate => '날짜';

  @override
  String get sortBySize => '크기';

  @override
  String get sortByRegion => '지역';

  @override
  String get ascending => '오름차순';

  @override
  String get descending => '내림차순';

  @override
  String get filter => '필터';

  @override
  String get filterByRegion => '지역별 필터';

  @override
  String get filterByGenre => '장르별 필터';

  @override
  String get filterByYear => '연도별 필터';

  @override
  String get clearFilters => '필터 지우기';

  @override
  String get systemInfo => '시스템 정보';

  @override
  String get cpu => 'CPU';

  @override
  String get memory => '메모리';

  @override
  String get storageInfo => '스토리지';

  @override
  String get os => '운영 체제';

  @override
  String get emulatorVersion => '에뮬레이터 버전';

  @override
  String get totalRoms => '총롬';

  @override
  String get totalSize => '총 크기';

  @override
  String get freeSpace => '여유 공간';

  @override
  String get usedSpace => '사용 중';

  @override
  String get systemUtilities => '시스템 유틸리티';

  @override
  String get romVerificationResults => '롬 검증 결과';

  @override
  String get totalRomFiles => '총롬 파일';

  @override
  String get emptyRomFiles => '빈롬 파일';

  @override
  String get validRomFiles => '유효한롬 파일';

  @override
  String get romsDirectoryDoesNotExist => '롬 디렉토리가 존재하지 않습니다';

  @override
  String get gamelistCheckResults => '게임 목록 검사 결과';

  @override
  String get totalPlatforms => '총 플랫폼';

  @override
  String get missingGamelists => '누락된 게임 목록';

  @override
  String get configurationBackup => '구성 백업';

  @override
  String get configurationBackedUp => '구성이 백업됨:';

  @override
  String get errorBackingUp => '구성 백업 오류:';

  @override
  String get romDatabase => '롬 데이터베이스';

  @override
  String get romDatabaseDownloaded => '롬 데이터베이스가 성공적으로 다운로드되었습니다';

  @override
  String get failedDownloadRomDatabase => '롬 데이터베이스 다운로드 실패';

  @override
  String get romDatabaseCleared => '롬 데이터베이스가 지워졌습니다';

  @override
  String get failedClearDatabase => '데이터베이스 지우기 실패';

  @override
  String get downloadRomDatabase => '롬 데이터베이스 다운로드';

  @override
  String get clearRomDatabase => '롬 데이터베이스 지우기';

  @override
  String get systemRequirements => '시스템 요구사항';

  @override
  String get failedToCheckSystem => '시스템 검사 실패';

  @override
  String cleanedUpTempFiles(String deletedCount) {
    return '$deletedCount개의 임시롬 파일이 정리되었습니다';
  }

  @override
  String get errorCleaningTempFiles => '임시 파일 정리 오류:';

  @override
  String get errorVerifyingRomFiles => '롬 파일 검증 오류:';

  @override
  String get errorCheckingGamelists => '게임 목록 검사 오류:';

  @override
  String get cancelDownload => '다운로드 취소';

  @override
  String get selectEmulator => '에뮬레이터 선택';

  @override
  String get biosStatusDashboard => 'BIOS 상태 대시보드';

  @override
  String get webSettings => '웹 설정';

  @override
  String get saveSettings => '설정 저장';

  @override
  String get errorSavingSettings => '설정 저장 오류:';

  @override
  String romsCountItems(String count) {
    return '$count롬';
  }

  @override
  String get savedPermanently => '영구 저장됨';

  @override
  String get keptInTemporary => '임시 스토리에 유지됨';

  @override
  String get tryAgain => '다시 시도';

  @override
  String get allDownloads => '모든 다운로드 완료';

  @override
  String romSavedPermanently(String name) {
    return '$name이(가) 영구 저장되었습니다';
  }

  @override
  String get undo => '실행 취소';

  @override
  String romKeptInTemporary(String name) {
    return '$name이(가) 임시 스토리에 유지됩니다';
  }

  @override
  String romsCountWithSize(String count, String size) {
    return '$count롬 • $size';
  }

  @override
  String get whatYouCanTry => '시도해 볼 수 있는 것:';

  @override
  String get tips => '팁';

  @override
  String get helpNavigateItems => '항목 간 탐색';

  @override
  String get helpGamepadNavigation => '게임패드 탐색';

  @override
  String get helpQuickNavigation => '빠른 탐색 (여러 항목 건너뛰기)';

  @override
  String get helpGamepadPageNavigation => '게임패드 페이지 탐색';

  @override
  String get helpGoToFirst => '첫 번째 항목으로 이동';

  @override
  String get helpGoToLast => '마지막 항목으로 이동';

  @override
  String get helpJumpToLetter => '해당 문자로 시작하는 항목으로 건너뛰기';

  @override
  String get helpSelectItem => '항목 선택';

  @override
  String get helpGamepadSelect => '게임패드 선택';

  @override
  String get helpGoBackCloseDialogs => '뒤로 / 대화상자 닫기';

  @override
  String get helpExitApplication => '앱 종료';

  @override
  String get helpGamepadBackClose => '게임패드 뒤로 / 대화상자 닫기';

  @override
  String get helpToggleViewMode => '보기 모드 전환 (그리드/목록/캐러셀)';

  @override
  String get helpGamepadViewToggle => '게임패드로 보기 전환';

  @override
  String get helpRefreshView => '현재 보기 새로고침';

  @override
  String get helpShowPlatformInfo => '플랫폼 정보 표시';

  @override
  String get helpActivateSearch => '검색 활성화';

  @override
  String get helpGamepadSearch => '게임패드 검색';

  @override
  String get helpShowHelpDialog => '이 도움말 대화상자 표시';

  @override
  String get helpGamepadHelp => '게임패드 도움말';

  @override
  String get tipUseKeyboardOrGamepad => '탐색에는 키보드 또는 게임패드를 사용하세요';

  @override
  String get tipAlphabeticalJump => '알파벳 건너뛰기는 모든 보기 모드에서 작동합니다';

  @override
  String get tipPressQuestionMark => '이 도움말을 보려면 ?를 누르세요';

  @override
  String get tipGamepadAlongside => '게임패드는 키보드 제어와 함께 작동합니다';

  @override
  String get configurePathsDescription =>
      '롬, 미디어 및 에뮬레이터를 찾기 위해 애플리케이션이 사용하는 경로를 구성합니다.';

  @override
  String get romListsAutoManaged =>
      '롬 목록이 이제 자동으로 관리됩니다. 설정 >롬 데이터베이스에서 다운로드하세요.';

  @override
  String get romStorage => '롬 스토리지';

  @override
  String get configureRomStorageDescription =>
      '다운로드한롬이 일시적으로 그리고 영구적으로 저장되는 위치를 구성합니다.';

  @override
  String get resetToDefaults => '기본값으로 재설정';

  @override
  String get mediaPathLabel => '미디어 경로';

  @override
  String get mediaPathHint => '미디어 (이미지, 비디오)가 있는 디렉토리';

  @override
  String get emulatorsPathLabel => '에뮬레이터 경로';

  @override
  String get emulatorsPathHint => '에뮬레이터 바이너리가 있는 디렉토리';

  @override
  String get gamelistPathAutomatic => '게임 목록 경로 (자동)';

  @override
  String get gamelistAutoDescription =>
      '게임 목록은 이제 앱 데이터 디렉토리에서 자동으로 관리됩니다. 이렇게 하면 앱이 완전히 독립적이 되고 향후 GitHub 기반 게임 목록 배포를 준비할 수 있습니다.';

  @override
  String get tempRomStorageLabel => '임시롬 스토리지 (선택사항)';

  @override
  String get tempRomStorageDescription =>
      '롬이 먼저 여기에 다운로드됩니다. 플레이 후 영구 스토리지로 승격할 수 있습니다.';

  @override
  String get permanentRomStorageLabel => '영구롬 스토리지 (선택사항)';

  @override
  String get permanentRomStorageDescription =>
      '영구 저장된롬이 여기에 저장됩니다. 이들은 자동으로 정리되지 않습니다.';

  @override
  String get defaultAppSupportDir => '기본값: 앱 지원 디렉토리';

  @override
  String currentPathDisplay(String path) {
    return '현재: $path';
  }

  @override
  String get configurationFile => '구성 파일';

  @override
  String get source => '소스:';

  @override
  String get customConfigActive => '사용자 지정 구성 활성화';

  @override
  String get pathStructure => '경로 구조';

  @override
  String get pathStructureDescription =>
      '미디어 경로: MEDIA_PATH/플랫폼/boxart|screenshots|videos/rom.png\n게임 목록 경로: ~/.local/share/com.example.emulator/gamelists/플랫폼/gamelist.xml (자동)\n에뮬레이터 경로: EMULATORS_PATH/emulator_binary';

  @override
  String get errorCheckingSystem => '시스템 검사 오류';

  @override
  String get recheckR => '다시 확인 (R)';

  @override
  String get allRequiredToolsInstalled => '모든 필수 도구가 설치되었습니다';

  @override
  String get missingRequiredTools => '필수 도구 누락';

  @override
  String get systemReadyToUse => '시스템이 에뮬레이터를 사용할 준비가 되었습니다';

  @override
  String get someRequiredToolsMissing => '일부 필수 도구가 누락되었습니다';

  @override
  String get requiredTools => '필수 도구';

  @override
  String get requiredToolsDescription => '이러한 도구는 에뮬레이터 다운로드 및 추출에 필요합니다';

  @override
  String get installationInstructions => '설치 지침';

  @override
  String get installed => '설치됨';

  @override
  String get missing => '누락';

  @override
  String get downloadEmulatorsAndGameLists => '에뮬레이터 및 게임 목록 다운로드';

  @override
  String get quickActions => '빠른 작업';

  @override
  String get downloadAll => '모두 다운로드';

  @override
  String get byCategory => '카테고리별';

  @override
  String get downloadQueue => '다운로드 대기열';

  @override
  String get noDownloadsInProgress => '진행 중인 다운로드 없음';

  @override
  String get selectQuickActionToStart => '다운로드를 시작하려면 위의 빠른 작업을 선택하세요';

  @override
  String get categorySony => 'Sony (PS1-PS4)';

  @override
  String get categoryNintendo => 'Nintendo (GC, Wii, Switch)';

  @override
  String get categoryMicrosoft => 'Microsoft (Xbox, Xbox 360)';

  @override
  String get categoryMultiPlatform => '멀티 플랫폼 (RetroArch)';

  @override
  String get categoryOtherEmulators => '기타 에뮬레이터';

  @override
  String get categoryUtilities => '유틸리티';

  @override
  String confirmDownloadDescription(String count, String size) {
    return '$count개의 에뮬레이터를 다운로드하시겠습니까?\n예상 크기: ~$size MB\n\n인터넷 연결에 따라 시간이 걸릴 수 있습니다.';
  }

  @override
  String get alreadyInstalled => '이미 설치됨';

  @override
  String get starting => '시작 중...';

  @override
  String get completed => '완료됨';

  @override
  String get gameListsAlreadyDownloaded => '게임 목록이 이미 다운로드되었습니다';

  @override
  String get redownload => '다시 다운로드';

  @override
  String get gameListsFromGitHub => '게임 목록 (GitHub에서)';

  @override
  String get downloaded => '다운로드됨';

  @override
  String get cancelled => '취소됨';

  @override
  String get missingFor => '누락됨:';

  @override
  String get noCustomConfigToBackup => '백업할 사용자 지정 구성이 없습니다.기본값을 사용합니다.';

  @override
  String get saveConfigurationBackup => '구성 백업 저장';

  @override
  String get refreshStatsR => '통계 새로고침 (R)';

  @override
  String get systemStatistics => '시스템 통계';

  @override
  String get romFiles => '롬 파일';

  @override
  String get maintenanceTools => '유지보수 도구';

  @override
  String get cleanupTemporaryRoms => '임시롬 정리';

  @override
  String get cleanupTemporaryRomsDescription => '시스템 임시 디렉토리에서 임시롬 파일 제거';

  @override
  String get verifyRomFiles => '롬 파일 검증';

  @override
  String get verifyRomFilesDescription => '모든롬 파일이 존재하고 유효한지 확인';

  @override
  String get checkMissingGamelists => '누락된 게임 목록 확인';

  @override
  String get checkMissingGamelistsDescription => 'gamelist.xml 파일이 없는 플랫폼 찾기';

  @override
  String get backupConfiguration => '구성 백업';

  @override
  String get backupConfigurationDescription => 'config.json의 백업 생성';

  @override
  String get downloadingRomDatabase => '롬 데이터베이스 다운로드 중...';

  @override
  String get downloadMayTakeMinutes => '연결에 따라 몇 분이 걸릴 수 있습니다...';

  @override
  String get databaseStatus => '데이터베이스 상태';

  @override
  String get notDownloaded => '다운로드되지 않음';

  @override
  String get aboutRomDatabase => '롬 데이터베이스 정보';

  @override
  String get aboutRomDatabaseDescription =>
      '롬 데이터베이스에는 플랫폼별로 정리된 사용 가능한롬 목록이 포함되어 있습니다.GitHub의 Forsaken romList 저장소에서 다운로드됩니다.';

  @override
  String get romDatabaseSource => '소스: github.com/ForsakenStation/romList';

  @override
  String get downloadRomDatabaseDescription =>
      'GitHub의 Forsaken romList 저장소에서롬 목록을 다운로드합니다.';

  @override
  String get downloadRomDatabaseStats => '크기: ~7 MB\n플랫폼: 138\n총롬: ~240,000';

  @override
  String get downloadWillOverwrite => '참고: 기존 데이터가 덮어씌워집니다.';

  @override
  String get clearRomDatabaseDescription =>
      '모든 다운로드된롬 목록이 삭제되고 데이터베이스가 초기 상태로 재설정됩니다.';

  @override
  String get gamelistsStatus => '게임 목록 상태';

  @override
  String get gamelistsDownloaded => '다운로드됨';

  @override
  String get gamelistsNotDownloaded => '다운로드되지 않음';

  @override
  String get aboutGamelists => '게임 목록 정보';

  @override
  String get aboutGamelistsDescription =>
      '게임 목록에는 각 플랫폼의 게임 메타데이터 (이름, 설명, 평점)가 포함됩니다.GitHub의 Forsaken gamelists 저장소에서 다운로드됩니다.';

  @override
  String get gamelistsSource => '소스: github.com/ForsakenStation/gamelists';

  @override
  String get downloadGamelists => '게임 목록 다운로드';

  @override
  String get downloadGamelistsDescription =>
      'GitHub의 Forsaken gamelists 저장소에서 gamelist.xml 파일을 다운로드합니다.';

  @override
  String get downloadGamelistsWillOverwrite => '참고: 기존 게임 목록 파일이 덮어씌워집니다.';

  @override
  String get downloadingGamelists => '게임 목록 다운로드 중...';

  @override
  String get gamelistsDownloadedSuccess => '게임 목록이 성공적으로 다운로드되었습니다';

  @override
  String get failedDownloadGamelists => '게임 목록 다운로드 실패';

  @override
  String get clearGamelists => '게임 목록 지우기';

  @override
  String get clearGamelistsDescription => '모든 다운로드된 게임 목록 파일이 삭제됩니다.';

  @override
  String get gamelistsCleared => '게임 목록이 지워졌습니다';

  @override
  String get failedClearGamelists => '게임 목록 지우기 실패';

  @override
  String get rebuildMediaCache => '미디어 캐시 재구축';

  @override
  String get rebuildMediaCacheDescription =>
      '미디어 디렉토리를 스캔하고 게임 목록에 경로를 캐시하여 더 빠른 로딩';

  @override
  String get rebuildMediaCacheConfirmTitle => '미디어 캐시를 재구축하시겠습니까?';

  @override
  String get rebuildMediaCacheConfirmBody =>
      '모든 미디어 디렉토리를 스캔하고 gamelist.xml 파일을 미디어 경로로 업데이트합니다.대규모 컬렉션의 경우 시간이 걸릴 수 있습니다.';

  @override
  String get rebuildMediaCacheProgress => '미디어 캐시 재구축 중...';

  @override
  String rebuildMediaCacheProcessingPlatform(
    String platform,
    String current,
    String total,
  ) {
    return '$platform 처리 중 ($current/$total)';
  }

  @override
  String get rebuildMediaCacheComplete => '미디어 캐시 재구축 완료';

  @override
  String rebuildMediaCacheSummary(
    String platforms,
    String games,
    String updated,
    String paths,
  ) {
    return '$platforms플랫폼, $games게임 스캔, $updated업데이트, $paths미디어 경로 캐시됨';
  }

  @override
  String get rebuildMediaCacheError => '미디어 캐시 재구축 실패';

  @override
  String rebuildMediaCacheErrors(String count) {
    return '재구축 중 $count개의 오류가 발생했습니다';
  }

  @override
  String get description => '설명';

  @override
  String get noDescriptionAvailable => '이 ROM에 대한 설명이 없습니다.';

  @override
  String get releaseDate => '출시일';

  @override
  String get players => '플레이어';

  @override
  String get rating => '평점';

  @override
  String get regions => '지역';

  @override
  String folderRomCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개의 ROM',
    );
    return '$_temp0';
  }

  @override
  String manualTitle(String name) {
    return '$name - 매뉴얼';
  }

  @override
  String get playInBrowser => '브라우저에서 플레이';

  @override
  String downloadingPlatformBios(String platformName) {
    return '$platformName BIOS 다운로드 중';
  }

  @override
  String get downloadingAllMissingBios => '누락된 모든 BIOS 다운로드 중';

  @override
  String biosFileLabel(String filename) {
    return '파일: $filename';
  }

  @override
  String batchProgressLabel(String completed, String total) {
    return '진행: $completed/$total 파일';
  }

  @override
  String get fileDetails => '파일 상세:';

  @override
  String get waiting => '대기 중...';

  @override
  String get verifying => '확인 중...';

  @override
  String get failed => '실패';

  @override
  String get preparing => '준비 중...';

  @override
  String get downloadingFiles => '파일 다운로드 중...';

  @override
  String get someDownloadsFailed => '일부 다운로드가 실패했습니다';

  @override
  String get downloadsCancelled => '다운로드가 취소되었습니다';

  @override
  String get calculating => '계산 중...';

  @override
  String secondsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count초',
    );
    return '$_temp0';
  }

  @override
  String minutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count분',
    );
    return '$_temp0';
  }

  @override
  String hoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count시간',
    );
    return '$_temp0';
  }

  @override
  String get downloadingAndLaunching => '다운로드 및 실행 중...';

  @override
  String get launching => '실행 중...';

  @override
  String emulatorLabel(String name) {
    return '에뮬레이터: $name';
  }

  @override
  String get generalInformation => '일반 정보';

  @override
  String get manufacturer => '제조사';

  @override
  String get releaseYear => '출시 연도';

  @override
  String get generation => '세대';

  @override
  String get technicalSpecifications => '기술 사양';

  @override
  String get resolution => '해상도';

  @override
  String get colors => '색상';

  @override
  String get notNow => '나중에';

  @override
  String get saveRomPermanently => 'ROM을 영구 저장하시겠습니까?';

  @override
  String get keepRomOfflineQuestion => '이 ROM을 다운로드 상태로 유지하여 오프라인에서 플레이하시겠습니까?';

  @override
  String get deletedToSaveSpace => '그렇지 않으면 나중에 공간 절약을 위해 삭제됩니다.';

  @override
  String get view => '보기';

  @override
  String get media => '미디어';

  @override
  String get navigate => '탐색';

  @override
  String get info => '정보';

  @override
  String get toggleFilter => '필터 전환';

  @override
  String get changeTheme => '테마 변경';

  @override
  String get keyboard => '키보드';

  @override
  String get gamepad => '게임패드';

  @override
  String get hideKeyboard => '키보드 숨기기';

  @override
  String get gameManual => '게임 매뉴얼';

  @override
  String get pdfDocument => 'PDF 문서';

  @override
  String get manual => '매뉴얼';

  @override
  String get video => '비디오';

  @override
  String get zoomOut => '축소';

  @override
  String get zoomIn => '확대';

  @override
  String pageCounter(String current, String total) {
    return '페이지 $current / $total';
  }

  @override
  String get zoom => '확대/축소';

  @override
  String get firstLast => '처음/마지막';

  @override
  String get scroll => '스크롤';

  @override
  String get loadingVideo => '동영상 로딩 중...';

  @override
  String get playPause => '재생/일시정지';

  @override
  String get useArrowKeysToNavigate => '화살표 키 또는 스와이프로 탐색하세요';

  @override
  String get searchRomsHint => 'ROM 검색...';

  @override
  String get cancelSearch => '검색 취소';

  @override
  String get virtualKeyboard => '가상 키보드';

  @override
  String get noRomsAvailable => '사용 가능한 ROM이 없습니다';

  @override
  String get noRomsForPlatformMessage =>
      '이 플랫폼의 ROM 파일을 찾을 수 없습니다. ROM 파일은 다운로드 URL이 포함된 .txt 파일로 플랫폼 디렉토리에 배치해야 합니다.';

  @override
  String get noMatchingRoms => '일치하는 ROM이 없습니다';

  @override
  String get tryDifferentSearch => '다른 검색어를 시도해 보세요';

  @override
  String get saveToPermanentStorage => '영구 저장소에 저장';

  @override
  String get temporary => '임시';

  @override
  String get permanent => '영구';

  @override
  String get tempPathLabel => '임시';

  @override
  String get foreverPathLabel => '영구';

  @override
  String get storageOverview => '저장소 개요';

  @override
  String get clearTemporaryStorage => '임시 저장소 비우기';

  @override
  String filesCount(String count) {
    return '$count개 파일';
  }

  @override
  String pathDisplay(String label, String path) {
    return '$label 경로: $path';
  }

  @override
  String get unknown => '알 수 없음';

  @override
  String get tagVerifiedGoodDump => '검증된 정상 덤프 - 작동 확인됨';

  @override
  String get tagBadDump => '불량 덤프 - 정상 작동하지 않을 수 있음';

  @override
  String get tagAlternateVersion => '대체 버전';

  @override
  String get tagOverdump => '오버덤프 - 추가 데이터 포함';

  @override
  String get tagModifiedHacked => '수정/해킹된 ROM';

  @override
  String get tagFanTranslation => '팬 번역';

  @override
  String get tagPirateBootleg => '해적판/부틀렉 버전';

  @override
  String get tagFixedVersion => '수정된 버전';

  @override
  String get tagCheatTrainer => '치트 트레이너 포함';

  @override
  String tagVersion(String text) {
    return '버전: $text';
  }

  @override
  String tagSpecialRelease(String text) {
    return '특별 출시: $text';
  }

  @override
  String tagMediaInfo(String text) {
    return '미디어 정보: $text';
  }

  @override
  String noEmulatorConfigured(
    String displayName,
    String platform,
    String configPath,
  ) {
    return '$displayName에 대해 구성된 에뮬레이터가 없습니다.\n\n\"$platform\"에 대한 구성을 다음 위치에 추가하세요:\n$configPath';
  }

  @override
  String get noEmulatorCommandAvailable => '사용 가능한 에뮬레이터 명령이 없습니다';

  @override
  String platformNotSupportedWeb(String platform, String supportedPlatforms) {
    return '플랫폼 \"$platform\"은(는) 아직 웹 브라우저에서 지원되지 않습니다.\n\n지원되는 플랫폼: $supportedPlatforms';
  }

  @override
  String failedToLaunchWebEmulator(String error) {
    return '웹 에뮬레이터를 실행하지 못했습니다: $error';
  }

  @override
  String failedToLaunchRom(String error) {
    return 'ROM을 실행하지 못했습니다.\n\n다음을 확인하세요:\n• 에뮬레이터가 올바르게 설치되어 있는지\n• ROM 파일이 유효한지\n• 구성이 올바른지\n\n오류: $error';
  }

  @override
  String errorLaunchingRom(String error) {
    return 'ROM 실행 오류: $error';
  }

  @override
  String noInfoAvailable(String platformName) {
    return '$platformName에 대한 정보가 없습니다';
  }

  @override
  String get platformInfoTooltip => '플랫폼 정보 (I)';

  @override
  String get navigationHint => '화살표 키 또는 스와이프로 이동';

  @override
  String get noGamesFound => '게임을 찾을 수 없습니다';

  @override
  String get noGamesFoundForSearch => '검색 결과에 맞는 게임이 없습니다';

  @override
  String get tryDifferentSearchOrClear => '다른 검색어를 시도하거나 필터를 지우세요';

  @override
  String get checkStorageOrDownload => '저장소 설정을 확인하거나 ROM을 다운로드하세요';

  @override
  String get searchGamesHint => '게임 검색...';

  @override
  String get settingsHeaderTitle => 'Forsaken 에뮬레이터 설정';

  @override
  String get settingsHeaderSubtitle => '에뮬레이터, 경로 설정 및 콘텐츠 다운로드';

  @override
  String get emulatorManagementDesc => '에뮬레이터 명령 추가, 편집 및 설정';

  @override
  String get systemPaths => '시스템 경로';

  @override
  String get systemPathsDesc => 'ROM, 미디어 및 에뮬레이터 경로 설정';

  @override
  String get romDatabaseDesc => 'GitHub에서 ROM 목록 다운로드 및 관리';

  @override
  String get romStorageDesc => '다운로드한 ROM, 저장소 및 임시 파일 정리 관리';

  @override
  String get downloadManagerDesc => '에뮬레이터, ROM 목록 및 게임 데이터 다운로드';

  @override
  String get systemRequirementsDesc => '필요한 도구 및 종속성 확인';

  @override
  String get gamepadTestDebug => '게임패드 테스트 및 디버그';

  @override
  String get gamepadTestDebugDesc => '게임패드 버튼, 축 테스트 및 문제 해결';

  @override
  String get biosFirmwareHelpDesc => 'BIOS 파일 및 펌웨어 요구 사항 확인';

  @override
  String get webSettingsDesc => 'CORS 프록시 및 웹 플랫폼 설정';

  @override
  String get setupWizardDesc => '초기 설정 마법사 재실행';

  @override
  String get languageDesc => '애플리케이션 언어 선택';

  @override
  String get aboutDebug => '정보 및 디버그';

  @override
  String get aboutDebugDesc => '앱 정보 및 디버그 설정';

  @override
  String get legalDisclaimer => '법적 고지';

  @override
  String get romDatabaseCredits => 'ROM 목록은 Arley4d의 AndroidRoms 저장소에서 제공됩니다:';

  @override
  String get romDatabaseThanks =>
      '보존 목적으로 포괄적인 ROM 데이터베이스를 유지하는 AndroidRoms 프로젝트에 특별한 감사를 드립니다.';

  @override
  String get biosFilesSection => 'BIOS 파일';

  @override
  String get biosFilesCredits =>
      'BIOS 파일은 Abdess의 retroarch_system 저장소에서 제공됩니다:';

  @override
  String get biosFilesThanks =>
      '이 저장소에는 다양한 에뮬레이션 플랫폼에 필요한 시스템 파일과 BIOS가 포함되어 있습니다. 이러한 필수 파일을 보존해 주신 관리자분들께 특별한 감사를 드립니다.';

  @override
  String get amigaCopyProtection => 'Amiga 복사 보호 지원은 capsimg 라이브러리에서 제공됩니다:';

  @override
  String get amigaCopyProtectionThanks =>
      'Amiga 에뮬레이션을 위한 IPF(복사 보호) 디스크 이미지 지원을 가능하게 하는 capsimg 라이브러리를 유지하는 rsn8887에 특별한 감사를 드립니다.';

  @override
  String get additionalBiosFiles => '추가 BIOS 파일은 RetroPieBios 프로젝트에서 제공됩니다:';

  @override
  String get additionalBiosThanks =>
      '다양한 시스템과 지역 간의 호환성을 향상시키는 추가 BIOS 변형 및 지역 파일을 제공해 주신 PIBSAS/RetroPieBios에 감사드립니다.';

  @override
  String get enabled => '활성화됨';

  @override
  String get disabled => '비활성화됨';

  @override
  String get disclaimerRequired => '계속하려면 면책 조항에 동의해야 합니다.';

  @override
  String get emulatorsPathRequired => '에뮬레이터 디렉토리 경로가 필요합니다.';

  @override
  String get emulatorConfigPathRequired => '에뮬레이터 설정 파일 경로가 필요합니다.';

  @override
  String get mediaPathRequired => '미디어 경로가 필요합니다.';

  @override
  String get tempRomPathRequired => '임시 ROM 저장소 경로가 필요합니다.';

  @override
  String get permanentRomPathRequired => '영구 ROM 저장소 경로가 필요합니다.';

  @override
  String wizardStepCounter(int current, int total) {
    return '단계 $current / $total';
  }

  @override
  String get emulatorConfiguration => '에뮬레이터 구성';

  @override
  String get emulatorConfigStepDesc =>
      '에뮬레이터가 설치된 경로를 설정하세요. 나중에 설정 > 시스템 경로에서 변경할 수 있습니다.';

  @override
  String get emulatorsDirectory => '에뮬레이터 디렉토리';

  @override
  String get pathToEmulatorBinaries => '에뮬레이터 바이너리 경로';

  @override
  String get emulatorConfigFile => '에뮬레이터 설정 파일';

  @override
  String get pathToEmulatorConfig => '에뮬레이터 설정 JSON 경로';

  @override
  String get storagePaths => '저장소 경로';

  @override
  String get storagePathsStepDesc =>
      '미디어 자산과 ROM 파일이 저장되는 위치를 구성하세요. 나중에 설정 > 시스템 경로에서 변경할 수 있습니다.';

  @override
  String get wizardMediaPathHint => '박스아트, 스크린샷 및 비디오';

  @override
  String get temporaryRomStorage => '임시 ROM 저장소';

  @override
  String get temporaryRomStorageHint => '단일 플레이 세션용으로 다운로드된 ROM';

  @override
  String get permanentRomStorage => '영구 ROM 저장소';

  @override
  String get permanentRomStorageHint => '오프라인 플레이를 위해 저장된 ROM';

  @override
  String get allSet => '모두 준비됐습니다!';

  @override
  String get wizardEmulatorReady => 'Forsaken 에뮬레이터를 사용할 준비가 되었습니다.';

  @override
  String get changeSettingsLater => '이 설정은 나중에 설정 화면에서 변경할 수 있습니다.';

  @override
  String get configurationSummary => '구성 요약';

  @override
  String get summaryEmulators => '에뮬레이터';

  @override
  String get summaryMedia => '미디어';

  @override
  String get summaryTempRoms => '임시 ROM';

  @override
  String get summarySavedRoms => '저장된 ROM';

  @override
  String get defaultValue => '(기본값)';

  @override
  String pdfPageIndicator(int current, int total) {
    return '$total페이지 중 $current페이지';
  }

  @override
  String get pdfZoomOut => '축소 (-)';

  @override
  String get pdfZoomIn => '확대 (+)';

  @override
  String get pdfResetZoom => '줌 초기화 (0)';

  @override
  String get pdfFirstPage => '첫 페이지 (Home)';

  @override
  String get pdfPreviousPage => '이전 페이지 (←/PgUp)';

  @override
  String get pdfNextPage => '다음 페이지 (→/PgDn)';

  @override
  String get pdfLastPage => '마지막 페이지 (End)';

  @override
  String get pdfFileNotFound => 'PDF 파일을 찾을 수 없습니다';

  @override
  String confirmDeleteEmulator(String system) {
    return '$system의 에뮬레이터 설정을 삭제하시겠습니까?';
  }

  @override
  String commandsConfigured(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개 명령 설정됨',
      one: '1개 명령 설정됨',
    );
    return '$_temp0';
  }

  @override
  String get noCommand => '명령 없음';

  @override
  String get reloadConfigTooltip => '설정 다시 불러오기 (R)';

  @override
  String get configurationInfo => '설정 정보';

  @override
  String get configLocation => '설정 위치:';

  @override
  String get hasLocalOverridesYes => '로컬 재정의 있음: 예';

  @override
  String get hasLocalOverridesNo => '로컬 재정의 있음: 아니오';

  @override
  String get changesSavedToDevice => '변경사항이 기기 저장소에 저장됩니다.';

  @override
  String get usingBundledConfig => '번들 설정 사용 중. 편집하여 로컬 재정의를 만드세요.';

  @override
  String get noEmulatorsConfigured => '설정된 에뮬레이터 없음';

  @override
  String get addFirstEmulator => '첫 번째 에뮬레이터를 추가하여 시작하세요';

  @override
  String get edit => '편집';

  @override
  String get editEmulator => '에뮬레이터 편집';

  @override
  String get system => '시스템';

  @override
  String get systemHint => 'e.g., nes, snes, ps1';

  @override
  String get commands => '명령';

  @override
  String commandNumber(int number) {
    return '명령 $number';
  }

  @override
  String get commandHint => 'e.g., ../retroarch.AppImage -f -L core.so';

  @override
  String get remove => '제거';

  @override
  String get options => '옵션';

  @override
  String get biosDownloading => '다운로드 중...';

  @override
  String downloadRequiredAndExtras(int requiredCount, int optionalCount) {
    return '필수 $requiredCount개 + 추가 $optionalCount개 다운로드';
  }

  @override
  String downloadRequiredFiles(int requiredCount) {
    return '필수 파일 $requiredCount개 다운로드';
  }

  @override
  String downloadOptionalExtras(int optionalCount) {
    return '선택적 추가 $optionalCount개 다운로드';
  }

  @override
  String get downloadFiles => '파일 다운로드';

  @override
  String batchDownloadConfirmation(int totalFiles, int platformCount) {
    return '$platformCount개 플랫폼의 BIOS 파일 $totalFiles개를 다운로드합니다:';
  }

  @override
  String get downloadSourceNote => '파일은 retroarch_system 저장소에서 다운로드됩니다.';

  @override
  String get biosOptional => '선택';

  @override
  String biosFilesFound(int foundCount, int totalCount) {
    return '$foundCount/$totalCount 파일 발견';
  }

  @override
  String optionalExtrasAvailable(int count) {
    return '+$count개 선택적 추가 파일 이용 가능';
  }

  @override
  String get biosLocations => '위치:';

  @override
  String get availableForDownload => '여러 소스에서 다운로드 가능';

  @override
  String get summary => '요약';

  @override
  String get biosComplete => '완료';

  @override
  String get biosPartial => '부분';

  @override
  String get biosFiles => '파일';

  @override
  String get biosDownloadable => '다운로드 가능';

  @override
  String get refreshF5Tooltip => '새로고침 (F5)';

  @override
  String get allBiosFilesFound => '모든 BIOS 파일을 찾았습니다!';

  @override
  String get noBiosRequirements => 'BIOS 요구 사항을 찾을 수 없습니다';

  @override
  String platformCount(int count) {
    return '$count개 플랫폼';
  }

  @override
  String failedToLoadBiosStatus(String error) {
    return 'BIOS 상태 로드 실패: $error';
  }

  @override
  String get refreshStatus => '상태 새로고침';

  @override
  String platformsCompleteCount(int complete, int total) {
    return '$complete/$total 플랫폼 완료';
  }

  @override
  String get platformStatusHeader => '플랫폼 상태';

  @override
  String filesVerifiedStatus(
    int presentFiles,
    int totalFiles,
    int verifiedFiles,
  ) {
    return '$presentFiles/$totalFiles 파일 ($verifiedFiles개 검증됨)';
  }

  @override
  String get biosCollectionOverview => 'BIOS 컬렉션 개요';

  @override
  String get biosVerified => '검증됨';

  @override
  String downloadComingSoon(String platformName) {
    return '$platformName 다운로드 기능 - 곧 출시!';
  }

  @override
  String get noGamepadConnected => '게임패드가 연결되지 않았습니다';

  @override
  String get connectGamepadPrompt => '게임패드를 연결하고 아무 버튼이나 누르세요';

  @override
  String get pressButtonToTest => '아무 버튼이나 눌러 테스트하세요 (동작 비활성화)';

  @override
  String get buttonFunctionTests => '버튼 기능 테스트';

  @override
  String get gamepadASelect => 'A (선택)';

  @override
  String get gamepadBBack => 'B (뒤로)';

  @override
  String get gamepadXSearch => 'X (검색)';

  @override
  String get gamepadYHelp => 'Y (도움말)';

  @override
  String get gamepadLBPageDown => 'LB (페이지 아래로)';

  @override
  String get gamepadRBPageUp => 'RB (페이지 위로)';

  @override
  String get gamepadStartMenu => 'Start (메뉴)';

  @override
  String get gamepadSelectSettings => 'Select (설정)';

  @override
  String get gamepadLSClick => 'LS 클릭';

  @override
  String get gamepadRSView => 'RS 클릭 (보기)';

  @override
  String get gamepadLTTrigger => 'LT (트리거)';

  @override
  String get gamepadRTTrigger => 'RT (트리거)';

  @override
  String get rawButtonStates => '원시 버튼 상태';

  @override
  String get noButtonsPressed => '눌린 버튼 없음';

  @override
  String get axisValues => '축 값';

  @override
  String get noAxisMovement => '축 움직임 없음';

  @override
  String get dpadLeftStick => 'D-Pad + 왼쪽 스틱';

  @override
  String get webSettingsDescription => '웹 플랫폼 전용 설정 구성';

  @override
  String get corsProxyWhyNeeded => 'CORS 프록시가 필요한 이유';

  @override
  String get corsProxyExplanation =>
      '브라우저는 CORS 보안 제한으로 인해 외부 서버에서 ROM 다운로드를 차단합니다. CORS 프록시는 사용자가 제어하는 서버에서 요청을 중계하여 필요한 헤더를 추가합니다.\n\nForsaken에는 무료로 배포할 수 있는 Cloudflare Worker가 포함되어 있습니다(일 10만 요청). 설정 지침은 tools/cors-proxy-worker/ 디렉토리를 참조하세요.';

  @override
  String get corsProxyUrl => 'CORS 프록시 URL';

  @override
  String get corsProxyHelperText =>
      'CORS 프록시를 비활성화하려면 비워두세요 (CORS가 없는 서버의 ROM은 실패합니다)';

  @override
  String get testingProxy => '프록시 테스트 중...';

  @override
  String get testProxyConnection => '프록시 연결 테스트';

  @override
  String get noProxyUrlConfigured => '프록시 URL이 설정되지 않았습니다';

  @override
  String proxyWorking(int statusCode) {
    return '프록시가 작동 중 (HTTP $statusCode)';
  }

  @override
  String proxyReturnedHttp(int statusCode) {
    return '프록시가 HTTP $statusCode을 반환했습니다';
  }

  @override
  String get connectionTimedOut => '연결 시간 초과';

  @override
  String get corsProxySettingsSaved =>
      'CORS 프록시 설정이 저장되었습니다. 새로운 ROM 실행 시 즉시 적용됩니다.';

  @override
  String get quickDeploy => '빠른 배포';

  @override
  String get corsProxyDeploySteps =>
      '1. dash.cloudflare.com에서 가입 (무료)\n2. Wrangler 설치: npm install -g wrangler\n3. 로그인: wrangler login\n4. cd tools/cors-proxy-worker\n5. npx wrangler deploy\n6. 위에 Worker URL 붙여넣기';

  @override
  String get permanentStorage => '영구 저장소';

  @override
  String get temporaryStorage => '임시 저장소';

  @override
  String get noDownloadedRoms => '다운로드된 ROM이 없습니다';

  @override
  String get biosErrorNetworkMessage => '네트워크 연결 실패';

  @override
  String get biosErrorNetworkSuggestions =>
      '인터넷 연결을 확인하세요\n잠시 후 다시 시도하세요\nDNS 설정을 확인하세요\n접근이 제한된 경우 VPN을 사용해 보세요';

  @override
  String get biosErrorFileNotFoundMessage => '서버에서 파일을 찾을 수 없습니다';

  @override
  String get biosErrorFileNotFoundSuggestions =>
      'BIOS 파일이 이동되었거나 이름이 변경되었을 수 있습니다\n다른 소스에서 다운로드해 보세요\n파일이 다른 브랜치/저장소에 있는지 확인하세요\n문제가 지속되면 보고해 주세요';

  @override
  String get biosErrorAccessDeniedMessage => '서버에 의해 접근이 거부되었습니다';

  @override
  String get biosErrorAccessDeniedSuggestions =>
      '서버가 다운로드를 차단하고 있을 수 있습니다\n나중에 다시 시도하세요 - 서버가 일시적으로 제한될 수 있습니다\n지역 제한이 있는 경우 VPN을 사용하세요\n인증이 필요한지 확인하세요';

  @override
  String get biosErrorRateLimitedMessage => '요청 제한 초과';

  @override
  String get biosErrorRateLimitedSuggestions =>
      '몇 분 후에 다시 시도하세요\n동시 다운로드 수를 줄이세요\n서버가 과도한 요청으로부터 보호하고 있습니다';

  @override
  String get biosErrorChecksumMessage => '파일 무결성 검증 실패';

  @override
  String get biosErrorChecksumSuggestions =>
      '다운로드 중 파일이 손상되었을 수 있습니다\n다시 다운로드해 보세요\n서버에서 파일이 업데이트되었는지 확인하세요\n인터넷 연결 안정성을 확인하세요';

  @override
  String get biosErrorSizeMismatchMessage => '예상치 못한 파일 크기';

  @override
  String get biosErrorSizeMismatchSuggestions =>
      '파일이 예상과 다른 버전일 수 있습니다\n다운로드가 불완전할 수 있습니다\n다시 다운로드해 보세요\n사용 가능한 디스크 공간을 확인하세요';

  @override
  String get biosErrorStorageMessage => '저장소 오류';

  @override
  String get biosErrorStorageSuggestions =>
      '디스크 공간을 확보하세요\n파일 권한을 확인하세요\n대상 디렉토리가 쓰기 가능한지 확인하세요\n다른 위치에 다운로드해 보세요';

  @override
  String get biosErrorTimeoutMessage => '다운로드 시간 초과';

  @override
  String get biosErrorTimeoutSuggestions =>
      '인터넷 연결이 느릴 수 있습니다\n서버가 과부하 상태일 수 있습니다\n안정적인 연결로 다시 시도하세요\n방화벽이 연결을 차단하고 있는지 확인하세요';

  @override
  String get biosErrorArchiveMessage => '아카이브 추출 실패';

  @override
  String get biosErrorArchiveSuggestions =>
      '다운로드한 아카이브가 손상되었을 수 있습니다\n파일을 다시 다운로드해 보세요\n올바른 추출 도구가 사용 가능한지 확인하세요\n파일이 유효한 아카이브 형식인지 확인하세요';

  @override
  String get biosErrorUnknownMessage => '다운로드 실패';

  @override
  String get biosErrorUnknownSuggestions =>
      '다시 다운로드해 보세요\n인터넷 연결을 확인하세요\n파일이 아직 사용 가능한지 확인하세요\n문제가 지속되면 지원팀에 문의하세요';
}
