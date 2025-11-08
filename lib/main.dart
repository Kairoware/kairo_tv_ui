import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const TVLauncherApp());
}
class TVLauncherApp extends StatelessWidget {
  const TVLauncherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kairo TV',
      debugShowCheckedModeBanner: false,
      // Tema principal do app
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black, // Cor de fundo durante o carregamento
        fontFamily: 'Inter',
      ),
      home: HomeScreen(),
    );
  }
}