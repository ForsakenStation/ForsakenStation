import 'dart:io' as io;

/// Whether the current platform is Linux (IO implementation).
bool get isLinux => io.Platform.isLinux;

/// Whether the current platform is macOS (IO implementation).
bool get isMacOS => io.Platform.isMacOS;

/// Whether the current platform is Windows (IO implementation).
bool get isWindows => io.Platform.isWindows;

/// Get the user's home directory path (IO implementation).
String get homeDirectory =>
    io.Platform.environment['HOME'] ??
    io.Platform.environment['USERPROFILE'] ??
    '';
