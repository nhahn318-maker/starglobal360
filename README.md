# Star Explorer 360

Star Explorer 360 is a native Flutter mini virtual tour created for the StarGlobal Mobile App Intern technical test. It connects an indoor sculpture gallery and an outdoor urban courtyard through interactive 360-degree panoramas.

The application does **not** use WebView. An equirectangular image is mapped to a spherical mesh by `panorama_viewer` and rendered through Flutter's graphics pipeline. Hotspots use spherical latitude/longitude coordinates, so they remain attached to their scene while the user pans or zooms.

## APK

- Installable APK: [`release/star-explorer-360-v1.0.0.apk`](release/star-explorer-360-v1.0.0.apk)
- Version: `1.0.0+1`
- Size: 22,744,871 bytes (21.7 MB)
- SHA-256: `5D3BB5D8DB181CC66177DFDA4E2029604F48ED17A4E4A6F7538FCA6617BA01C1`
- Android application ID: `com.nhahn.star_global_360`

The submission APK is a release-mode build signed with a development key so it can be installed directly for evaluation. A production release would use a private upload/release key managed outside the repository.

## Completed features

- Home screen backed by local JSON data.
- Two connected 4096 x 2048 equirectangular panoramas.
- Three spherical hotspots per panorama (six total).
- Four information hotspots with accessible bottom sheets.
- Two navigation hotspots with a fade transition between panoramas.
- Drag-to-pan and pinch-to-zoom interaction.
- First-use gesture guidance, loading feedback, reset-view control, and error/retry state.
- Responsive Material 3 interface and custom Android launcher icon.
- Offline operation after installation; no API or network access is required.
- JSON validation for required fields, coordinate ranges, duplicate IDs, and navigation targets.
- Unit/widget tests plus clean static analysis.

## Architecture

The project uses a lightweight feature-first structure. It keeps data parsing, validation, state, and presentation separate without adding unnecessary domain abstractions for a two-screen application.

```text
lib/
|-- app/
|   |-- app.dart
|   `-- theme.dart
|-- core/
|   |-- errors/
|   `-- widgets/
|-- features/
|   `-- panorama/
|       |-- data/
|       |   |-- datasources/
|       |   |-- models/
|       |   `-- repositories/
|       `-- presentation/
|           |-- controllers/
|           |-- screens/
|           `-- widgets/
`-- main.dart

assets/
|-- data/panoramas.json
|-- images/
`-- panoramas/
```

Data flow:

```text
assets/data/panoramas.json
        -> PanoramaLocalDataSource
        -> PanoramaRepository (cross-record validation)
        -> PanoramaCatalogController (UI state)
        -> HomeScreen / PanoramaViewerScreen
```

`PanoramaCatalogController` uses Flutter's built-in `ChangeNotifier`, so this small project does not need an additional state-management package. Dependencies are constructed explicitly in `app.dart`, keeping ownership and disposal easy to follow.

## Data model

Panorama content is not hard-coded in widgets. Each JSON record provides:

- identity, title, subtitle, and description;
- thumbnail and equirectangular asset paths;
- initial latitude, longitude, and zoom;
- a list of information or navigation hotspots;
- an optional target panorama ID for navigation hotspots.

The repository validates relationships after parsing. This structure can be moved to a REST API or local database without rewriting presentation widgets.

## Technical research

### Research process

1. Read the test requirements and separated mandatory behavior from optional product features.
2. Reviewed the equirectangular photo-sphere format and spherical heading/pitch conventions.
3. Compared a WebView-based JavaScript viewer with a Flutter-rendered sphere.
4. Verified that `panorama_viewer` supports gestures, zoom, spherical hotspots, image-load events, and controller operations.
5. Tested the JSON/data boundary independently before connecting the UI.
6. Reduced source HDRIs to 4096 x 2048 JPEGs and verified Android debug/release compilation.

### References

- [Google Photo Sphere XMP metadata](https://developers.google.com/streetview/spherical-metadata) - equirectangular projection and orientation conventions.
- [`panorama_viewer` package](https://pub.dev/packages/panorama_viewer) - package overview, platform support, and license.
- [`PanoramaViewer` API](https://pub.dev/documentation/panorama_viewer/latest/panorama_viewer/PanoramaViewer-class.html) - gesture, zoom, view, and hotspot configuration.
- [`Hotspot` API](https://pub.dev/documentation/panorama_viewer/latest/panorama_viewer/Hotspot-class.html) - latitude/longitude placement.
- [Flutter assets documentation](https://docs.flutter.dev/ui/assets/assets-and-images) - local JSON and image bundling.

## Why this solution

`panorama_viewer` 2.0.7 provides the required interaction with a small, understandable API and no embedded browser. It builds on `flutter_cube` to render a textured sphere and exposes hotspots in spherical coordinates. This directly addresses the highest-risk parts of the assignment while leaving time for data validation, UI polish, tests, documentation, and a verified APK.

The panoramas are stored locally because the assignment needs a self-contained demo, not a content backend. Keeping the data source behind a repository makes a later API migration straightforward.

## Performance decisions

- Panorama images are 4096 x 2048 rather than their original 8K+ exports.
- Optimized progressive JPEGs keep the two panorama assets near 2.5 MB combined.
- Images and JSON are bundled locally, eliminating network latency and broken demo links.
- The viewer limits zoom to a practical range of 1x to 3x.
- Only the active panorama viewer is interactive; scene changes replace it through a short fade.

## Dependencies

| Package | Version | Purpose |
|---|---:|---|
| Flutter SDK | 3.29.3 (local build) | UI, navigation, assets, and state primitives |
| `panorama_viewer` | 2.0.7 | Spherical panorama rendering, gestures, zoom, and hotspots |

`panorama_viewer` transitively uses `flutter_cube` and `dchs_motion_sensors`. Sensor control is disabled in this version of the tour; the user controls the view with touch gestures.

## Run locally

Prerequisites:

- Flutter 3.29 or newer
- Dart 3.7 or newer
- Android SDK with an emulator or physical Android device

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Build an installable release APK:

```bash
flutter build apk --release
```

The generated file is `build/app/outputs/flutter-apk/app-release.apk`.

## Verification performed

- `flutter analyze` - no issues.
- `flutter test` - all tests passed.
- `flutter build apk --debug` - succeeded.
- `flutter build apk --release` - succeeded.
- APK checksum recorded above after copying the verified release artifact.
- Physical-device pass on vivo V2041 (1080 x 2408): install, launch, full-screen render, pan gesture, information hotspot, and panorama navigation verified.

The connected-device pass confirmed the required flow on one Android model. A broader low-, mid-, and high-range device matrix would still be required before production release.

## Challenges and trade-offs

- **Stable hotspot placement:** screen-space overlays would drift. Spherical latitude/longitude hotspots keep markers tied to panorama content.
- **Image memory:** original HDRIs were much larger than needed for a mobile demo. They were downscaled while preserving the 2:1 projection.
- **Scope control:** search, favorites, maps, authentication, and a backend were intentionally excluded so the required viewer could be complete and testable.
- **Package dependency:** the viewer depends on a third-party rendering package. The app isolates it in one screen so it can be replaced without changing the catalog/data layer.

## Current limitations

- Panorama content is bundled and cannot be updated remotely.
- There is no multi-resolution tile streaming for very large scenes.
- Hotspot positions are demo content and should receive a final pass on representative physical devices.
- Gyroscope control is intentionally disabled.
- The current submission targets Android only.
- Production signing, Play Store configuration, and device-matrix benchmarking are outside this test build.

## Future improvements

- API-backed content management with caching and offline fallback.
- Multi-resolution panorama tiles for faster loading of high-resolution scenes.
- Optional gyroscope mode with a clear permission and calibration flow.
- Mini-map, guided auto-tour, favorites, and visit history.
- Analytics for hotspot engagement and scene transitions.
- Integration tests on low-, mid-, and high-range Android devices.
- iOS target and accessibility testing with screen readers.

## Asset credits

Both panorama HDRIs are provided by [Poly Haven](https://polyhaven.com/) under [CC0](https://polyhaven.com/license). Attribution is not required by CC0 but is included in appreciation of the creators.

- [Sculpture Exhibition](https://polyhaven.com/a/sculpture_exhibition) by Oliksiy Yakovlyev; resized and JPEG-optimized for this application.
- [Urban Courtyard](https://polyhaven.com/a/urban_courtyard) by Greg Zaal; resized and JPEG-optimized for this application.

See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for dependency and asset notices.
