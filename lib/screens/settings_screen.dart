import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import '../theme/app_colors.dart';

/// Tela de Configurações do PaceWeather.
/// Demonstra o uso prático do `SharedPreferences` para preferências de interface
/// (não sensíveis), contrastando com o `flutter_secure_storage` usado para o JWT.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final PreferencesService _prefsService = PreferencesService();

  bool _weatherNotifications = true;
  bool _useKilometers = true;
  bool _heartRateAlerts = true;
  bool _darkMode = false;
  String _lastSearchSaved = '';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final useKm = await _prefsService.getUseKilometers();
    final weatherNotif = await _prefsService.getWeatherNotifications();
    final lastSearch = await _prefsService.getLastSearch();
    if (!mounted) return;
    setState(() {
      _useKilometers = useKm;
      _weatherNotifications = weatherNotif;
      _lastSearchSaved = lastSearch;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.dark, size: 20),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Voltar',
        ),
        title: const Text(
          'Configurações & Armazenamento',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: AppColors.dark,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          // Banner Didático sobre SharedPreferences vs flutter_secure_storage
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryYellow.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primaryYellow,
                width: 1.2,
              ),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.security_rounded, color: AppColors.dark, size: 22),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'SharedPreferences vs flutter_secure_storage:\n'
                    '• SharedPreferences: salva estas preferências de UI e última busca em XML/plist (texto puro, NÃO seguro para tokens).\n'
                    '• flutter_secure_storage: criptografa o JWT via Keystore/Keychain.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.dark,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'PREFERÊNCIAS SALVAS NO SHAREDPREFERENCES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),

          _buildSettingsCard(
            children: [
              SwitchListTile(
                title: const Text('Notificações de Clima',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                subtitle:
                    const Text('Persistido via SharedPreferences (booleano)'),
                value: _weatherNotifications,
                activeThumbColor: AppColors.primaryYellow,
                activeTrackColor: AppColors.dark,
                onChanged: (val) {
                  setState(() => _weatherNotifications = val);
                  _prefsService.saveWeatherNotifications(val);
                },
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Alertas de Zona Cardíaca',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                subtitle: const Text(
                    'Avisar se ultrapassar a zona de treino planejada'),
                value: _heartRateAlerts,
                activeThumbColor: AppColors.primaryYellow,
                activeTrackColor: AppColors.dark,
                onChanged: (val) {
                  setState(() => _heartRateAlerts = val);
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            'UNIDADES, TEMA E ÚLTIMA PESQUISA (SHAREDPREFERENCES)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),

          _buildSettingsCard(
            children: [
              ListTile(
                title: const Text('Unidade de Distância',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                subtitle:
                    Text(_useKilometers ? 'Quilômetros (km)' : 'Milhas (mi)'),
                trailing: TextButton(
                  onPressed: () {
                    final next = !_useKilometers;
                    setState(() => _useKilometers = next);
                    _prefsService.saveUseKilometers(next);
                  },
                  child: Text(
                    _useKilometers ? 'Mudar p/ Milhas' : 'Mudar p/ Km',
                    style: const TextStyle(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('Última Pesquisa Realizada',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                subtitle: Text(
                  _lastSearchSaved.isEmpty
                      ? 'Nenhuma busca salva recentemente'
                      : 'Termo salvo: "$_lastSearchSaved"',
                ),
                leading: const Icon(Icons.history_rounded, color: AppColors.dark),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Modo Escuro (Preferência de Tema)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                subtitle:
                    const Text('Tema de alto contraste para treinos noturnos'),
                value: _darkMode,
                activeThumbColor: AppColors.primaryYellow,
                activeTrackColor: AppColors.dark,
                onChanged: (val) {
                  setState(() => _darkMode = val);
                },
              ),
            ],
          ),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.dark, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.arrow_back, color: AppColors.dark),
              label: const Text(
                'Voltar à Navegação Principal',
                style: TextStyle(
                  color: AppColors.dark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}
