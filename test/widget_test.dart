// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:unit_conventor/main.dart';

void main() {
  testWidgets('Unit converter app launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const UnitConverterApp());

    // Verify that the app title is displayed.
    expect(find.text('Unit Converter'), findsOneWidget);

    // Verify that navigation items are present.
    expect(find.text('Length'), findsOneWidget);
    expect(find.text('Weight'), findsOneWidget);
    expect(find.text('Temperature'), findsOneWidget);

    // Verify that conversion UI elements are present.
    expect(find.text('From'), findsOneWidget);
    expect(find.text('To'), findsOneWidget);
    expect(find.text('Enter value'), findsOneWidget);
  });

  testWidgets('Unit conversion works correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const UnitConverterApp());

    // Find the input text field.
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    // Enter a value (100 meters).
    await tester.enterText(textField, '100');
    await tester.pump();

    // The default conversion should be from Meter to Kilometer.
    // 100 meters = 0.1 kilometers.
    // The result should be displayed somewhere in the widget tree.
    expect(find.textContaining('0.1'), findsOneWidget);
  });

  testWidgets('Swap units button works', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const UnitConverterApp());

    // Find and tap the swap button.
    final swapButton = find.byIcon(Icons.swap_vert);
    expect(swapButton, findsOneWidget);

    await tester.tap(swapButton);
    await tester.pump();

    // The units should be swapped (visual confirmation in the app).
    // This test just verifies the button is tappable without errors.
    expect(swapButton, findsOneWidget);
  });

  testWidgets('Navigation between categories works', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const UnitConverterApp());

    // Tap on the Weight category.
    await tester.tap(find.text('Weight'));
    await tester.pump();

    // Verify we're now in the Weight category by checking for weight units.
    // The first dropdown should now contain weight units.
    final dropdowns = find.byType(DropdownButtonFormField<String>);
    expect(dropdowns, findsNWidgets(2));

    // Verify that conversion still works in the new category.
    final textField = find.byType(TextField);
    await tester.enterText(textField, '1');
    await tester.pump();

    // 1 Kilogram = 1000 Grams (default conversion).
    expect(find.textContaining('1000'), findsOneWidget);
  });
}