import 'package:flutter/material.dart';
import '../../models/workout_model.dart';
import '../../theme/app_colors.dart';
import '../main_navigation_shell.dart';
import 'meus_treinos_desktop.dart';
import 'meus_treinos_mobile.dart';

/// Tela principal "Meus Treinos".
class MeusTreinosScreen extends StatefulWidget {
  const MeusTreinosScreen({super.key});

  @override
  State<MeusTreinosScreen> createState() => _MeusTreinosScreenState();
}

class _MeusTreinosScreenState extends State<MeusTreinosScreen> {
  final TextEditingController _searchController = TextEditingController();

  WorkoutCategory _selectedCategory = WorkoutCategory.all;
  String _activeSearchQuery = '';
  bool _isSearchButtonEnabled = false;

  late List<WorkoutModel> _allWorkouts;

  @override
  void initState() {
    super.initState();
    _allWorkouts = WorkoutModel.getMockWorkouts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Lista filtrada por Categoria e Palavra-chave
  List<WorkoutModel> get _filteredWorkouts {
    return _allWorkouts.where((workout) {
      final matchesCategory = _selectedCategory == WorkoutCategory.all ||
          workout.category == _selectedCategory;

      if (_activeSearchQuery.isEmpty) {
        return matchesCategory;
      }

      // Normaliza quebras de linha
      final query = _activeSearchQuery
          .trim()
          .toLowerCase()
          .replaceAll(RegExp(r'\s+'), ' ');
      final normalizedTitle =
          workout.title.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
      final normalizedMetric =
          workout.metric.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

      final matchesQuery =
          normalizedTitle.contains(query) || normalizedMetric.contains(query);

      return matchesCategory && matchesQuery;
    }).toList();
  }

  /// Filtra em tempo real a cada digitação
  void _onSearchChanged(String value) {
    debugPrint('[PaceWeather Event] onChanged: "$value"');

    final trimmed = value.trim();
    setState(() {
      _activeSearchQuery = trimmed;
      _isSearchButtonEnabled = trimmed.length >= 2;
    });
  }

  /// Ação do botão de busca, só executa se houver texto válido digitado.
  void _onPrimaryActionSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    // Exibe mensagem de confirmação
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.search, color: AppColors.primaryBlue),
              SizedBox(width: 8),
              Text('Confirmar Filtro'),
            ],
          ),
          content: Text(
            'Deseja aplicar a busca pelo termo "$query" na grade de treinos?',
            style: const TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryYellow,
                foregroundColor: AppColors.dark,
              ),
              onPressed: () {
                // Fecha diálogo, atualiza estado e exibe SnackBar
                Navigator.of(dialogContext).pop();

                setState(() {
                  _activeSearchQuery = query;
                });

                final int totalFound = _filteredWorkouts.length;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Filtro confirmado: $totalFound treino(s) exibido(s) para "$query"',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: AppColors.dark,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Aplicar Filtro',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  /// Ação do botão limpar, limpa o campo de texto, restaura a listagem completa e exibe SnackBar.
  void _onSecondaryActionClear() {
    _searchController.clear();
    setState(() {
      _activeSearchQuery = '';
      _isSearchButtonEnabled = false;
      _selectedCategory = WorkoutCategory.all;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Busca e filtros redefinidos com sucesso.'),
        backgroundColor: AppColors.textSecondary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Ao tocar no card, navega para a tela de detalhes passando o modelo via arguments em rota nomeada.
  void _onCardTap(WorkoutModel workout) {
    Navigator.of(context).pushNamed(
      '/workout_details',
      arguments: workout,
    );
  }

  /// Exibe diálogo detalhado ao tocar e segurar no card.
  void _onCardLongPress(WorkoutModel workout) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(workout.icon, color: AppColors.dark),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  workout.title.replaceAll('\n', ' '),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• Distância/Carga: ${workout.metric}',
                  style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 6),
              Text('• Zona Cardíaca Alvo: ${workout.heartRateZone}',
                  style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 6),
              Text('• Categoria: ${workout.categoryName}',
                  style: const TextStyle(fontSize: 15)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Fechar', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // REQUISITO 4: Abre detalhes via arguments
                Navigator.of(context).pushNamed(
                  '/workout_details',
                  arguments: workout,
                );
              },
              child: const Text(
                'Ver Detalhes (arguments)',
                style: TextStyle(
                    color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryYellow,
                foregroundColor: AppColors.dark,
              ),
              icon: const Icon(Icons.star, size: 18),
              label: const Text('Favoritar',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '⭐ Treino ${workout.title.replaceAll('\n', ' ')} adicionado aos favoritos!'),
                    backgroundColor: AppColors.dark,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  /// Alternância de categoria pelos botões de filtro
  void _onSelectCategory(WorkoutCategory category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _navigateToHome() {
    MainNavigationShell.switchTab(context, 0);
  }

  /// Abre formulário de novo treino e aguarda retorno de valor via Navigator.pop
  Future<void> _navigateToAddWorkout() async {
    final result = await Navigator.of(context).pushNamed('/novo_treino');
    if (result != null && result is Map && mounted) {
      final categoryStr = result['category']?.toString() ?? 'Longão';
      final WorkoutCategory cat;
      if (categoryStr == 'Longão') {
        cat = WorkoutCategory.running;
      } else if (categoryStr == 'Regenerativo') {
        cat = WorkoutCategory.recovery;
      } else {
        cat = WorkoutCategory.intervals;
      }

      final newWorkout = WorkoutModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: result['title']?.toString() ?? 'Novo Treino',
        metric: result['metric']?.toString() ?? '5.000m',
        icon: Icons.directions_run,
        category: cat,
        heartRateZone: result['zone']?.toString() ?? 'Z2',
      );

      setState(() {
        _allWorkouts.insert(0, newWorkout);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Requisito 5 (pop com valor): Treino "${newWorkout.title}" recebido e inserido na lista!',
          ),
          backgroundColor: AppColors.dark,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryYellow,
        foregroundColor: AppColors.dark,
        elevation: 3,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Novo Treino (pop valor)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: _navigateToAddWorkout,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          // LayoutBuilder para responsividade
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // Layout Mobile (< 600px)
              return MeusTreinosMobileLayout(
                workouts: _filteredWorkouts,
                selectedCategory: _selectedCategory,
                searchController: _searchController,
                isSearchButtonEnabled: _isSearchButtonEnabled,
                onSearchChanged: _onSearchChanged,
                onPrimarySearch: _onPrimaryActionSearch,
                onSecondaryClear: _onSecondaryActionClear,
                onSelectCategory: _onSelectCategory,
                onCardTap: _onCardTap,
                onCardLongPress: _onCardLongPress,
                onHomePressed: _navigateToHome,
              );
            } else {
              // Layout Desktop/Tablet/Paisagem (>= 600px)
              return MeusTreinosDesktopLayout(
                workouts: _filteredWorkouts,
                selectedCategory: _selectedCategory,
                searchController: _searchController,
                isSearchButtonEnabled: _isSearchButtonEnabled,
                onSearchChanged: _onSearchChanged,
                onPrimarySearch: _onPrimaryActionSearch,
                onSecondaryClear: _onSecondaryActionClear,
                onSelectCategory: _onSelectCategory,
                onCardTap: _onCardTap,
                onCardLongPress: _onCardLongPress,
                onHomePressed: _navigateToHome,
              );
            }
          },
        ),
      ),
    );
  }
}
