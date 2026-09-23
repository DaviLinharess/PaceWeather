import 'package:flutter/material.dart';
import '../../models/workout_model.dart';
import '../../theme/app_colors.dart';
import '../home_screen.dart';
import 'meus_treinos_desktop.dart';
import 'meus_treinos_mobile.dart';

/// Tela principal "Meus Treinos".
/// Integra os requisitos da Atividade 1 (Layout Responsivo via LayoutBuilder)
/// e da Atividade 2 (Tratamento de Eventos, Ciclo Ação-Processamento-Feedback e Encadeamento).
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

  /// Lista filtrada dinamicamente por Categoria E por Palavra-chave (com normalização de espaços e quebras de linha)
  List<WorkoutModel> get _filteredWorkouts {
    return _allWorkouts.where((workout) {
      final matchesCategory = _selectedCategory == WorkoutCategory.all ||
          workout.category == _selectedCategory;

      if (_activeSearchQuery.isEmpty) {
        return matchesCategory;
      }

      // Normaliza quebras de linha '\n' e múltiplos espaços para que 'Treino\nLongo' case perfeitamente com 'Treino Longo'
      final query = _activeSearchQuery.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
      final normalizedTitle = workout.title.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
      final normalizedMetric = workout.metric.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

      final matchesQuery = normalizedTitle.contains(query) ||
          normalizedMetric.contains(query);

      return matchesCategory && matchesQuery;
    }).toList();
  }

  // =========================================================================
  // TRATAMENTO DE EVENTOS - ATIVIDADE 2
  // =========================================================================

  /// 1. ENTRADA DE DADOS EM TEMPO REAL (TextField: onChanged)
  /// Reage a cada caractere digitado, filtra em tempo real, exibe no console e valida tamanho mínimo.
  void _onSearchChanged(String value) {
    debugPrint('[PaceWeather Event] onChanged: "$value"');

    final trimmed = value.trim();
    setState(() {
      _activeSearchQuery = trimmed;
      _isSearchButtonEnabled = trimmed.length >= 2;
    });
  }

  /// 2. AÇÃO PRINCIPAL (Botão 1: onPressed com condição e encadeamento)
  /// Só pode ser executada se houver texto válido digitado.
  /// Fluxo de encadeamento: Botão ➔ Validação ➔ AlertDialog ➔ Confirmação ➔ Estado + SnackBar.
  void _onPrimaryActionSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return; // Proteção condicional

    // Dispara a primeira etapa do encadeamento: Exibe diálogo de confirmação
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
                // Etapa 2 do encadeamento: Fecha diálogo, garante atualização e dispara SnackBar
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
              child: const Text('Aplicar Filtro', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  /// 3. AÇÃO SECUNDÁRIA (Botão 2: onPressed com comportamento diferente)
  /// Limpa o campo de texto, restaura a listagem completa e gera feedback imediato.
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

  /// 4. INTERAÇÃO POR GESTO - Gesto 1: onTap (Toque rápido no card)
  /// Inicia o treino e emite SnackBar de início de sessão.
  void _onCardTap(WorkoutModel workout) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '▶ Iniciando ${workout.title.replaceAll('\n', ' ')} (${workout.metric})',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.dark,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// 4. INTERAÇÃO POR GESTO - Gesto 2: onLongPress (Toque longo / segurar o card)
  /// Exibe diálogo detalhado de inspeção com encadeamento de favoritar o treino.
  void _onCardLongPress(WorkoutModel workout) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(workout.icon, color: AppColors.dark),
              const SizedBox(width: 8),
              Text(workout.title.replaceAll('\n', ' ')),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• Distância/Carga: ${workout.metric}', style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 6),
              Text('• Zona Cardíaca Alvo: ${workout.heartRateZone}', style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 6),
              Text('• Categoria: ${workout.categoryName}', style: const TextStyle(fontSize: 15)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Fechar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryYellow,
                foregroundColor: AppColors.dark,
              ),
              icon: const Icon(Icons.star, size: 18),
              label: const Text('Favoritar', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('⭐ Treino ${workout.title.replaceAll('\n', ' ')} adicionado aos favoritos!'),
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
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        // LayoutBuilder conforme Atividade 1
        child: LayoutBuilder(
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
