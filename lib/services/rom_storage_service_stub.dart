// Stub for web platform - RomStorageService uses dart:io
class RomStorageService {
  static RomStorageService? _instance;

  RomStorageService._();

  static RomStorageService get instance {
    _instance ??= RomStorageService._();
    return _instance!;
  }

  Future<void> initializeStorageDirectories() async {
    // No-op on web
  }

  void setCustomTempPath(String? path) {}
  void setCustomForeverPath(String? path) {}
  String? getCustomTempPath() => null;
  String? getCustomForeverPath() => null;
}
