import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Botão de filtro em formato de pílula/retângulo arredondado
/// Estilizado conforme os seletores do protótipo da tela "Meus Treinos"
class FilterPill extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterPill({
    super.key,
    this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
  }) : assert(label != null || icon != null, 'Deve conter texto ou ícone');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 68,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryYellow : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryYellow
                : const Color(0xFFE2E6EE),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primaryYellow.withValues(alpha: 0.35)
                  : Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: label != null
            ? Text(
                label!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? AppColors.dark : AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              )
            : Icon(
                icon,
                size: 26,
                color: isSelected ? AppColors.dark : AppColors.textPrimary,
              ),
      ),
    );
  }
}
