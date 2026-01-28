import 'dart:io';

/// Represents an overlay configuration for RetroArch
class OverlayConfig {
  /// The platform this overlay is for
  final String platform;

  /// Name of the overlay variant (e.g., "default", "Wood", "Alt")
  final String variant;

  /// Path to the overlay configuration file (.cfg)
  final String? configPath;

  /// Path to the overlay image file (.png)
  final String imagePath;

  /// Whether this overlay is the default for the platform
  final bool isDefault;

  const OverlayConfig({
    required this.platform,
    required this.variant,
    this.configPath,
    required this.imagePath,
    this.isDefault = false,
  });

  /// Display name for UI
  String get displayName {
    if (isDefault || variant.isEmpty || variant == 'default') {
      return 'Default';
    }
    return variant;
  }

  /// Full display name including platform
  String get fullDisplayName => '$platform - $displayName';

  /// Check if all required files exist
  Future<bool> isValid() async {
    if (configPath == null) {
      final imageFile = File(imagePath);
      return await imageFile.exists();
    }

    final configFile = File(configPath!);
    final imageFile = File(imagePath);

    return await configFile.exists() && await imageFile.exists();
  }

  @override
  String toString() {
    return 'OverlayConfig(platform: $platform, variant: $variant, default: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OverlayConfig &&
        other.platform == platform &&
        other.variant == variant &&
        other.configPath == configPath &&
        other.imagePath == imagePath;
  }

  @override
  int get hashCode {
    return Object.hash(platform, variant, configPath, imagePath);
  }
}

/// Collection of overlay configurations for a platform
class PlatformOverlays {
  /// The platform name
  final String platform;

  /// Available overlay configurations
  final List<OverlayConfig> overlays;

  const PlatformOverlays({required this.platform, required this.overlays});

  /// Get the default overlay for this platform
  OverlayConfig? get defaultOverlay {
    // First try to find one marked as default
    final marked = overlays.where((o) => o.isDefault).firstOrNull;
    if (marked != null) return marked;

    // Otherwise, return the first one
    return overlays.isNotEmpty ? overlays.first : null;
  }

  /// Get overlay by variant name
  OverlayConfig? getByVariant(String variant) {
    return overlays.where((o) => o.variant == variant).firstOrNull;
  }

  /// Check if this platform has any overlays
  bool get hasOverlays => overlays.isNotEmpty;

  /// Get all variant names
  List<String> get variantNames => overlays.map((o) => o.variant).toList();

  @override
  String toString() {
    return 'PlatformOverlays(platform: $platform, count: ${overlays.length})';
  }
}
