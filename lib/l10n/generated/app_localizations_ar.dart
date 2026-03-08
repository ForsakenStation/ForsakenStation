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
  String get biosRequired => 'مطلوب';

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
  String get launchFile => 'ملف التشغيل';

  @override
  String get launchFileSubtitle =>
      'الملف المراد البحث عنه داخل ملف ZIP المستخرج (مثال: eboot.bin)';

  @override
  String get launchFileHint => 'مثال: eboot.bin';

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
  String get biosMissing => 'مفقود';

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
  String get gamepadConnected => 'وحدة التحكم متصلة';

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

  @override
  String get view => 'عرض';

  @override
  String get media => 'وسائط';

  @override
  String get navigate => 'تنقل';

  @override
  String get info => 'معلومات';

  @override
  String get toggleFilter => 'تبديل الفلتر';

  @override
  String get changeTheme => 'تغيير السمة';

  @override
  String get keyboard => 'لوحة المفاتيح';

  @override
  String get gamepad => 'عصا التحكم';

  @override
  String get hideKeyboard => 'إخفاء لوحة المفاتيح';

  @override
  String get gameManual => 'دليل اللعبة';

  @override
  String get pdfDocument => 'مستند PDF';

  @override
  String get manual => 'الدليل';

  @override
  String get video => 'فيديو';

  @override
  String get zoomOut => 'تصغير';

  @override
  String get zoomIn => 'تكبير';

  @override
  String pageCounter(String current, String total) {
    return 'صفحة $current / $total';
  }

  @override
  String get zoom => 'تكبير/تصغير';

  @override
  String get firstLast => 'الأول/الأخير';

  @override
  String get scroll => 'تمرير';

  @override
  String get loadingVideo => 'جارٍ تحميل الفيديو...';

  @override
  String get playPause => 'تشغيل/إيقاف';

  @override
  String get useArrowKeysToNavigate => 'استخدم مفاتيح الأسهم أو اسحب للتنقل';

  @override
  String get searchRomsHint => 'البحث عن رومات...';

  @override
  String get cancelSearch => 'إلغاء البحث';

  @override
  String get virtualKeyboard => 'لوحة مفاتيح افتراضية';

  @override
  String get noRomsAvailable => 'لا توجد رومات متاحة';

  @override
  String get noRomsForPlatformMessage =>
      'لم يتم العثور على ملفات روم لهذه المنصة. يجب وضع ملفات الروم كملفات .txt تحتوي على روابط التنزيل في مجلد المنصة.';

  @override
  String get noMatchingRoms => 'لا توجد رومات مطابقة';

  @override
  String get tryDifferentSearch => 'جرب مصطلح بحث مختلف';

  @override
  String get saveToPermanentStorage => 'حفظ في التخزين الدائم';

  @override
  String get temporary => 'مؤقت';

  @override
  String get permanent => 'دائم';

  @override
  String get tempPathLabel => 'مؤقت';

  @override
  String get foreverPathLabel => 'دائم';

  @override
  String get storageOverview => 'نظرة عامة على التخزين';

  @override
  String get clearTemporaryStorage => 'مسح التخزين المؤقت';

  @override
  String filesCount(String count) {
    return '$count ملفات';
  }

  @override
  String pathDisplay(String label, String path) {
    return 'مسار $label: $path';
  }

  @override
  String get unknown => 'غير معروف';

  @override
  String get tagVerifiedGoodDump => 'نسخة موثقة وصحيحة - تعمل بشكل مؤكد';

  @override
  String get tagBadDump => 'نسخة سيئة - قد لا تعمل بشكل صحيح';

  @override
  String get tagAlternateVersion => 'إصدار بديل';

  @override
  String get tagOverdump => 'نسخة زائدة - تحتوي على بيانات إضافية';

  @override
  String get tagModifiedHacked => 'روم معدل/مخترق';

  @override
  String get tagFanTranslation => 'ترجمة معجبين';

  @override
  String get tagPirateBootleg => 'إصدار مقرصن/مزيف';

  @override
  String get tagFixedVersion => 'إصدار مصحح';

  @override
  String get tagCheatTrainer => 'يتضمن مدرب غش';

  @override
  String tagVersion(String text) {
    return 'الإصدار: $text';
  }

  @override
  String tagSpecialRelease(String text) {
    return 'إصدار خاص: $text';
  }

  @override
  String tagMediaInfo(String text) {
    return 'معلومات الوسائط: $text';
  }

  @override
  String noEmulatorConfigured(
    String displayName,
    String platform,
    String configPath,
  ) {
    return 'لم يتم إعداد محاكي لـ $displayName.\n\nالرجاء إضافة إعداد لـ \"$platform\" في:\n$configPath';
  }

  @override
  String get noEmulatorCommandAvailable => 'لا يوجد أمر محاكي متاح';

  @override
  String platformNotSupportedWeb(String platform, String supportedPlatforms) {
    return 'المنصة \"$platform\" غير مدعومة بعد في متصفح الويب.\n\nالمنصات المدعومة: $supportedPlatforms';
  }

  @override
  String failedToLaunchWebEmulator(String error) {
    return 'فشل في تشغيل محاكي الويب: $error';
  }

  @override
  String failedToLaunchRom(String error) {
    return 'فشل في تشغيل ROM.\n\nتحقق من:\n• أن المحاكي مثبت بشكل صحيح\n• أن ملف ROM صالح\n• أن الإعدادات صحيحة\n\nالخطأ: $error';
  }

  @override
  String errorLaunchingRom(String error) {
    return 'خطأ في تشغيل ROM: $error';
  }

  @override
  String noInfoAvailable(String platformName) {
    return 'لا تتوفر معلومات عن $platformName';
  }

  @override
  String get platformInfoTooltip => 'معلومات المنصة (I)';

  @override
  String get navigationHint => 'استخدم مفاتيح الأسهم أو اسحب للتنقل';

  @override
  String get noGamesFound => 'لم يتم العثور على ألعاب';

  @override
  String get noGamesFoundForSearch => 'لم يتم العثور على ألعاب للبحث';

  @override
  String get tryDifferentSearchOrClear => 'جرّب مصطلح بحث مختلف أو امسح الفلتر';

  @override
  String get checkStorageOrDownload =>
      'تحقق من إعدادات التخزين أو حمّل بعض الرومات';

  @override
  String get searchGamesHint => 'البحث عن ألعاب...';

  @override
  String get settingsHeaderTitle => 'تكوين محاكي Forsaken';

  @override
  String get settingsHeaderSubtitle =>
      'تكوين المحاكيات والمسارات وتنزيل المحتوى';

  @override
  String get emulatorManagementDesc => 'إضافة وتحرير وتكوين أوامر المحاكيات';

  @override
  String get systemPaths => 'مسارات النظام';

  @override
  String get systemPathsDesc => 'تكوين مسارات ROMs والوسائط والمحاكيات';

  @override
  String get romDatabaseDesc => 'تنزيل وإدارة قوائم ROMs من GitHub';

  @override
  String get romStorageDesc =>
      'إدارة ROMs المحملة والتخزين وتنظيف الملفات المؤقتة';

  @override
  String get downloadManagerDesc =>
      'تنزيل المحاكيات وقوائم ROMs وبيانات الألعاب';

  @override
  String get systemRequirementsDesc => 'التحقق من الأدوات والتبعيات المطلوبة';

  @override
  String get gamepadTestDebug => 'اختبار وتصحيح وحدة التحكم';

  @override
  String get gamepadTestDebugDesc =>
      'اختبار أزرار وحدة التحكم والمحاور وحل المشكلات';

  @override
  String get biosFirmwareHelpDesc =>
      'التحقق من ملفات BIOS ومتطلبات البرنامج الثابت';

  @override
  String get webSettingsDesc => 'وكيل CORS وتكوين منصة الويب';

  @override
  String get setupWizardDesc => 'إعادة تشغيل معالج الإعداد الأولي';

  @override
  String get languageDesc => 'اختيار لغة التطبيق';

  @override
  String get aboutDebug => 'حول والتصحيح';

  @override
  String get aboutDebugDesc => 'معلومات التطبيق وإعدادات التصحيح';

  @override
  String get legalDisclaimer => 'إخلاء المسؤولية القانونية';

  @override
  String get romDatabaseCredits =>
      'قوائم ROMs مصدرها الأصلي مستودع AndroidRoms بواسطة Arley4d:';

  @override
  String get romDatabaseThanks =>
      'شكر خاص لمشروع AndroidRoms للحفاظ على قواعد بيانات شاملة للـ ROMs لأغراض الحفظ.';

  @override
  String get biosFilesSection => 'ملفات BIOS';

  @override
  String get biosFilesCredits =>
      'ملفات BIOS مصدرها مستودع retroarch_system بواسطة Abdess:';

  @override
  String get biosFilesThanks =>
      'يحتوي هذا المستودع على ملفات النظام و BIOS المطلوبة من منصات المحاكاة المختلفة. شكر خاص للقائمين على الصيانة لحفظ هذه الملفات الأساسية.';

  @override
  String get amigaCopyProtection =>
      'دعم حماية النسخ لـ Amiga مقدم من مكتبة capsimg:';

  @override
  String get amigaCopyProtectionThanks =>
      'شكر خاص لـ rsn8887 لصيانة مكتبة capsimg التي تتيح دعم صور الأقراص IPF (المحمية ضد النسخ) لمحاكاة Amiga.';

  @override
  String get additionalBiosFiles =>
      'ملفات BIOS إضافية مقدمة من مشروع RetroPieBios:';

  @override
  String get additionalBiosThanks =>
      'شكراً لـ PIBSAS/RetroPieBios لتوفير متغيرات BIOS إضافية وملفات إقليمية تعزز التوافق عبر الأنظمة والمناطق المختلفة.';

  @override
  String get enabled => 'مفعّل';

  @override
  String get disabled => 'معطّل';

  @override
  String get disclaimerRequired => 'يجب قبول إخلاء المسؤولية للمتابعة.';

  @override
  String get emulatorsPathRequired => 'مسار دليل المحاكيات مطلوب.';

  @override
  String get emulatorConfigPathRequired => 'مسار ملف تكوين المحاكي مطلوب.';

  @override
  String get mediaPathRequired => 'مسار الوسائط مطلوب.';

  @override
  String get tempRomPathRequired => 'مسار تخزين ROM المؤقت مطلوب.';

  @override
  String get permanentRomPathRequired => 'مسار تخزين ROM الدائم مطلوب.';

  @override
  String wizardStepCounter(int current, int total) {
    return 'الخطوة $current / $total';
  }

  @override
  String get emulatorConfiguration => 'تكوين المحاكي';

  @override
  String get emulatorConfigStepDesc =>
      'حدد المسارات التي تم تثبيت المحاكيات فيها. يمكنك تغييرها لاحقاً في الإعدادات > مسارات النظام.';

  @override
  String get emulatorsDirectory => 'دليل المحاكيات';

  @override
  String get pathToEmulatorBinaries => 'المسار إلى ملفات المحاكي التنفيذية';

  @override
  String get emulatorConfigFile => 'ملف تكوين المحاكي';

  @override
  String get pathToEmulatorConfig => 'المسار إلى JSON تكوين المحاكي';

  @override
  String get storagePaths => 'مسارات التخزين';

  @override
  String get storagePathsStepDesc =>
      'حدد أين يتم تخزين أصول الوسائط وملفات ROM. يمكنك تغييرها لاحقاً في الإعدادات > مسارات النظام.';

  @override
  String get wizardMediaPathHint => 'أغلفة الألعاب ولقطات الشاشة والفيديوهات';

  @override
  String get temporaryRomStorage => 'تخزين ROM المؤقت';

  @override
  String get temporaryRomStorageHint => 'ROMs محملة لجلسات لعب فردية';

  @override
  String get permanentRomStorage => 'تخزين ROM الدائم';

  @override
  String get permanentRomStorageHint => 'ROMs محفوظة للعب بدون اتصال';

  @override
  String get allSet => 'كل شيء جاهز!';

  @override
  String get wizardEmulatorReady => 'محاكي Forsaken جاهز للاستخدام.';

  @override
  String get changeSettingsLater =>
      'يمكنك تغيير أي من هذه الإعدادات لاحقاً من شاشة الإعدادات.';

  @override
  String get configurationSummary => 'ملخص التكوين';

  @override
  String get summaryEmulators => 'المحاكيات';

  @override
  String get summaryMedia => 'الوسائط';

  @override
  String get summaryTempRoms => 'ROMs مؤقتة';

  @override
  String get summarySavedRoms => 'ROMs محفوظة';

  @override
  String get defaultValue => '(افتراضي)';

  @override
  String pdfPageIndicator(int current, int total) {
    return 'الصفحة $current من $total';
  }

  @override
  String get pdfZoomOut => 'تصغير (-)';

  @override
  String get pdfZoomIn => 'تكبير (+)';

  @override
  String get pdfResetZoom => 'إعادة تعيين التكبير (0)';

  @override
  String get pdfFirstPage => 'الصفحة الأولى (Home)';

  @override
  String get pdfPreviousPage => 'الصفحة السابقة (←/PgUp)';

  @override
  String get pdfNextPage => 'الصفحة التالية (→/PgDn)';

  @override
  String get pdfLastPage => 'الصفحة الأخيرة (End)';

  @override
  String get pdfFileNotFound => 'ملف PDF غير موجود';

  @override
  String confirmDeleteEmulator(String system) {
    return 'هل أنت متأكد من حذف تكوين المحاكي لـ $system؟';
  }

  @override
  String commandsConfigured(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أوامر مكوّنة',
      one: 'أمر واحد مكوّن',
    );
    return '$_temp0';
  }

  @override
  String get noCommand => 'لا يوجد أمر';

  @override
  String get reloadConfigTooltip => 'إعادة تحميل التكوين (R)';

  @override
  String get configurationInfo => 'معلومات التكوين';

  @override
  String get configLocation => 'موقع التكوين:';

  @override
  String get hasLocalOverridesYes => 'تجاوزات محلية: نعم';

  @override
  String get hasLocalOverridesNo => 'تجاوزات محلية: لا';

  @override
  String get changesSavedToDevice => 'يتم حفظ تغييراتك في تخزين الجهاز.';

  @override
  String get usingBundledConfig =>
      'استخدام التكوين المرفق. حرّر لإنشاء تجاوزات محلية.';

  @override
  String get noEmulatorsConfigured => 'لا توجد محاكيات مكوّنة';

  @override
  String get addFirstEmulator => 'أضف أول محاكي للبدء';

  @override
  String get edit => 'تحرير';

  @override
  String get editEmulator => 'تحرير المحاكي';

  @override
  String get system => 'النظام';

  @override
  String get systemHint => 'e.g., nes, snes, ps1';

  @override
  String get commands => 'الأوامر';

  @override
  String commandNumber(int number) {
    return 'الأمر $number';
  }

  @override
  String get commandHint => 'e.g., ../retroarch.AppImage -f -L core.so';

  @override
  String get remove => 'إزالة';

  @override
  String get options => 'الخيارات';

  @override
  String get biosDownloading => 'جارٍ التنزيل...';

  @override
  String downloadRequiredAndExtras(int requiredCount, int optionalCount) {
    return 'تنزيل $requiredCount مطلوبة + $optionalCount إضافية';
  }

  @override
  String downloadRequiredFiles(int requiredCount) {
    return 'تنزيل $requiredCount ملفات مطلوبة';
  }

  @override
  String downloadOptionalExtras(int optionalCount) {
    return 'تنزيل $optionalCount إضافية اختيارية';
  }

  @override
  String get downloadFiles => 'تنزيل الملفات';

  @override
  String batchDownloadConfirmation(int totalFiles, int platformCount) {
    return 'سيتم تنزيل $totalFiles ملف BIOS لـ $platformCount منصات:';
  }

  @override
  String get downloadSourceNote =>
      'سيتم تنزيل الملفات من مستودع retroarch_system.';

  @override
  String get biosOptional => 'اختياري';

  @override
  String biosFilesFound(int foundCount, int totalCount) {
    return '$foundCount/$totalCount ملفات موجودة';
  }

  @override
  String optionalExtrasAvailable(int count) {
    return '+$count إضافية اختيارية متاحة';
  }

  @override
  String get biosLocations => 'المواقع:';

  @override
  String get availableForDownload => 'متاح للتنزيل من مصادر متعددة';

  @override
  String get summary => 'ملخص';

  @override
  String get biosComplete => 'مكتمل';

  @override
  String get biosPartial => 'جزئي';

  @override
  String get biosFiles => 'الملفات';

  @override
  String get biosDownloadable => 'قابل للتنزيل';

  @override
  String get refreshF5Tooltip => 'تحديث (F5)';

  @override
  String get allBiosFilesFound => 'تم العثور على جميع ملفات BIOS!';

  @override
  String get noBiosRequirements => 'لم يتم العثور على متطلبات BIOS';

  @override
  String platformCount(int count) {
    return '$count منصات';
  }

  @override
  String failedToLoadBiosStatus(String error) {
    return 'فشل تحميل حالة BIOS: $error';
  }

  @override
  String get refreshStatus => 'تحديث الحالة';

  @override
  String platformsCompleteCount(int complete, int total) {
    return '$complete/$total منصات مكتملة';
  }

  @override
  String get platformStatusHeader => 'حالة المنصات';

  @override
  String filesVerifiedStatus(
    int presentFiles,
    int totalFiles,
    int verifiedFiles,
  ) {
    return '$presentFiles/$totalFiles ملفات ($verifiedFiles تم التحقق)';
  }

  @override
  String get biosCollectionOverview => 'نظرة عامة على مجموعة BIOS';

  @override
  String get biosVerified => 'تم التحقق';

  @override
  String downloadComingSoon(String platformName) {
    return 'وظيفة التنزيل لـ $platformName - قريباً!';
  }

  @override
  String get noGamepadConnected => 'لا توجد وحدة تحكم متصلة';

  @override
  String get connectGamepadPrompt => 'قم بتوصيل وحدة تحكم واضغط أي زر';

  @override
  String get pressButtonToTest => 'اضغط أي زر للاختبار (الإجراءات معطلة)';

  @override
  String get buttonFunctionTests => 'اختبارات وظائف الأزرار';

  @override
  String get gamepadASelect => 'A (تحديد)';

  @override
  String get gamepadBBack => 'B (رجوع)';

  @override
  String get gamepadXSearch => 'X (بحث)';

  @override
  String get gamepadYHelp => 'Y (مساعدة)';

  @override
  String get gamepadLBPageDown => 'LB (صفحة لأسفل)';

  @override
  String get gamepadRBPageUp => 'RB (صفحة لأعلى)';

  @override
  String get gamepadStartMenu => 'Start (القائمة)';

  @override
  String get gamepadSelectSettings => 'Select (الإعدادات)';

  @override
  String get gamepadLSClick => 'LS نقر';

  @override
  String get gamepadRSView => 'RS نقر (عرض)';

  @override
  String get gamepadLTTrigger => 'LT (زناد)';

  @override
  String get gamepadRTTrigger => 'RT (زناد)';

  @override
  String get rawButtonStates => 'حالات الأزرار الخام';

  @override
  String get noButtonsPressed => 'لا توجد أزرار مضغوطة';

  @override
  String get axisValues => 'قيم المحاور';

  @override
  String get noAxisMovement => 'لا توجد حركة محاور';

  @override
  String get dpadLeftStick => 'D-Pad + العصا اليسرى';

  @override
  String get webSettingsDescription => 'تكوين الإعدادات الخاصة بمنصة الويب';

  @override
  String get corsProxyWhyNeeded => 'لماذا يُحتاج وكيل CORS؟';

  @override
  String get corsProxyExplanation =>
      'تحظر المتصفحات تنزيل ROM من الخوادم الخارجية بسبب قيود أمان CORS. يقوم وكيل CORS بإعادة توجيه الطلب من خادم تتحكم فيه، مضيفاً الرؤوس اللازمة.\n\nيتضمن Forsaken عامل Cloudflare يمكنك نشره مجاناً (100 ألف طلب/يوم). راجع مجلد tools/cors-proxy-worker/ لتعليمات الإعداد.';

  @override
  String get corsProxyUrl => 'عنوان URL لوكيل CORS';

  @override
  String get corsProxyHelperText =>
      'اتركه فارغاً لتعطيل وكيل CORS (ستفشل ROM من الخوادم بدون CORS)';

  @override
  String get testingProxy => 'جارٍ اختبار الوكيل...';

  @override
  String get testProxyConnection => 'اختبار اتصال الوكيل';

  @override
  String get noProxyUrlConfigured => 'لم يتم تكوين عنوان URL للوكيل';

  @override
  String proxyWorking(int statusCode) {
    return 'الوكيل يعمل (HTTP $statusCode)';
  }

  @override
  String proxyReturnedHttp(int statusCode) {
    return 'الوكيل أرجع HTTP $statusCode';
  }

  @override
  String get connectionTimedOut => 'انتهت مهلة الاتصال';

  @override
  String get corsProxySettingsSaved =>
      'تم حفظ إعدادات وكيل CORS. يسري مفعولها فوراً لعمليات تشغيل ROM الجديدة.';

  @override
  String get quickDeploy => 'نشر سريع';

  @override
  String get corsProxyDeploySteps =>
      '1. سجّل في dash.cloudflare.com (مجاني)\n2. ثبّت Wrangler: npm install -g wrangler\n3. تسجيل الدخول: wrangler login\n4. cd tools/cors-proxy-worker\n5. npx wrangler deploy\n6. الصق عنوان URL للعامل أعلاه';

  @override
  String get permanentStorage => 'التخزين الدائم';

  @override
  String get temporaryStorage => 'التخزين المؤقت';

  @override
  String get noDownloadedRoms => 'لا توجد ألعاب ROM محمّلة';

  @override
  String get biosErrorNetworkMessage => 'فشل الاتصال بالشبكة';

  @override
  String get biosErrorNetworkSuggestions =>
      'تحقق من اتصالك بالإنترنت\nحاول مرة أخرى بعد لحظات\nتحقق من إعدادات DNS\nجرّب استخدام VPN إذا كان الوصول مقيّداً';

  @override
  String get biosErrorFileNotFoundMessage => 'الملف غير موجود على الخادم';

  @override
  String get biosErrorFileNotFoundSuggestions =>
      'ربما تم نقل ملف BIOS أو إعادة تسميته\nجرّب التنزيل من مصدر بديل\nتحقق مما إذا كان الملف موجوداً في فرع/مستودع مختلف\nأبلغ عن هذه المشكلة إذا استمرت';

  @override
  String get biosErrorAccessDeniedMessage => 'تم رفض الوصول من قبل الخادم';

  @override
  String get biosErrorAccessDeniedSuggestions =>
      'قد يكون الخادم يحظر التنزيلات\nحاول مرة أخرى لاحقاً - قد يكون الخادم مقيّداً مؤقتاً\nاستخدم VPN إذا كان الوصول مقيّداً حسب المنطقة\nتحقق مما إذا كانت المصادقة مطلوبة';

  @override
  String get biosErrorRateLimitedMessage => 'تم تجاوز حد الطلبات';

  @override
  String get biosErrorRateLimitedSuggestions =>
      'انتظر بضع دقائق قبل المحاولة مرة أخرى\nقلّل عدد التنزيلات المتزامنة\nالخادم يحمي نفسه من الطلبات المفرطة';

  @override
  String get biosErrorChecksumMessage => 'فشل التحقق من سلامة الملف';

  @override
  String get biosErrorChecksumSuggestions =>
      'قد يكون الملف تالفاً أثناء التنزيل\nجرّب التنزيل مرة أخرى\nتحقق مما إذا تم تحديث الملف على الخادم\nتحقق من استقرار اتصالك بالإنترنت';

  @override
  String get biosErrorSizeMismatchMessage => 'حجم الملف غير متوقع';

  @override
  String get biosErrorSizeMismatchSuggestions =>
      'قد يكون الملف بإصدار مختلف عن المتوقع\nقد يكون التنزيل غير مكتمل\nجرّب التنزيل مرة أخرى\nتحقق من المساحة المتاحة على القرص';

  @override
  String get biosErrorStorageMessage => 'خطأ في التخزين';

  @override
  String get biosErrorStorageSuggestions =>
      'قم بتحرير مساحة على القرص\nتحقق من أذونات الملفات\nتأكد من أن مجلد الوجهة قابل للكتابة\nجرّب التنزيل إلى موقع مختلف';

  @override
  String get biosErrorTimeoutMessage => 'انتهت مهلة التنزيل';

  @override
  String get biosErrorTimeoutSuggestions =>
      'قد يكون اتصال الإنترنت بطيئاً\nقد يكون الخادم محملاً بشكل زائد\nحاول مرة أخرى مع اتصال مستقر\nتحقق مما إذا كان جدار الحماية يحظر الاتصال';

  @override
  String get biosErrorArchiveMessage => 'فشل استخراج الأرشيف';

  @override
  String get biosErrorArchiveSuggestions =>
      'قد يكون الأرشيف المُنزّل تالفاً\nجرّب تنزيل الملف مرة أخرى\nتحقق من توفر أداة الاستخراج الصحيحة\nتحقق من أن الملف بتنسيق أرشيف صالح';

  @override
  String get biosErrorUnknownMessage => 'فشل التنزيل';

  @override
  String get biosErrorUnknownSuggestions =>
      'جرّب التنزيل مرة أخرى\nتحقق من اتصالك بالإنترنت\nتحقق من أن الملف لا يزال متاحاً\nتواصل مع الدعم إذا استمرت المشكلة';

  @override
  String get wizardDownloadEmulators => 'تنزيل المحاكيات';

  @override
  String get wizardDownloadEmulatorsDesc =>
      'تنزيل ملفات المحاكيات المُعدّة مسبقاً لمنصتك. يمكنك تنزيل الكل أو الاختيار حسب الفئة.';

  @override
  String get wizardDownloadRomLists => 'تنزيل قوائم الرومات';

  @override
  String get wizardDownloadRomListsDesc =>
      'تنزيل ملفات قاعدة بيانات الرومات من GitHub. تحتوي على بيانات وصفية لتنظيم مكتبة ألعابك.';

  @override
  String get wizardDownloadGamelists => 'تنزيل قوائم الألعاب';

  @override
  String get wizardDownloadGamelistsDesc =>
      'تنزيل ملفات gamelist.xml من GitHub. تحتوي على أسماء الألعاب والأوصاف والتقييمات وبيانات وصفية أخرى.';

  @override
  String get wizardSkipStep => 'تخطي';

  @override
  String get wizardDownloadComplete => 'اكتمل التنزيل!';

  @override
  String wizardDownloadFailed(String error) {
    return 'فشل التنزيل: $error';
  }

  @override
  String get wizardAlreadyDownloaded => 'تم التنزيل مسبقاً';

  @override
  String get wizardSelectCategory => 'اختر فئة للتنزيل، أو نزّل الكل:';

  @override
  String get wizardDownloading => 'جارٍ التنزيل...';

  @override
  String get wizardDownloadOptional =>
      'هذه الخطوة اختيارية. يمكنك التنزيل لاحقاً من الإعدادات.';

  @override
  String get archiveOrgSettings => 'حساب Archive.org';

  @override
  String get archiveOrgSettingsDesc =>
      'تكوين بيانات اعتماد Archive.org لتنزيل الرومات';

  @override
  String get archiveOrgSettingsDescription =>
      'بعض الرومات مستضافة على Archive.org وتتطلب مصادقة للتنزيل. قم بتكوين مفاتيح API من نوع S3 هنا.';

  @override
  String get archiveOrgWhyNeeded => 'لماذا بيانات الاعتماد مطلوبة؟';

  @override
  String get archiveOrgExplanation =>
      'بعض الملفات على Archive.org تتطلب حسابًا مسجل الدخول للتنزيل. يستخدم Forsaken مفاتيح API بنمط S3 حتى لا يتم تخزين كلمة المرور الخاصة بك أبدًا.\n\nقم بإنشاء مفاتيحك على:\nhttps://archive.org/account/s3.php';

  @override
  String get archiveOrgAccessKey => 'مفتاح الوصول';

  @override
  String get archiveOrgSecretKey => 'المفتاح السري';

  @override
  String get archiveOrgAccessKeyHint => 'مفتاح الوصول بنمط S3';

  @override
  String get archiveOrgSecretKeyHint => 'المفتاح السري بنمط S3';

  @override
  String get archiveOrgSettingsSaved => 'تم حفظ بيانات اعتماد Archive.org.';

  @override
  String get archiveOrgAuthRequired => 'المصادقة مطلوبة';

  @override
  String get archiveOrgAuthRequiredMessage =>
      'يتطلب هذا الملف حساب Archive.org للتنزيل.\n\nيرجى تكوين مفاتيح API من نوع S3 لـ Archive.org في الإعدادات للمتابعة.';

  @override
  String get goToSettings => 'الذهاب إلى الإعدادات';
}
