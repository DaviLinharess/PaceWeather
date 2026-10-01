import 'package:flutter/material.dart';
import '../../models/workout_model.dart';
import '../../theme/app_colors.dart';
import '../../widgets/filter_pill.dart';
import '../../widgets/pace_weather_logo.dart';
import '../../widgets/workout_card.dart';

/// Layout mobile (< 600px) da tela "Meus Treinos".
/// Estrutura em 3 seções visuais principais integrando os elementos interativos:
/// - Seção 1: Cabeçalho com logo e barra de busca interativa (TextField + 2 botões distintos)
/// - Seção 2: Barra de filtros e badge indicador da API do Clima
/// - Seção 3: Grade de treinos com suporte a múltiplos gestos (onTap e onLongPress)
class MeusTreinosMobileLayout extends StatelessWidget {
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

  const MeusTreinosMobileLayout({
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
        // SEÇÃO 1: CABEÇALHO, LOGO E BARRA DE BUSCA
        // ==========================================
        Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.home_outlined,
                    size: 28, color: AppColors.dark),
                onPressed: onHomePressed,
                tooltip: 'Início',
              ),
              const PaceWeatherLogo(
                iconSize: 68,
                showText: true,
              ),
              IconButton(
                icon: const Icon(Icons.person_outline,
                    size: 28, color: AppColors.dark),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Perfil do Corredor (Interação simulada)'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                tooltip: 'Perfil',
              ),
            ],
          ),
        ),

        // Barra de Entrada de Dados com TextField e 2 Botões de Comportamentos Distintos
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            child: Row(
              children: [
                const Icon(Icons.search,
                    color: AppColors.textSecondary, size: 22),
                const SizedBox(width: 8),
                // Campo de Texto com reação em tempo real ao evento onChanged
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                    decoration: const InputDecoration(
                      hintText: 'Buscar treino (ex: Longo, 400m)...',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),

                // Botão 1: Ação Principal (onPressed condicional com encadeamento)
                IconButton(
                  icon: Icon(
                    Icons.filter_list_rounded,
                    color: isSearchButtonEnabled
                        ? AppColors.dark
                        : Colors.grey.shade400,
                  ),
                  tooltip: 'Aplicar Filtro de Busca',
                  onPressed: isSearchButtonEnabled ? onPrimarySearch : null,
                ),

                // Botão 2: Ação Secundária (onPressed com comportamento diferente - Limpeza)
                IconButton(
                  icon: const Icon(Icons.close_rounded,
                      color: Colors.grey, size: 20),
                  tooltip: 'Limpar Busca e Filtros',
                  onPressed: onSecondaryClear,
                ),
              ],
            ),
          ),
        ),

        // ==========================================
        // SEÇÃO 2: BARRA DE FILTROS E INDICADOR CLIMA
        // ==========================================
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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

        const SizedBox(height: 10),

        // ==========================================
        // SEÇÃO 3: GRADE RESPONSIVA COM GESTOS (onTap e onLongPress)
        // ==========================================
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: workouts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search_off_rounded,
                            size: 48, color: Colors.grey),
                        const SizedBox(height: 8),
                        const Text(
                          'Nenhum treino encontrado.',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        TextButton(
                          onPressed: onSecondaryClear,
                          child: const Text('Limpar busca',
                              style: TextStyle(color: AppColors.primaryBlue)),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 6, bottom: 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.82,
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
                  ),
          ),
        ),
      ],
    );
  }
}
