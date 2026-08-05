import 'package:flutter/material.dart';
import 'package:star_global_360/app/theme.dart';
import 'package:star_global_360/features/panorama/data/models/panorama_model.dart';

class PanoramaCard extends StatelessWidget {
  const PanoramaCard({
    required this.panorama,
    required this.onExplore,
    super.key,
  });

  final PanoramaModel panorama;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Explore ${panorama.title} in 360 degrees',
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: InkWell(
          onTap: onExplore,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      panorama.thumbnailAsset,
                      fit: BoxFit.cover,
                      semanticLabel: '${panorama.title} panorama preview',
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0x99000000)],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      top: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.navy.withValues(alpha: 0.86),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.threesixty_rounded,
                              size: 17,
                              color: AppColors.gold,
                            ),
                            SizedBox(width: 6),
                            Text(
                              '360° VIEW',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.7,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 18,
                      right: 18,
                      bottom: 16,
                      child: Text(
                        panorama.subtitle.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      panorama.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      panorama.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 19,
                          color: AppColors.navy,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${panorama.hotspots.length} interactive markers',
                          style: const TextStyle(
                            color: AppColors.navy,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: AppColors.navy,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
