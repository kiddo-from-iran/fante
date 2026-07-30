import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard/game_editor/question_tools/question_tool_models.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

/// Side panel listing draggable question tools.
class QuestionToolsPanel extends StatelessWidget {
  const QuestionToolsPanel({super.key});

  static const tools = QuestionToolKind.values;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'ابزارها',
            textAlign: TextAlign.center,
            style: AppTextTheme.getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'بکشید و در کادر سوال رها کنید',
            textAlign: TextAlign.center,
            style: AppTextTheme.getTextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          for (final kind in tools) ...[
            _DraggableToolChip(kind: kind),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _DraggableToolChip extends StatelessWidget {
  const _DraggableToolChip({required this.kind});

  final QuestionToolKind kind;

  @override
  Widget build(BuildContext context) {
    final chip = _ToolChip(label: kind.shortLabel, dragging: false);

    return Draggable<QuestionToolKind>(
      data: kind,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.05,
          child: SizedBox(
            width: 150,
            child: _ToolChip(label: kind.shortLabel, dragging: true),
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.35, child: chip),
      child: chip,
    );
  }
}

class _ToolChip extends StatelessWidget {
  const _ToolChip({
    required this.label,
    required this.dragging,
  });

  final String label;
  final bool dragging;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: dragging
            ? AppColors.primaryGold.withValues(alpha: 0.2)
            : AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primaryGold),
        boxShadow: dragging
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppTextTheme.getTextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textLight,
        ),
      ),
    );
  }
}
