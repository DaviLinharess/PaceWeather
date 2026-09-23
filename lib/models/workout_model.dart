import 'package:flutter/material.dart';

/// Categorias de treino
enum WorkoutCategory {
  all,
  running, // Longão
  intervals, // Intervalado
  recovery, // Regenerativo
}

extension WorkoutCategoryExtension on WorkoutCategory {
  String get displayName {
    switch (this) {
      case WorkoutCategory.all:
        return 'Todos';
      case WorkoutCategory.running:
        return 'Longão';
      case WorkoutCategory.intervals:
        return 'Intervalado';
      case WorkoutCategory.recovery:
        return 'Regenerativo';
    }
  }
}

/// Modelo de dados representando um treino no PaceWeather
class WorkoutModel {
  final String id;
  final String title;
  final String metric; // Ex: '10.000m' ou '10x 400m'
  final IconData icon;
  final WorkoutCategory category;
  final String heartRateZone; // Ex: 'Z2', 'Z5'

  const WorkoutModel({
    required this.id,
    required this.title,
    required this.metric,
    required this.icon,
    required this.category,
    this.heartRateZone = 'Z2',
  });

  String get categoryName => category.displayName;

  /// Lista mockada estática exatamente conforme o protótipo visual
  static List<WorkoutModel> getMockWorkouts() {
    return const [
      WorkoutModel(
        id: '1',
        title: 'Treino\nLongo',
        metric: '10.000m',
        icon: Icons.directions_run,
        category: WorkoutCategory.running,
        heartRateZone: 'Z2',
      ),
      WorkoutModel(
        id: '2',
        title: 'Treino\nRegenerativo',
        metric: '2.000m',
        icon: Icons.favorite_border,
        category: WorkoutCategory.recovery,
        heartRateZone: 'Z1',
      ),
      WorkoutModel(
        id: '3',
        title: 'Treino\nIntervalado',
        metric: '10x 400m',
        icon: Icons.timer_outlined,
        category: WorkoutCategory.intervals,
        heartRateZone: 'Z4',
      ),
      WorkoutModel(
        id: '4',
        title: 'Treino\nLongo',
        metric: '8.000m',
        icon: Icons.directions_run,
        category: WorkoutCategory.running,
        heartRateZone: 'Z3',
      ),
      WorkoutModel(
        id: '5',
        title: 'Fartlek\nPirâmide',
        metric: '6.000m',
        icon: Icons.directions_run,
        category: WorkoutCategory.running,
        heartRateZone: 'Z4',
      ),
      WorkoutModel(
        id: '6',
        title: 'Tiros\nCurtos',
        metric: '12x 200m',
        icon: Icons.timer_outlined,
        category: WorkoutCategory.intervals,
        heartRateZone: 'Z5',
      ),
    ];
  }
}
