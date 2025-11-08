import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'wallpaper_slideshow.dart';
import 'bottom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lista de apps para a barra inferior (favoritos/recentes)
  List<Application> _favoriteApps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteApps();
  }

  // Carrega alguns apps para exibir na barra inferior.
  // No futuro, você pode implementar uma lógica para salvar os favoritos.
  Future<void> _loadFavoriteApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    );

    // Pega os 8 primeiros apps como "favoritos" para este exemplo
    setState(() {
      _favoriteApps = apps.take(8).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Widget do Slideshow como fundo
          const WallpaperSlideshow(),
          // 2. Barra de aplicativos inferior
          BottomAppBar(
            favoriteApps: _favoriteApps,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}