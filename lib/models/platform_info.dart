/// Model representing detailed information about a gaming platform/console
///
/// Contains historical and technical information including:
/// - Name and manufacturer
/// - Release year and generation
/// - Hardware specifications
/// - Description and notable games
class PlatformInfo {
  final String fullName;
  final String manufacturer;
  final int releaseYear;
  final int? generation;
  final String description;
  final String cpu;
  final String resolution;
  final String colors;

  PlatformInfo({
    required this.fullName,
    required this.manufacturer,
    required this.releaseYear,
    this.generation,
    required this.description,
    required this.cpu,
    required this.resolution,
    required this.colors,
  });

  factory PlatformInfo.fromJson(Map<String, dynamic> json) {
    return PlatformInfo(
      fullName: json['fullName'] as String,
      manufacturer: json['manufacturer'] as String,
      releaseYear: json['releaseYear'] as int,
      generation: json['generation'] as int?,
      description: json['description'] as String,
      cpu: json['cpu'] as String,
      resolution: json['resolution'] as String,
      colors: json['colors'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'manufacturer': manufacturer,
      'releaseYear': releaseYear,
      'generation': generation,
      'description': description,
      'cpu': cpu,
      'resolution': resolution,
      'colors': colors,
    };
  }

  /// Returns a formatted generation string for display
  String get generationString {
    if (generation == null) {
      return 'Computer / Arcade';
    }
    if (generation == 0) {
      return 'Multiple Generations';
    }

    // Handle special cases for ordinal numbers
    final suffix = _getOrdinalSuffix(generation!);
    return '$generation$suffix Generation';
  }

  String _getOrdinalSuffix(int number) {
    if (number >= 11 && number <= 13) {
      return 'th';
    }
    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
