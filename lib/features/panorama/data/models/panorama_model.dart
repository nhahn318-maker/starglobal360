import 'package:star_global_360/features/panorama/data/models/hotspot_model.dart';

final class PanoramaInitialView {
  const PanoramaInitialView({
    required this.latitude,
    required this.longitude,
    required this.zoom,
  });

  factory PanoramaInitialView.fromJson(Map<String, dynamic> json) {
    final latitude = json['latitude'];
    final longitude = json['longitude'];
    final zoom = json['zoom'];
    if (latitude is! num || longitude is! num || zoom is! num) {
      throw const FormatException('initialView values must be numeric.');
    }
    if (latitude < -90 || latitude > 90) {
      throw const FormatException('Initial latitude is out of range.');
    }
    if (longitude < -180 || longitude > 180) {
      throw const FormatException('Initial longitude is out of range.');
    }
    if (zoom < 1 || zoom > 5) {
      throw const FormatException('Initial zoom must be between 1 and 5.');
    }

    return PanoramaInitialView(
      latitude: latitude.toDouble(),
      longitude: longitude.toDouble(),
      zoom: zoom.toDouble(),
    );
  }

  final double latitude;
  final double longitude;
  final double zoom;
}

final class PanoramaModel {
  const PanoramaModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.thumbnailAsset,
    required this.imageAsset,
    required this.initialView,
    required this.hotspots,
  });

  factory PanoramaModel.fromJson(Map<String, dynamic> json) {
    final initialView = json['initialView'];
    final hotspots = json['hotspots'];
    if (initialView is! Map<String, dynamic>) {
      throw const FormatException('initialView must be an object.');
    }
    if (hotspots is! List<dynamic> || hotspots.length < 3) {
      throw const FormatException(
        'Each panorama requires at least 3 hotspots.',
      );
    }

    return PanoramaModel(
      id: _requiredString(json, 'id'),
      title: _requiredString(json, 'title'),
      subtitle: _requiredString(json, 'subtitle'),
      description: _requiredString(json, 'description'),
      thumbnailAsset: _requiredString(json, 'thumbnail'),
      imageAsset: _requiredString(json, 'image'),
      initialView: PanoramaInitialView.fromJson(initialView),
      hotspots: List.unmodifiable(
        hotspots.map(
          (item) => HotspotModel.fromJson(item as Map<String, dynamic>),
        ),
      ),
    );
  }

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String thumbnailAsset;
  final String imageAsset;
  final PanoramaInitialView initialView;
  final List<HotspotModel> hotspots;

  static String _requiredString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('$key must be a non-empty string.');
    }
    return value;
  }
}
