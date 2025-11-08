import 'dart:async';
import 'package:flutter/material.dart';

class WallpaperSlideshow extends StatefulWidget {
  const WallpaperSlideshow({super.key});

  @override
  State<WallpaperSlideshow> createState() => _WallpaperSlideshowState();
}

class _WallpaperSlideshowState extends State<WallpaperSlideshow> {
  // Lista de gradientes para o fundo
  final List<Gradient> _gradients = [
    const LinearGradient(
      colors: [Color(0xFF005AA7), Color(0xFFFFFDE4)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xFF42275a), Color(0xFF734b6d)],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ),
    const LinearGradient(
      colors: [Color(0xFFff6e7f), Color(0xFFbfe9ff)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    const LinearGradient(
      colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Inicia o timer para trocar de imagem a cada 10 segundos
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
    _timer?.cancel(); // Cancela o timer para evitar memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 2), // Duração da transição de fade
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Container(
        key: ValueKey<int>(_currentIndex),
        decoration: BoxDecoration(
          gradient: _gradients[_currentIndex],
        ),
      ),
    );
  }
}