import 'package:shared_preferences/shared_preferences.dart';

/// Serviço que utiliza `SharedPreferences` exclusivamente para dados NÃO SENSÍVEIS:
/// - Última pesquisa realizada na tela de treinos (`last_search_query`)
/// - Preferência de unidade de distância (`use_kilometers`)
/// - Preferência de notificações climáticas (`weather_notifications`)

class PreferencesService {
  static const String _keyLastSearch = 'last_search_query';
  static const String _keyUseKilometers = 'use_kilometers';
  static const String _keyWeatherNotifications = 'weather_notifications';

  Future<void> saveLastSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastSearch, query);
  }

  Future<String> getLastSearch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastSearch) ?? '';
  }

  Future<void> saveUseKilometers(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyUseKilometers, value);
  }

  Future<bool> getUseKilometers() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyUseKilometers) ?? true;
  }

  Future<void> saveWeatherNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyWeatherNotifications, value);
  }

  Future<bool> getWeatherNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyWeatherNotifications) ?? true;
  }
}
