import 'package:flutter/material.dart';
import '../../models/workout_model.dart';
import '../../theme/app_colors.dart';
import '../novo_treino_screen.dart';
import 'meus_treinos_desktop.dart';
import 'meus_treinos_mobile.dart';

/// Tela principal "Meus Treinos" com responsividade mandatória via LayoutBuilder.
/// Alterna dinamicamente entre MobileLayout (< 600px) e DesktopLayout (>= 600px).
class MeusTreinosScreen extends StatefulWidget {
  const MeusTreinosScreen({super.key});

  @override
  State<MeusTreinosScreen> createState() => _MeusTreinosScreenState();
}

class _MeusTreinosScreenState extends State<MeusTreinosScreen> {
  WorkoutCategory _selectedCategory = WorkoutCategory.all;
  late List<WorkoutModel> _allWorkouts;

  @override
  void initState() {
    super.initState();
    _allWorkouts = WorkoutModel.getMockWorkouts();
  }

  List<WorkoutModel> get _filteredWorkouts {
    if (_selectedCategory == WorkoutCategory.all) {
      return _allWorkouts;
    }
    return _allWorkouts
        .where((w) => w.category == _selectedCategory)
        .toList();
  }

  void _onSelectCategory(WorkoutCategory category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _navigateToAddWorkout() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const NovoTreinoScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        // LayoutBuilder conforme exigência explícita do professor
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // Layout para smartphones em modo retrato (< 600px)
              return MeusTreinosMobileLayout(
                workouts: _filteredWorkouts,
                selectedCategory: _selectedCategory,
                onSelectCategory: _onSelectCategory,
                onHomePressed: _navigateToHome,
                onAddWorkoutPressed: _navigateToAddWorkout,
              );
            } else {
              // Layout para tablets, monitores ou paisagem (>= 600px)
              return MeusTreinosDesktopLayout(
                workouts: _filteredWorkouts,
                selectedCategory: _selectedCategory,
                onSelectCategory: _onSelectCategory,
                onHomePressed: _navigateToHome,
                onAddWorkoutPressed: _navigateToAddWorkout,
              );
            }
          },
        ),
      ),
    );
  }
}
