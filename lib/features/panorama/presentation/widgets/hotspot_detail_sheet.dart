import 'package:flutter/material.dart';
import 'package:star_global_360/app/theme.dart';
import 'package:star_global_360/features/panorama/data/models/hotspot_model.dart';

class HotspotDetailSheet extends StatelessWidget {
  const HotspotDetailSheet({required this.hotspot, super.key});

  final HotspotModel hotspot;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (hotspot.imageAsset case final imageAsset?) ...[
              Semantics(
                image: true,
                label: '${hotspot.title} image',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            color: AppColors.navy.withValues(alpha: 0.06),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.broken_image_outlined,
                              color: AppColors.navy,
                            ),
                          ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ] else ...[
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF3D5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_outlined,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 18),
            ],
            Text(
              hotspot.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              hotspot.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Continue exploring'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
