// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Forsaken Emulator';

  @override
  String get retroGamingFrontend => 'واجهة ألعاب الرجعي';

  @override
  String get platforms => 'المنصات';

  @override
  String get roms => 'الرومات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get settingsAndConfiguration => 'الإعدادات والتكوين';

  @override
  String get aboutForsakenEmulator => 'حول Forsaken Emulator';

  @override
  String get version => 'الإصدار';

  @override
  String get appDescription =>
      'واجهة محاكيات متعددة المنصات الحديثة مبنية بـ Flutter.';

  @override
  String get emulators => 'المحاكيات';

  @override
  String get ready => 'جاهز';

  @override
  String get back => 'رجوع';

  @override
  String get select => 'تحديد';

  @override
  String get search => 'بحث';

  @override
  String get refresh => 'تحديث';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get error => 'خطأ';

  @override
  String get initializationError => 'خطأ في التهيئة';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get ok => 'موافق';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get confirm => 'تأكيد';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get close => 'إغلاق';

  @override
  String get noRomsFound => 'لم يتم العثور على رومات';

  @override
  String get noPlatformsFound => 'لم يتم العثور على منصات';

  @override
  String get checkRomsPath => 'تحقق من متغير البيئة ROMS_PATH';

  @override
  String get downloading => 'جارٍ التنزيل...';

  @override
  String get downloadComplete => 'اكتمل التنزيل';

  @override
  String get downloadFailed => 'فشل التنزيل';

  @override
  String get emulatorNotFound => 'المحاكي غير موجود';

  @override
  String get romNotFound => 'الروم غير موجود';

  @override
  String get biosRequired => 'BIOS مطلوب';

  @override
  String get systemCheck => 'فحص النظام';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'السمة';

  @override
  String get systemDefault => 'افتراضي النظام';

  @override
  String get help => 'مساعدة';

  @override
  String get keyboardAndGamepadControls =>
      'عناصر تحكم لوحة المفاتيح وعصا التحكم';

  @override
  String get navigation => 'التنقل';

  @override
  String get actions => 'الإجراءات';

  @override
  String get viewControls => 'عناصر تحكم العرض';

  @override
  String get gotIt => 'فهمت!';

  @override
  String get exit => 'خروج';

  @override
  String get exitApplication => 'الخروج من التطبيق';

  @override
  String get exitConfirm => 'هل أنت متأكد أنك تريد الخروج؟';

  @override
  String get downloadManager => 'مدير التنزيلات';

  @override
  String get clearCompleted => 'مسح المكتملة';

  @override
  String get selectCategory => 'تحديد الفئة';

  @override
  String get confirmDownload => 'تأكيد التنزيل';

  @override
  String get downloadGameLists => 'تنزيل قوائم الألعاب';

  @override
  String get downloadGameListsDescription =>
      'سيؤدي هذا إلى تنزيل قوائم الرومات من GitHub.';

  @override
  String get gameListsDownloaded => 'تم تنزيل قوائم الألعاب!';

  @override
  String get romStorageManagement => 'إدارة تخزين الرومات';

  @override
  String get deleteRom => 'حذف الروم؟';

  @override
  String deleteRomConfirm(String fileName) {
    return 'حذف $fileName؟';
  }

  @override
  String get actionCannotBeUndone => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String deleted(String fileName) {
    return 'تم الحذف: $fileName';
  }

  @override
  String get savePermanently => 'حفظ بشكل دائم؟';

  @override
  String moveRomConfirm(String fileName) {
    return 'نقل $fileName إلى التخزين الدائم؟';
  }

  @override
  String saved(String fileName) {
    return 'تم الحفظ: $fileName';
  }

  @override
  String get clearAll => 'مسح الكل؟';

  @override
  String get clearAllConfirm => 'حذف جميع الرومات المؤقتة؟';

  @override
  String get allCleared => 'تم مسح جميع الرومات المؤقتة';

  @override
  String get systemPathsConfiguration => 'تكوين مسارات النظام';

  @override
  String get migrateRoms => 'ترحيل الرومات؟';

  @override
  String get migrateRomsDescription =>
      'تم تغيير مسار التخزين الدائم للرومات من \$oldPath إلى \$newPath. هل تريد ترحيل الرومات الموجودة إلى الموقع الجديد؟';

  @override
  String get noKeepThem => 'لا، الاحتفاظ بها';

  @override
  String get yesMigrateRoms => 'نعم، ترحيل الرومات';

  @override
  String get migratingRoms => 'جارٍ ترحيل الرومات...';

  @override
  String get romMigrationFailed => 'تحذير: فشل ترحيل الرومات';

  @override
  String get pathsSaved => 'تم حفظ المسارات بنجاح';

  @override
  String get errorSavingPaths => 'خطأ في حفظ المسارات:';

  @override
  String get resetConfiguration => 'إعادة تعيين التكوين';

  @override
  String get resetConfigDescription =>
      'سيؤدي هذا إلى إعادة تعيين جميع المسارات إلى قيمها الافتراضية. لن تتأثر روماتك وملفات الوسائط.';

  @override
  String get configurationReset =>
      'تمت إعادة تعيين التكوين إلى القيم الافتراضية';

  @override
  String get errorResettingConfiguration => 'خطأ في إعادة تعيين التكوين:';

  @override
  String get savePaths => 'حفظ المسارات';

  @override
  String get saving => 'جارٍ الحفظ...';

  @override
  String get emulatorManagement => 'إدارة المحاكيات';

  @override
  String get configurationReloaded => 'تمت إعادة تحميل التكوين';

  @override
  String get errorLoadingEmulators => 'خطأ في تحميل المحاكيات:';

  @override
  String get emulatorAdded => 'تمت إضافة المحاكي بنجاح';

  @override
  String get errorAddingEmulator => 'خطأ في إضافة المحاكي:';

  @override
  String get emulatorUpdated => 'تم تحديث المحاكي بنجاح';

  @override
  String get errorUpdatingEmulator => 'خطأ في تحديث المحاكي:';

  @override
  String get deleteEmulator => 'حذف المحاكي';

  @override
  String get emulatorDeleted => 'تم حذف المحاكي';

  @override
  String get errorDeletingEmulator => 'خطأ في حذف المحاكي:';

  @override
  String get configurationSource => 'مصدر التكوين';

  @override
  String get addEmulator => 'إضافة محاكي';

  @override
  String get systemNameRequired => 'اسم النظام مطلوب';

  @override
  String get commandRequired => 'مطلوب أمر واحد على الأقل';

  @override
  String get addCommand => 'إضافة أمر';

  @override
  String get acceptZipFiles => 'قبول ملفات ZIP';

  @override
  String get acceptZipSubtitle => 'السماح بتشغيل الرومات من أرشيفات ZIP';

  @override
  String get useForeverMode => 'استخدام وضع Forever';

  @override
  String get useForeverSubtitle => 'إبقاء المحاكي قيد التشغيل';

  @override
  String get workInProgress => 'عمل قيد التقدم';

  @override
  String get wipSubtitle => 'وضع علامة كغير مكون بالكامل بعد';

  @override
  String get biosFirmwareHelp => 'مساعدة BIOS والبرمجية الثابتة';

  @override
  String get downloadMissingFiles => 'تنزيل الملفات المفقودة';

  @override
  String get showOnlyMissing => 'إظهار المفقودة فقط';

  @override
  String get downloadAllMissingBios => 'تنزيل جميع BIOS المفقودة';

  @override
  String get configurationError => 'خطأ في التكوين';

  @override
  String get configurationErrorDescription =>
      'لم تتمكن التطبيق من العثور على التكوين المطلوب.\nيرجى تكوين مساراتك في الإعدادات > مسارات النظام.';

  @override
  String get configurationRequired =>
      'مطلوب:\n- مسار الوسائط: المجلد الذي يحتوي على أصول الوسائط\n- مسار المحاكيات: المجلد الذي يحتوي على ملفات المحاكيات الثنائية\n\nاختياري:\n- مسارات تخزين الرومات للتنزيلات المؤقتة/الدائمة';

  @override
  String get goToSettingsToConfigure =>
      'انتقل إلى الإعدادات > مسارات النظام للتكوين';

  @override
  String get noDownloadableBios => 'لا توجد ملفات BIOS قابلة للتنزيل مفقودة';

  @override
  String get allDownloadsCompleted => 'تمت جميع التنزيلات بنجاح!';

  @override
  String get batchDownloadFailed => 'فشل التنزيل الدفعي:';

  @override
  String get download => 'تنزيل';

  @override
  String get downloadCancelled => 'تم إلغاء التنزيل';

  @override
  String get launched => 'تم التشغيل:';

  @override
  String get failedToSave => 'فشل في حفظ الروم بشكل دائم';

  @override
  String get failedToSaveRom => 'فشل في حفظ الروم بشكل دائم';

  @override
  String get errorSaving => 'خطأ في حفظ الروم:';

  @override
  String errorSavingRom(String error) {
    return 'خطأ في حفظ الروم: $error';
  }

  @override
  String get openFolder => 'فتح المجلد';

  @override
  String get viewManual => 'عرض الدليل';

  @override
  String get play => 'لعب';

  @override
  String get goBack => 'رجوع';

  @override
  String get clearSearch => 'مسح البحث';

  @override
  String get iUnderstand => 'أفهم وأقبل هذه الشروط';

  @override
  String get start => 'بدء';

  @override
  String get debugMode => 'وضع التصحيح: ';

  @override
  String get toggleDebugMode => 'تبديل وضع التصحيح';

  @override
  String get preparingDownload => 'جارٍ إعداد التنزيل...';

  @override
  String get noEmulatorsAvailable => 'لا توجد محاكيات متاحة لهذه الفئة';

  @override
  String get failedToLaunch => 'فشل في تشغيل المحاكي الويب:';

  @override
  String get platformInfo => 'معلومات المنصة';

  @override
  String get emulatorPlatformInfo => 'معلومات منصة المحاكي';

  @override
  String get favorites => 'المفضلة';

  @override
  String get all => 'الكل';

  @override
  String get collections => 'المجموعات';

  @override
  String get searchRoms => 'البحث عن رومات...';

  @override
  String get searchPlatforms => 'البحث عن منصات...';

  @override
  String romsCount(int count) {
    return '$count رومات';
  }

  @override
  String platformsCount(int count) {
    return '$count منصات';
  }

  @override
  String get region => 'المنطقة';

  @override
  String get genre => 'النوع';

  @override
  String get year => 'السنة';

  @override
  String get publisher => 'الناشر';

  @override
  String get developer => 'المطور';

  @override
  String get playWithNetplay => 'اللعب عبر الشبكة';

  @override
  String get downloadBios => 'تنزيل BIOS';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get addToFavorites => 'إضافة إلى المفضلة';

  @override
  String get removeFromFavorites => 'إزالة من المفضلة';

  @override
  String get biosMissing => 'BIOS مفقود';

  @override
  String get biosPresent => 'BIOS موجود';

  @override
  String get checkingBios => 'جارٍ فحص BIOS...';

  @override
  String get emulatorDownloading => 'جارٍ تنزيل المحاكي...';

  @override
  String get emulatorDownloadComplete => 'تم تنزيل المحاكي';

  @override
  String get emulatorDownloadFailed => 'فشل تنزيل المحاكي';

  @override
  String get installingEmulator => 'جارٍ تثبيت المحاكي...';

  @override
  String get emulatorReady => 'المحاكي جاهز';

  @override
  String get configuration => 'التكوين';

  @override
  String get paths => 'المسارات';

  @override
  String get storage => 'التخزين';

  @override
  String get emulatorsPath => 'مسار المحاكيات';

  @override
  String get romsPath => 'مسار الرومات';

  @override
  String get mediaPath => 'مسار الوسائط';

  @override
  String get biosPath => 'مسار BIOS';

  @override
  String get tempPath => 'المسار المؤقت';

  @override
  String get browse => 'تصفح';

  @override
  String get apply => 'تطبيق';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get clear => 'مسح';

  @override
  String get scan => 'فحص';

  @override
  String get scanForRoms => 'فحص الرومات';

  @override
  String get scanningRoms => 'جارٍ فحص الرومات...';

  @override
  String get scanComplete => 'اكتمل الفحص';

  @override
  String romsFound(int count) {
    return 'تم العثور على $count رومات';
  }

  @override
  String get noNewRomsFound => 'لم يتم العثور على رومات جديدة';

  @override
  String get launchEmulator => 'تشغيل المحاكي';

  @override
  String get emulatorError => 'خطأ في المحاكي';

  @override
  String get gamepadConnected => 'عصا التحكم متصلة';

  @override
  String get gamepadDisconnected => 'عصا التحكم غير متصلة';

  @override
  String get gamepadTest => 'اختبار عصا التحكم';

  @override
  String get pressAnyButton => 'اضغط أي زر للاختبار';

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
  String get dpadUp => 'D-Pad أعلى';

  @override
  String get dpadDown => 'D-Pad أسفل';

  @override
  String get dpadLeft => 'D-Pad يسار';

  @override
  String get dpadRight => 'D-Pad يمين';

  @override
  String get leftShoulder => 'L1';

  @override
  String get rightShoulder => 'R1';

  @override
  String get leftTrigger => 'L2';

  @override
  String get rightTrigger => 'R2';

  @override
  String get leftStick => 'العصا اليسرى';

  @override
  String get rightStick => 'العصا اليمنى';

  @override
  String get setupWizard => 'معالج الإعداد';

  @override
  String get welcome => 'مرحبا';

  @override
  String get welcomeMessage => 'مرحبا بك في Forsaken Emulator';

  @override
  String get next => 'التالي';

  @override
  String get previous => 'السابق';

  @override
  String get finish => 'إنهاء';

  @override
  String get skip => 'تخطي';

  @override
  String get setupComplete => 'اكتمل الإعداد';

  @override
  String get selectLanguage => 'تحديد اللغة';

  @override
  String get selectEmulatorsPath => 'تحديد مسار المحاكيات';

  @override
  String get selectRomsPath => 'تحديد مسار الرومات';

  @override
  String get selectMediaPath => 'تحديد مسار الوسائط';

  @override
  String get allSettingsConfigured => 'تم تكوين جميع الإعدادات';

  @override
  String get darkTheme => 'داكن';

  @override
  String get lightTheme => 'فاتح';

  @override
  String get systemTheme => 'النظام';

  @override
  String get about => 'حول';

  @override
  String get checkForUpdates => 'التحقق من التحديثات';

  @override
  String get noUpdatesAvailable => 'لا توجد تحديثات متاحة';

  @override
  String get updateAvailable => 'تحديث متاح';

  @override
  String get downloadingUpdate => 'جارٍ تنزيل التحديث...';

  @override
  String get installingUpdate => 'جارٍ تثبيت التحديث...';

  @override
  String get updateComplete => 'اكتمل التحديث';

  @override
  String get updateFailed => 'فشل التحديث';

  @override
  String get networkError => 'خطأ في الشبكة';

  @override
  String get connectionError => 'خطأ في الاتصال';

  @override
  String get timeoutError => 'خطأ في المهلة';

  @override
  String get unknownError => 'خطأ غير معروف';

  @override
  String get permissionDenied => 'الإذن مرفوض';

  @override
  String get fileNotFound => 'الملف غير موجود';

  @override
  String get directoryNotFound => 'المجلد غير موجود';

  @override
  String get diskFull => 'القرص ممتلئ';

  @override
  String get invalidPath => 'مسار غير صالح';

  @override
  String get pathNotWritable => 'المسار غير قابل للكتابة';

  @override
  String get romCorrupted => 'قد يكون ملف الروم تالفا';

  @override
  String get zipError => 'خطأ في أرشيف ZIP';

  @override
  String get extractionFailed => 'فشل الاستخراج';

  @override
  String get checksumMismatch => 'عدم تطابق المجموع الاختباري';

  @override
  String get biosCheckFailed => 'فشل فحص BIOS';

  @override
  String get continueAnyway => 'المتابعة على أي حال';

  @override
  String get reportIssue => 'الإبلاغ عن مشكلة';

  @override
  String get copyToClipboard => 'نسخ إلى الحافظة';

  @override
  String get copiedToClipboard => 'تم النسخ إلى الحافظة';

  @override
  String get share => 'مشاركة';

  @override
  String get hide => 'إخفاء';

  @override
  String get show => 'إظهار';

  @override
  String get toggleView => 'تبديل العرض';

  @override
  String get gridView => 'عرض شبكي';

  @override
  String get listView => 'عرض قائمة';

  @override
  String get carouselView => 'عرض دائري';

  @override
  String get sortBy => 'ترتيب حسب';

  @override
  String get sortByName => 'الاسم';

  @override
  String get sortByDate => 'التاريخ';

  @override
  String get sortBySize => 'الحجم';

  @override
  String get sortByRegion => 'المنطقة';

  @override
  String get ascending => 'تصاعدي';

  @override
  String get descending => 'تنازلي';

  @override
  String get filter => 'تصفية';

  @override
  String get filterByRegion => 'تصفية حسب المنطقة';

  @override
  String get filterByGenre => 'تصفية حسب النوع';

  @override
  String get filterByYear => 'تصفية حسب السنة';

  @override
  String get clearFilters => 'مسح الفلاتر';

  @override
  String get systemInfo => 'معلومات النظام';

  @override
  String get cpu => 'المعالج';

  @override
  String get memory => 'الذاكرة';

  @override
  String get storageInfo => 'التخزين';

  @override
  String get os => 'نظام التشغيل';

  @override
  String get emulatorVersion => 'إصدار المحاكي';

  @override
  String get totalRoms => 'إجمالي الرومات';

  @override
  String get totalSize => 'الحجم الإجمالي';

  @override
  String get freeSpace => 'المساحة المتاحة';

  @override
  String get usedSpace => 'المساحة المستخدمة';

  @override
  String get systemUtilities => 'أدوات النظام';

  @override
  String get romVerificationResults => 'نتائج التحقق من الرومات';

  @override
  String get totalRomFiles => 'إجمالي ملفات الروم';

  @override
  String get emptyRomFiles => 'ملفات روم فارغة';

  @override
  String get validRomFiles => 'ملفات روم صالحة';

  @override
  String get romsDirectoryDoesNotExist => 'مجلد الرومات غير موجود';

  @override
  String get gamelistCheckResults => 'نتائج فحص قوائم الألعاب';

  @override
  String get totalPlatforms => 'إجمالي المنصات';

  @override
  String get missingGamelists => 'قوائم ألعاب مفقودة';

  @override
  String get configurationBackup => 'نسخ احتياطي للتكوين';

  @override
  String get configurationBackedUp => 'تم نسخ التكوين احتياطيا في:';

  @override
  String get errorBackingUp => 'خطأ في نسخ التكوين احتياطيا:';

  @override
  String get romDatabase => 'قاعدة بيانات الرومات';

  @override
  String get romDatabaseDownloaded => 'تم تنزيل قاعدة بيانات الرومات بنجاح';

  @override
  String get failedDownloadRomDatabase => 'فشل تنزيل قاعدة بيانات الرومات';

  @override
  String get romDatabaseCleared => 'تم مسح قاعدة بيانات الرومات';

  @override
  String get failedClearDatabase => 'فشل مسح قاعدة البيانات';

  @override
  String get downloadRomDatabase => 'تنزيل قاعدة بيانات الرومات';

  @override
  String get clearRomDatabase => 'مسح قاعدة بيانات الرومات';

  @override
  String get systemRequirements => 'متطلبات النظام';

  @override
  String get failedToCheckSystem => 'فشل فحص النظام';

  @override
  String cleanedUpTempFiles(String deletedCount) {
    return 'تم تنظيف $deletedCount ملفات روم مؤقتة';
  }

  @override
  String get errorCleaningTempFiles => 'خطأ في تنظيف الملفات المؤقتة:';

  @override
  String get errorVerifyingRomFiles => 'خطأ في التحقق من ملفات الروم:';

  @override
  String get errorCheckingGamelists => 'خطأ في فحص قوائم الألعاب:';

  @override
  String get cancelDownload => 'إلغاء التنزيل';

  @override
  String get selectEmulator => 'تحديد المحاكي';

  @override
  String get biosStatusDashboard => 'لوحة حالة BIOS';

  @override
  String get webSettings => 'إعدادات الويب';

  @override
  String get saveSettings => 'حفظ الإعدادات';

  @override
  String get errorSavingSettings => 'خطأ في حفظ الإعدادات:';

  @override
  String romsCountItems(String count) {
    return '$count رومات';
  }

  @override
  String get savedPermanently => 'تم حفظه بشكل دائم';

  @override
  String get keptInTemporary => 'تم الاحتفاظ به في التخزين المؤقت';

  @override
  String get tryAgain => 'إعادة المحاولة';

  @override
  String get allDownloads => 'اكتملت جميع التنزيلات';

  @override
  String romSavedPermanently(String name) {
    return 'تم حفظ $name بشكل دائم';
  }

  @override
  String get undo => 'تراجع';

  @override
  String romKeptInTemporary(String name) {
    return 'تم الاحتفاظ بـ $name في التخزين المؤقت';
  }

  @override
  String romsCountWithSize(String count, String size) {
    return '$count رومات • $size';
  }

  @override
  String get whatYouCanTry => 'ما يمكنك تجربته:';

  @override
  String get tips => 'نصائح';

  @override
  String get helpNavigateItems => 'التنقل بين العناصر';

  @override
  String get helpGamepadNavigation => 'التنقل بعصا التحكم';

  @override
  String get helpQuickNavigation => 'تنقل سريع (تخطي عدة عناصر)';

  @override
  String get helpGamepadPageNavigation => 'تنقل الصفحات بعصا التحكم';

  @override
  String get helpGoToFirst => 'الذهاب إلى العنصر الأول';

  @override
  String get helpGoToLast => 'الذهاب إلى العنصر الأخير';

  @override
  String get helpJumpToLetter => 'الانتقال إلى العنصر الذي يبدأ بتلك الحرف';

  @override
  String get helpSelectItem => 'تحديد العنصر';

  @override
  String get helpGamepadSelect => 'التحديد بعصا التحكم';

  @override
  String get helpGoBackCloseDialogs => 'رجوع / إغلاق النوافذ';

  @override
  String get helpExitApplication => 'الخروج من التطبيق';

  @override
  String get helpGamepadBackClose => 'عصا التحكم رجوع / إغلاق النوافذ';

  @override
  String get helpToggleViewMode => 'تبديل وضع العرض (شبكي/قائمي/دائري)';

  @override
  String get helpGamepadViewToggle => 'تبديل العرض بعصا التحكم';

  @override
  String get helpRefreshView => 'تحديث العرض الحالي';

  @override
  String get helpShowPlatformInfo => 'عرض معلومات المنصة';

  @override
  String get helpActivateSearch => 'تفعيل البحث';

  @override
  String get helpGamepadSearch => 'البحث بعصا التحكم';

  @override
  String get helpShowHelpDialog => 'عرض نافذة المساعدة هذه';

  @override
  String get helpGamepadHelp => 'مساعدة عصا التحكم';

  @override
  String get tipUseKeyboardOrGamepad =>
      'استخدم لوحة المفاتيح أو عصا التحكم للتنقل';

  @override
  String get tipAlphabeticalJump => 'الالقفز الأبجدي يعمل في جميع أوضاع العرض';

  @override
  String get tipPressQuestionMark => 'اضغط ? في أي وقت لرؤية هذه المساعدة';

  @override
  String get tipGamepadAlongside =>
      'عصا التحكم يعمل junto مع عناصر تحكم لوحة المفاتيح';

  @override
  String get configurePathsDescription =>
      'تكوين المسارات التي تستخدمها التطبيقات لتحديد موقع الرومات والوسائط والمحاكيات.';

  @override
  String get romListsAutoManaged =>
      'قوائم الرومات الآن تُدار تلقائيا. قم بتنزيلها من الإعدادات > قاعدة بيانات الرومات.';

  @override
  String get romStorage => 'تخزين الرومات';

  @override
  String get configureRomStorageDescription =>
      'تكوين مكان تخزين الرومات التي تم تنزيلها بشكل مؤقت ودائم.';

  @override
  String get resetToDefaults => 'إعادة تعيين للافتراضيات';

  @override
  String get mediaPathLabel => 'مسار الوسائط';

  @override
  String get mediaPathHint =>
      'المجلد الذي يحتوي على الوسائط (صور، مقاطع فيديو)';

  @override
  String get emulatorsPathLabel => 'مسار المحاكيات';

  @override
  String get emulatorsPathHint =>
      'المجلد الذي يحتوي على الملفات الثنائية للمحاكيات';

  @override
  String get gamelistPathAutomatic => 'مسار قائمة الألعاب (تلقائي)';

  @override
  String get gamelistAutoDescription =>
      'قوائم الألعاب الآن تُدار تلقائيا في مجلد بيانات التطبيق. وهذا يجعل التطبيق مستقلا بالكامل ويستعد لتوزيع قوائم الألعاب المستند إلى GitHub في المستقبل.';

  @override
  String get tempRomStorageLabel => 'تخزين الرومات المؤقت (اختياري)';

  @override
  String get tempRomStorageDescription =>
      'يتم تنزيل الرومات هنا أولا. يمكن ترقيتها إلى التخزين الدائم بعد اللعب.';

  @override
  String get permanentRomStorageLabel => 'تخزين الرومات الدائم (اختياري)';

  @override
  String get permanentRomStorageDescription =>
      'الرومات المحفوظة بشكل دائم مخزنة هنا. هذه لا يتم تنظيفها تلقائيا.';

  @override
  String get defaultAppSupportDir => 'افتراضي: مجلد دعم التطبيق';

  @override
  String currentPathDisplay(String path) {
    return 'الحالي: $path';
  }

  @override
  String get configurationFile => 'ملف التكوين';

  @override
  String get source => 'المصدر:';

  @override
  String get customConfigActive => 'تكوين مخصص نشط';

  @override
  String get pathStructure => 'هيكل المسارات';

  @override
  String get pathStructureDescription =>
      'مسار الوسائط: MEDIA_PATH/المنصة/boxart|screenshots|videos/rom.png\nمسار قائمة الألعاب: ~/.local/share/com.example.emulator/gamelists/المنصة/gamelist.xml (تلقائي)\nمسار المحاكيات: EMULATORS_PATH/emulator_binary';

  @override
  String get errorCheckingSystem => 'خطأ في فحص النظام';

  @override
  String get recheckR => 'إعادة الفحص (R)';

  @override
  String get allRequiredToolsInstalled => 'جميع الأدوات المطلوبة مثبتة';

  @override
  String get missingRequiredTools => 'أدوات مطلوبة مفقودة';

  @override
  String get systemReadyToUse => 'نظامك جاهز لاستخدام المحاكي';

  @override
  String get someRequiredToolsMissing => 'بعض الأدوات المطلوبة مفقودة';

  @override
  String get requiredTools => 'الأدوات المطلوبة';

  @override
  String get requiredToolsDescription =>
      'هذه الأدوات مطلوبة لتنزيل واستخراج المحاكيات';

  @override
  String get installationInstructions => 'تعليمات التثبيت';

  @override
  String get installed => 'مثبت';

  @override
  String get missing => 'مفقود';

  @override
  String get downloadEmulatorsAndGameLists => 'تنزيل المحاكيات وقوائم الألعاب';

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get downloadAll => 'تنزيل الكل';

  @override
  String get byCategory => 'حسب الفئة';

  @override
  String get downloadQueue => 'قائمة انتظار التنزيل';

  @override
  String get noDownloadsInProgress => 'لا توجد تنزيلات جارية';

  @override
  String get selectQuickActionToStart => 'حدد إجراء سريع أعلاه لبدء التنزيل';

  @override
  String get categorySony => 'Sony (PS1-PS4)';

  @override
  String get categoryNintendo => 'Nintendo (GC, Wii, Switch)';

  @override
  String get categoryMicrosoft => 'Microsoft (Xbox, Xbox 360)';

  @override
  String get categoryMultiPlatform => 'متعدد المنصات (RetroArch)';

  @override
  String get categoryOtherEmulators => 'محاكيات أخرى';

  @override
  String get categoryUtilities => 'أدوات';

  @override
  String confirmDownloadDescription(String count, String size) {
    return 'تنزيل $count محاكي(ات)؟\nالحجم المقدر: ~$size MB\n\nقد يستغرق ذلك некотор الوقت حسب اتصالك بالإنترنت.';
  }

  @override
  String get alreadyInstalled => 'مثبت بالفعل';

  @override
  String get starting => 'جارٍ البدء...';

  @override
  String get completed => 'مكتمل';

  @override
  String get gameListsAlreadyDownloaded => 'قوائم الألعاب موجودة بالفعل';

  @override
  String get redownload => 'إعادة التنزيل';

  @override
  String get gameListsFromGitHub => 'قوائم الألعاب (من GitHub)';

  @override
  String get downloaded => 'تم التنزيل';

  @override
  String get cancelled => 'ملغى';

  @override
  String get missingFor => 'مفقود لـ:';

  @override
  String get noCustomConfigToBackup =>
      'لا يوجد تكوين مخصص للنسخ الاحتياطي. استخدام القيم الافتراضية.';

  @override
  String get saveConfigurationBackup => 'حفظ نسخ احتياطي للتكوين';

  @override
  String get refreshStatsR => 'تحديث الإحصائيات (R)';

  @override
  String get systemStatistics => 'إحصائيات النظام';

  @override
  String get romFiles => 'ملفات الروم';

  @override
  String get maintenanceTools => 'أدوات الصيانة';

  @override
  String get cleanupTemporaryRoms => 'تنظيف الرومات المؤقتة';

  @override
  String get cleanupTemporaryRomsDescription =>
      'إزالة ملفات الروم المؤقتة من مجلد النظام المؤقت';

  @override
  String get verifyRomFiles => 'التحقق من ملفات الروم';

  @override
  String get verifyRomFilesDescription =>
      'التحقق من أن جميع ملفات الروم موجودة وصالحة';

  @override
  String get checkMissingGamelists => 'فحص قوائم الألعاب المفقودة';

  @override
  String get checkMissingGamelistsDescription =>
      'العثور على المنصات التي تفتقر إلى ملف gamelist.xml';

  @override
  String get backupConfiguration => 'نسخ احتياطي للتكوين';

  @override
  String get backupConfigurationDescription =>
      'إنشاء نسخة احتياطية من config.json';

  @override
  String get downloadingRomDatabase => 'جارٍ تنزيل قاعدة بيانات الرومات...';

  @override
  String get downloadMayTakeMinutes => 'قد يستغرق ذلك بضع دقائق حسب اتصالك...';

  @override
  String get databaseStatus => 'حالة قاعدة البيانات';

  @override
  String get notDownloaded => 'غير موجود';

  @override
  String get aboutRomDatabase => 'حول قاعدة بيانات الرومات';

  @override
  String get aboutRomDatabaseDescription =>
      'تحتوي قاعدة بيانات الرومات على قوائم الرومات المتاحة منظمة حسب المنصة. يتم تنزيلها من مستودع romList الخاص بـ Forsaken على GitHub.';

  @override
  String get romDatabaseSource => 'المصدر: github.com/ForsakenStation/romList';

  @override
  String get downloadRomDatabaseDescription =>
      'سيؤدي هذا إلى تنزيل قوائم الرومات من مستودع romList الخاص بـ Forsaken على GitHub.';

  @override
  String get downloadRomDatabaseStats =>
      'الحجم: ~7 MB\nالمنصات: 138\nإجمالي الرومات: ~240,000';

  @override
  String get downloadWillOverwrite =>
      'ملاحظة: سيؤدي هذا إلى الكتابة فوق البيانات الموجودة.';

  @override
  String get clearRomDatabaseDescription =>
      'سيؤدي هذا إلى حذف جميع قوائم الرومات التي تم تنزيلها وإعادة تعيين قاعدة البيانات إلى حالتها الأولية.';

  @override
  String get gamelistsStatus => 'حالة قوائم الألعاب';

  @override
  String get gamelistsDownloaded => 'تم التنزيل';

  @override
  String get gamelistsNotDownloaded => 'غير موجود';

  @override
  String get aboutGamelists => 'حول قوائم الألعاب';

  @override
  String get aboutGamelistsDescription =>
      'تحتوي قوائم الألعاب على بيانات وصفية للألعاب (الأسماء والأوصاف والتقييمات) لكل منصة. يتم تنزيلها من مستودع gamelists الخاص بـ Forsaken على GitHub.';

  @override
  String get gamelistsSource => 'المصدر: github.com/ForsakenStation/gamelists';

  @override
  String get downloadGamelists => 'تنزيل قوائم الألعاب';

  @override
  String get downloadGamelistsDescription =>
      'سيؤدي هذا إلى تنزيل ملفات gamelist.xml من مستودع gamelists الخاص بـ Forsaken على GitHub.';

  @override
  String get downloadGamelistsWillOverwrite =>
      'ملاحظة: سيؤدي هذا إلى الكتابة فوق ملفات قوائم الألعاب الموجودة.';

  @override
  String get downloadingGamelists => 'جارٍ تنزيل قوائم الألعاب...';

  @override
  String get gamelistsDownloadedSuccess => 'تم تنزيل قوائم الألعاب بنجاح';

  @override
  String get failedDownloadGamelists => 'فشل تنزيل قوائم الألعاب';

  @override
  String get clearGamelists => 'مسح قوائم الألعاب';

  @override
  String get clearGamelistsDescription =>
      'سيؤدي هذا إلى حذف جميع ملفات قوائم الألعاب التي تم تنزيلها.';

  @override
  String get gamelistsCleared => 'تم مسح قوائم الألعاب';

  @override
  String get failedClearGamelists => 'فشل مسح قوائم الألعاب';

  @override
  String get rebuildMediaCache => 'إعادة بناء ذاكرة الوسائط المؤقتة';

  @override
  String get rebuildMediaCacheDescription =>
      'فحص مجلدات الوسائط وتخزين المسارات في قوائم الألعاب للتحميل الأسرع';

  @override
  String get rebuildMediaCacheConfirmTitle =>
      'إعادة بناء ذاكرة الوسائط المؤقتة؟';

  @override
  String get rebuildMediaCacheConfirmBody =>
      'سيؤدي هذا إلى فحص جميع مجلدات الوسائط وتحديث ملفات gamelist.xml بمسارات الوسائط. قد يستغرق ذلك بعض الوقت للمجموعات الكبيرة.';

  @override
  String get rebuildMediaCacheProgress =>
      'جارٍ إعادة بناء ذاكرة الوسائط المؤقتة...';

  @override
  String rebuildMediaCacheProcessingPlatform(
    String platform,
    String current,
    String total,
  ) {
    return 'معالجة $platform ($current/$total)';
  }

  @override
  String get rebuildMediaCacheComplete =>
      'تمت إعادة بناء ذاكرة الوسائط المؤقتة';

  @override
  String rebuildMediaCacheSummary(
    String platforms,
    String games,
    String updated,
    String paths,
  ) {
    return '$platforms منصات، $games ألعاب تم فحصها، $updated تم تحديثها، $paths مسارات وسائط مخزنة';
  }

  @override
  String get rebuildMediaCacheError =>
      'فشل في إعادة بناء ذاكرة الوسائط المؤقتة';

  @override
  String rebuildMediaCacheErrors(String count) {
    return 'حدثت $count أخطاء أثناء إعادة البناء';
  }

  @override
  String get description => 'الوصف';

  @override
  String get noDescriptionAvailable => 'لا يوجد وصف متاح لهذه الروم.';

  @override
  String get releaseDate => 'تاريخ الإصدار';

  @override
  String get players => 'اللاعبون';

  @override
  String get rating => 'التقييم';

  @override
  String get regions => 'المناطق';

  @override
  String folderRomCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count روم',
      one: '$count روم',
    );
    return '$_temp0';
  }

  @override
  String manualTitle(String name) {
    return '$name - الدليل';
  }

  @override
  String get playInBrowser => 'تشغيل في المتصفح';

  @override
  String downloadingPlatformBios(String platformName) {
    return 'جارٍ تنزيل BIOS لـ $platformName';
  }

  @override
  String get downloadingAllMissingBios => 'جارٍ تنزيل جميع ملفات BIOS المفقودة';

  @override
  String biosFileLabel(String filename) {
    return 'ملف: $filename';
  }

  @override
  String batchProgressLabel(String completed, String total) {
    return 'التقدم: $completed/$total ملفات';
  }

  @override
  String get fileDetails => 'تفاصيل الملف:';

  @override
  String get waiting => 'انتظار...';

  @override
  String get verifying => 'جارٍ التحقق...';

  @override
  String get failed => 'فشل';

  @override
  String get preparing => 'جارٍ التحضير...';

  @override
  String get downloadingFiles => 'جارٍ تنزيل الملفات...';

  @override
  String get someDownloadsFailed => 'فشلت بعض التنزيلات';

  @override
  String get downloadsCancelled => 'تم إلغاء التنزيلات';

  @override
  String get calculating => 'جارٍ الحساب...';

  @override
  String secondsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ثوانٍ',
      one: 'ثانية واحدة',
    );
    return '$_temp0';
  }

  @override
  String minutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دقائق',
      one: 'دقيقة واحدة',
    );
    return '$_temp0';
  }

  @override
  String hoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ساعات',
      one: 'ساعة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get downloadingAndLaunching => 'جارٍ التنزيل والتشغيل...';

  @override
  String get launching => 'جارٍ التشغيل...';

  @override
  String emulatorLabel(String name) {
    return 'المحاكي: $name';
  }

  @override
  String get generalInformation => 'معلومات عامة';

  @override
  String get manufacturer => 'الشركة المصنعة';

  @override
  String get releaseYear => 'سنة الإصدار';

  @override
  String get generation => 'الجيل';

  @override
  String get technicalSpecifications => 'المواصفات التقنية';

  @override
  String get resolution => 'الدقة';

  @override
  String get colors => 'الألوان';

  @override
  String get notNow => 'ليس الآن';

  @override
  String get saveRomPermanently => 'حفظ الروم بشكل دائم؟';

  @override
  String get keepRomOfflineQuestion =>
      'هل تريد الاحتفاظ بهذه الروم المحملة للعب بدون اتصال؟';

  @override
  String get deletedToSaveSpace =>
      'إذا لم يكن كذلك، سيتم حذفها لاحقاً لتوفير المساحة.';
}
