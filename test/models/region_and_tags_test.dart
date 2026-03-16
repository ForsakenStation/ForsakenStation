import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forsaken/models/region_info.dart';
import 'package:forsaken/models/rom_tags.dart';

void main() {
  group('RegionInfo', () {
    test('parses single region correctly', () {
      final info = RegionInfo.fromRomName('Super Mario Bros (USA).nes');
      expect(info, isNotNull);
      expect(info!.regions, contains('USA'));
      expect(info.regions.length, 1);
    });

    test('parses comma-separated regions correctly', () {
      final info = RegionInfo.fromRomName('Zelda (USA, Europe).nes');
      expect(info, isNotNull);
      expect(info!.regions, containsAll(['USA', 'Europe']));
      expect(info.regions.length, 2);
    });

    test('rejects non-region tags', () {
      final info = RegionInfo.fromRomName('Game (Rev 1).nes');
      expect(info, isNull);
    });

    test('rejects version tags', () {
      final info = RegionInfo.fromRomName('Game (v1.1).nes');
      expect(info, isNull);
    });

    test('handles multiple parentheses correctly', () {
      final info = RegionInfo.fromRomName('Game (USA) (Rev 1).nes');
      expect(info, isNotNull);
      expect(info!.regions, contains('USA'));
      expect(info.regions, isNot(contains('Rev 1')));
      expect(info.regions.length, 1);
    });

    test('parses PAL/NTSC as regions', () {
      final info = RegionInfo.fromRomName('Game (PAL).nes');
      expect(info, isNotNull);
      expect(info!.regions, contains('PAL'));
    });

    test('rejects Demo as region', () {
      final info = RegionInfo.fromRomName('Game (Demo).nes');
      expect(info, isNull);
    });

    test('rejects Beta as region', () {
      final info = RegionInfo.fromRomName('Game (Beta).nes');
      expect(info, isNull);
    });

    test('rejects Proto as region', () {
      final info = RegionInfo.fromRomName('Game (Proto).nes');
      expect(info, isNull);
    });

    test('rejects long text with hyphens', () {
      final info = RegionInfo.fromRomName(
        'Abandoned Places (Europe) (v1.17) (Demo) (Coverdisk - Amiga Action - Issue 30)',
      );
      expect(info, isNotNull);
      expect(info!.regions, contains('Europe'));
      expect(info.regions, isNot(contains('Demo')));
      expect(
        info.regions,
        isNot(contains('Coverdisk - Amiga Action - Issue 30')),
      );
      expect(info.regions.length, 1);
    });

    test('getFlag returns flag emoji for USA', () {
      final flag = RegionInfo.getFlag('USA');
      expect(flag, isNotEmpty);
      expect(flag, isNot(equals('🗺️')));
    });

    test('getFlag returns flag emoji for Japan', () {
      final flag = RegionInfo.getFlag('Japan');
      expect(flag, isNotEmpty);
      expect(flag, isNot(equals('🗺️')));
    });

    test('getFlag returns globe emoji for unknown regions', () {
      expect(RegionInfo.getFlag('UnknownRegion'), equals('🗺️'));
    });

    test('getRegionName returns full name for known regions', () {
      expect(RegionInfo.getRegionName('usa'), equals('United States'));
      expect(RegionInfo.getRegionName('japan'), equals('Japan'));
      expect(RegionInfo.getRegionName('europe'), equals('Europe'));
    });

    test('getRegionName returns original string for unknown regions', () {
      expect(RegionInfo.getRegionName('Atlantis'), equals('Atlantis'));
    });

    test('isEmpty and isNotEmpty work correctly', () {
      final info = RegionInfo(['USA']);
      expect(info.isEmpty, isFalse);
      expect(info.isNotEmpty, isTrue);

      final empty = RegionInfo([]);
      expect(empty.isEmpty, isTrue);
      expect(empty.isNotEmpty, isFalse);
    });

    test('toString returns expected format', () {
      final info = RegionInfo(['USA', 'Europe']);
      expect(info.toString(), equals('RegionInfo(USA, Europe)'));
    });
  });

  group('RomTags', () {
    test('does not parse regions as tags', () {
      final tags = RomTags.fromRomName('Game (USA).nes');
      expect(tags, isNull);
    });

    test('does not parse comma-separated regions as tags', () {
      final tags = RomTags.fromRomName('Game (USA, Europe).nes');
      expect(tags, isNull);
    });

    test('parses version tags correctly', () {
      final tags = RomTags.fromRomName('Game (Rev 1).nes');
      expect(tags, isNotNull);
      expect(tags!.tags.any((t) => t.type == RomTagType.version), isTrue);
    });

    test('parses quality tags correctly', () {
      final tags = RomTags.fromRomName('Game [!].nes');
      expect(tags, isNotNull);
      expect(tags!.tags.any((t) => t.type == RomTagType.quality), isTrue);
    });

    test('parses hack tags correctly', () {
      final tags = RomTags.fromRomName('Game [h].nes');
      expect(tags, isNotNull);
      expect(tags!.tags.any((t) => t.type == RomTagType.modification), isTrue);
    });

    test('combines multiple tags', () {
      final tags = RomTags.fromRomName('Game (USA) [!] (Rev 1).nes');
      expect(tags, isNotNull);
      expect(tags!.tags.length, equals(2)); // [!] and Rev 1, not USA
    });

    test('parses Demo as tag', () {
      final tags = RomTags.fromRomName('Game (Demo).nes');
      expect(tags, isNotNull);
      expect(
        tags!.tags.any((t) => t.text.toLowerCase().contains('demo')),
        isTrue,
      );
    });

    test('parses Beta as tag', () {
      final tags = RomTags.fromRomName('Game (Beta).nes');
      expect(tags, isNotNull);
      expect(
        tags!.tags.any((t) => t.text.toLowerCase().contains('beta')),
        isTrue,
      );
    });

    test('complex ROM name parsing', () {
      final tags = RomTags.fromRomName(
        'Abandoned Places (Europe) (v1.17) (Demo) (Coverdisk - Amiga Action - Issue 30)',
      );
      expect(tags, isNotNull);
      // Should have v1.17, Demo, and the coverdisk info as tags
      expect(tags!.tags.length, greaterThan(0));
      expect(tags.tags.any((t) => t.type == RomTagType.version), isTrue);
      expect(
        tags.tags.any((t) => t.text.toLowerCase().contains('demo')),
        isTrue,
      );
    });

    test('isEmpty and isNotEmpty work correctly', () {
      final tags = RomTags([const RomTag(
        text: 'Verified',
        type: RomTagType.quality,
        icon: '✓',
        color: Color(0xFF4CAF50),
      )]);
      expect(tags.isEmpty, isFalse);
      expect(tags.isNotEmpty, isTrue);

      final empty = RomTags([]);
      expect(empty.isEmpty, isTrue);
      expect(empty.isNotEmpty, isFalse);
    });

    test('toString returns expected format', () {
      final tags = RomTags([
        const RomTag(
          text: 'Verified',
          type: RomTagType.quality,
          icon: '✓',
          color: Color(0xFF4CAF50),
        ),
        const RomTag(
          text: 'Hack',
          type: RomTagType.modification,
          icon: '🔧',
          color: Color(0xFF9C27B0),
        ),
      ]);
      expect(tags.toString(), equals('RomTags(Verified, Hack)'));
    });

    test('translation tag is parsed correctly from [t]', () {
      final tags = RomTags.fromRomName('Game [t].nes');
      expect(tags, isNotNull);
      expect(
        tags!.tags.any((t) => t.type == RomTagType.modification),
        isTrue,
      );
      expect(
        tags.tags.any((t) => t.text.toLowerCase().contains('translation')),
        isTrue,
      );
    });
  });
}
