import 'package:flutter/material.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';
import 'app_drawer_screen.dart';
import 'settings_screen.dart';
import 'app_icon.dart';
 // 1. Importa a nova tela

class CustomBottomAppBar extends StatelessWidget {
  final List<AppInfo> favoriteApps;
  final bool isLoading;
  final VoidCallback onAddApp; // Callback para o botão de adicionar

  const CustomBottomAppBar({
    super.key,
    required this.favoriteApps,
    required this.isLoading,
    required this.onAddApp,
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

  // Função para navegar para a tela de configurações
  void _openSettings(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SettingsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Usa um slide da direita para a esquerda
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.ease));
          return SlideTransition(position: animation.drive(tween), child: child);
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
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : Center( // 1. Centraliza o conteúdo
                      child: SingleChildScrollView( // 2. Permite a rolagem
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: Row( // 3. Alinha os ícones
                          children: [
                            // Ícone da gaveta de apps
                            Padding(
                              padding: EdgeInsets.only(right: itemSpacing),
                              child: AppIcon(
                                onTap: () => _openAppDrawer(context),
                                autoFocus: true,
                                size: iconSize,
                                borderWidth: borderWidth,
                                customIcon: const Icon(Icons.grid_view_rounded, color: Color(0xFF02083A), size: 64.0),
                              ),
                            ),
                            // Ícones dos apps favoritos
                            ...favoriteApps.map((app) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: itemSpacing),
                              child: AppIcon(
                                app: app,
                                onTap: () => InstalledApps.startApp(app.packageName),
                                size: iconSize,
                                borderWidth: borderWidth,
                              ),
                            )).toList(),
                            // Ícone para Adicionar App
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: itemSpacing),
                              child: AppIcon(
                                onTap: onAddApp, // Chama a função passada pela HomeScreen
                                size: iconSize,
                                borderWidth: borderWidth,
                                customIcon: const Icon(Icons.add, color: Color(0xFF02083A), size: 64.0),
                              ),
                            ),
                            // Ícone de Configurações
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: itemSpacing),
                              child: AppIcon(
                                onTap: () => _openSettings(context),
                                size: iconSize,
                                borderWidth: borderWidth,
                                // Ícone de engrenagem
                                customIcon: const Icon(Icons.settings, color: Color(0xFF02083A), size: 64.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}