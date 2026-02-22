import 'dart:convert';
import 'package:flutter/services.dart';

class BiosFile {
  final String filename;
  final bool found;
  final String? region;
  final String? description;

  BiosFile({
    required this.filename,
    this.found = false,
    this.region,
    this.description,
  });

  factory BiosFile.fromJson(Map<String, dynamic> json) {
    return BiosFile(
      filename: json['filename'] as String,
      region: json['region'] as String?,
      description: json['description'] as String?,
    );
  }

  BiosFile copyWith({bool? found}) {
    return BiosFile(
      filename: filename,
      found: found ?? this.found,
      region: region,
      description: description,
    );
  }
}

class BiosRequirement {
  final String platform;
  final String displayName;
  final bool required;
  final List<BiosFile> files;
  final List<String> locations;
  final String? notes;

  BiosRequirement({
    required this.platform,
    required this.displayName,
    required this.required,
    required this.files,
    required this.locations,
    this.notes,
  });

  factory BiosRequirement.fromJson(Map<String, dynamic> json) {
    return BiosRequirement(
      platform: json['platform'] as String,
      displayName: json['displayName'] as String,
      required: json['required'] as bool? ?? false,
      locations: List<String>.from(json['locations'] as List),
      notes: json['notes'] as String?,
      files: (json['files'] as List)
          .map((f) => BiosFile.fromJson(f as Map<String, dynamic>))
          .toList(),
    );
  }

  BiosRequirement copyWith({List<BiosFile>? files}) {
    return BiosRequirement(
      platform: platform,
      displayName: displayName,
      required: required,
      files: files ?? this.files,
      locations: locations,
      notes: notes,
    );
  }

  bool get hasAllFiles => files.every((f) => f.found);
  bool get hasSomeFiles => files.any((f) => f.found);
  int get foundCount => files.where((f) => f.found).length;
  int get totalCount => files.length;

  static List<BiosRequirement>? _cachedRequirements;

  /// Load all BIOS requirements from the assets JSON file
  static Future<List<BiosRequirement>> loadAll() async {
    if (_cachedRequirements != null) return _cachedRequirements!;

    try {
      final jsonStr = await rootBundle.loadString(
        'assets/data/bios_requirements.json',
      );
      final List<dynamic> jsonList = jsonDecode(jsonStr);
      _cachedRequirements = jsonList
          .map((json) => BiosRequirement.fromJson(json))
          .toList();
      return _cachedRequirements!;
    } catch (e) {
      // Return empty list if loading fails to avoid crashes
      return [];
    }
  }

  // Backwards compatibility for existing code
  static Future<List<BiosRequirement>> getDefaultRequirements() => loadAll();
}
