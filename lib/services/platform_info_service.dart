import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/platform_info.dart';
import '../utils/platform_aliases.dart';
import 'debug_service.dart';
import 'locale_service.dart';

/// Service for loading and caching platform information
///
/// Loads detailed information about gaming platforms from a JSON asset file,
/// including historical data, technical specifications, and notable games.
class PlatformInfoService {
  static PlatformInfoService? _instance;
  static const Set<String> _localizedInfoLanguages = {'ca', 'en', 'eu', 'gl'};

  Map<String, PlatformInfo>? _platformInfoCache;
  Map<String, PlatformInfo>? _fallbackInfoCache;
  String? _cachedLanguageCode;

  PlatformInfoService._();

  static PlatformInfoService get instance {
    _instance ??= PlatformInfoService._();
    return _instance!;
  }

  String _assetPathForLanguage(String? languageCode) {
    if (languageCode != null && _localizedInfoLanguages.contains(languageCode)) {
      return 'assets/data/platforms_info_$languageCode.json';
    }
    return 'assets/data/platforms_info.json';
  }

  /// Load all platform information from JSON asset
  Future<Map<String, PlatformInfo>> loadPlatformInfo() async {
    final languageCode = LocaleService.instance.currentLocale?.languageCode;
    if (_platformInfoCache != null && _cachedLanguageCode == languageCode) {
      return _platformInfoCache!;
    }

    final assetPath = _assetPathForLanguage(languageCode);
    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      _platformInfoCache = {};
      _cachedLanguageCode = languageCode;
      jsonData.forEach((key, value) {
        _platformInfoCache![key] = PlatformInfo.fromJson(value);
      });

      return _platformInfoCache!;
    } catch (e) {
      DebugService.instance.error(
        'Error loading platform info from $assetPath: $e',
        tag: 'PlatformInfo',
      );
      return {};
    }
  }

  Future<Map<String, PlatformInfo>> _loadFallbackInfo() async {
    if (_fallbackInfoCache != null) return _fallbackInfoCache!;
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/platforms_info.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      _fallbackInfoCache = {};
      jsonData.forEach((key, value) {
        _fallbackInfoCache![key] = PlatformInfo.fromJson(value);
      });
      return _fallbackInfoCache!;
    } catch (e) {
      DebugService.instance.error(
        'Error loading fallback platform info: $e',
        tag: 'PlatformInfo',
      );
      return {};
    }
  }

  /// Get information for a specific platform by its identifier
  ///
  /// Returns null if the platform information is not found
  Future<PlatformInfo?> getPlatformInfo(String platformId) async {
    final allInfo = await loadPlatformInfo();
    final candidates = PlatformAliases.getCandidates(platformId);

    for (final candidate in candidates) {
      final info = allInfo[candidate.toLowerCase()];
      if (info != null) return info;
    }

    if (_cachedLanguageCode != null &&
        _localizedInfoLanguages.contains(_cachedLanguageCode)) {
      final fallback = await _loadFallbackInfo();
      for (final candidate in candidates) {
        final info = fallback[candidate.toLowerCase()];
        if (info != null) return info;
      }
    }

    return null;
  }

  /// Check if platform information exists for a given platform ID
  Future<bool> hasPlatformInfo(String platformId) async {
    return (await getPlatformInfo(platformId)) != null;
  }

  /// Clear the cache (useful for testing or reloading)
  void clearCache() {
    _platformInfoCache = null;
    _fallbackInfoCache = null;
    _cachedLanguageCode = null;
  }

  /// Get all platform IDs that have information available
  Future<List<String>> getAvailablePlatformIds() async {
    final allInfo = await loadPlatformInfo();
    return allInfo.keys.toList();
  }
}
