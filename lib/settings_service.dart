import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Uma classe de serviço para salvar e carregar as configurações do usuário.
class SettingsService {
  static const _themeColorKey = 'theme_color';
  static const _wallpaperIdKey = 'wallpaper_id';
  static const _favoriteAppsKey = 'favorite_apps';

  Future<void> saveThemeColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeColorKey, color.value);
  }

  Future<Color?> loadThemeColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt(_themeColorKey);
    return colorValue != null ? Color(colorValue) : null;
  }

  Future<void> saveWallpaperId(String wallpaperId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_wallpaperIdKey, wallpaperId);
  }

  Future<String?> loadWallpaperId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_wallpaperIdKey);
  }

  Future<void> saveFavoriteApps(List<String> packageNames) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoriteAppsKey, packageNames);
  }

  Future<List<String>> loadFavoriteApps() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteAppsKey) ?? [];
  }
}