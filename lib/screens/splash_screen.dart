import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/pace_weather_logo.dart';

/// Tela 1: Carregamento (Splash Screen)
/// Fundo branco com formas orgânicas amarela e azul nos cantos e logo centralizado.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Transição automática para a Home após 2.5 segundos de simulação de carregamento
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Forma orgânica geométrica amarela no canto superior direito
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: const BoxDecoration(
                color: AppColors.primaryYellow,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 2. Forma orgânica geométrica azul no canto inferior esquerdo
          Positioned(
            bottom: -90,
            left: -80,
            child: Container(
              width: 290,
              height: 290,
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 3. Logotipo centralizado PaceWeather
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/home');
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PaceWeatherLogo(
                    iconSize: 130,
                    fontSize: 40,
                    showText: true,
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
