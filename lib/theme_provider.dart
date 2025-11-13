import 'package:flutter/material.dart';
import 'settings_service.dart';

class ThemeProvider extends ChangeNotifier {
  final SettingsService _settingsService;
  // Cor de destaque padrão
  Color _selectedColor = const Color(0xFF02083A);

  ThemeProvider(this._settingsService) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _selectedColor = await _settingsService.loadThemeColor() ?? _selectedColor;
    notifyListeners();
  }

  Color get selectedColor => _selectedColor;

  Future<void> updateSelectedColor(Color newColor) async {
    if (_selectedColor != newColor) {
      _selectedColor = newColor;
      await _settingsService.saveThemeColor(newColor);
      notifyListeners(); // Notifica os widgets que a cor mudou
    }
  }
}