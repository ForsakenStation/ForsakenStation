import 'package:forsaken/models/emulator_config.dart';
import 'package:forsaken/models/platform_info.dart';
import 'package:forsaken/models/rom.dart';

/// Generates test data for unit tests.
///
/// Provides static methods to create valid instances of core models
/// and JSON maps (both valid and invalid) for serialization tests.
class TestDataGenerators {
  /// Generates a [Rom] with sensible defaults.
  ///
  /// [platform] defaults to 'nes', [index] is used to make names unique.
  static Rom generateRom({
    String? platform,
    String? subdirectory,
    int index = 0,
  }) {
    final p = platform ?? 'nes';
    return Rom(
      name: 'Test Rom $index',
      fileName: 'test_rom_$index.nes',
      platform: p,
      urlFilePath: '/roms/$p/test_rom_$index.txt',
      downloadUrl: 'https://example.com/roms/test_rom_$index.nes',
      localPath: '/tmp/test_rom_$index.nes',
      subdirectory: subdirectory,
    );
  }

  /// Generates a [PlatformInfo] with sensible defaults.
  static PlatformInfo generatePlatformInfo({
    String? fullName,
    int? releaseYear,
  }) {
    return PlatformInfo(
      fullName: fullName ?? 'Nintendo Entertainment System',
      manufacturer: 'Nintendo',
      releaseYear: releaseYear ?? 1983,
      generation: 3,
      description: 'An 8-bit home video game console.',
      cpu: 'Ricoh 2A03 @ 1.79 MHz',
      resolution: '256x240',
      colors: '54',
    );
  }

  /// Generates an [EmulatorCommand] with sensible defaults.
  static EmulatorCommand generateEmulatorCommand({
    String? name,
    String? command,
  }) {
    return EmulatorCommand(
      name: name ?? 'RetroArch NES',
      command: command ?? 'retroarch',
      args: ['-L', 'nestopia_libretro.so', '{ROM}'],
    );
  }

  /// Generates an [EmulatorConfig] with [commandCount] commands.
  static EmulatorConfig generateEmulatorConfig({
    String? platform,
    int commandCount = 1,
  }) {
    final p = platform ?? 'nes';
    final commands = List.generate(
      commandCount,
      (i) => generateEmulatorCommand(
        name: 'Command ${i + 1}',
        command: 'retroarch',
      ),
    );
    return EmulatorConfig(
      platform: p,
      commands: commands,
      acceptZipFiles: true,
      useForeverMode: false,
    );
  }

  /// Returns a valid [PlatformInfo] JSON map.
  static Map<String, dynamic> generateValidPlatformInfoJson() {
    return {
      'fullName': 'Super Nintendo Entertainment System',
      'manufacturer': 'Nintendo',
      'releaseYear': 1990,
      'generation': 4,
      'description': 'A 16-bit home video game console.',
      'cpu': 'Ricoh 5A22 @ 3.58 MHz',
      'resolution': '256x224',
      'colors': '32768',
    };
  }

  /// Returns an invalid [PlatformInfo] JSON map (missing required fields).
  static Map<String, dynamic> generateInvalidPlatformInfoJson() {
    return {
      'fullName': 'Incomplete Platform',
      // missing: manufacturer, releaseYear, description, cpu, resolution, colors
    };
  }

  /// Returns a valid [EmulatorConfig] JSON map in our native format.
  ///
  /// Uses the `platform` key as expected by [EmulatorConfig.fromJson].
  static Map<String, dynamic> generateValidEmulatorConfigJson({
    String? platform,
  }) {
    return {
      'platform': platform ?? 'snes',
      'commands': [
        {
          'name': 'RetroArch SNES',
          'command': 'retroarch',
          'args': ['-L', 'snes9x_libretro.so', '{ROM}'],
        },
      ],
      'acceptZipFiles': true,
      'useForeverMode': false,
    };
  }

  /// Returns a valid [EmulatorConfig] JSON map in Forsaken format.
  ///
  /// Uses the `system` + `command` keys as expected by the Forsaken format
  /// branch in [EmulatorConfig.fromJson].
  static Map<String, dynamic> generateValidForsakenConfigJson({
    String? system,
  }) {
    return {
      'system': system ?? 'snes',
      'command': 'retroarch -L snes9x_libretro.so',
    };
  }
}
