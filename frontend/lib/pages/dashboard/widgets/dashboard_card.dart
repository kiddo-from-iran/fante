import 'package:flutter/material.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

/// Outer glass panel used for every dashboard section.
class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    this.title,
    this.actionLabel,
    this.onAction,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final String? title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Row(
              children: [
                Text(
                  title!,
                  style: AppTextTheme.getTextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),
                const Spacer(),
                if (actionLabel != null)
                  TextButton(
                    onPressed: onAction,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primaryGold,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          actionLabel!,
                          style: AppTextTheme.getTextStyle(
                            fontSize: 12,
                            color: AppColors.primaryGold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_back_rounded, size: 14),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }
}
