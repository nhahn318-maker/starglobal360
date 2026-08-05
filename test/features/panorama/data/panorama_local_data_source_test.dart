import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:star_global_360/core/errors/app_exception.dart';
import 'package:star_global_360/features/panorama/data/datasources/panorama_local_data_source.dart';
import 'package:star_global_360/features/panorama/data/models/hotspot_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'bundled catalog contains two valid panoramas and six hotspots',
    () async {
      final source = await rootBundle.loadString('assets/data/panoramas.json');
      final panoramas = PanoramaLocalDataSource.parse(source);

      expect(panoramas, hasLength(2));
      expect(panoramas.expand((panorama) => panorama.hotspots), hasLength(6));
      expect(
        panoramas
            .expand((panorama) => panorama.hotspots)
            .where((hotspot) => hotspot.type == HotspotType.navigation),
        hasLength(2),
      );
      final hotspotImages =
          panoramas
              .expand((panorama) => panorama.hotspots)
              .map((hotspot) => hotspot.imageAsset)
              .whereType<String>()
              .toSet();
      expect(hotspotImages, hasLength(4));
      for (final imageAsset in hotspotImages) {
        expect(
          (await rootBundle.load(imageAsset)).lengthInBytes,
          greaterThan(0),
        );
      }
    },
  );

  test('invalid catalogs fail with a user-safe app exception', () {
    expect(
      () => PanoramaLocalDataSource.parse('{"panoramas": []}'),
      throwsA(isA<AppException>()),
    );
  });
}
