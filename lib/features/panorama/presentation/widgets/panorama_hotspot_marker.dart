import 'package:flutter/material.dart';
import 'package:star_global_360/app/theme.dart';
import 'package:star_global_360/features/panorama/data/models/hotspot_model.dart';

class PanoramaHotspotMarker extends StatefulWidget {
  const PanoramaHotspotMarker({
    required this.hotspot,
    required this.onTap,
    super.key,
  });

  final HotspotModel hotspot;
  final VoidCallback onTap;

  @override
  State<PanoramaHotspotMarker> createState() => _PanoramaHotspotMarkerState();
}

class _PanoramaHotspotMarkerState extends State<PanoramaHotspotMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNavigation = widget.hotspot.type == HotspotType.navigation;
    return Semantics(
      button: true,
      label: widget.hotspot.title,
      child: Tooltip(
        message: widget.hotspot.title,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Transform.scale(
                    scale: 0.9 + (_controller.value * 0.22),
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.gold.withValues(
                          alpha: 0.15 + (_controller.value * 0.12),
                        ),
                      ),
                    ),
                  ),
                  child!,
                ],
              );
            },
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isNavigation ? AppColors.gold : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                isNavigation
                    ? Icons.arrow_forward_rounded
                    : Icons.info_outline_rounded,
                size: 22,
                color: AppColors.navy,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
