import 'package:flutter/material.dart';
import 'package:star_global_360/app/theme.dart';
import 'package:star_global_360/features/panorama/data/datasources/panorama_local_data_source.dart';
import 'package:star_global_360/features/panorama/data/repositories/panorama_repository.dart';
import 'package:star_global_360/features/panorama/presentation/controllers/panorama_catalog_controller.dart';
import 'package:star_global_360/features/panorama/presentation/screens/home_screen.dart';

class StarGlobalApp extends StatefulWidget {
  const StarGlobalApp({super.key});

  @override
  State<StarGlobalApp> createState() => _StarGlobalAppState();
}

class _StarGlobalAppState extends State<StarGlobalApp> {
  late final PanoramaCatalogController _catalogController;

  @override
  void initState() {
    super.initState();
    _catalogController = PanoramaCatalogController(
      PanoramaRepository(PanoramaLocalDataSource()),
    )..load();
  }

  @override
  void dispose() {
    _catalogController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Star Explorer 360',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: HomeScreen(controller: _catalogController),
    );
  }
}
