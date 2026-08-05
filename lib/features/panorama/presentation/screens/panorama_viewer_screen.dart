import 'dart:async';

import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import 'package:star_global_360/app/theme.dart';
import 'package:star_global_360/features/panorama/data/models/hotspot_model.dart';
import 'package:star_global_360/features/panorama/data/models/panorama_model.dart';
import 'package:star_global_360/features/panorama/presentation/controllers/panorama_catalog_controller.dart';
import 'package:star_global_360/features/panorama/presentation/widgets/hotspot_detail_sheet.dart';
import 'package:star_global_360/features/panorama/presentation/widgets/panorama_hotspot_marker.dart';
import 'package:star_global_360/features/panorama/presentation/widgets/viewer_instruction_overlay.dart';

class PanoramaViewerScreen extends StatefulWidget {
  const PanoramaViewerScreen({
    required this.initialPanoramaId,
    required this.controller,
    super.key,
  });

  final String initialPanoramaId;
  final PanoramaCatalogController controller;

  @override
  State<PanoramaViewerScreen> createState() => _PanoramaViewerScreenState();
}

class _PanoramaViewerScreenState extends State<PanoramaViewerScreen> {
  late String _currentPanoramaId;
  bool _isImageLoading = true;
  bool _showInstructions = true;
  int _viewerRevision = 0;
  Timer? _instructionTimer;

  PanoramaModel get _currentPanorama {
    return widget.controller.findById(_currentPanoramaId)!;
  }

  @override
  void initState() {
    super.initState();
    _currentPanoramaId = widget.initialPanoramaId;
    _instructionTimer = Timer(const Duration(seconds: 7), _dismissInstructions);
  }

  @override
  void dispose() {
    _instructionTimer?.cancel();
    super.dispose();
  }

  void _dismissInstructions() {
    if (!mounted || !_showInstructions) return;
    setState(() => _showInstructions = false);
  }

  void _showHelp() {
    _instructionTimer?.cancel();
    setState(() => _showInstructions = true);
  }

  void _resetView() {
    setState(() {
      _isImageLoading = true;
      _viewerRevision++;
    });
  }

  void _handleHotspot(HotspotModel hotspot) {
    if (hotspot.type == HotspotType.navigation) {
      final targetId = hotspot.targetPanoramaId;
      if (targetId == null || widget.controller.findById(targetId) == null) {
        return;
      }
      setState(() {
        _currentPanoramaId = targetId;
        _isImageLoading = true;
        _viewerRevision++;
      });
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Now exploring ${_currentPanorama.title}'),
            duration: const Duration(seconds: 2),
          ),
        );
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) => HotspotDetailSheet(hotspot: hotspot),
    );
  }

  @override
  Widget build(BuildContext context) {
    final panorama = _currentPanorama;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                );
              },
              child: PanoramaViewer(
                key: ValueKey('${panorama.id}-$_viewerRevision'),
                latitude: panorama.initialView.latitude,
                longitude: panorama.initialView.longitude,
                zoom: panorama.initialView.zoom,
                minZoom: 1,
                maxZoom: 3,
                sensitivity: 1.1,
                sensorControl: SensorControl.none,
                onImageLoad: () {
                  if (mounted) setState(() => _isImageLoading = false);
                },
                hotspots: panorama.hotspots
                    .map(
                      (hotspot) => Hotspot(
                        name: hotspot.id,
                        latitude: hotspot.latitude,
                        longitude: hotspot.longitude,
                        width: 60,
                        height: 60,
                        widget: PanoramaHotspotMarker(
                          hotspot: hotspot,
                          onTap: () => _handleHotspot(hotspot),
                        ),
                      ),
                    )
                    .toList(growable: false),
                child: Image.asset(
                  panorama.imageAsset,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.medium,
                  semanticLabel: '${panorama.title} 360 panorama',
                ),
              ),
            ),
          ),
          const Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [Color(0x99000000), Colors.transparent],
                  ),
                ),
              ),
            ),
          ),
          _ViewerAppBar(
            panorama: panorama,
            onBack: () => Navigator.of(context).pop(),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: MediaQuery.paddingOf(context).bottom + 16,
            child: _ViewerControls(
              markerCount: panorama.hotspots.length,
              onHelp: _showHelp,
              onReset: _resetView,
            ),
          ),
          if (_isImageLoading)
            const Positioned.fill(
              child: IgnorePointer(child: _LoadingOverlay()),
            ),
          if (_showInstructions)
            ViewerInstructionOverlay(onDismiss: _dismissInstructions),
        ],
      ),
    );
  }
}

class _ViewerAppBar extends StatelessWidget {
  const _ViewerAppBar({required this.panorama, required this.onBack});

  final PanoramaModel panorama;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            _RoundAction(
              tooltip: 'Back to tours',
              icon: Icons.arrow_back_rounded,
              onPressed: onBack,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.48),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      panorama.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      panorama.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewerControls extends StatelessWidget {
  const _ViewerControls({
    required this.markerCount,
    required this.onHelp,
    required this.onReset,
  });

  final int markerCount;
  final VoidCallback onHelp;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.56),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.gold,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '$markerCount markers',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        _RoundAction(
          tooltip: 'Reset view',
          icon: Icons.center_focus_strong,
          onPressed: onReset,
        ),
        const SizedBox(width: 10),
        _RoundAction(
          tooltip: 'Show controls',
          icon: Icons.help_outline_rounded,
          onPressed: onHelp,
        ),
      ],
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon),
      color: Colors.white,
      style: IconButton.styleFrom(
        backgroundColor: Colors.black.withValues(alpha: 0.56),
        side: const BorderSide(color: Colors.white24),
        minimumSize: const Size(52, 52),
      ),
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.navy,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.gold),
            const SizedBox(height: 18),
            Text(
              'Preparing the 360° view…',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
