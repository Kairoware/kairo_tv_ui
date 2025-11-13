import 'package:flutter/material.dart';
import 'package:kairo_tv_ui/wallpaper_provider.dart';
import 'package:kairo_tv_ui/theme_provider.dart';
import 'package:provider/provider.dart';

class WallpaperSelectionDialog extends StatefulWidget {
  const WallpaperSelectionDialog({super.key});

  @override
  State<WallpaperSelectionDialog> createState() => _WallpaperSelectionDialogState();
}

class _WallpaperSelectionDialogState extends State<WallpaperSelectionDialog> {
  @override
  Widget build(BuildContext context) {
    final wallpaperProvider = Provider.of<WallpaperProvider>(context);
    final availableWallpapers = WallpaperProvider.availableWallpapers;

    return AlertDialog(
      title: const Text('Escolha um Papel de Parede', style: TextStyle(color: Colors.black)),
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(16.0),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7, // Ocupa 70% da largura da tela
        height: MediaQuery.of(context).size.height * 0.7, // Ocupa 70% da altura da tela
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 16 / 9,
          ),
          itemCount: availableWallpapers.length,
          itemBuilder: (context, index) {
            final wallpaper = availableWallpapers[index];
            final isSelected = wallpaperProvider.selectedWallpaper.id == wallpaper.id;

            return _WallpaperThumbnail(
              wallpaper: wallpaper,
              isSelected: isSelected,
              autofocus: index == 0, // Foca o primeiro item automaticamente
              onTap: () {
                wallpaperProvider.setWallpaper(wallpaper);
                // Usar setState para reconstruir e mostrar a nova seleção antes de fechar
                setState(() {});
                // Um pequeno atraso para o usuário ver a seleção antes do diálogo fechar
                Future.delayed(const Duration(milliseconds: 200), () {
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                });
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Fechar',
            style: TextStyle(color: Colors.black87),
          )),
      ],
    );
  }
}

// Widget interno para gerenciar o foco de cada miniatura
class _WallpaperThumbnail extends StatefulWidget {
  final AppBackground wallpaper;
  final bool isSelected;
  final bool autofocus;
  final VoidCallback onTap;

  const _WallpaperThumbnail({
    required this.wallpaper,
    required this.isSelected,
    required this.onTap,
    this.autofocus = false,
  });

  @override
  State<_WallpaperThumbnail> createState() => _WallpaperThumbnailState();
}

class _WallpaperThumbnailState extends State<_WallpaperThumbnail> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (mounted) {
        setState(() => _isFocused = _focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return InkWell(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onTap: widget.onTap,
      focusColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            widget.wallpaper.build(context),
            // Adiciona uma borda se estiver selecionado ou focado
            if (widget.isSelected || _isFocused)
              // A borda do item selecionado agora é cinza para contrastar com o fundo branco
              Container(decoration: BoxDecoration(border: Border.all(color: _isFocused ? themeProvider.selectedColor : Colors.grey.shade700, width: 4.0), borderRadius: BorderRadius.circular(8.0))),
          ],
        ),
      ),
    );
  }
}