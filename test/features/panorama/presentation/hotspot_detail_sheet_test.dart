import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:star_global_360/features/panorama/data/models/hotspot_model.dart';
import 'package:star_global_360/features/panorama/presentation/widgets/hotspot_detail_sheet.dart';

void main() {
  testWidgets('information hotspot displays its optional image', (
    tester,
  ) async {
    const hotspot = HotspotModel(
      id: 'test_hotspot',
      type: HotspotType.info,
      latitude: 0,
      longitude: 0,
      title: 'Test landmark',
      description: 'Test description',
      imageAsset: 'assets/images/museum_gallery_thumb.jpg',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: HotspotDetailSheet(hotspot: hotspot)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Test landmark'), findsOneWidget);
    expect(find.text('Test description'), findsOneWidget);
  });
}
