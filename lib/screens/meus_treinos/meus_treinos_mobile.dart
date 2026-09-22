import 'package:flutter/material.dart';
import '../../models/workout_model.dart';
import '../../theme/app_colors.dart';
import '../../widgets/filter_pill.dart';
import '../../widgets/pace_weather_logo.dart';
import '../../widgets/workout_card.dart';

/// Layout otimizado para telas menores (< 600px - smartphones em modo retrato)
/// Estrutura estrita com 3 seções visuais utilizando Column, Row, Expanded, Padding e SizedBox.
class MeusTreinosMobileLayout extends StatelessWidget {
  final List<WorkoutModel> workouts;
  final WorkoutCategory selectedCategory;
  final ValueChanged<WorkoutCategory> onSelectCategory;
  final VoidCallback onHomePressed;
  final VoidCallback onAddWorkoutPressed;

  const MeusTreinosMobileLayout({
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
        // SEÇÃO 1: CABEÇALHO COM NAVEGAÇÃO E LOGOTIPO
        // ==========================================
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.home_outlined, size: 30, color: AppColors.dark),
                onPressed: onHomePressed,
                tooltip: 'Início',
              ),
              const PaceWeatherLogo(
                iconSize: 72,
                fontSize: 24,
                showText: true,
              ),
              IconButton(
                icon: const Icon(Icons.person_outline, size: 30, color: AppColors.dark),
                onPressed: () {},
                tooltip: 'Perfil',
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // ==========================================
        // SEÇÃO 2: BARRA DE FILTROS DE CATEGORIA
        // ==========================================
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FilterPill(
                label: 'ALL',
                isSelected: selectedCategory == WorkoutCategory.all,
                onTap: () => onSelectCategory(WorkoutCategory.all),
              ),
              const SizedBox(width: 8),
              FilterPill(
                icon: Icons.directions_run,
                isSelected: selectedCategory == WorkoutCategory.running,
                onTap: () => onSelectCategory(WorkoutCategory.running),
              ),
              const SizedBox(width: 8),
              FilterPill(
                icon: Icons.timer_outlined,
                isSelected: selectedCategory == WorkoutCategory.intervals,
                onTap: () => onSelectCategory(WorkoutCategory.intervals),
              ),
              const SizedBox(width: 8),
              FilterPill(
                icon: Icons.favorite_border,
                isSelected: selectedCategory == WorkoutCategory.recovery,
                onTap: () => onSelectCategory(WorkoutCategory.recovery),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ==========================================
        // SEÇÃO 3: GRADE RESPONSIVA DE CARDS DE TREINO
        // ==========================================
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.82,
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
            ),
          ),
        ),
      ],
    );
  }
}
