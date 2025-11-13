import 'package:flutter/material.dart';
import 'settings_service.dart';

// Uma classe base para representar diferentes tipos de fundos.
abstract class AppBackground {
  final String id;
  const AppBackground(this.id);

  Widget build(BuildContext context);
}

// Representa um fundo com gradiente.
class GradientBackground extends AppBackground {
  final Gradient gradient;
  const GradientBackground(String id, this.gradient) : super(id);

  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(gradient: gradient));
  }
}

// Representa um fundo com uma imagem de asset.
class ImageBackground extends AppBackground {
  final String assetPath;
  const ImageBackground(String id, this.assetPath) : super(id);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}

// Representa o slideshow de gradientes dinâmico.
class SlideshowBackground extends AppBackground {
  const SlideshowBackground(String id) : super(id);

  @override
  Widget build(BuildContext context) {
    // Este widget é apenas para a miniatura na tela de seleção.
    // Mostra um gradiente representativo com um ícone.
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: const Center(child: Icon(Icons.collections, color: Colors.white, size: 40)),
    );
  }
}

class WallpaperProvider extends ChangeNotifier {
  final SettingsService _settingsService;
  // Lista de papéis de parede disponíveis.
  // Adicione suas imagens na pasta 'assets/images/' e declare-as no pubspec.yaml
  static final List<AppBackground> availableWallpapers = [
    const SlideshowBackground('slideshow'), // Opção do slideshow adicionada
    const ImageBackground('img1', 'assets/images/wallpaper1.jpg'),
    const ImageBackground('img2', 'assets/images/wallpaper2.jpg'),
    const GradientBackground('grad1', LinearGradient(colors: [Color(0xFF005AA7), Color(0xFFFFFDE4)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
    const GradientBackground('grad2', LinearGradient(colors: [Color(0xFF42275a), Color(0xFF734b6d)], begin: Alignment.bottomLeft, end: Alignment.topRight)),
  ];

  AppBackground _selectedWallpaper = availableWallpapers.first; // Padrão

  WallpaperProvider(this._settingsService) {
    _loadWallpaper();
  }

  Future<void> _loadWallpaper() async {
    final wallpaperId = await _settingsService.loadWallpaperId();
    _selectedWallpaper = availableWallpapers.firstWhere((w) => w.id == wallpaperId, orElse: () => availableWallpapers.first);
    notifyListeners();
  }

  AppBackground get selectedWallpaper => _selectedWallpaper;

  Future<void> setWallpaper(AppBackground newWallpaper) async {
    _selectedWallpaper = newWallpaper;
    await _settingsService.saveWallpaperId(newWallpaper.id);
    notifyListeners();
  }
}