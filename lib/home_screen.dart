import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';
import 'wallpaper_slideshow.dart';
import 'custom_bottom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lista de apps para a barra inferior (favoritos/recentes)
  List<AppInfo> _favoriteApps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteApps();
  }

  // Carrega alguns apps para exibir na barra inferior.
  // No futuro, você pode implementar uma lógica para salvar os favoritos.
  Future<void> _loadFavoriteApps() async {    
    try {
      List<AppInfo> apps = await InstalledApps.getInstalledApps(
          withIcon: true,
          excludeSystemApps: false,
        );
      // Pega os 8 primeiros apps como "favoritos" para este exemplo
      if (mounted) {
        setState(() {
          _favoriteApps = apps.take(8).toList();
        });
      }
    } on PlatformException catch (e) {
      print("Erro ao carregar os aplicativos: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Widget do Slideshow como fundo
          const WallpaperSlideshow(),
          // 2. Barra de aplicativos inferior (agora com o nome corrigido)
          CustomBottomAppBar(
            favoriteApps: _favoriteApps,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}