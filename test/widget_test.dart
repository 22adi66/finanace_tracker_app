// This is a basic Flutter widget test for Finance Tracker App.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanace_tracker_app/main.dart';

void main() {
  testWidgets('Finance Tracker App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app loads (looking for splash screen or login elements)
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
