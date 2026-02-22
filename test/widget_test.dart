import 'package:flutter_test/flutter_test.dart';
import 'package:forsaken/main.dart';

void main() {
  testWidgets('EmulatorApp shows initializing screen on startup', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EmulatorApp());

    expect(find.text('Configuration Error'), findsWidgets);
  });
}
