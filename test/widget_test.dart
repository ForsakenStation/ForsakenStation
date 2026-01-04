import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:emulator/main.dart';

void main() {
  testWidgets('EmulatorApp shows configuration error when no .env', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EmulatorApp());

    expect(find.text('Configuration Error'), findsWidgets);
  });
}
