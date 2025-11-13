import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';
import 'wallpaper_slideshow.dart';
import 'custom_bottom_app_bar.dart';
import 'add_favorite_dialog.dart';
import 'settings_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SettingsService _settingsService = SettingsService();
  // Lista de apps para a barra inferior (favoritos/recentes)
  List<AppInfo> _favoriteApps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteApps();
  }

  // Carrega os apps favoritos salvos.
  Future<void> _loadFavoriteApps() async {
    try {
      final favoritePackageNames = await _settingsService.loadFavoriteApps();
      if (favoritePackageNames.isEmpty) {
        // Se não houver favoritos, carrega os 3 primeiros apps como padrão inicial
        List<AppInfo> allApps = await InstalledApps.getInstalledApps(withIcon: true);
        _favoriteApps = allApps.take(3).toList();
        await _saveFavorites(); // Salva essa lista inicial
      } else {
        // Carrega os AppInfo para os pacotes salvos
        final List<AppInfo> loadedFavorites = [];
        for (var packageName in favoritePackageNames) {
          final appInfo = await InstalledApps.getAppInfo(packageName); // Pode retornar null
          if (appInfo != null) { // Adiciona a verificação de nulidade
            loadedFavorites.add(appInfo);
          }
        }
        _favoriteApps = loadedFavorites;
      }

      if (mounted) {
        setState(() {});
      }
    } on PlatformException catch (e) {
      print("Erro ao carregar os aplicativos: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Salva a lista atual de favoritos
  Future<void> _saveFavorites() async {
    final packageNames = _favoriteApps.map((app) => app.packageName).toList();
    await _settingsService.saveFavoriteApps(packageNames);
  }
  // Abre o diálogo para adicionar um novo app e atualiza a lista
  Future<void> _addFavoriteApp() async {
    // Mostra o diálogo e aguarda um resultado (o AppInfo selecionado)
    final AppInfo? newFavorite = await showDialog<AppInfo>(
      context: context,
      builder: (BuildContext context) => const AddFavoriteDialog(),
    );

    // Se o usuário selecionou um app, adiciona-o à lista
    if (newFavorite != null && mounted) {
      setState(() {
        // Evita adicionar duplicatas
        if (!_favoriteApps.any((app) => app.packageName == newFavorite.packageName)) {
          _favoriteApps.add(newFavorite);
          _saveFavorites(); // Salva a nova lista
        }
      });
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
            onAddApp: _addFavoriteApp, // Passa a função para a barra inferior
          ),
        ],
      ),
    );
  }
}