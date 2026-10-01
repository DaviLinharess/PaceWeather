import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Tela de Perfil do Atleta (Aba 3 da BottomNavigationBar).
/// Demonstração de preservação de estado da aba e seção independente de navegação.
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header do Perfil com Avatar
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryYellow,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'DL',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppColors.dark,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Davi Linhares',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppColors.dark,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Corredor Intermediário • Meia Maratona',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Banner da Aba 3
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryBlue.withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.tab_rounded,
                        color: AppColors.primaryBlue, size: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Requisito 3: Aba 3 do BottomNavigationBar. Ao alternar entre as abas, a pilha e o estado desta tela são preservados.',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.dark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'ESTATÍSTICAS DA SEMANA',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 12),

              // Cards de Métricas
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.directions_run_rounded,
                      title: 'Distância',
                      value: '38.4 km',
                      color: AppColors.primaryYellow,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.speed_rounded,
                      title: 'Pace Médio',
                      value: "5'14\" /km",
                      color: AppColors.lightBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.timer_outlined,
                      title: 'Tempo Total',
                      value: '3h 18min',
                      color: AppColors.lightBlue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.local_fire_department_outlined,
                      title: 'Calorias',
                      value: '2.450 kcal',
                      color: AppColors.primaryYellow,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'METAS & RECORDES PESSOAIS',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.emoji_events_outlined,
                          color: AppColors.dark),
                      title: Text('Melhor 5K: 23min 42s',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Registrado em clima frio (17ºC)'),
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.emoji_events_outlined,
                          color: AppColors.dark),
                      title: Text('Melhor 10K: 49min 10s',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Treino intervalado recente'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: color, width: 5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.dark, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: AppColors.dark,
            ),
          ),
        ],
      ),
    );
  }
}
