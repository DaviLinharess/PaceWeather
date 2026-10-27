import 'package:flutter/material.dart';
import '../models/workout_model.dart';

class WorkoutProvider extends ChangeNotifier {
  late List<WorkoutModel> _workouts;
  WorkoutCategory _selectedCategory = WorkoutCategory.all;
  String _searchQuery = '';

  WorkoutProvider() {
    _workouts = List.from(WorkoutModel.getMockWorkouts());
  }

  /// Lista completa de treinos
  List<WorkoutModel> get workouts => List.unmodifiable(_workouts);

  /// Quantidade total de treinos cadastrados
  int get totalWorkouts => _workouts.length;

  /// Categoria de filtro ativa
  WorkoutCategory get selectedCategory => _selectedCategory;

  /// Termo de busca ativo
  String get searchQuery => _searchQuery;

  /// Retorna os treinos filtrados de acordo com a categoria e busca ativa
  List<WorkoutModel> get filteredWorkouts {
    return _workouts.where((workout) {
      final matchesCategory = _selectedCategory == WorkoutCategory.all ||
          workout.category == _selectedCategory;

      if (_searchQuery.isEmpty) {
        return matchesCategory;
      }

      final query =
          _searchQuery.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
      final normalizedTitle =
          workout.title.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
      final normalizedMetric =
          workout.metric.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

      final matchesQuery =
          normalizedTitle.contains(query) || normalizedMetric.contains(query);

      return matchesCategory && matchesQuery;
    }).toList();
  }

  /// Adiciona um novo treino no início da lista e notifica os widgets inscritos
  void addWorkout(WorkoutModel workout) {
    _workouts.insert(0, workout);
    notifyListeners();
  }

  /// Remove um treino pelo identificador e notifica os widgets inscritos
  void removeWorkout(String id) {
    _workouts.removeWhere((workout) => workout.id == id);
    notifyListeners();
  }

  /// Define a categoria de filtro selecionada e notifica os widgets inscritos
  void setCategory(WorkoutCategory category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  /// Atualiza o termo de busca e notifica os widgets ouvintes
  void setSearchQuery(String query) {
    final trimmed = query.trim();
    if (_searchQuery != trimmed) {
      _searchQuery = trimmed;
      notifyListeners();
    }
  }

  /// Reseta todos os filtros (categoria e busca) para o estado inicial
  void clearFilters() {
    _selectedCategory = WorkoutCategory.all;
    _searchQuery = '';
    notifyListeners();
  }
}
