import 'dart:io';
import 'package:flutter/foundation.dart';
import 'debug_service.dart';

/// Service for checking system requirements
///
/// Checks if required system tools are installed and available
class SystemCheckService {
  static final SystemCheckService instance = SystemCheckService._internal();

  SystemCheckService._internal();

  /// Required tools for different platforms
  static const Map<String, List<String>> _requiredTools = {
    'linux': ['7z', 'unrar'],
    'macos': ['7z', 'unrar'],
    'windows': ['7z'],
  };

  /// Checks if a command is available in the system PATH
  Future<bool> isCommandAvailable(String command) async {
    if (kIsWeb) {
      // Web platform doesn't have system commands
      return false;
    }

    try {
      if (Platform.isWindows) {
        // On Windows, use 'where' command
        final result = await Process.run('where', [command]);
        return result.exitCode == 0;
      } else {
        // On Unix-like systems, use 'which' command
        final result = await Process.run('which', [command]);
        return result.exitCode == 0;
      }
    } catch (e) {
      DebugService.instance.error(
        'Error checking command availability: $e',
        tag: 'SystemCheck',
      );
      return false;
    }
  }

  /// Gets the list of required tools for the current platform
  List<String> getRequiredTools() {
    if (kIsWeb) {
      // Web platform doesn't require system tools
      return [];
    }

    if (Platform.isLinux) {
      return _requiredTools['linux'] ?? [];
    } else if (Platform.isMacOS) {
      return _requiredTools['macos'] ?? [];
    } else if (Platform.isWindows) {
      return _requiredTools['windows'] ?? [];
    }
    return [];
  }

  /// Checks all required tools and returns missing ones
  Future<List<String>> checkRequiredTools() async {
    final required = getRequiredTools();
    final missing = <String>[];

    for (final tool in required) {
      final available = await isCommandAvailable(tool);
      if (!available) {
        missing.add(tool);
      }
    }

    return missing;
  }

  /// Performs a full system check
  ///
  /// Returns a map with:
  /// - 'missing_required': List of missing required tools
  /// - 'missing_optional': List of missing optional tools
  /// - 'all_required_met': Whether all required tools are installed
  Future<SystemCheckResult> performSystemCheck() async {
    final missingRequired = await checkRequiredTools();

    return SystemCheckResult(
      missingRequired: missingRequired,
      allRequiredMet: missingRequired.isEmpty,
    );
  }

  /// Gets installation instructions for missing tools
  String getInstallInstructions(List<String> tools) {
    if (tools.isEmpty) return '';

    if (kIsWeb) {
      return 'System tools are not required on the web platform.';
    }

    final toolsStr = tools.join(' ');

    if (Platform.isLinux) {
      return '''
To install the missing tools, run one of these commands based on your distribution:

Debian/Ubuntu:
sudo apt update && sudo apt install -y $toolsStr

Fedora:
sudo dnf install -y $toolsStr

Arch Linux:
sudo pacman -S --noconfirm $toolsStr

Gentoo:
sudo emerge $toolsStr
''';
    } else if (Platform.isMacOS) {
      return '''
To install the missing tools, use Homebrew:

brew install $toolsStr

If you don't have Homebrew, install it first:
/bin/bash -c "\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
''';
    } else if (Platform.isWindows) {
      return '''
To install the missing tools on Windows, you can:

1. Install via Chocolatey:
   choco install $toolsStr

2. Or download them manually:
   - 7-Zip: https://www.7-zip.org/download.html
   - wget: https://eternallybored.org/misc/wget/
''';
    }

    return '';
  }

  /// Gets tool descriptions
  String getToolDescription(String tool) {
    const descriptions = {
      '7z': 'Archive extraction tool (for .7z, .zip files)',
      'unrar': 'RAR archive extraction tool',
    };

    return descriptions[tool] ?? tool;
  }
}

/// Result of a system check
class SystemCheckResult {
  final List<String> missingRequired;
  final bool allRequiredMet;

  SystemCheckResult({
    required this.missingRequired,
    required this.allRequiredMet,
  });

  /// Whether any tools are missing (required or optional)
  bool get hasAnyMissing => missingRequired.isNotEmpty;
}
