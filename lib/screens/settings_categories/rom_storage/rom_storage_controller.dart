import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../../services/rom_storage_service.dart';
import '../../../services/debug_service.dart';

class RomStorageController extends ChangeNotifier {
  final RomStorageService _storageService = RomStorageService.instance;
  final _debug = DebugService.instance;

  Map<String, dynamic> _storageStats = {};
  Map<String, List<File>> _tempRoms = {};
  Map<String, List<File>> _foreverRoms = {};
  bool _isLoading = true;

  Map<String, dynamic> get storageStats => _storageStats;
  Map<String, List<File>> get tempRoms => _tempRoms;
  Map<String, List<File>> get foreverRoms => _foreverRoms;
  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _storageStats = await _storageService.getStorageStats();

      final tempDir = await _storageService.getTempStorageDirectory();
      _tempRoms = await _listRomsByPlatform(tempDir);

      final foreverDir = await _storageService.getForeverStorageDirectory();
      _foreverRoms = await _listRomsByPlatform(foreverDir);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _debug.error(
        'Error loading storage data: $e',
        tag: 'RomStorageController',
      );
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, List<File>>> _listRomsByPlatform(Directory baseDir) async {
    final Map<String, List<File>> romsByPlatform = {};
    if (!await baseDir.exists()) return romsByPlatform;

    await for (var entity in baseDir.list()) {
      if (entity is Directory) {
        final platformName = entity.path.split('/').last;
        final List<File> roms = [];

        await for (var romEntity in entity.list()) {
          if (romEntity is File) roms.add(romEntity);
        }

        if (roms.isNotEmpty) romsByPlatform[platformName] = roms;
      }
    }
    return romsByPlatform;
  }

  Future<bool> deleteRom(
    String platform,
    String fileName,
    bool isForever,
  ) async {
    final success = isForever
        ? await _storageService.deleteFromForeverStorage(platform, fileName)
        : await _storageService.deleteFromTempStorage(platform, fileName);

    if (success) await loadData();
    return success;
  }

  Future<String?> moveToForever(String platform, String fileName) async {
    final newPath = await _storageService.moveToForeverStorage(
      platform,
      fileName,
    );
    if (newPath != null) await loadData();
    return newPath;
  }

  Future<void> clearAllTempRoms() async {
    await _storageService.cleanupAllTempRoms();
    await loadData();
  }
}
