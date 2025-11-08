import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'app_drawer_screen.dart';
import 'app_icon.dart';
import 'wallpaper_slideshow.dart';

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

  // Função para navegar para a gaveta de apps
  void _openAppDrawer() {
    Navigator.of(context).push(
      // Usamos uma rota customizada para a animação
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const AppDrawerScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define as dimensões base do seu design original (1920x1080)
    const double designWidth = 1920.0;

    // Pega a largura atual da tela
    final double screenWidth = MediaQuery.of(context).size.width;

    // Calcula um fator de escala para ajustar os tamanhos
    final double scaleFactor = screenWidth / designWidth;

    // Calcula os tamanhos proporcionais
    final double barHeight = 250 * scaleFactor;
    final double iconSize = 150 * scaleFactor; // Ícone menor
    final double borderWidth = 6 * scaleFactor; // Borda mais fina
    final double horizontalPadding = 49 * scaleFactor;
    final double itemSpacing = 24 * scaleFactor; // Aumentei um pouco o espaçamento

    return Scaffold(
      body: Stack(
        children: [
          // 1. Widget do Slideshow como fundo
          const WallpaperSlideshow(),
          // A barra inferior que fica atrás dos ícones
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: barHeight,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFB2C5EA),
                // Simula a sombra interna com um gradiente
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    const Color(0xFFB2C5EA).withOpacity(0.2),
                  ],
                  stops: const [0.0, 0.2],
                ),
              ),
            ),
          ),
          // Lista horizontal de apps na barra
          Positioned(
            left: 0,
            right: 0,
            bottom: (barHeight - iconSize) / 2, // Centraliza verticalmente
            height: iconSize,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    itemCount: _favoriteApps.length + 1, // +1 para o botão da gaveta
                    itemBuilder: (context, index) {
                      // O primeiro item é o botão da gaveta
                      if (index == 0) {
                        return Padding(
                          padding: EdgeInsets.only(right: itemSpacing),
                          child: AppIcon(
                            onTap: _openAppDrawer,
                            autoFocus: true, // Foca o primeiro item
                            size: iconSize,
                            borderWidth: borderWidth,
                            // Ícone customizado para a gaveta de apps
                            customIcon: const Icon(
                              Icons.grid_view_rounded,
                              color: Color(0xFF02083A),
                              size: 64.0,
                            ),
                          ),
                        );
                      }
                      // O resto são os ícones dos apps
                      final app = _favoriteApps[index - 1];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: itemSpacing),
                        child: AppIcon(
                          app: app,
                          onTap: () => DeviceApps.openApp(app.packageName),
                          size: iconSize,
                          borderWidth: borderWidth,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}