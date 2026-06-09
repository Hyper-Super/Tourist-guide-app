import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tourist_guide/main.dart';

void main() {
  testWidgets('App starts with SplashScreen and navigates to Home', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TouristGuideApp());

    // Verify that the splash screen is displayed.
    expect(find.text('Tourist Guide'), findsOneWidget);
    expect(find.byIcon(Icons.travel_explore), findsOneWidget);

    // Wait for the animation and timer to finish
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Verify that we navigated to the Home screen (which has 'Home' label in bottom nav)
    expect(find.text('Home'), findsWidgets);
  });
}
