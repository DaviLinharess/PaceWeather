import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/workout_model.dart';
import '../theme/app_colors.dart';
import '../widgets/app_drawer.dart';
import '../widgets/pace_weather_logo.dart';
import 'home_screen.dart';
import 'meus_treinos/meus_treinos_screen.dart';
import 'novo_treino_screen.dart';
import 'perfil_screen.dart';
import 'workout_details_screen.dart';

/// Shell principal de navegação do PaceWeather.
/// Implementa simultaneamente:
/// - Drawer com Configurações (push), Sobre (modal) e Logout (pushReplacement).
/// - BottomNavigationBar com 3 abas principais (Início, Treinos, Perfil)
///   preservando o estado e histórico de cada aba via `IndexedStack` e múltiplos `Navigator`s.
/// - PopScope respeitando o histórico local de cada aba no botão físico/gesto voltar do Android.
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  /// Helper estático para alternar abas a partir de qualquer tela filha
  static void switchTab(BuildContext context, int tabIndex) {
    final state = context.findAncestorStateOfType<_MainNavigationShellState>();
    state?.selectTab(tabIndex);
  }

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  // Chaves de navegação independentes para cada uma das 3 abas
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void selectTab(int index) {
    if (index >= 0 && index < _navigatorKeys.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  /// Constrói o Navigator aninhado para cada aba, preservando o histórico interno
  Widget _buildTabNavigator(int index, Widget initialScreen) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) {
        // Rotas que podem ser empilhadas dentro da própria aba
        if (settings.name == '/workout_details') {
          final workout = settings.arguments as WorkoutModel?;
          return MaterialPageRoute(
            builder: (context) => WorkoutDetailsScreen(workout: workout),
            settings: settings,
          );
        }

        if (settings.name == '/novo_treino') {
          return MaterialPageRoute(
            builder: (context) => const NovoTreinoScreen(),
            settings: settings,
          );
        }

        return MaterialPageRoute(
          builder: (context) => initialScreen,
          settings: settings,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // PopScope interceptando o botão físico/gesto de voltar do Android
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // 1. Verifica se a aba atual possui telas em sua pilha interna para desempilhar
        final currentNavigatorState =
            _navigatorKeys[_currentIndex].currentState;
        if (currentNavigatorState != null && currentNavigatorState.canPop()) {
          currentNavigatorState.pop();
          return;
        }

        // 2. Se a aba atual não tem mais histórico, mas não estamos na aba 0 (Início),
        // retorna para a aba principal (Início)
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return;
        }

        // 3. Se já estiver na raiz da aba 0, confirma saída do aplicativo
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (dialogCtx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Sair do PaceWeather?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text(
              'Deseja realmente sair e encerrar a aplicação?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(false),
                child: const Text('Continuar no App'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryYellow,
                  foregroundColor: AppColors.dark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => Navigator.of(dialogCtx).pop(true),
                child: const Text(
                  'Sair',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );

        if (shouldExit == true && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu_rounded,
                  color: AppColors.dark, size: 28),
              tooltip: 'Abrir Drawer',
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: const PaceWeatherLogo(
            iconSize: 32,
            fontSize: 18,
            showText: true,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined,
                  color: AppColors.dark, size: 24),
              tooltip: 'Configurações Rápidas',
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pushNamed('/settings');
              },
            ),
            const SizedBox(width: 6),
          ],
        ),

        // REQUISITO 2: Drawer Lateral com 3 ações complementares
        drawer: const AppDrawer(),

        // REQUISITO 3: IndexedStack preservando o estado de cada uma das 3 abas
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildTabNavigator(0, const HomeScreen()),
            _buildTabNavigator(1, const MeusTreinosScreen()),
            _buildTabNavigator(2, const PerfilScreen()),
          ],
        ),

        // REQUISITO 3: BottomNavigationBar com 3 seções principais
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              if (_currentIndex == index) {
                // Toque na mesma aba desempilha até a raiz daquela aba
                _navigatorKeys[index]
                    .currentState
                    ?.popUntil((route) => route.isFirst);
              } else {
                setState(() {
                  _currentIndex = index;
                });
              }
            },
            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: AppColors.dark,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'Início',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.directions_run_outlined),
                activeIcon: Icon(Icons.directions_run_rounded),
                label: 'Treinos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                activeIcon: Icon(Icons.person_rounded),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
