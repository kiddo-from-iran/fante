import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard/game_editor/question_tools/question_tool_models.dart';
import 'package:frontend/pages/dashboard/game_editor/question_tools/question_tool_widgets.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

/// Main questions canvas: definition field, dropped tools, and pagination.
class QuestionsEditorPanel extends StatelessWidget {
  const QuestionsEditorPanel({
    super.key,
    required this.questions,
    required this.results,
    required this.activeIndex,
    required this.onActiveChanged,
    required this.onPromptChanged,
    required this.onToolsChanged,
    required this.onAddQuestion,
    required this.onDropTool,
  });

  final List<GameQuestionDraft> questions;
  final List<GameResultDraft> results;
  final int activeIndex;
  final ValueChanged<int> onActiveChanged;
  final ValueChanged<String> onPromptChanged;
  final VoidCallback onToolsChanged;
  final VoidCallback onAddQuestion;
  final ValueChanged<QuestionToolKind> onDropTool;

  @override
  Widget build(BuildContext context) {
    final question = questions[activeIndex];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'سوالات بازی',
            textAlign: TextAlign.center,
            style: AppTextTheme.getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'متن سوال',
            style: AppTextTheme.getTextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            key: ValueKey('prompt-$activeIndex'),
            initialValue: question.prompt,
            onChanged: onPromptChanged,
            cursorColor: AppColors.primaryGold,
            style: AppTextTheme.getTextStyle(
              fontSize: 14,
              color: AppColors.textLight,
            ),
            decoration: questionToolFieldDecoration(
              hint: 'تعریف سوال را اینجا بنویسید...',
            ),
          ),
          const SizedBox(height: 16),
          DragTarget<QuestionToolKind>(
            onWillAcceptWithDetails: (details) => question.tools.isEmpty,
            onAcceptWithDetails: (details) => onDropTool(details.data),
            builder: (context, candidate, rejected) {
              final hovering = candidate.isNotEmpty;
              final blocked = question.tools.isNotEmpty && rejected.isNotEmpty;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                constraints: const BoxConstraints(minHeight: 180),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: hovering
                      ? AppColors.primaryGold.withValues(alpha: 0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: blocked
                        ? AppColors.errorColor.withValues(alpha: 0.7)
                        : hovering
                            ? AppColors.primaryGold
                            : AppColors.textMuted.withValues(alpha: 0.35),
                    width: hovering || blocked ? 1.6 : 1,
                  ),
                ),
                child: question.tools.isEmpty
                    ? Center(
                        child: Text(
                          'یک ابزار را از ستون کناری به اینجا بکشید\n(فقط یک ابزار برای هر سوال)',
                          textAlign: TextAlign.center,
                          style: AppTextTheme.getTextStyle(
                            fontSize: 13,
                            color: AppColors.textMuted,
                            height: 1.5,
                          ),
                        ),
                      )
                    : _buildTool(question.tools.first, 0),
              );
            },
          ),
          const SizedBox(height: 18),
          _QuestionPagination(
            count: questions.length,
            activeIndex: activeIndex,
            onSelect: onActiveChanged,
            onAdd: onAddQuestion,
          ),
        ],
      ),
    );
  }

  Widget _buildTool(QuestionToolBlock block, int index) {
    void remove() {
      questions[activeIndex].tools.removeAt(index);
      onToolsChanged();
    }

    switch (block.kind) {
      case QuestionToolKind.multipleChoice:
        return MultipleChoiceToolWidget(
          block: block,
          results: results,
          onChanged: onToolsChanged,
          onRemove: remove,
        );
      case QuestionToolKind.multipleChoiceImage:
        return MultipleChoiceImageToolWidget(
          block: block,
          results: results,
          onChanged: onToolsChanged,
          onRemove: remove,
        );
      case QuestionToolKind.range:
        return RangeToolWidget(
          block: block,
          results: results,
          onChanged: onToolsChanged,
          onRemove: remove,
        );
    }
  }
}

class _QuestionPagination extends StatelessWidget {
  const _QuestionPagination({
    required this.count,
    required this.activeIndex,
    required this.onSelect,
    required this.onAdd,
  });

  final int count;
  final int activeIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          InkWell(
            onTap: () => onSelect(i),
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == activeIndex
                    ? AppColors.primaryGold
                    : AppColors.backgroundDark,
                border: Border.all(
                  color: i == activeIndex
                      ? AppColors.primaryGold
                      : AppColors.textMuted.withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                '${i + 1}',
                style: AppTextTheme.getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: i == activeIndex
                      ? AppColors.textBlack
                      : AppColors.textLight,
                ),
              ),
            ),
          ),
        InkWell(
          onTap: onAdd,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.backgroundDark,
              border: Border.all(color: AppColors.primaryGold),
            ),
            child: const Icon(
              Icons.add,
              size: 18,
              color: AppColors.primaryGold,
            ),
          ),
        ),
        TextButton(
          onPressed: onAdd,
          child: Text(
            'سوال جدید',
            style: AppTextTheme.getTextStyle(
              fontSize: 12,
              color: AppColors.primaryGold,
            ),
          ),
        ),
      ],
    );
  }
}
