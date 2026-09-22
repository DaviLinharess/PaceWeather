import 'package:flutter/material.dart';
import '../../models/workout_model.dart';
import '../../theme/app_colors.dart';
import '../../widgets/filter_pill.dart';
import '../../widgets/pace_weather_logo.dart';
import '../../widgets/workout_card.dart';

/// Layout adaptado para telas amplas (>= 600px - tablets, monitores e smartphones em modo paisagem)
/// Reorganiza as 3 seções utilizando Row, Column e Expanded com grid adaptativo de 3 a 4 colunas.
class MeusTreinosDesktopLayout extends StatelessWidget {
  final List<WorkoutModel> workouts;
  final WorkoutCategory selectedCategory;
  final ValueChanged<WorkoutCategory> onSelectCategory;
  final VoidCallback onHomePressed;
  final VoidCallback onAddWorkoutPressed;

  const MeusTreinosDesktopLayout({
    super.key,
    required this.workouts,
    required this.selectedCategory,
    required this.onSelectCategory,
    required this.onHomePressed,
    required this.onAddWorkoutPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ==========================================
        // SEÇÃO 1: CABEÇALHO EXPANDIDO COM LOGOTIPO
        // ==========================================
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.15)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.home_outlined, size: 28, color: AppColors.dark),
                    onPressed: onHomePressed,
                    tooltip: 'Voltar ao Início',
                  ),
                  const SizedBox(width: 16),
                  const PaceWeatherLogo(
                    iconSize: 55,
                    fontSize: 22,
                    showText: true,
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text(
                      'Novo Treino',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: onAddWorkoutPressed,
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.person_outline, size: 28, color: AppColors.dark),
                    onPressed: () {},
                    tooltip: 'Meu Perfil',
                  ),
                ],
              ),
            ],
          ),
        ),

        // ==========================================
        // SEÇÃO 2: BARRA DE FILTROS ALINHADA
        // ==========================================
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Row(
            children: [
              const Text(
                'Filtrar por:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 20),
              FilterPill(
                label: 'ALL',
                isSelected: selectedCategory == WorkoutCategory.all,
                onTap: () => onSelectCategory(WorkoutCategory.all),
              ),
              const SizedBox(width: 12),
              FilterPill(
                icon: Icons.directions_run,
                isSelected: selectedCategory == WorkoutCategory.running,
                onTap: () => onSelectCategory(WorkoutCategory.running),
              ),
              const SizedBox(width: 12),
              FilterPill(
                icon: Icons.timer_outlined,
                isSelected: selectedCategory == WorkoutCategory.intervals,
                onTap: () => onSelectCategory(WorkoutCategory.intervals),
              ),
              const SizedBox(width: 12),
              FilterPill(
                icon: Icons.favorite_border,
                isSelected: selectedCategory == WorkoutCategory.recovery,
                onTap: () => onSelectCategory(WorkoutCategory.recovery),
              ),
              const Spacer(),
              // Badge contextual de clima para treino ao ar livre
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.cloud_outlined, color: AppColors.primaryBlue, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Clima Atual: 20ºC (Nublado - Ótimo para correr)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.dark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ==========================================
        // SEÇÃO 3: GRADE RESPONSIVA AMPLA (3 a 4 COLUNAS)
        // ==========================================
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: LayoutBuilder(
              builder: (context, gridConstraints) {
                // Ajusta entre 3 e 4 colunas dependendo da largura do monitor/tablet
                final int columnCount = gridConstraints.maxWidth > 900 ? 4 : 3;

                return GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 8, bottom: 32),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columnCount,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    final workout = workouts[index];
                    return WorkoutCard(
                      workout: workout,
                      onPlay: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Iniciando ${workout.title.replaceAll('\n', ' ')} (${workout.metric})'),
                            duration: const Duration(seconds: 2),
                            backgroundColor: AppColors.dark,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
