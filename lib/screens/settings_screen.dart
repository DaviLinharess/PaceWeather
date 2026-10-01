import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Tela de Configurações do PaceWeather.
/// Requisito: Acessada via `Navigator.pushNamed(context, '/settings')` a partir do Drawer.
/// Permite retorno à tela anterior via `Navigator.pop(context)`.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _weatherNotifications = true;
  bool _useKilometers = true;
  bool _heartRateAlerts = true;
  bool _darkMode = false;

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
          'Configurações',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppColors.dark,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          // Banner Didático do Requisito
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
              children: [
                Icon(Icons.push_pin_outlined,
                    color: AppColors.dark, size: 22),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Requisito: Esta tela foi empilhada via Navigator.pushNamed a partir do Drawer. Ao voltar, é feito o pop da rota.',
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

          const SizedBox(height: 24),

          const Text(
            'PREFERÊNCIAS DO ATLETA',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),

          // Card de Notificações de Clima
          _buildSettingsCard(
            children: [
              SwitchListTile(
                title: const Text('Notificações de Clima',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                subtitle: const Text('Alertas para melhores horários de corrida'),
                value: _weatherNotifications,
                activeThumbColor: AppColors.primaryYellow,
                activeTrackColor: AppColors.dark,
                onChanged: (val) {
                  setState(() => _weatherNotifications = val);
                },
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Alertas de Zona Cardíaca',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                subtitle: const Text('Avisar se ultrapassar a zona de treino planejada'),
                value: _heartRateAlerts,
                activeThumbColor: AppColors.primaryYellow,
                activeTrackColor: AppColors.dark,
                onChanged: (val) {
                  setState(() => _heartRateAlerts = val);
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            'UNIDADES E APARÊNCIA',
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
                subtitle: Text(_useKilometers ? 'Quilômetros (km)' : 'Milhas (mi)'),
                trailing: TextButton(
                  onPressed: () {
                    setState(() => _useKilometers = !_useKilometers);
                  },
                  child: Text(
                    _useKilometers ? 'Mudar p/ Milhas' : 'Mudar p/ Km',
                    style: const TextStyle(
                        color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Modo Escuro (Em breve)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                subtitle: const Text('Tema de alto contraste para treinos noturnos'),
                value: _darkMode,
                activeThumbColor: AppColors.primaryYellow,
                activeTrackColor: AppColors.dark,
                onChanged: (val) {
                  setState(() => _darkMode = val);
                },
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Botão Voltar explícito
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
                'Voltar à Navegação Principal (Navigator.pop)',
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
