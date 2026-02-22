import 'emulator_platform.dart';
import 'collection.dart';

/// Union type to represent either a Platform or a Collection in the platforms list
class PlatformOrCollection {
  final EmulatorPlatform? platform;
  final Collection? collection;

  PlatformOrCollection.platform(this.platform) : collection = null;
  PlatformOrCollection.collection(this.collection) : platform = null;

  bool get isPlatform => platform != null;
  bool get isCollection => collection != null;

  String get name {
    if (isPlatform) return platform!.name;
    return collection!.name;
  }

  String get displayName {
    if (isPlatform) return platform!.displayName;
    return collection!.displayName;
  }

  int get romCount {
    if (isPlatform) return platform!.romCount;
    return collection!.romCount;
  }

  @override
  String toString() {
    if (isPlatform) return 'PlatformOrCollection(platform: ${platform!.name})';
    return 'PlatformOrCollection(collection: ${collection!.name})';
  }
}
