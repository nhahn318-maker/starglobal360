import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:star_global_360/core/errors/app_exception.dart';
import 'package:star_global_360/features/panorama/data/models/panorama_model.dart';

final class PanoramaLocalDataSource {
  PanoramaLocalDataSource({
    this.assetPath = 'assets/data/panoramas.json',
    AssetBundle? bundle,
  }) : bundle = bundle ?? rootBundle;

  final String assetPath;
  final AssetBundle bundle;

  Future<List<PanoramaModel>> loadPanoramas() async {
    try {
      final source = await bundle.loadString(assetPath);
      return parse(source);
    } on AppException {
      rethrow;
    } catch (error) {
      throw AppException('Unable to load panorama data.', cause: error);
    }
  }

  static List<PanoramaModel> parse(String source) {
    try {
      final decoded = jsonDecode(source);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Root JSON must be an object.');
      }
      final items = decoded['panoramas'];
      if (items is! List<dynamic> || items.length < 2) {
        throw const FormatException('At least 2 panoramas are required.');
      }

      return List.unmodifiable(
        items.map(
          (item) => PanoramaModel.fromJson(item as Map<String, dynamic>),
        ),
      );
    } catch (error) {
      throw AppException('Panorama data is invalid.', cause: error);
    }
  }
}
