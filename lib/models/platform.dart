import 'rom.dart';

class Platform {
  final String name;
  final String path;
  final List<Rom> roms;

  Platform({required this.name, required this.path, this.roms = const []});

  String get displayName {
    return name[0].toUpperCase() + name.substring(1);
  }

  int get romCount => roms.length;

  @override
  String toString() {
    return 'Platform(name: $displayName, roms: ${roms.length})';
  }
}
