import 'package:flutter/material.dart';
import 'package:frontend/pages/game/models/game_session_data.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class GameResultBar extends StatelessWidget {
  const GameResultBar({
    super.key,
    required this.option,
    this.highlighted = false,
    this.showPercent = true,
    this.onTap,
  });

  final GameOptionData option;
  final bool highlighted;
  final bool showPercent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fillColor = highlighted
        ? AppColors.primaryGold
        : AppColors.hoverButton.withValues(alpha: 0.85);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: highlighted
                    ? AppColors.primaryGold
                    : AppColors.cardBorder,
                width: highlighted ? 1.5 : 1,
              ),
              boxShadow: highlighted
                  ? [
                      BoxShadow(
                        color: AppColors.primaryGold.withValues(alpha: 0.25),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                if (showPercent) ...[
                  SizedBox(
                    width: 36,
                    child: Text(
                      '${option.percent.toInt()}%',
                      style: AppTextTheme.getTextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: highlighted
                            ? AppColors.primaryGold
                            : AppColors.textLight,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: option.percent / 100,
                          minHeight: 28,
                          backgroundColor: AppColors.backgroundDark,
                          valueColor: AlwaysStoppedAnimation<Color>(fillColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            option.label,
                            textAlign: TextAlign.right,
                            style: AppTextTheme.getTextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textLight,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GameOptionTile extends StatelessWidget {
  const GameOptionTile({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          splashColor: AppColors.primaryGold.withValues(alpha: 0.12),
          highlightColor: AppColors.primaryGold.withValues(alpha: 0.06),
          child: Ink(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected
                    ? AppColors.primaryGold
                    : AppColors.cardBorder,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextTheme.getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: selected ? AppColors.primaryGold : AppColors.textLight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GameOrangeButton extends StatelessWidget {
  const GameOrangeButton({
    super.key,
    required this.label,
    this.onPressed,
    this.outlined = false,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool outlined;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final button = outlined
        ? OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryGold,
              side: const BorderSide(color: AppColors.primaryGold, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              label,
              style: AppTextTheme.getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryGold,
              ),
            ),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGold,
              foregroundColor: AppColors.textLight,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              label,
              style: AppTextTheme.getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textLight,
              ),
            ),
          );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class GameGlowStatBar extends StatelessWidget {
  const GameGlowStatBar({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primaryGold.withValues(alpha: 0.55),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGold.withValues(alpha: 0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppTextTheme.getTextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textLight,
        ),
      ),
    );
  }
}
