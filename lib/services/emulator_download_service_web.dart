import '../models/emulator_download_info.dart';
import 'debug_service.dart';

/// Web stub for EmulatorDownloadService
class EmulatorDownloadService {
  static EmulatorDownloadService? _instance;
  final _debug = DebugService.instance;

  EmulatorDownloadService._();

  static EmulatorDownloadService get instance {
    _instance ??= EmulatorDownloadService._();
    return _instance!;
  }

  /// Always fails on web since we use EmulatorJS
  Future<String?> downloadEmulator(
    EmulatorDownloadInfo emulator, {
    Function(double progress)? onProgress,
    Function(String status)? onStatus,
  }) async {
    _debug.warning('Cannot download native emulator on web platform');
    onStatus?.call('Error: Emulators cannot be installed on web platform');
    return null;
  }

  /// Always fails on web
  Future<Map<String, String?>> downloadMultipleEmulators(
    List<EmulatorDownloadInfo> emulators, {
    Function(String emulatorName, double progress)? onProgress,
    Function(String emulatorName, String status)? onStatus,
  }) async {
    _debug.warning('Cannot download native emulators on web platform');
    return {};
  }

  /// Web emulators are always "installed" (they use EmulatorJS)
  Future<bool> isEmulatorInstalled(EmulatorDownloadInfo emulator) async {
    // Return true for libretro cores that match emulatorjs?
    // Actually the web doesn't use the native emulator downloads anyway.
    return false;
  }

  /// Cannot delete emulators on web
  Future<bool> deleteEmulator(EmulatorDownloadInfo emulator) async {
    return false;
  }

  /// No downloads on web
  int getTotalDownloadSize(List<EmulatorDownloadInfo> emulators) {
    return 0;
  }
}
