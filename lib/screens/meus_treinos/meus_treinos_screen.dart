import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/workout_model.dart';
import '../../providers/workout_provider.dart';
import '../../theme/app_colors.dart';
import '../main_navigation_shell.dart';
import 'meus_treinos_desktop.dart';
import 'meus_treinos_mobile.dart';

/// Tela principal "Meus Treinos".
/// 
/// Refatorada para usar Gerenciamento de Estado Global via Provider + ChangeNotifier.
/// Remove a lógica de estado local (setState para lista de treinos) e consome
/// o WorkoutProvider através de Consumer<WorkoutProvider> e context.read/watch.
class MeusTreinosScreen extends StatefulWidget {
  const MeusTreinosScreen({super.key});

  @override
  State<MeusTreinosScreen> createState() => _MeusTreinosScreenState();
}

class _MeusTreinosScreenState extends State<MeusTreinosScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchButtonEnabled = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Filtra em tempo real a cada digitação (habilita/desabilita botão de busca)
  void _onSearchChanged(String value) {
    debugPrint('[PaceWeather Event] onChanged: "$value"');
    final trimmed = value.trim();
    setState(() {
      _isSearchButtonEnabled = trimmed.length >= 2;
    });
  }

  /// Ação do botão de busca, confirma e atualiza o estado global no WorkoutProvider
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
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryYellow,
                foregroundColor: AppColors.dark,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();

                // Modifica o estado global via Provider
                context.read<WorkoutProvider>().setSearchQuery(query);

                final int totalFound =
                    context.read<WorkoutProvider>().filteredWorkouts.length;
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

  /// Ação do botão limpar, restaura a listagem completa no estado global
  void _onSecondaryActionClear() {
    _searchController.clear();
    setState(() {
      _isSearchButtonEnabled = false;
    });

    // Limpa filtros no Provider global
    context.read<WorkoutProvider>().clearFilters();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Busca e filtros redefinidos com sucesso.'),
        backgroundColor: AppColors.textSecondary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Ao tocar no card, navega para a tela de detalhes passando o modelo
  void _onCardTap(WorkoutModel workout) {
    Navigator.of(context).pushNamed(
      '/workout_details',
      arguments: workout,
    );
  }

  /// Exibe diálogo detalhado ao tocar e segurar no card (com opção de exclusão reativa)
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
                Navigator.of(context).pushNamed(
                  '/workout_details',
                  arguments: workout,
                );
              },
              child: const Text(
                'Ver Detalhes',
                style: TextStyle(
                    color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Excluir'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // Modificação do estado global via Provider (Remoção)
                context.read<WorkoutProvider>().removeWorkout(workout.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Treino "${workout.title.replaceAll('\n', ' ')}" removido!'),
                    backgroundColor: AppColors.dark,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
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

  /// Alternância de categoria via Provider global
  void _onSelectCategory(WorkoutCategory category) {
    context.read<WorkoutProvider>().setCategory(category);
  }

  void _navigateToHome() {
    MainNavigationShell.switchTab(context, 0);
  }

  /// Abre formulário de novo treino.
  Future<void> _navigateToAddWorkout() async {
    await Navigator.of(context).pushNamed('/novo_treino');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // Botão Flutuante reage à quantidade total de treinos via Consumer
      floatingActionButton: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          return FloatingActionButton.extended(
            backgroundColor: AppColors.primaryYellow,
            foregroundColor: AppColors.dark,
            elevation: 3,
            icon: const Icon(Icons.add_rounded),
            label: Text(
              'Novo Treino (${workoutProvider.totalWorkouts})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: _navigateToAddWorkout,
          );
        },
      ),
      // REQUISITO: Consumo reativo via Consumer<WorkoutProvider>
      body: SafeArea(
        child: Consumer<WorkoutProvider>(
          builder: (context, workoutProvider, child) {
            final filteredWorkouts = workoutProvider.filteredWorkouts;
            final selectedCategory = workoutProvider.selectedCategory;

            return LayoutBuilder(
              // LayoutBuilder para responsividade
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  // Layout Mobile (< 600px)
                  return MeusTreinosMobileLayout(
                    workouts: filteredWorkouts,
                    selectedCategory: selectedCategory,
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
                    workouts: filteredWorkouts,
                    selectedCategory: selectedCategory,
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
            );
          },
        ),
      ),
    );
  }
}
