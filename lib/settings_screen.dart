import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'wallpaper_selection_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Helper para construir os itens da lista de forma consistente
  // Movido para dentro da classe State para manter a consistência
  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap, // Alterado para permitir onTap nulo (desativado)
  }) {
    return ListTile(
      leading: Icon(icon, size: 30, color: Colors.black87),
      title: Text(title, style: const TextStyle(color: Colors.black, fontSize: 18)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.black.withOpacity(0.7))),
      onTap: onTap,
      enabled: onTap != null, // Desativa o ListTile se onTap for nulo
      focusColor: Colors.black.withOpacity(0.1),
    );
  }

  // Função para mostrar o diálogo de seleção de cores
  void _showColorPickerDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    Color pickerColor = themeProvider.selectedColor;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escolha uma cor de destaque'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (color) => pickerColor = color,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Salvar'),
            onPressed: () {
              themeProvider.updateSelectedColor(pickerColor); // Não precisa de await aqui
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black), // Garante que o botão de voltar seja preto
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSettingsTile(
            context: context,
            icon: Icons.palette_outlined,
            title: 'Temas',
            subtitle: 'Mude as cores e o estilo do launcher',
            onTap: () => _showColorPickerDialog(context),
          ),
      
          _buildSettingsTile(
            context: context,
            icon: Icons.wallpaper,
            title: 'Escolher Papel de Parede',
            subtitle: 'Selecione um fundo da coleção',
            onTap: () {
              showDialog(context: context, builder: (context) {
                return const WallpaperSelectionDialog();
              });
            },
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.gradient,
            title: 'Escolher Gradiente',
            subtitle: 'Funcionalidade em desenvolvimento',
            onTap: null, // Define onTap como nulo para desativar
          ),
          const Divider(color: Colors.white24),
          _buildSettingsTile(
            context: context,
            icon: Icons.info_outline,
            title: 'Sobre o Launcher',
            subtitle: 'Veja informações sobre o aplicativo',
            onTap: () {
              showAboutDialog(context: context, applicationName: 'Kairo TV Launcher', applicationVersion: '1.2.0', applicationLegalese: '© 2024 KairoWare', children: [const Text('Um launcher simples e elegante para sua Android TV.')]);
            },
          ),
        ],
      ),
    );
  }
}