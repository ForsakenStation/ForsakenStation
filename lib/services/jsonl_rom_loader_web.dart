// Web stub for JsonlRomLoader platform-specific functions
// These are not used on web - the main class handles web directly
import '../models/rom.dart';

Future<List<Rom>> loadRomsFromJsonlIO(String jsonlPath, String platform) async {
  // Not used on web
  return [];
}

Future<Map<String, int>> getPlatformRomCountsIO(String jsonlDirectory) async {
  // Not used on web
  return {};
}

Future<int> countRomsInJsonlIO(String jsonlPath) async {
  // Not used on web
  return 0;
}
