// Cross-platform OS detection utilities.
//
// This file conditionally imports the IO or web implementation,
// providing a unified API for platform checks used in models.
import 'platform_utils_io.dart'
    if (dart.library.js_interop) 'platform_utils_web.dart'
    as platform_info;

/// Whether the current platform is Linux.
bool get isLinux => platform_info.isLinux;

/// Whether the current platform is macOS.
bool get isMacOS => platform_info.isMacOS;

/// Whether the current platform is Windows.
bool get isWindows => platform_info.isWindows;

/// Get the user's home directory path, or empty string if unavailable.
String get homeDirectory => platform_info.homeDirectory;
