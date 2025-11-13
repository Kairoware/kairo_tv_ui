import 'package:flutter/material.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';
import 'app_icon.dart';

class AddFavoriteDialog extends StatefulWidget {
  const AddFavoriteDialog({super.key});

  @override
  State<AddFavoriteDialog> createState() => _AddFavoriteDialogState();
}

class _AddFavoriteDialogState extends State<AddFavoriteDialog> {
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
    // Usando a mesma lógica de escala para consistência visual
    const double designWidth = 1920.0;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double scaleFactor = screenWidth / designWidth;

    final double iconSize = 150 * scaleFactor;
    final double borderWidth = 6 * scaleFactor;
    final double gridPadding = 30 * scaleFactor;
    final double gridSpacing = 24 * scaleFactor;

    return AlertDialog(
      backgroundColor: const Color(0xFF0A1045).withOpacity(0.95),
      title: const Text('Adicionar aos Favoritos', style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: double.maxFinite, // Ocupa toda a largura disponível no diálogo
        child: FutureBuilder<List<AppInfo>>(
          future: _appsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhum aplicativo encontrado.', style: TextStyle(color: Colors.white)));
            }

            final apps = snapshot.data!;
            return GridView.builder(
              padding: EdgeInsets.all(gridPadding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6, // Menos colunas para caber bem no diálogo
                crossAxisSpacing: gridSpacing,
                mainAxisSpacing: gridSpacing,
              ),
              itemCount: apps.length,
              itemBuilder: (context, index) {
                final app = apps[index];
                return AppIcon(
                  app: app,
                  onTap: () => Navigator.of(context).pop(app), // Retorna o app selecionado
                  size: iconSize,
                  borderWidth: borderWidth,
                  showAppName: true, // Ativa a exibição do nome
                );
              },
            );
          },
        ),
      ),
      actions: [TextButton(child: const Text('Cancelar', style: TextStyle(color: Colors.white)), onPressed: () => Navigator.of(context).pop())],
    );
  }
}