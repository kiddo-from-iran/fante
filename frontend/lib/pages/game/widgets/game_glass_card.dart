import 'package:flutter/material.dart';
import 'package:frontend/theme/app_colors.dart';

class GameGlassCard extends StatelessWidget {
  const GameGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderColor,
    this.glow = false,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color? borderColor;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final border = borderColor ?? AppColors.primaryGold.withValues(alpha: 0.28);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surfaceCard.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: glow ? 1.5 : 1),
        boxShadow: glow
            ? [
                BoxShadow(
                  color: AppColors.primaryGold.withValues(alpha: 0.35),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
