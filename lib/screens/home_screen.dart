import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/pace_weather_logo.dart';
import 'meus_treinos/meus_treinos_screen.dart';
import 'novo_treino_screen.dart';

/// Tela 2: Home
/// Exibe a logo superior e o card meteorológico com boas-vindas "Bem-vindo, Davi !",
/// informações climáticas (OpenWeather API simulation) e botões "Treinar" e "Novo Treino".
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
            // Seção Superior: Logotipo PaceWeather
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

            // Seção Inferior: Card com Cabeçalho Amarelo e Bloco Meteorológico Azul
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
                    // Faixa de Saudação
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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

                    // Card Azul com os Dados Meteorológicos
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                            // Bloco de Informações Meteorológicas
                            const Column(
                              children: [
                                Text(
                                  'Nublado',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.dark,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Temperatura Atual:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.dark,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '20ºC',
                                  style: TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.dark,
                                    height: 1.1,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Condição do Tempo:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.dark,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Ventos Fortes',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.dark,
                                  ),
                                ),
                              ],
                            ),

                            // Botões de Ação Inferiores: "Treinar" e "Novo Treino"
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.dark,
                                      foregroundColor: Colors.white,
                                      elevation: 4,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const MeusTreinosScreen(),
                                        ),
                                      );
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
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const NovoTreinoScreen(),
                                        ),
                                      );
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
