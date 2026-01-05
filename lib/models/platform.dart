import 'rom.dart';
import 'package:path/path.dart' as filePath;
import '../utils/platform_names.dart';

class Platform {
  final String name;
  final String path;
  final List<Rom> roms;
  Platform({required this.name, required this.path, this.roms = const []});

  String get displayName {
    return PlatformNames.getDisplayName(name);
  }

  String get shortName {
    return PlatformNames.getShortName(name);
  }

  String get code {
    return filePath.basename(path);
  }

  int get romCount => roms.length;

  @override
  String toString() {
    return 'Platform(name: $displayName, roms: ${roms.length})';
  }
}
