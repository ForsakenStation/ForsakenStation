// Web stub for RomService platform-specific functions
// These are not used on web - the main class handles web via JSONL HTTP
import '../models/emulator_platform.dart';
import '../models/rom.dart';
import '../models/rom_item.dart';

Future<List<EmulatorPlatform>> loadPlatformsFromFiles(
  String romsBasePath,
) async {
  // Not available on web
  return [];
}

Future<List<Rom>> loadRomsForPlatform(
  String platformPath,
  String platformName,
) async {
  // Not available on web
  return [];
}

Future<List<RomItem>> loadItemsInDirectory(
  String directoryPath,
  String platformName,
) async {
  // Not available on web
  return [];
}
