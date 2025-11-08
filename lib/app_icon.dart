import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';

// Widget para os ícones dos apps, agora com estado para o foco
class AppIcon extends StatefulWidget {
  final AppInfo? app;
  final VoidCallback onTap;
  final Widget? customIcon; // Para o ícone da gaveta
  final bool autoFocus;
  final double size;
  final double borderWidth;

  const AppIcon({
    super.key,
    this.app,
    required this.onTap,
    this.customIcon,
    this.autoFocus = false,
    required this.size,
    required this.borderWidth,
  });

  @override
  State<AppIcon> createState() => _AppIconState();
}

class _AppIconState extends State<AppIcon> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (mounted) {
        setState(() {
          _isFocused = _focusNode.hasFocus;
        });
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
    // O raio do border é proporcional ao tamanho do ícone
    final double borderRadius = widget.size * (30 / 174);

    return InkWell(
      focusNode: _focusNode,
      onTap: widget.onTap,
      autofocus: widget.autoFocus,
      focusColor: Colors.transparent, // A cor do foco é controlada pela borda
      borderRadius: BorderRadius.circular(borderRadius),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: const Color(0xFFFCFDFF),
          borderRadius: BorderRadius.circular(borderRadius),
          // Adiciona a borda azul quando o item está focado
          border: _isFocused
              ? Border.all(color: const Color(0xFF02083A), width: widget.borderWidth)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        // Anima a escala do ícone quando focado
        transform: _isFocused ? (Matrix4.identity()..scale(1.1)) : Matrix4.identity(),
        transformAlignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius * 0.66),
          child: widget.customIcon != null
              ? Center(child: widget.customIcon) // Garante que o ícone customizado seja centralizado
              : (widget.app?.icon != null // Se for um app com ícone...
                  ? Center(
                      child: Image.memory(
                        widget.app!.icon!,
                        width: widget.size * 0.5, // O ícone ocupará 50% do card
                        height: widget.size * 0.5,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Center(child: Icon(Icons.error, size: widget.size * 0.4))), // Fallback de erro
        ),
      ),
    );
  }
}