import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'wallpaper_provider.dart';
import 'settings_service.dart';

void main() {
  final settingsService = SettingsService();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(settingsService)),
        ChangeNotifierProvider(create: (_) => WallpaperProvider(settingsService)),
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kairo TV Launcher',
      debugShowCheckedModeBanner: false,
      // Tema principal do app
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black, // Cor de fundo durante o carregamento
        fontFamily: 'Inter',
      ),
      home: const HomeScreen(),
    );
  }
}