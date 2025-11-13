import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kairo_tv_ui/wallpaper_provider.dart';
import 'package:provider/provider.dart';

class WallpaperSlideshow extends StatefulWidget {
  const WallpaperSlideshow({super.key});

  @override
  State<WallpaperSlideshow> createState() => _WallpaperSlideshowState();
}

class _WallpaperSlideshowState extends State<WallpaperSlideshow> {
  // Lista de gradientes para o slideshow
  final List<Gradient> _gradients = [
    const LinearGradient(colors: [Color(0xFF005AA7), Color(0xFFFFFDE4)], begin: Alignment.topLeft, end: Alignment.bottomRight),
    const LinearGradient(colors: [Color(0xFF42275a), Color(0xFF734b6d)], begin: Alignment.bottomLeft, end: Alignment.topRight),
    const LinearGradient(colors: [Color(0xFFff6e7f), Color(0xFFbfe9ff)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    const LinearGradient(colors: [Color(0xFF11998e), Color(0xFF38ef7d)], begin: Alignment.centerLeft, end: Alignment.centerRight),
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel(); // Cancela qualquer timer existente
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _gradients.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ouve as mudanças no WallpaperProvider
    final wallpaperProvider = Provider.of<WallpaperProvider>(context);
    final selectedWallpaper = wallpaperProvider.selectedWallpaper;

    // Se o papel de parede selecionado não for o slideshow, cancela o timer.
    // Se for, e o timer não estiver ativo, inicia-o.
    if (selectedWallpaper is! SlideshowBackground) {
      _timer?.cancel();
      _timer = null;
    } else if (_timer == null) {
      _startTimer();
    }

    return AnimatedSwitcher(
      duration: const Duration(seconds: 2), // Duração da transição de fade
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: SizedBox.expand(
        // A chave muda para acionar a animação.
        // Se for slideshow, a chave é o índice do gradiente.
        // Se for estático, a chave é o ID do papel de parede.
        key: ValueKey(selectedWallpaper is SlideshowBackground ? _currentIndex : selectedWallpaper.id),
        child: selectedWallpaper is SlideshowBackground
            ? Container(decoration: BoxDecoration(gradient: _gradients[_currentIndex]))
            : selectedWallpaper.build(context),
      ),
    );
  }
}