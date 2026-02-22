// Stub for web platform - RomService uses dart:io which doesn't work on web
import '../models/emulator_platform.dart';
import '../models/rom.dart';

class RomService {
  final String romsBasePath;
  final String? jsonlBasePath;

  RomService({required this.romsBasePath, this.jsonlBasePath});

  Future<List<EmulatorPlatform>> loadEmulatorPlatforms() async {
    // Web stub - returns empty list
    // Web version should use WebRomService instead
    return [];
  }

  Future<List<Rom>> loadRomsForEmulatorPlatform(String platformName) async {
    return [];
  }
}
