import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_shell.dart';
import 'screens/novo_treino_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/workout_details_screen.dart';
import 'theme/app_colors.dart';
import 'widgets/app_navigator_observer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const PaceWeatherApp());
}

class PaceWeatherApp extends StatelessWidget {
  const PaceWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaceWeather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryYellow,
          primary: AppColors.primaryYellow,
          secondary: AppColors.primaryBlue,
        ),
        fontFamily: 'sans-serif',
      ),
      navigatorObservers: [
        AppNavigatorObserver(scope: 'RootNavigator'),
      ],
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainNavigationShell(),
        '/settings': (context) => const SettingsScreen(),
        '/workout_details': (context) => const WorkoutDetailsScreen(),
        '/novo_treino': (context) => const NovoTreinoScreen(),
      },
    );
  }
}
