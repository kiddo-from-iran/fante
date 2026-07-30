import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/pages/dashboard/game_editor/question_tools/question_tool_models.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

/// Dialog to assign how many points an answer adds to each predefined result.
Future<ResultScoreMap?> showOptionScoreDialog({
  required BuildContext context,
  required String choiceLabel,
  required List<GameResultDraft> results,
  required ResultScoreMap initialScores,
}) {
  return showDialog<ResultScoreMap>(
    context: context,
    builder: (context) => _OptionScoreDialog(
      choiceLabel: choiceLabel,
      results: results,
      initialScores: Map<String, int>.from(initialScores),
    ),
  );
}

class _OptionScoreDialog extends StatefulWidget {
  const _OptionScoreDialog({
    required this.choiceLabel,
    required this.results,
    required this.initialScores,
  });

  final String choiceLabel;
  final List<GameResultDraft> results;
  final ResultScoreMap initialScores;

  @override
  State<_OptionScoreDialog> createState() => _OptionScoreDialogState();
}

class _OptionScoreDialogState extends State<_OptionScoreDialog> {
  late final List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    // One independent controller per row (index-based — never shared by id).
    _controllers = List<TextEditingController>.generate(
      widget.results.length,
      (i) {
        final resultId = widget.results[i].id;
        return TextEditingController(
          text: '${widget.initialScores[resultId] ?? 0}',
        );
      },
    );
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    final scores = <String, int>{};
    for (var i = 0; i < widget.results.length; i++) {
      final raw = _controllers[i].text.trim();
      final value = int.tryParse(raw) ?? 0;
      if (value != 0) {
        scores[widget.results[i].id] = value;
      }
    }
    Navigator.of(context).pop(scores);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'تخصیص امتیاز',
          style: AppTextTheme.getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textLight,
          ),
        ),
        content: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'این پاسخ چقدر به هر نتیجه امتیاز می‌دهد؟',
                style: AppTextTheme.getTextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.choiceLabel,
                style: AppTextTheme.getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGold,
                ),
              ),
              const SizedBox(height: 16),
              if (widget.results.isEmpty)
                Text(
                  'هنوز نتیجه‌ای تعریف نشده. به مرحله نتایج برگردید.',
                  style: AppTextTheme.getTextStyle(
                    fontSize: 13,
                    color: AppColors.errorColor,
                  ),
                )
              else
                for (var i = 0; i < widget.results.length; i++) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.results[i].title.trim().isEmpty
                              ? 'نتیجه بدون عنوان'
                              : widget.results[i].title,
                          style: AppTextTheme.getTextStyle(
                            fontSize: 13,
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 88,
                        child: TextField(
                          key: ValueKey(
                            'score-field-${widget.results[i].id}-$i',
                          ),
                          controller: _controllers[i],
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'-?\d*'),
                            ),
                          ],
                          textAlign: TextAlign.center,
                          cursorColor: AppColors.primaryGold,
                          style: AppTextTheme.getTextStyle(
                            fontSize: 14,
                            color: AppColors.textLight,
                          ),
                          decoration: InputDecoration(
                            hintText: '0',
                            hintStyle: AppTextTheme.getTextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.primaryGold,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.primaryGold,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.primaryGold,
                                width: 1.6,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'امتیاز',
                        style: AppTextTheme.getTextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'انصراف',
              style: AppTextTheme.getTextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: widget.results.isEmpty ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGold,
              foregroundColor: AppColors.textBlack,
              elevation: 0,
            ),
            child: Text(
              'ذخیره',
              style: AppTextTheme.getTextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact summary of assigned result scores under an option.
class OptionScoreSummary extends StatelessWidget {
  const OptionScoreSummary({
    super.key,
    required this.scores,
    required this.results,
  });

  final ResultScoreMap scores;
  final List<GameResultDraft> results;

  @override
  Widget build(BuildContext context) {
    if (scores.isEmpty) {
      return const SizedBox.shrink();
    }

    final chips = <Widget>[];
    for (final entry in scores.entries) {
      if (entry.value == 0) continue;
      GameResultDraft? result;
      for (final r in results) {
        if (r.id == entry.key) {
          result = r;
          break;
        }
      }
      final title = (result?.title.trim().isNotEmpty ?? false)
          ? result!.title
          : 'نتیجه';
      chips.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryGold.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primaryGold.withValues(alpha: 0.45),
            ),
          ),
          child: Text(
            '$title: ${entry.value > 0 ? '+' : ''}${entry.value}',
            style: AppTextTheme.getTextStyle(
              fontSize: 11,
              color: AppColors.primaryGold,
            ),
          ),
        ),
      );
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Wrap(spacing: 6, runSpacing: 6, children: chips),
    );
  }
}
