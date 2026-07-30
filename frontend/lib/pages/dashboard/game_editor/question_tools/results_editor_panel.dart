import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard/game_editor/question_tools/question_tool_models.dart';
import 'package:frontend/pages/dashboard/game_editor/question_tools/question_tool_widgets.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

/// Step for defining predefined results before building questions.
class ResultsEditorPanel extends StatelessWidget {
  const ResultsEditorPanel({
    super.key,
    required this.results,
    required this.onChanged,
  });

  final List<GameResultDraft> results;
  final VoidCallback onChanged;

  void _addResult() {
    results.add(GameResultDraft.create(title: 'نتیجه ${results.length + 1}'));
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'نتایج بازی',
            textAlign: TextAlign.center,
            style: AppTextTheme.getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'نتایج از پیش تعریف‌شده را بسازید. بعداً در سوالات مشخص می‌کنید '
            'هر گزینه چقدر به هر نتیجه امتیاز می‌دهد.',
            textAlign: TextAlign.center,
            style: AppTextTheme.getTextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 20),
          if (results.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.textMuted.withValues(alpha: 0.35),
                ),
              ),
              child: Text(
                'هنوز نتیجه‌ای اضافه نشده. حداقل یک نتیجه بسازید.',
                textAlign: TextAlign.center,
                style: AppTextTheme.getTextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
            )
          else
            for (var i = 0; i < results.length; i++) ...[
              _ResultCard(
                index: i,
                result: results[i],
                canRemove: results.length > 1,
                onChanged: onChanged,
                onRemove: () {
                  results.removeAt(i);
                  onChanged();
                },
              ),
              const SizedBox(height: 12),
            ],
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.center,
            child: TextButton.icon(
              onPressed: _addResult,
              icon: const Icon(Icons.add, color: AppColors.primaryGold),
              label: Text(
                'افزودن نتیجه',
                style: AppTextTheme.getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.index,
    required this.result,
    required this.canRemove,
    required this.onChanged,
    required this.onRemove,
  });

  final int index;
  final GameResultDraft result;
  final bool canRemove;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryGold.withValues(alpha: 0.2),
                  border: Border.all(color: AppColors.primaryGold),
                ),
                child: Text(
                  '${index + 1}',
                  style: AppTextTheme.getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'نتیجه ${index + 1}',
                  style: AppTextTheme.getTextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textLight,
                  ),
                ),
              ),
              if (canRemove)
                IconButton(
                  onPressed: onRemove,
                  tooltip: 'حذف نتیجه',
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'عنوان نتیجه',
            style: AppTextTheme.getTextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            key: ValueKey('${result.id}-title'),
            initialValue: result.title,
            onChanged: (v) {
              result.title = v;
              onChanged();
            },
            cursorColor: AppColors.primaryGold,
            style: AppTextTheme.getTextStyle(
              fontSize: 14,
              color: AppColors.textLight,
            ),
            decoration: questionToolFieldDecoration(
              hint: 'مثلاً: شخصیت ماجراجو',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'توضیحات (اختیاری)',
            style: AppTextTheme.getTextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            key: ValueKey('${result.id}-desc'),
            initialValue: result.description,
            maxLines: 3,
            onChanged: (v) {
              result.description = v;
              onChanged();
            },
            cursorColor: AppColors.primaryGold,
            style: AppTextTheme.getTextStyle(
              fontSize: 13,
              color: AppColors.textLight,
            ),
            decoration: questionToolFieldDecoration(
              hint: 'توضیح کوتاه درباره این نتیجه...',
            ),
          ),
        ],
      ),
    );
  }
}
