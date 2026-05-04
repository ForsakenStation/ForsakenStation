import 'package:flutter_test/flutter_test.dart';
import 'package:forsaken/main.dart';
import 'package:forsaken/screens/initializing_screen.dart';

void main() {
  testWidgets('EmulatorApp shows initializing screen on startup', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EmulatorApp());
    await tester.pump();

    expect(find.byType(InitializingScreen), findsOneWidget);
  });
}
