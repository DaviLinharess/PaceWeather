import 'package:flutter/material.dart';
import '../../models/workout_model.dart';
import '../../theme/app_colors.dart';
import '../../widgets/filter_pill.dart';
import '../../widgets/pace_weather_logo.dart';
import '../../widgets/workout_card.dart';

/// Layout desktop/tablet (>= 600px) da tela "Meus Treinos".
/// Estrutura em 3 seções amplas integrando os componentes interativos:
/// - Seção 1: Cabeçalho com logo, campo de busca com TextField e botões de ação distintos
/// - Seção 2: Barra de filtros de categoria e badge da API do Clima
/// - Seção 3: Grade multi-colunas de treinos com múltiplos gestos (onTap e onLongPress)
class MeusTreinosDesktopLayout extends StatelessWidget {
  final List<WorkoutModel> workouts;
  final WorkoutCategory selectedCategory;
  final TextEditingController searchController;
  final bool isSearchButtonEnabled;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onPrimarySearch;
  final VoidCallback onSecondaryClear;
  final ValueChanged<WorkoutCategory> onSelectCategory;
  final ValueChanged<WorkoutModel> onCardTap;
  final ValueChanged<WorkoutModel> onCardLongPress;
  final VoidCallback onHomePressed;

  const MeusTreinosDesktopLayout({
    super.key,
    required this.workouts,
    required this.selectedCategory,
    required this.searchController,
    required this.isSearchButtonEnabled,
    required this.onSearchChanged,
    required this.onPrimarySearch,
    required this.onSecondaryClear,
    required this.onSelectCategory,
    required this.onCardTap,
    required this.onCardLongPress,
    required this.onHomePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ==========================================
        // SEÇÃO 1: CABEÇALHO EXPANDIDO COM BUSCA
        // ==========================================
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.15)),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.home_outlined, size: 28, color: AppColors.dark),
                onPressed: onHomePressed,
                tooltip: 'Início',
              ),
              const SizedBox(width: 16),
              const PaceWeatherLogo(
                iconSize: 55,
                showText: true,
              ),

              const Spacer(),

              // Barra de Busca Desktop posicionada na direita
              SizedBox(
                width: 380,
                height: 48,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: onSearchChanged,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          decoration: const InputDecoration(
                            hintText: 'Buscar treino por nome ou distância...',
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      // Botão 1: Ação Principal (Condicional com encadeamento de eventos)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSearchButtonEnabled ? AppColors.dark : Colors.grey.shade300,
                          foregroundColor: isSearchButtonEnabled ? Colors.white : Colors.grey.shade600,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: isSearchButtonEnabled ? onPrimarySearch : null,
                        child: const Text('Filtrar', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 6),
                      // Botão 2: Ação Secundária (Limpeza / Reset de estado)
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20, color: Colors.grey),
                        tooltip: 'Limpar Busca',
                        onPressed: onSecondaryClear,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // ==========================================
        // SEÇÃO 2: BARRA DE FILTROS ALINHADA
        // ==========================================
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          child: Row(
            children: [
              const Text(
                'Filtrar por:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 16),
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
              Text(
                '${workouts.length} treino(s) disponível(is)',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey),
              ),
            ],
          ),
        ),

        // ==========================================
        // SEÇÃO 3: GRADE RESPONSIVA AMPLA COM GESTOS
        // ==========================================
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: workouts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search_off_rounded, size: 56, color: Colors.grey),
                        const SizedBox(height: 10),
                        const Text(
                          'Nenhum treino corresponde à pesquisa.',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        const SizedBox(height: 6),
                        ElevatedButton(
                          onPressed: onSecondaryClear,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryYellow,
                            foregroundColor: AppColors.dark,
                          ),
                          child: const Text('Limpar Filtros e Busca'),
                        ),
                      ],
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, gridConstraints) {
                      final int columnCount = gridConstraints.maxWidth > 900 ? 4 : 3;

                      return GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(top: 6, bottom: 32),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columnCount,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                          childAspectRatio: 0.95,
                        ),
                        itemCount: workouts.length,
                        itemBuilder: (context, index) {
                          final workout = workouts[index];
                          // Card configurado com onTap e onLongPress gerando respostas distintas
                          return WorkoutCard(
                            workout: workout,
                            onTap: () => onCardTap(workout),
                            onLongPress: () => onCardLongPress(workout),
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
