enum HotspotType {
  info,
  navigation;

  static HotspotType fromJson(Object? value) {
    return switch (value) {
      'info' => HotspotType.info,
      'navigation' => HotspotType.navigation,
      _ => throw FormatException('Unsupported hotspot type: $value'),
    };
  }
}

final class HotspotModel {
  const HotspotModel({
    required this.id,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.description,
    this.imageAsset,
    this.targetPanoramaId,
  });

  factory HotspotModel.fromJson(Map<String, dynamic> json) {
    final type = HotspotType.fromJson(json['type']);
    final targetPanoramaId = json['targetPanoramaId'] as String?;

    if (type == HotspotType.navigation && targetPanoramaId == null) {
      throw const FormatException(
        'Navigation hotspots require a targetPanoramaId.',
      );
    }

    return HotspotModel(
      id: _requiredString(json, 'id'),
      type: type,
      latitude: _coordinate(json, 'latitude', min: -90, max: 90),
      longitude: _coordinate(json, 'longitude', min: -180, max: 180),
      title: _requiredString(json, 'title'),
      description: _requiredString(json, 'description'),
      imageAsset: _optionalString(json, 'image'),
      targetPanoramaId: targetPanoramaId,
    );
  }

  final String id;
  final HotspotType type;
  final double latitude;
  final double longitude;
  final String title;
  final String description;
  final String? imageAsset;
  final String? targetPanoramaId;

  static String _requiredString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('$key must be a non-empty string.');
    }
    return value;
  }

  static String? _optionalString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) {
      return null;
    }
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('$key must be a non-empty string when provided.');
    }
    return value;
  }

  static double _coordinate(
    Map<String, dynamic> json,
    String key, {
    required double min,
    required double max,
  }) {
    final value = json[key];
    if (value is! num || value < min || value > max) {
      throw FormatException('$key must be between $min and $max.');
    }
    return value.toDouble();
  }
}
