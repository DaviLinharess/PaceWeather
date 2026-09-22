import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Tela 3: Criar Treino (Novo Treino)
/// Topo amarelo com título e descrição; card inferior com campos arredondados
/// e seletor das zonas de frequência cardíaca (Z1 a Z5).
class NovoTreinoScreen extends StatefulWidget {
  const NovoTreinoScreen({super.key});

  @override
  State<NovoTreinoScreen> createState() => _NovoTreinoScreenState();
}

class _NovoTreinoScreenState extends State<NovoTreinoScreen> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _repeticoesController = TextEditingController();
  final TextEditingController _distanciaController = TextEditingController();

  String _selectedZone = 'Z5';
  final List<String> _zones = ['Z1', 'Z2', 'Z3', 'Z4', 'Z5'];

  @override
  void dispose() {
    _tituloController.dispose();
    _repeticoesController.dispose();
    _distanciaController.dispose();
    super.dispose();
  }

  void _saveWorkout() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Treino cadastrado com sucesso na Zona $_selectedZone!'),
        backgroundColor: AppColors.dark,
        duration: const Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryYellow,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // SEÇÃO SUPERIOR: TOPO AMARELO COM TÍTULO
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.dark, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Novo Treino',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: AppColors.dark,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Aqui você cadastrará seu novo treino! Poderá ter acesso a ele na página "Treinar".',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.dark,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ==========================================
            // SEÇÃO INFERIOR: FORMULÁRIO EM CARD ARREDONDADO
            // ==========================================
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F3F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(44),
                    topRight: Radius.circular(44),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Campo 1: Título do Treino
                      _buildFieldLabel('Título do Treino'),
                      const SizedBox(height: 8),
                      _buildPillInput(
                        controller: _tituloController,
                        hintText: 'Ex: Treino Intervalado',
                      ),

                      const SizedBox(height: 20),

                      // Campo 2: Número de Repetições
                      _buildFieldLabel('Número de Repetições'),
                      const SizedBox(height: 8),
                      _buildPillInput(
                        controller: _repeticoesController,
                        hintText: 'Ex: 10',
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 20),

                      // Campo 3: Distância
                      _buildFieldLabel('Distância'),
                      const SizedBox(height: 8),
                      _buildPillInput(
                        controller: _distanciaController,
                        hintText: 'Ex: 5000 m',
                      ),

                      const SizedBox(height: 20),

                      // Campo 4: Zona de Frequência Cardíaca (Pill seletor Z1 a Z5)
                      _buildFieldLabel('Zona de Frequência Cardíaca'),
                      const SizedBox(height: 8),
                      _buildHeartRateZoneSelector(),

                      const SizedBox(height: 36),

                      // Botão Salvar (Pílula Preta)
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.dark,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _saveWorkout,
                          child: const Text(
                            'Salvar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppColors.dark,
      ),
    );
  }

  Widget _buildPillInput({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.dark,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF9EA6B2),
          ),
        ),
      ),
    );
  }

  Widget _buildHeartRateZoneSelector() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _zones.map((zone) {
          final isSelected = zone == _selectedZone;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedZone = zone;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryYellow : Colors.transparent,
                shape: BoxShape.circle,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryYellow.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                zone,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.dark,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
