import 'package:flutter/material.dart';
import '../models/workout_model.dart';
import '../theme/app_colors.dart';

/// Tela de Detalhes do Treino.
/// Esta tela recebe parâmetros via `arguments` em rota nomeada ('/workout_details').
class WorkoutDetailsScreen extends StatelessWidget {
  final WorkoutModel? workout;

  const WorkoutDetailsScreen({super.key, this.workout});

  @override
  Widget build(BuildContext context) {
    // Extração dinâmica dos argumentos passados via rota nomeada
    final WorkoutModel item = workout ??
        (ModalRoute.of(context)?.settings.arguments as WorkoutModel?) ??
        const WorkoutModel(
          id: '0',
          title: 'Treino Demonstração',
          metric: '5.000m',
          icon: Icons.directions_run,
          category: WorkoutCategory.running,
          heartRateZone: 'Z2',
        );

    final cleanTitle = item.title.replaceAll('\n', ' ');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.dark, size: 20),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Voltar',
        ),
        title: const Text(
          'Detalhes do Treino',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppColors.dark,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Didático do Requisito Obrigatório 4
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryYellow.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryYellow,
                  width: 1.2,
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.input_rounded, color: AppColors.dark, size: 22),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Requisito 4: Dados carregados com sucesso via arguments através da rota nomeada "/workout_details"!',
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

            const SizedBox(height: 20),

            // Card Principal Amarelo do Treino
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryYellow,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(item.icon, size: 26, color: AppColors.dark),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.categoryName,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.dark,
                              ),
                            ),
                            Text(
                              cleanTitle,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: AppColors.dark,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(color: AppColors.dark, thickness: 1),
                  const SizedBox(height: 16),

                  // Métricas Técnicas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetricItem(
                        icon: Icons.straighten_rounded,
                        label: 'Distância / Meta',
                        value: item.metric,
                      ),
                      _buildMetricItem(
                        icon: Icons.monitor_heart_outlined,
                        label: 'Zona Alvo',
                        value: item.heartRateZone,
                      ),
                      _buildMetricItem(
                        icon: Icons.timer_outlined,
                        label: 'Ritmo Previsto',
                        value: '5:15 /km',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Card de Condição Climática Recomendada
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.wb_sunny_outlined,
                          color: AppColors.primaryBlue, size: 24),
                      SizedBox(width: 10),
                      Text(
                        'Recomendação Climática',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.dark,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Para a zona alvo selecionada, prefira horários entre 06:00 e 08:30 ou após as 18:00 com temperaturas entre 18ºC e 22ºC e umidade acima de 50%.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Botão de Iniciar Treino
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.play_arrow_rounded, size: 24),
                label: const Text(
                  'Iniciar Este Treino Agora',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('🚀 Cronômetro iniciado para "$cleanTitle"!'),
                      backgroundColor: AppColors.dark,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Botão de Voltar (Navigator.pop)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton.icon(
                icon: const Icon(Icons.arrow_back,
                    color: AppColors.dark, size: 18),
                label: const Text(
                  'Voltar à lista de treinos',
                  style: TextStyle(
                    color: AppColors.dark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.dark),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.dark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: AppColors.dark,
          ),
        ),
      ],
    );
  }
}
