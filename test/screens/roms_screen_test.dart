import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:forsaken/l10n/generated/app_localizations.dart';
import 'package:forsaken/models/emulator_platform.dart';
import 'package:forsaken/models/rom.dart';
import 'package:forsaken/screens/roms_screen.dart';
import 'package:forsaken/services/rom_service.dart';
import 'package:forsaken/widgets/common/controls_bottom_bar.dart';
import 'package:forsaken/widgets/common/platform_badge.dart';

Widget _buildTestApp(Widget child) {
  return MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return '/tmp/forsaken_test_app_support';
    });
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('RomsScreen renders grouped collection items and ControlsBottomBar', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final platform = EmulatorPlatform(
      name: 'recently_played',
      path: '',
      roms: [
        Rom(
          name: 'Super Mario World',
          fileName: 'smw.zip',
          platform: 'snes',
          urlFilePath: '',
        ),
        Rom(
          name: 'Sonic The Hedgehog',
          fileName: 'sonic.zip',
          platform: 'megadrive',
          urlFilePath: '',
        ),
      ],
    );

    await tester.pumpWidget(
      _buildTestApp(
        RomsScreen(
          platform: platform,
          romService: RomService(
            romsBasePath: '/tmp/forsaken_test_nonexistent_roms',
          ),
          isCollection: true,
        ),
      ),
    );
    for (var i = 0; i < 20; i++) {
      await tester.runAsync(() async {
        await Future.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump();
      if (find.text('Super Mario World').evaluate().isNotEmpty) break;
    }

    expect(find.text('Super Mario World'), findsWidgets);
    expect(find.text('Sonic The Hedgehog'), findsWidgets);
    expect(find.byType(PlatformBadge), findsWidgets);
    expect(find.byType(ControlsBottomBar), findsOneWidget);
  });

  testWidgets('RomsScreen toggles view mode with V key', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final platform = EmulatorPlatform(
      name: 'snes',
      path: '',
      roms: [
        Rom(
          name: 'Chrono Trigger',
          fileName: 'chrono.zip',
          platform: 'snes',
          urlFilePath: '',
        ),
      ],
    );

    await tester.pumpWidget(
      _buildTestApp(
        RomsScreen(
          platform: platform,
          romService: RomService(
            romsBasePath: '/tmp/forsaken_test_nonexistent_roms',
          ),
          isCollection: true,
        ),
      ),
    );
    for (var i = 0; i < 20; i++) {
      await tester.runAsync(() async {
        await Future.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump();
      if (find.text('Super Mario World').evaluate().isNotEmpty) break;
    }

    await tester.sendKeyEvent(LogicalKeyboardKey.keyV);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));

    expect(tester.takeException(), isNull);
  });
}
