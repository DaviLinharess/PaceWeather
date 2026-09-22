import 'package:flutter/material.dart';

/// Widget do logotipo oficial do PaceWeather.
/// Carrega a imagem oficial enviada pelo usuário (assets/images/logo.png).
class PaceWeatherLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final double iconSize;
  final double fontSize;
  final bool showText;

  const PaceWeatherLogo({
    super.key,
    this.width,
    this.height,
    this.iconSize = 100,
    this.fontSize = 32,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width ?? (iconSize * 1.5);
    final effectiveHeight = height ?? iconSize;

    return Image.asset(
      'assets/images/logo.png',
      width: effectiveWidth,
      height: effectiveHeight,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback caso a imagem não esteja no bundle
        return Icon(
          Icons.directions_run,
          size: effectiveHeight * 0.8,
          color: const Color(0xFF007AE5),
        );
      },
    );
  }
}
