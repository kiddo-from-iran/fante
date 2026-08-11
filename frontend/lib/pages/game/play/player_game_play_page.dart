import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/pages/dashboard/game_editor/player_game.dart';
import 'package:frontend/pages/game/models/game_kind.dart';
import 'package:frontend/pages/game/models/game_session_data.dart';
import 'package:frontend/pages/game/utils/player_game_mapper.dart';
import 'package:frontend/pages/game/widgets/game_author_header.dart';
import 'package:frontend/pages/game/widgets/game_glass_card.dart';
import 'package:frontend/pages/game/widgets/game_option_widgets.dart';
import 'package:frontend/pages/game/widgets/game_play_below_section.dart';
import 'package:frontend/pages/game/widgets/game_scaffold.dart';
import 'package:frontend/pages/game/widgets/quiz_inline_result_panel.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:frontend/widgets/toast/app_toast.dart';

/// Multi-question play session built from a published [PlayerGame].
class PlayerGamePlayPage extends StatelessWidget {
  const PlayerGamePlayPage({super.key, required this.game});

  final PlayerGame game;

  @override
  Widget build(BuildContext context) {
    final background = PlayerGameMapper.playBackgroundOf(game);
    return GameScaffold(
      backgroundAsset: background,
      child: _PlayerGamePlayBody(game: game),
    );
  }
}

class _PlayerGamePlayBody extends StatefulWidget {
  const _PlayerGamePlayBody({required this.game});

  final PlayerGame game;

  @override
  State<_PlayerGamePlayBody> createState() => _PlayerGamePlayBodyState();
}

class _PlayerGamePlayBodyState extends State<_PlayerGamePlayBody> {
  late final List<GameSessionData> _steps;
  late final GameSidebarData _sidebar;
  late final List<int?> _answers;
  int _index = 0;
  int? _selected;
  bool _finished = false;

  bool get _isQuiz => widget.game.kind == GameKind.quiz;

  @override
  void initState() {
    super.initState();
    _steps = PlayerGameMapper.buildPlaySteps(widget.game);
    _sidebar = PlayerGameMapper.sidebarOf(widget.game);
    _answers = List<int?>.filled(_steps.length, null);
  }

  GameSessionData get _current => _steps[_index];

  int get _score {
    if (!_isQuiz) return _answers.whereType<int>().length;
    var correct = 0;
    for (var i = 0; i < _steps.length; i++) {
      final step = _steps[i];
      final answer = _answers[i];
      if (step is! QuizPlayData || answer == null) continue;
      if (step.correctIndex != null && answer == step.correctIndex) {
        correct += 1;
      }
    }
    return correct;
  }

  void _select(int i) {
    if (_selected == i) return;
    setState(() => _selected = i);
  }

  void _next() {
    if (_selected == null) return;
    _answers[_index] = _selected;
    if (_index >= _steps.length - 1) {
      setState(() => _finished = true);
      return;
    }
    setState(() {
      _index += 1;
      _selected = null;
    });
  }

  Future<void> _shareResultLink() async {
    final base = Uri.base;
    final link = base.replace(
      queryParameters: {
        ...base.queryParameters,
        'gameId': widget.game.id,
        'score': '$_score',
        'total': '${_steps.length}',
      },
      fragment: 'game/result/quiz',
    ).toString();

    // Prefer a clean path-style link on Flutter web.
    final pathLink =
        '${base.origin}/game/result/quiz?gameId=${widget.game.id}&score=$_score&total=${_steps.length}';

    await Clipboard.setData(ClipboardData(text: pathLink.isNotEmpty ? pathLink : link));
    if (!mounted) return;
    AppToast.success(context, 'لینک نتیجه کپی شد');
  }

  void _showAnswerReport() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.72,
            minChildSize: 0.4,
            maxChildSize: 0.92,
            builder: (context, controller) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.textMuted.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'گزارش پاسخ‌های شما',
                      textAlign: TextAlign.center,
                      style: AppTextTheme.getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                    ),
                    if (_isQuiz) ...[
                      const SizedBox(height: 6),
                      Text(
                        'پاسخ شما و پاسخ صحیح برای هر سوال',
                        textAlign: TextAlign.center,
                        style: AppTextTheme.getTextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 6),
                      Text(
                        'این بازی پاسخ درست/غلط ندارد — فقط انتخاب‌های شما نمایش داده می‌شود',
                        textAlign: TextAlign.center,
                        style: AppTextTheme.getTextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.separated(
                        controller: controller,
                        itemCount: _steps.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          return _AnswerReportCard(
                            index: i,
                            step: _steps[i],
                            selectedIndex: _answers[i],
                            showCorrectness: _isQuiz,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_steps.isEmpty) {
      return Center(
        child: Text(
          'سوالی برای این بازی تعریف نشده است.',
          style: AppTextTheme.getTextStyle(color: AppColors.textLight),
        ),
      );
    }

    final data = _current;
    return GameSessionLayout(
      sidebar: GameSidebar(data: _sidebar),
      main: _finished
          ? QuizInlineResultPanel(
              title: widget.game.title,
              designerName: 'شما',
              score: _score,
              totalQuestions: _steps.length,
              onShare: _shareResultLink,
              onViewChoices: _showAnswerReport,
            )
          : GameGlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GameAuthorHeader(
                    title: data.title,
                    designerName: data.designerName,
                    designerAvatar: data.designerAvatar,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'سوال ${_index + 1} از ${_steps.length}',
                    textAlign: TextAlign.right,
                    style: AppTextTheme.getTextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.cardBorder, height: 1),
                  const SizedBox(height: 20),
                  if (data is QuizPlayData)
                    _QuizStep(
                      data: data,
                      selected: _selected,
                      onSelect: _select,
                    ),
                  if (data is PollPlayData)
                    _PollStep(
                      data: data,
                      selected: _selected,
                      onSelect: _select,
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _selected == null ? null : _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGold,
                        foregroundColor: AppColors.textBlack,
                        disabledBackgroundColor:
                            AppColors.primaryGold.withValues(alpha: 0.35),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _index >= _steps.length - 1
                            ? 'مشاهده نتیجه'
                            : 'سوال بعد',
                        style: AppTextTheme.getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      footer: const GamePlayBelowSection(),
    );
  }
}

class _AnswerReportCard extends StatelessWidget {
  const _AnswerReportCard({
    required this.index,
    required this.step,
    required this.selectedIndex,
    required this.showCorrectness,
  });

  final int index;
  final GameSessionData step;
  final int? selectedIndex;
  final bool showCorrectness;

  @override
  Widget build(BuildContext context) {
    String question;
    List<String> options;
    int? correctIndex;

    if (step is QuizPlayData) {
      final q = step as QuizPlayData;
      question = q.question;
      options = q.options;
      correctIndex = q.correctIndex;
    } else if (step is PollPlayData) {
      final q = step as PollPlayData;
      question = q.question;
      options = q.options.map((o) => o.label).toList();
      correctIndex = null;
    } else {
      question = 'سوال ${index + 1}';
      options = const [];
      correctIndex = null;
    }

    final userLabel = (selectedIndex != null &&
            selectedIndex! >= 0 &&
            selectedIndex! < options.length)
        ? options[selectedIndex!]
        : '—';
    final correct = correctIndex;
    final hasCorrect =
        correct != null && correct >= 0 && correct < options.length;
    final correctLabel = hasCorrect ? options[correct] : null;
    final isCorrect =
        showCorrectness && hasCorrect && selectedIndex == correct;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: showCorrectness
              ? (isCorrect
                  ? const Color(0xFF2D7D46)
                  : AppColors.errorColor.withValues(alpha: 0.7))
              : AppColors.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${index + 1}. $question',
            textAlign: TextAlign.right,
            style: AppTextTheme.getTextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 10),
          _ReportLine(
            label: 'پاسخ شما',
            value: userLabel,
            color: showCorrectness
                ? (isCorrect
                    ? const Color(0xFF7DCEA0)
                    : AppColors.errorColor)
                : AppColors.primaryGold,
          ),
          if (showCorrectness && correctLabel != null) ...[
            const SizedBox(height: 6),
            _ReportLine(
              label: 'پاسخ صحیح',
              value: correctLabel,
              color: const Color(0xFF7DCEA0),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReportLine extends StatelessWidget {
  const _ReportLine({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.right,
      text: TextSpan(
        style: AppTextTheme.getTextStyle(fontSize: 12, color: AppColors.textMuted),
        children: [
          TextSpan(text: '$label: '),
          TextSpan(
            text: value,
            style: AppTextTheme.getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizStep extends StatelessWidget {
  const _QuizStep({
    required this.data,
    required this.selected,
    required this.onSelect,
  });

  final QuizPlayData data;
  final int? selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          data.question,
          textAlign: TextAlign.right,
          style: AppTextTheme.getTextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textLight,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        for (var i = 0; i < data.options.length; i++)
          GameOptionTile(
            label: data.options[i],
            selected: selected == i,
            onTap: () => onSelect(i),
          ),
      ],
    );
  }
}

class _PollStep extends StatelessWidget {
  const _PollStep({
    required this.data,
    required this.selected,
    required this.onSelect,
  });

  final PollPlayData data;
  final int? selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          data.question,
          textAlign: TextAlign.right,
          style: AppTextTheme.getTextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textLight,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        for (var i = 0; i < data.options.length; i++)
          GameOptionTile(
            label: data.options[i].label,
            selected: selected == i,
            onTap: () => onSelect(i),
          ),
      ],
    );
  }
}
