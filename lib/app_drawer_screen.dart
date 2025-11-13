import 'package:flutter/material.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';
import 'app_icon.dart';

// Nova tela para a gaveta de apps
class AppDrawerScreen extends StatefulWidget {
  const AppDrawerScreen({super.key});

  @override
  State<AppDrawerScreen> createState() => _AppDrawerScreenState();
}

class _AppDrawerScreenState extends State<AppDrawerScreen> {
  late Future<List<AppInfo>> _appsFuture;

  @override
  void initState() {
    super.initState();
    // Carrega todos os apps que podem ser abertos
    _appsFuture = InstalledApps.getInstalledApps(
      withIcon: true,
      excludeSystemApps: false,
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

    final double iconSize = 150 * scaleFactor;
    final double borderWidth = 6 * scaleFactor;
    final double gridPadding = 60 * scaleFactor;
    final double gridSpacing = 32 * scaleFactor;

    return Scaffold(
      backgroundColor: const Color(0xFFADADB2).withOpacity(0.95),
      body: FutureBuilder<List<AppInfo>>(
        future: _appsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum aplicativo encontrado.'));
          }

          final apps = snapshot.data!;
          return GridView.builder(
            padding: EdgeInsets.all(gridPadding),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8, // Mais colunas para a gaveta
              crossAxisSpacing: gridSpacing,
              mainAxisSpacing: gridSpacing,
              childAspectRatio: 1.0,
            ),
            itemCount: apps.length,
            itemBuilder: (context, index) {
              final app = apps[index];
              return AppIcon(
                app: app,
                onTap: () => InstalledApps.startApp(app.packageName),
                size: iconSize,
                borderWidth: borderWidth,
                showAppName: true, // Ativa a exibição do nome
              );
            },
          );
        },
      ),
    );
  }
}