import 'dart:convert';
import '../services/debug_service.dart';
import '../utils/file_utils.dart';
import '../utils/platform_utils.dart' as platform_utils;

/// Represents a single emulator command configuration
class EmulatorCommand {
  final String name;
  final String command;
  final List<String> args;

  EmulatorCommand({
    required this.name,
    required this.command,
    this.args = const [],
  });

  factory EmulatorCommand.fromJson(Map<String, dynamic> json) {
    final commandString = json['command'] as String;
    // Parse the command string into command and args
    final parts = commandString.trim().split(RegExp(r'\s+'));
    final command = parts.isNotEmpty ? parts.first : '';
    final args = parts.length > 1 ? parts.sublist(1) : <String>[];

    // Add {ROM} placeholder at the end if not present
    if (args.isEmpty || !args.any((arg) => arg.contains('{ROM}'))) {
      args.add('{ROM}');
    }

    return EmulatorCommand(
      name: json['name'] as String,
      command: command,
      args: args.isNotEmpty
          ? args
          : (json['args'] != null
                ? List<String>.from(json['args'] as List)
                : const []),
    );
  }

  /// Creates an EmulatorCommand from Forsaken format
  /// Forsaken format: { "system": "nes", "command": "retroarch -L core.so" }
  factory EmulatorCommand.fromForsakenFormat(
    String system,
    String commandString, {
    int index = 0,
  }) {
    // Parse the command string into command and args
    final parts = commandString.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) {
      throw Exception('Empty command string for system: $system');
    }

    final command = parts.first;
    final args = parts.length > 1 ? parts.sublist(1) : <String>[];

    // Add {ROM} placeholder at the end if not present
    if (!args.any((arg) => arg.contains('{ROM}'))) {
      args.add('{ROM}');
    }

    // Generate a meaningful name based on the command
    String name = system.toUpperCase();
    if (index > 0) {
      // Extract emulator name from command for better display
      final cmdName = command.split('/').last.replaceAll('.AppImage', '');
      name = '$name - ${cmdName.toUpperCase()} (#${index + 1})';
    }

    return EmulatorCommand(name: name, command: command, args: args);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'command': command, 'args': args};
  }

  /// Builds the full command with ROM path
  /// Replaces {ROM} placeholder with actual ROM path
  /// Expands ~ to home directory
  List<String> buildCommand(String romPath) {
    final processedArgs = args.map((arg) {
      var processed = arg.replaceAll('{ROM}', romPath);

      // Expand ~ to home directory
      if (processed.startsWith('~/')) {
        final home = platform_utils.homeDirectory;
        if (home.isNotEmpty) {
          processed = processed.replaceFirst('~/', '$home/');
        }
      }

      return processed;
    }).toList();

    return processedArgs;
  }

  /// Check if this command uses RetroArch
  bool get isRetroArch {
    final cmdLower = command.toLowerCase();
    return cmdLower.contains('retroarch') ||
        cmdLower.endsWith('retroarch') ||
        cmdLower.endsWith('retroarch.exe');
  }

  @override
  String toString() {
    return 'EmulatorCommand(name: $name, command: $command, args: $args)';
  }
}

/// Represents emulator configuration for a platform
class EmulatorConfig {
  final String platform;
  final List<EmulatorCommand> commands;

  /// Whether the emulator accepts zip files directly.
  /// When true, zip files are passed as-is to the emulator.
  /// When false, zip files are extracted before launching.
  final bool acceptZipFiles;

  /// Whether ROMs for this emulator should always be saved to forever storage.
  final bool useForeverMode;

  /// The filename to search for inside extracted zip directories.
  /// Used when acceptZipFiles is false to find the correct file to launch.
  /// Example: "eboot.bin" for PS4 games.
  final String? launchFile;

  EmulatorConfig({
    required this.platform,
    required this.commands,
    this.acceptZipFiles = true,
    this.useForeverMode = false,
    this.launchFile,
  });

  factory EmulatorConfig.fromJson(Map<String, dynamic> json) {
    // Support both our format and Forsaken format
    // Our format: { "platform": "nes", "commands": [...] }
    // Forsaken format: { "system": "nes", "command": "..." or command: [...] }

    final acceptZip = json['acceptZipFiles'] == true;
    final foreverMode = json['useForeverMode'] == true;
    final launchFile = json['launchFile'] as String?;

    if (json.containsKey('system') && json.containsKey('command')) {
      // Forsaken format
      final system = json['system'] as String;
      final commandField = json['command'];

      List<EmulatorCommand> commands;

      if (commandField is String) {
        // Single command as string
        commands = [EmulatorCommand.fromForsakenFormat(system, commandField)];
      } else if (commandField is List) {
        // Multiple commands as array of strings or objects
        commands = commandField.asMap().entries.map((entry) {
          final value = entry.value;
          if (value is String) {
            return EmulatorCommand.fromForsakenFormat(
              system,
              value,
              index: entry.key,
            );
          } else if (value is Map<String, dynamic>) {
            return EmulatorCommand.fromJson(value);
          } else {
            throw Exception('Invalid command entry type for system: $system');
          }
        }).toList();
      } else {
        throw Exception('Invalid command type for system: $system');
      }

      return EmulatorConfig(
        platform: system,
        commands: commands,
        acceptZipFiles: acceptZip,
        useForeverMode: foreverMode,
        launchFile: launchFile,
      );
    } else {
      // Our format
      return EmulatorConfig(
        platform: json['platform'] as String,
        commands: (json['commands'] as List)
            .map((cmd) => EmulatorCommand.fromJson(cmd as Map<String, dynamic>))
            .toList(),
        acceptZipFiles: acceptZip,
        useForeverMode: foreverMode,
        launchFile: launchFile,
      );
    }
  }

  /// Whether this platform requires zip extraction before launching
  bool get requiresExtraction => !acceptZipFiles;

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'commands': commands.map((cmd) => cmd.toJson()).toList(),
      'acceptZipFiles': acceptZipFiles,
      'useForeverMode': useForeverMode,
      if (launchFile != null) 'launchFile': launchFile,
    };
  }

  /// Checks if multiple commands are available
  bool get hasMultipleCommands => commands.length > 1;

  /// Gets the first/default command
  EmulatorCommand? get defaultCommand =>
      commands.isNotEmpty ? commands.first : null;

  @override
  String toString() {
    return 'EmulatorConfig(platform: $platform, commands: ${commands.length})';
  }
}

/// Main configuration container for all emulators
class EmulatorsConfig {
  final List<EmulatorConfig> emulators;
  final Map<String, EmulatorConfig> _platformMap = {};
  final _debug = DebugService.instance;

  EmulatorsConfig({required this.emulators}) {
    // Build platform lookup map
    for (var config in emulators) {
      final key = config.platform.toLowerCase();
      _platformMap[key] = config;
    }
    _debug.info(
      'Loaded ${_platformMap.length} platform configurations',
      tag: 'EmulatorsConfig',
    );
  }

  factory EmulatorsConfig.fromJson(Map<String, dynamic> json) {
    return EmulatorsConfig(
      emulators: (json['emulators'] as List)
          .map((e) => EmulatorConfig.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'emulators': emulators.map((e) => e.toJson()).toList()};
  }

  /// Loads emulator configuration from the main config.json file
  static Future<EmulatorsConfig?> loadFromFile(String filePath) async {
    final debug = DebugService.instance;
    try {
      if (!await fileExists(filePath)) {
        debug.error(
          'Config file does not exist: $filePath',
          tag: 'EmulatorsConfig',
        );
        return null;
      }

      final contents = await readFileAsString(filePath);
      final json = jsonDecode(contents) as Map<String, dynamic>;
      return EmulatorsConfig.fromJson(json);
    } catch (e) {
      debug.error(
        'Error loading emulators config from $filePath',
        tag: 'EmulatorsConfig',
        error: e,
      );
      return null;
    }
  }

  /// Get configuration for a specific platform
  EmulatorConfig? getConfigForPlatform(String platform) {
    return _platformMap[platform.toLowerCase()];
  }

  /// Check if a platform is configured
  bool isPlatformConfigured(String platform) {
    return _platformMap.containsKey(platform.toLowerCase());
  }

  /// Get list of all configured platforms
  List<String> get configuredPlatforms {
    return _platformMap.keys.toList();
  }

  @override
  String toString() {
    return 'EmulatorsConfig(platforms: ${emulators.length})';
  }
}
