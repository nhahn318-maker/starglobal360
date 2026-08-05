import 'package:star_global_360/core/errors/app_exception.dart';
import 'package:star_global_360/features/panorama/data/datasources/panorama_local_data_source.dart';
import 'package:star_global_360/features/panorama/data/models/hotspot_model.dart';
import 'package:star_global_360/features/panorama/data/models/panorama_model.dart';

final class PanoramaRepository {
  const PanoramaRepository(this._localDataSource);

  final PanoramaLocalDataSource _localDataSource;

  Future<List<PanoramaModel>> getPanoramas() async {
    final panoramas = await _localDataSource.loadPanoramas();
    final ids = panoramas.map((panorama) => panorama.id).toSet();

    if (ids.length != panoramas.length) {
      throw const AppException('Panorama IDs must be unique.');
    }

    for (final panorama in panoramas) {
      final hotspotIds = panorama.hotspots.map((hotspot) => hotspot.id).toSet();
      if (hotspotIds.length != panorama.hotspots.length) {
        throw AppException('${panorama.id} contains duplicate hotspot IDs.');
      }

      for (final hotspot in panorama.hotspots) {
        if (hotspot.type == HotspotType.navigation &&
            !ids.contains(hotspot.targetPanoramaId)) {
          throw AppException('${hotspot.id} points to an unknown panorama.');
        }
      }
    }

    return panoramas;
  }
}
