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
        const SliverAppBar(
          pinned: true,
          expandedHeight: 190,
          backgroundColor: AppColors.navy,
          surfaceTintColor: Colors.transparent,
          title: _Brand(),
          flexibleSpace: FlexibleSpaceBar(background: _HeroHeader()),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
          sliver: SliverList.separated(
            itemCount: panoramas.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final panorama = panoramas[index];
              return PanoramaCard(
                panorama: panorama,
                onExplore: () => onExplore(panorama),
              );
            },
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
        Icon(Icons.blur_circular_rounded, color: AppColors.gold, size: 22),
        SizedBox(width: 9),
        Text(
          'STAR 360',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
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
          colors: [AppColors.navy, AppColors.navySoft],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -48,
            bottom: -68,
            child: Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white10, width: 22),
              ),
            ),
          ),
          const Positioned(
            left: 20,
            bottom: 22,
            child: Text(
              'Explore 360°',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
