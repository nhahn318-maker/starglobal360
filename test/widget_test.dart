import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:star_global_360/app/app.dart';

void main() {
  testWidgets('home shows the JSON-backed panorama catalog', (tester) async {
    await tester.pumpWidget(const StarGlobalApp());
    await tester.pumpAndSettle();

    expect(find.text('Explore 360°'), findsOneWidget);
    expect(find.text('Sculpture Gallery'), findsOneWidget);

    await tester.drag(find.byType(Scrollable), const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(find.text('Urban Courtyard'), findsOneWidget);
  });
}
