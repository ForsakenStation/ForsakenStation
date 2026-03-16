import 'package:flutter_test/flutter_test.dart';

import 'package:forsaken/models/emulator_config.dart';
import '../helpers/test_data_generators.dart';

void main() {
  group('EmulatorCommand', () {
    group('fromJson', () {
      test('parses command string into command and args', () {
        final json = {
          'name': 'RetroArch NES',
          'command': 'retroarch -L nestopia_libretro.so',
        };
        final cmd = EmulatorCommand.fromJson(json);

        expect(cmd.name, equals('RetroArch NES'));
        expect(cmd.command, equals('retroarch'));
        expect(cmd.args, contains('-L'));
        expect(cmd.args, contains('nestopia_libretro.so'));
      });

      test('adds {ROM} placeholder when not present', () {
        final json = {
          'name': 'Test',
          'command': 'retroarch -L core.so',
        };
        final cmd = EmulatorCommand.fromJson(json);

        expect(cmd.args.any((a) => a.contains('{ROM}')), isTrue);
      });
    });

    group('toJson', () {
      test('produces correct map', () {
        final cmd = TestDataGenerators.generateEmulatorCommand();
        final json = cmd.toJson();

        expect(json['name'], equals(cmd.name));
        expect(json['command'], equals(cmd.command));
        expect(json['args'], equals(cmd.args));
      });
    });

    group('buildCommand', () {
      test('replaces {ROM} placeholder with actual path', () {
        final cmd = EmulatorCommand(
          name: 'Test',
          command: 'retroarch',
          args: ['-L', 'core.so', '{ROM}'],
        );
        final result = cmd.buildCommand('/path/to/game.nes');

        expect(result, contains('/path/to/game.nes'));
        expect(result, isNot(contains('{ROM}')));
      });

      test('returns args list with ROM path substituted', () {
        final cmd = EmulatorCommand(
          name: 'Test',
          command: 'retroarch',
          args: ['-L', 'core.so', '{ROM}'],
        );
        final result = cmd.buildCommand('/roms/game.sfc');

        expect(result.length, equals(3));
        expect(result.last, equals('/roms/game.sfc'));
      });
    });

    group('isRetroArch', () {
      test('returns true for retroarch command', () {
        final cmd = TestDataGenerators.generateEmulatorCommand(
          command: 'retroarch',
        );
        expect(cmd.isRetroArch, isTrue);
      });

      test('returns true for retroarch with full path', () {
        final cmd = TestDataGenerators.generateEmulatorCommand(
          command: '/usr/bin/retroarch',
        );
        expect(cmd.isRetroArch, isTrue);
      });

      test('returns false for non-retroarch command', () {
        final cmd = TestDataGenerators.generateEmulatorCommand(
          command: 'dolphin-emu',
        );
        expect(cmd.isRetroArch, isFalse);
      });

      test('returns false for mame command', () {
        final cmd = TestDataGenerators.generateEmulatorCommand(
          command: 'mame',
        );
        expect(cmd.isRetroArch, isFalse);
      });
    });
  });

  group('EmulatorConfig', () {
    group('fromJson - native format', () {
      test('creates correct instance from native format (platform key)', () {
        final json = TestDataGenerators.generateValidEmulatorConfigJson(
          platform: 'nes',
        );
        final config = EmulatorConfig.fromJson(json);

        expect(config.platform, equals('nes'));
        expect(config.commands, isNotEmpty);
        expect(config.acceptZipFiles, isTrue);
        expect(config.useForeverMode, isFalse);
      });

      test('parses commands list correctly', () {
        final json = TestDataGenerators.generateValidEmulatorConfigJson();
        final config = EmulatorConfig.fromJson(json);

        expect(config.commands.length, equals(1));
        expect(config.commands.first.name, equals('RetroArch SNES'));
      });
    });

    group('fromJson - Forsaken format', () {
      test('creates correct instance from Forsaken format (system+command keys)',
          () {
        final json = TestDataGenerators.generateValidForsakenConfigJson(
          system: 'genesis',
        );
        final config = EmulatorConfig.fromJson(json);

        expect(config.platform, equals('genesis'));
        expect(config.commands, isNotEmpty);
      });

      test('parses command string into EmulatorCommand', () {
        final json = {
          'system': 'snes',
          'command': 'retroarch -L snes9x_libretro.so',
        };
        final config = EmulatorConfig.fromJson(json);

        expect(config.commands.first.command, equals('retroarch'));
        expect(config.commands.first.args, contains('-L'));
      });
    });

    group('toJson', () {
      test('produces correct map with platform key', () {
        final config = TestDataGenerators.generateEmulatorConfig(
          platform: 'snes',
        );
        final json = config.toJson();

        expect(json['platform'], equals('snes'));
        expect(json['commands'], isA<List>());
        expect(json['acceptZipFiles'], equals(config.acceptZipFiles));
        expect(json['useForeverMode'], equals(config.useForeverMode));
      });

      test('includes launchFile when set', () {
        final config = EmulatorConfig(
          platform: 'ps4',
          commands: [TestDataGenerators.generateEmulatorCommand()],
          acceptZipFiles: false,
          launchFile: 'eboot.bin',
        );
        final json = config.toJson();

        expect(json['launchFile'], equals('eboot.bin'));
      });

      test('omits launchFile when null', () {
        final config = TestDataGenerators.generateEmulatorConfig();
        final json = config.toJson();

        expect(json.containsKey('launchFile'), isFalse);
      });
    });

    group('requiresExtraction', () {
      test('is true when acceptZipFiles is false', () {
        final config = EmulatorConfig(
          platform: 'ps4',
          commands: [TestDataGenerators.generateEmulatorCommand()],
          acceptZipFiles: false,
        );
        expect(config.requiresExtraction, isTrue);
      });

      test('is false when acceptZipFiles is true', () {
        final config = TestDataGenerators.generateEmulatorConfig();
        expect(config.requiresExtraction, isFalse);
      });
    });

    group('hasMultipleCommands', () {
      test('returns true when multiple commands exist', () {
        final config = TestDataGenerators.generateEmulatorConfig(
          commandCount: 3,
        );
        expect(config.hasMultipleCommands, isTrue);
      });

      test('returns false when only one command', () {
        final config = TestDataGenerators.generateEmulatorConfig(
          commandCount: 1,
        );
        expect(config.hasMultipleCommands, isFalse);
      });
    });

    group('defaultCommand', () {
      test('returns first command', () {
        final config = TestDataGenerators.generateEmulatorConfig(
          commandCount: 3,
        );
        expect(config.defaultCommand, equals(config.commands.first));
      });

      test('returns null when no commands', () {
        final config = EmulatorConfig(
          platform: 'empty',
          commands: [],
        );
        expect(config.defaultCommand, isNull);
      });
    });

    // Feature: unit-testing-implementation, Property 3: Computed Properties Are Consistent
    group('property tests', () {
      // **Validates: Requirements 2.3**
      test('requiresExtraction is always inverse of acceptZipFiles', () {
        for (var i = 0; i < 50; i++) {
          final acceptZip = i.isEven;
          final config = EmulatorConfig(
            platform: 'platform_$i',
            commands: [TestDataGenerators.generateEmulatorCommand()],
            acceptZipFiles: acceptZip,
          );
          expect(
            config.requiresExtraction,
            equals(!config.acceptZipFiles),
            reason:
                'requiresExtraction must be inverse of acceptZipFiles (i=$i, acceptZipFiles=$acceptZip)',
          );
        }
      });

      // **Validates: Requirements 2.3**
      test('hasMultipleCommands is consistent with commands.length', () {
        for (var count = 1; count <= 5; count++) {
          final config = TestDataGenerators.generateEmulatorConfig(
            platform: 'platform_$count',
            commandCount: count,
          );
          expect(
            config.hasMultipleCommands,
            equals(config.commands.length > 1),
            reason:
                'hasMultipleCommands must equal commands.length > 1 (count=$count)',
          );
        }
      });

      // **Validates: Requirements 2.3**
      test(
          'defaultCommand always returns first command when commands non-empty',
          () {
        for (var count = 1; count <= 5; count++) {
          final config = TestDataGenerators.generateEmulatorConfig(
            platform: 'platform_$count',
            commandCount: count,
          );
          expect(
            config.defaultCommand,
            equals(config.commands.first),
            reason:
                'defaultCommand must equal commands.first (commandCount=$count)',
          );
        }
      });

      // **Validates: Requirements 2.3**
      test('JSON round-trip preserves all fields across 50 generated configs',
          () {
        final platforms = [
          'nes', 'snes', 'genesis', 'gba', 'psx',
          'n64', 'dc', 'ps2', 'gc', 'wii',
        ];
        for (var i = 0; i < 50; i++) {
          final platform = platforms[i % platforms.length];
          final commandCount = (i % 5) + 1;
          final original = TestDataGenerators.generateEmulatorConfig(
            platform: '${platform}_$i',
            commandCount: commandCount,
          );
          final json = original.toJson();
          final restored = EmulatorConfig.fromJson(json);

          expect(
            restored.platform,
            equals(original.platform),
            reason: 'platform must survive round-trip (i=$i)',
          );
          expect(
            restored.commands.length,
            equals(original.commands.length),
            reason: 'command count must survive round-trip (i=$i)',
          );
        }
      });
    });
  });

  group('EmulatorsConfig', () {
    late EmulatorsConfig emulatorsConfig;

    setUp(() {
      emulatorsConfig = EmulatorsConfig(
        emulators: [
          TestDataGenerators.generateEmulatorConfig(platform: 'nes'),
          TestDataGenerators.generateEmulatorConfig(platform: 'snes'),
          TestDataGenerators.generateEmulatorConfig(platform: 'genesis'),
        ],
      );
    });

    group('getConfigForPlatform', () {
      test('returns correct config for existing platform', () {
        final config = emulatorsConfig.getConfigForPlatform('nes');
        expect(config, isNotNull);
        expect(config!.platform, equals('nes'));
      });

      test('is case-insensitive', () {
        expect(emulatorsConfig.getConfigForPlatform('NES'), isNotNull);
        expect(emulatorsConfig.getConfigForPlatform('Snes'), isNotNull);
        expect(emulatorsConfig.getConfigForPlatform('GENESIS'), isNotNull);
      });

      test('returns null for unconfigured platform', () {
        final config = emulatorsConfig.getConfigForPlatform('ps5');
        expect(config, isNull);
      });
    });

    group('isPlatformConfigured', () {
      test('returns true for configured platform', () {
        expect(emulatorsConfig.isPlatformConfigured('nes'), isTrue);
      });

      test('returns true case-insensitively', () {
        expect(emulatorsConfig.isPlatformConfigured('NES'), isTrue);
        expect(emulatorsConfig.isPlatformConfigured('SNES'), isTrue);
      });

      test('returns false for unconfigured platform', () {
        expect(emulatorsConfig.isPlatformConfigured('atari'), isFalse);
      });
    });

    group('configuredPlatforms', () {
      test('lists all configured platforms', () {
        final platforms = emulatorsConfig.configuredPlatforms;
        expect(platforms.length, equals(3));
        expect(platforms, containsAll(['nes', 'snes', 'genesis']));
      });

      test('returns empty list when no emulators configured', () {
        final empty = EmulatorsConfig(emulators: []);
        expect(empty.configuredPlatforms, isEmpty);
      });
    });
  });
}
