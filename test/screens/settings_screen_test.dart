import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:forsaken/l10n/generated/app_localizations.dart';
import 'package:forsaken/screens/settings_screen.dart';
import 'package:forsaken/widgets/common/controls_bottom_bar.dart';

Widget _buildTestApp(Widget child) {
  return MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('SettingsScreen renders sections and ControlsBottomBar', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_buildTestApp(const SettingsScreen()));
    await tester.pump();

    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(ControlsBottomBar), findsOneWidget);
  });

  testWidgets('SettingsScreen handles arrow key navigation', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_buildTestApp(const SettingsScreen()));
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
