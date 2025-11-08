import 'package:flutter/material.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';
import 'app_drawer_screen.dart';
import 'app_icon.dart';

class CustomBottomAppBar extends StatelessWidget {
  final List<AppInfo> favoriteApps;
  final bool isLoading;

  const CustomBottomAppBar({
    super.key,
    required this.favoriteApps,
    required this.isLoading,
  });

  // Função para navegar para a gaveta de apps
  void _openAppDrawer(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AppDrawerScreen(),
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
    final double iconSize = 150 * scaleFactor;
    final double borderWidth = 6 * scaleFactor;
    final double horizontalPadding = 49 * scaleFactor;
    final double itemSpacing = 24 * scaleFactor;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SizedBox(
        height: barHeight,
        child: Stack(
          children: [
            // Fundo da barra
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFB2C5EA),
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
            // Lista de ícones
            Positioned(
              left: 0,
              right: 0,
              bottom: (barHeight - iconSize) / 2, // Centraliza verticalmente
              height: iconSize,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      itemCount: favoriteApps.length + 1, // +1 para a gaveta
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: EdgeInsets.only(right: itemSpacing),
                            child: AppIcon(
                              onTap: () => _openAppDrawer(context),
                              autoFocus: true,
                              size: iconSize,
                              borderWidth: borderWidth,
                              customIcon: const Icon(Icons.grid_view_rounded, color: Color(0xFF02083A), size: 64.0),
                            ),
                          );
                        }
                        final app = favoriteApps[index - 1];
                        return Padding(padding: EdgeInsets.symmetric(horizontal: itemSpacing), child: AppIcon(app: app, onTap: () => InstalledApps.startApp(app.packageName), size: iconSize, borderWidth: borderWidth));
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}