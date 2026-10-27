import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pace_weather/models/workout_model.dart';
import 'package:pace_weather/providers/workout_provider.dart';

void main() {
  group('WorkoutProvider - Testes de Estado Global e Reatividade', () {
    test('1. Estado inicial carrega os mocks corretamente', () {
      final provider = WorkoutProvider();
      expect(provider.totalWorkouts, equals(6));
      expect(provider.selectedCategory, equals(WorkoutCategory.all));
      expect(provider.searchQuery, isEmpty);
      expect(provider.filteredWorkouts.length, equals(6));
    });

    test('2. Adicionar treino atualiza o estado e dispara notifyListeners', () {
      final provider = WorkoutProvider();
      bool listenerNotified = false;
      provider.addListener(() {
        listenerNotified = true;
      });

      final newWorkout = const WorkoutModel(
        id: 'test-999',
        title: 'Treino Teste',
        metric: '5.000m',
        icon: Icons.directions_run,
        category: WorkoutCategory.running,
        heartRateZone: 'Z3',
      );

      provider.addWorkout(newWorkout);

      expect(listenerNotified, isTrue);
      expect(provider.totalWorkouts, equals(7));
      expect(provider.workouts.first.id, equals('test-999'));
    });

    test('3. Remover treino atualiza o total e dispara notifyListeners', () {
      final provider = WorkoutProvider();
      int notificationCount = 0;
      provider.addListener(() {
        notificationCount++;
      });

      provider.removeWorkout('1');

      expect(notificationCount, equals(1));
      expect(provider.totalWorkouts, equals(5));
      expect(provider.workouts.any((w) => w.id == '1'), isFalse);
    });

    testWidgets('4. Pelo menos dois widgets distintos reagem à mesma mudança de estado via Consumer',
        (WidgetTester tester) async {
      final provider = WorkoutProvider();

      // Monta uma árvore com 2 widgets consumidores independentes do mesmo estado
      await tester.pumpWidget(
        ChangeNotifierProvider<WorkoutProvider>.value(
          value: provider,
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  // Widget 1: Exibe badge de contagem
                  Consumer<WorkoutProvider>(
                    builder: (context, p, _) =>
                        Text('Widget1_Total: ${p.totalWorkouts}', key: const Key('widget1')),
                  ),
                  // Widget 2: Exibe lista de títulos
                  Consumer<WorkoutProvider>(
                    builder: (context, p, _) => Text(
                      'Widget2_Primeiro: ${p.workouts.first.title.replaceAll('\n', ' ')}',
                      key: const Key('widget2'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verificação do estado inicial (6 treinos, primeiro: Treino Longo)
      expect(find.text('Widget1_Total: 6'), findsOneWidget);
      expect(find.text('Widget2_Primeiro: Treino Longo'), findsOneWidget);

      // Mutação do estado a partir do provider (simulando ação do usuário)
      provider.addWorkout(const WorkoutModel(
        id: 'new-100',
        title: 'Maratona Reativa',
        metric: '42.000m',
        icon: Icons.directions_run,
        category: WorkoutCategory.running,
      ));

      // Re-renderização reativa do Flutter
      await tester.pump();

      // Ambos os widgets reagiram simultaneamente à mesma mudança de estado!
      expect(find.text('Widget1_Total: 7'), findsOneWidget);
      expect(find.text('Widget2_Primeiro: Maratona Reativa'), findsOneWidget);
    });
  });
}
