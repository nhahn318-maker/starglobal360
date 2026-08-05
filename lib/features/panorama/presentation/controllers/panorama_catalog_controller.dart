import 'package:flutter/foundation.dart';
import 'package:star_global_360/features/panorama/data/models/panorama_model.dart';
import 'package:star_global_360/features/panorama/data/repositories/panorama_repository.dart';

enum CatalogStatus { initial, loading, ready, failure }

final class PanoramaCatalogController extends ChangeNotifier {
  PanoramaCatalogController(this._repository);

  final PanoramaRepository _repository;

  CatalogStatus _status = CatalogStatus.initial;
  List<PanoramaModel> _panoramas = const [];
  String? _errorMessage;

  CatalogStatus get status => _status;
  List<PanoramaModel> get panoramas => _panoramas;
  String? get errorMessage => _errorMessage;

  PanoramaModel? findById(String id) {
    for (final panorama in _panoramas) {
      if (panorama.id == id) return panorama;
    }
    return null;
  }

  Future<void> load() async {
    if (_status == CatalogStatus.loading) return;
    _status = CatalogStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _panoramas = await _repository.getPanoramas();
      _status = CatalogStatus.ready;
    } catch (_) {
      _status = CatalogStatus.failure;
      _errorMessage = 'The tour could not be loaded. Please try again.';
    }
    notifyListeners();
  }
}
