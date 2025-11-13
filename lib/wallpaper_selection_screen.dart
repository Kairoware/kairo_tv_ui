import 'package:flutter/material.dart';
import 'package:kairo_tv_ui/wallpaper_provider.dart';
import 'package:provider/provider.dart';

class WallpaperSelectionScreen extends StatelessWidget {
  const WallpaperSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wallpaperProvider = Provider.of<WallpaperProvider>(context, listen: false);
    final availableWallpapers = WallpaperProvider.availableWallpapers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolher Papel de Parede'),
        backgroundColor: Colors.black.withOpacity(0.3),
      ),
      backgroundColor: const Color(0xFF0A1045),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 colunas
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 16 / 9, // Proporção de TV
        ),
        itemCount: availableWallpapers.length,
        itemBuilder: (context, index) {
          final wallpaper = availableWallpapers[index];
          return GestureDetector(
            onTap: () {
              wallpaperProvider.setWallpaper(wallpaper);
              Navigator.of(context).pop(); // Volta para a tela de configurações
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Constrói a miniatura do papel de parede
                  wallpaper.build(context),
                  // Adiciona uma borda se for o papel de parede selecionado
                  if (wallpaperProvider.selectedWallpaper.id == wallpaper.id)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blueAccent,
                          width: 4.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}