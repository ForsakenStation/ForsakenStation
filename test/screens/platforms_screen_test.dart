import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:forsaken/l10n/generated/app_localizations.dart';
import 'package:forsaken/providers/theme_provider.dart';
import 'package:forsaken/screens/platforms_screen.dart';
import 'package:forsaken/services/rom_service.dart';
import 'package:forsaken/widgets/common/controls_bottom_bar.dart';
import 'package:provider/provider.dart';

Widget _buildTestApp(Widget child) {
  return ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'forsaken_roms_path': '/tmp/forsaken_test_nonexistent_roms',
    });
  });

  testWidgets('PlatformsScreen renders app bar, search, and ControlsBottomBar', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _buildTestApp(
        PlatformsScreen(
          romService: RomService(
            romsBasePath: '/tmp/forsaken_test_nonexistent_roms',
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Forsaken'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsWidgets);
    expect(find.byIcon(Icons.settings), findsWidgets);
    expect(find.byType(ControlsBottomBar), findsOneWidget);
  });

  testWidgets('PlatformsScreen opens and cancels global search dialog', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _buildTestApp(
        PlatformsScreen(
          romService: RomService(
            romsBasePath: '/tmp/forsaken_test_nonexistent_roms',
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    await tester.tap(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.byIcon(Icons.search),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(AlertDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
