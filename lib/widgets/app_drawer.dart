import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'pace_weather_logo.dart';

/// Drawer Lateral do PaceWeather.
/// 1. Configurações: navega com `pushNamed` para '/settings'
/// 2. Sobre: exibe um modal/pop-up (`showDialog`)
/// 3. Logout: navega com `pushReplacementNamed` para '/login'
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  color: AppColors.primaryYellow, size: 28),
              SizedBox(width: 10),
              Text(
                'Sobre o App',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: AppColors.dark,
                ),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: PaceWeatherLogo(
                  iconSize: 50,
                  fontSize: 22,
                  showText: true,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'PaceWeather v1.0.0',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: AppColors.dark,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Aplicativo desenvolvido para corredores de rua, integrando planejamento de treinos ao monitoramento climático ideal.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 14),
              Divider(),
              SizedBox(height: 8),
              Text(
                'Aluno: Davi Linhares',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
              Text(
                'Disciplina: Desenvolvimento para Dispositivos Móveis',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryYellow,
                foregroundColor: AppColors.dark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Entendi',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Cabeçalho Customizado do Usuário
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
            decoration: const BoxDecoration(
              color: AppColors.primaryYellow,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'DL',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.dark,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.dark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'ATLETA',
                        style: TextStyle(
                          color: AppColors.primaryYellow,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'Davi Linhares',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.dark,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'davi@paceweather.com',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.dark,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Item 1: Configurações (Navegação com push)
          ListTile(
            leading: const Icon(Icons.settings_outlined,
                color: AppColors.dark, size: 24),
            title: const Text(
              'Configurações',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.dark,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: Colors.grey),
            onTap: () {
              Navigator.of(context).pop(); // Fecha o Drawer
              Navigator.of(context, rootNavigator: true).pushNamed('/settings');
            },
          ),

          const Divider(indent: 20, endIndent: 20),

          // Item 2: Sobre (Abertura de Modal / Dialog)
          ListTile(
            leading: const Icon(Icons.info_outline_rounded,
                color: AppColors.dark, size: 24),
            title: const Text(
              'Sobre o PaceWeather',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.dark,
              ),
            ),
            trailing: const Icon(Icons.open_in_new_rounded,
                size: 16, color: Colors.grey),
            onTap: () {
              Navigator.of(context).pop(); // Fecha o Drawer
              _showAboutDialog(context);
            },
          ),

          const Spacer(),

          const Divider(indent: 20, endIndent: 20),

          // Item 3: Logout (Navegação com pushReplacement)
          ListTile(
            leading: const Icon(Icons.logout_rounded,
                color: Colors.redAccent, size: 24),
            title: const Text(
              'Sair da Conta (Logout)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.redAccent,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop(); // Fecha o Drawer
              // pushReplacementNamed para a tela de login removendo o shell da pilha
              Navigator.of(context, rootNavigator: true)
                  .pushReplacementNamed('/login');
            },
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
