import 'package:flutter/material.dart';
import 'package:star_global_360/app/theme.dart';
import 'package:star_global_360/core/widgets/app_error_view.dart';
import 'package:star_global_360/features/panorama/data/models/panorama_model.dart';
import 'package:star_global_360/features/panorama/presentation/controllers/panorama_catalog_controller.dart';
import 'package:star_global_360/features/panorama/presentation/screens/panorama_viewer_screen.dart';
import 'package:star_global_360/features/panorama/presentation/widgets/panorama_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({required this.controller, super.key});

  final PanoramaCatalogController controller;

  void _openPanorama(BuildContext context, PanoramaModel panorama) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder:
            (_) => PanoramaViewerScreen(
              initialPanoramaId: panorama.id,
              controller: controller,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return switch (controller.status) {
            CatalogStatus.initial || CatalogStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            CatalogStatus.failure => AppErrorView(
              message: controller.errorMessage ?? 'Something went wrong.',
              onRetry: controller.load,
            ),
            CatalogStatus.ready => _HomeContent(
              panoramas: controller.panoramas,
              onExplore: (panorama) => _openPanorama(context, panorama),
            ),
          };
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.panoramas, required this.onExplore});

  final List<PanoramaModel> panoramas;
  final ValueChanged<PanoramaModel> onExplore;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 330,
          backgroundColor: AppColors.navy,
          surfaceTintColor: Colors.transparent,
          title: const _Brand(),
          flexibleSpace: const FlexibleSpaceBar(background: _HeroHeader()),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
          sliver: SliverList.list(
            children: [
              Text(
                'Choose your next view',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Two connected spaces. Six interactive stories. One seamless 360° tour.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              for (final panorama in panoramas) ...[
                PanoramaCard(
                  panorama: panorama,
                  onExplore: () => onExplore(panorama),
                ),
                const SizedBox(height: 20),
              ],
              const _TechnicalNote(),
            ],
          ),
        ),
      ],
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.blur_circular_rounded, color: AppColors.gold),
        SizedBox(width: 10),
        Text(
          'STAR EXPLORER',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navy, AppColors.navySoft, Color(0xFF294A5C)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -70,
            top: 48,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white12, width: 24),
              ),
            ),
          ),
          Positioned(
            left: -40,
            bottom: -70,
            child: Container(
              width: 180,
              height: 180,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x14E5B85C),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 96, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Text(
                      'MINI VIRTUAL MUSEUM TOUR',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Explore beyond\nthe frame.',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Move through art and architecture in an immersive 360° experience.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TechnicalNote extends StatelessWidget {
  const _TechnicalNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.navy.withValues(alpha: 0.08)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.speed_rounded, color: AppColors.navy),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Rendered natively in Flutter. No WebView, no network connection required.',
              style: TextStyle(
                fontSize: 13,
                height: 1.45,
                color: AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
