import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/pace_weather_logo.dart';
import 'main_navigation_shell.dart';

// Tela Home do PaceWeather
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Logotipo Oficial PaceWeather
            const Expanded(
              flex: 4,
              child: Center(
                child: PaceWeatherLogo(
                  iconSize: 110,
                  fontSize: 36,
                  showText: true,
                ),
              ),
            ),

            // Faixa Amarela com "olá" e Bloco Azul da API do Clima
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.primaryYellow,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                ),
                child: Column(
                  children: [
                    // parte do "ola"
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Bem-vindo, Davi !',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppColors.dark,
                          ),
                        ),
                      ),
                    ),

                    // Card Azul com a indicação da API do Clima
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(6, 0, 6, 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 24),
                        decoration: const BoxDecoration(
                          color: AppColors.lightBlue,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                            bottomLeft: Radius.circular(36),
                            bottomRight: Radius.circular(36),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Bloco reservado para a futura integração da API externa
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 28),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  width: 1.5,
                                ),
                              ),
                              child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.cloud_outlined,
                                    size: 48,
                                    color: AppColors.dark,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'API do Clima aparecerá aqui',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.dark,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Integração futura com OpenWeather API',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.dark,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Botões de Navegação: "Treinar" e "Novo Treino"
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.dark,
                                      foregroundColor: Colors.white,
                                      elevation: 4,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () {
                                      // Alterna para a aba 1 (Treinos) no BottomNavigationBar
                                      MainNavigationShell.switchTab(context, 1);
                                    },
                                    child: const Text(
                                      'Treinar',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.dark,
                                      foregroundColor: Colors.white,
                                      elevation: 4,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () async {
                                      // REQUISITO 5: Abre rota nomeada e aguarda resultado retornado via Navigator.pop
                                      final result = await Navigator.of(context)
                                          .pushNamed('/novo_treino');

                                      if (result != null &&
                                          result is Map &&
                                          context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Requisito 5: Treino "${result['title']}" salvo! (Retornado via Navigator.pop)',
                                            ),
                                            backgroundColor: AppColors.dark,
                                            duration:
                                                const Duration(seconds: 3),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text(
                                      'Novo Treino',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
