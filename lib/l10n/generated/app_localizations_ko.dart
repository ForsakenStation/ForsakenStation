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
  String get biosRequired => 'BIOS 필요';

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
  String get biosMissing => 'BIOS 누락';

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
}
