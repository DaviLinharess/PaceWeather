import 'package:flutter/material.dart';
import '../models/workout_model.dart';
import '../theme/app_colors.dart';

/// Card de Treino estilizado fielmente ao protótipo da tela "Meus Treinos"
/// Fundo amarelo vibrante, badge superior com ícone do tipo, métrica e botão de play.
class WorkoutCard extends StatelessWidget {
  final WorkoutModel workout;
  final VoidCallback? onPlay;

  const WorkoutCard({
    super.key,
    required this.workout,
    this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryYellow,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Badge superior com o ícone da categoria (círculo branco)
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              workout.icon,
              size: 20,
              color: AppColors.dark,
            ),
          ),

          const SizedBox(height: 12),

          // 2. Título do Treino
          Text(
            workout.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.dark,
              height: 1.15,
            ),
          ),

          const SizedBox(height: 8),

          // 3. Métrica (Distância ou Repetições)
          Text(
            workout.metric,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.dark,
            ),
          ),

          const Spacer(),

          // 4. Botão de Iniciar / Play no canto inferior direito
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: onPlay,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow_outlined,
                  size: 24,
                  color: AppColors.dark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
