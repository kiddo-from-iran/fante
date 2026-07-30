import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard/dashboard_assets.dart';
import 'package:frontend/pages/dashboard/dashboard_nav.dart';
import 'package:frontend/pages/dashboard/dashboard_routes.dart';
import 'package:frontend/pages/dashboard/game_editor/player_game.dart';
import 'package:frontend/pages/dashboard/game_editor/question_tools/question_tools_panel.dart';
import 'package:frontend/pages/dashboard/game_editor/question_tools/questions_editor_panel.dart';
import 'package:frontend/pages/dashboard/game_editor/question_tools/results_editor_panel.dart';
import 'package:frontend/pages/dashboard/widgets/dashboard_shell.dart';
import 'package:frontend/pages/game/models/game_kind.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:frontend/widgets/toast/app_toast.dart';

class DashboardGameEditorPage extends StatefulWidget {
  const DashboardGameEditorPage({
    super.key,
    this.gameId,
  });

  final String? gameId;

  @override
  State<DashboardGameEditorPage> createState() =>
      _DashboardGameEditorPageState();
}

class _DashboardGameEditorPageState extends State<DashboardGameEditorPage> {
  late PlayerGame _draft;
  int _step = 0;
  int _activeQuestion = 0;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  static const double _contentMaxWidth = 1100;

  bool get _isEditing => widget.gameId != null;

  double _sideGapFor(double maxWidth) {
    if (maxWidth >= 1100) return 40;
    if (maxWidth >= 800) return 28;
    return 12;
  }

  Widget _contentFrame({required Widget child}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sideGap = _sideGapFor(constraints.maxWidth);
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sideGap),
              child: child,
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    final existing = widget.gameId == null
        ? null
        : PlayerGamesStore.instance.byId(widget.gameId!);

    if (existing != null) {
      _draft = existing.copy();
      _draft.ensureResults();
      if (_draft.results.isEmpty) {
        _draft.results = [
          GameResultDraft.create(title: 'نتیجه ۱'),
          GameResultDraft.create(title: 'نتیجه ۲'),
        ];
      }
    } else {
      _draft = PlayerGame(
        id: PlayerGamesStore.instance.nextId(),
        title: '',
        description: '',
        kind: GameKind.quiz,
        createdAt: DateTime.now(),
        imagePath: DashboardAssets.thumb1,
        results: [
          GameResultDraft.create(title: 'نتیجه ۱'),
          GameResultDraft.create(title: 'نتیجه ۲'),
        ],
        questions: [GameQuestionDraft()],
      );
    }

    _titleController.text = _draft.title;
    _descriptionController.text = _draft.description;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _syncDraftFromFields() {
    _draft.title = _titleController.text.trim();
    _draft.description = _descriptionController.text.trim();
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  void _saveAndContinue() {
    _syncDraftFromFields();

    // 0: info → 1: results → 2: questions → 3: publish
    if (_step == 0) {
      if (_draft.title.isEmpty) {
        AppToast.warning(context, 'لطفاً عنوان بازی را وارد کنید');
        return;
      }
      setState(() => _step = 1);
      return;
    }

    if (_step == 1) {
      _draft.ensureResults();
      if (_draft.results.isEmpty) {
        AppToast.warning(context, 'حداقل یک نتیجه تعریف کنید');
        return;
      }
      if (_draft.results.any((r) => r.title.trim().isEmpty)) {
        AppToast.warning(context, 'عنوان همه نتایج را وارد کنید');
        return;
      }
      setState(() => _step = 2);
      return;
    }

    if (_step == 2) {
      if (_draft.questions.isEmpty) {
        AppToast.warning(context, 'حداقل یک سوال اضافه کنید');
        return;
      }
      setState(() => _step = 3);
      return;
    }

    _draft.isPublished = true;
    PlayerGamesStore.instance.upsert(_draft);
    AppToast.success(
      context,
      _isEditing ? 'بازی با موفقیت ویرایش شد' : 'بازی با موفقیت ساخته شد',
    );
    Navigator.of(context).pushNamedAndRemoveUntil(
      DashboardRoutes.games,
      (route) =>
          route.settings.name == DashboardRoutes.dashboard || route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      active: DashboardSection.myQuizzes,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _isEditing ? 'ویرایش بازی' : 'ساخت بازی جدید',
            textAlign: TextAlign.center,
            style: AppTextTheme.getTextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 20),
          _Stepper(
            currentStep: _step,
            onStepTap: (step) {
              if (step > _step) return; // only previous / current
              _syncDraftFromFields();
              setState(() => _step = step);
            },
          ),
          const SizedBox(height: 24),
          if (_step == 0) _buildInfoStep(),
          if (_step == 1) _buildResultsStep(),
          if (_step == 2) _buildQuestionsStep(),
          if (_step == 3) _buildPublishStep(),
          const SizedBox(height: 24),
          _contentFrame(
            child: _FooterActions(
              onCancel: _cancel,
              onContinue: _saveAndContinue,
              continueLabel: _step == 3 ? 'انتشار' : 'ذخیره و ادامه',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoStep() {
    return _contentFrame(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 720;
            final form = _InfoForm(
              titleController: _titleController,
              descriptionController: _descriptionController,
              kind: _draft.kind,
              onKindChanged: (kind) => setState(() => _draft.kind = kind),
              onChanged: () => setState(_syncDraftFromFields),
            );
            final preview = _LivePreview(
              title: _titleController.text.trim().isEmpty
                  ? 'دنیای انیمه'
                  : _titleController.text.trim(),
              description: _descriptionController.text.trim().isEmpty
                  ? 'توضیحات بازی اینجا نمایش داده می‌شود.'
                  : _descriptionController.text.trim(),
              imagePath: _draft.imagePath ?? DashboardAssets.thumb1,
            );

            if (!wide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  form,
                  const SizedBox(height: 20),
                  preview,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: form),
                const SizedBox(width: 24),
                SizedBox(width: 240, child: preview),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildResultsStep() {
    _draft.ensureResults();
    return _contentFrame(
      child: ResultsEditorPanel(
        results: _draft.results,
        onChanged: () => setState(() {}),
      ),
    );
  }

  Widget _buildQuestionsStep() {
    _draft.ensureResults();
    return _contentFrame(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 860;
          final main = QuestionsEditorPanel(
            questions: _draft.questions,
            results: _draft.results,
            activeIndex: _activeQuestion,
            onActiveChanged: (i) => setState(() => _activeQuestion = i),
            onPromptChanged: (value) {
              setState(() => _draft.questions[_activeQuestion].prompt = value);
            },
            onToolsChanged: () => setState(() {}),
            onAddQuestion: () {
              setState(() {
                _draft.questions.add(GameQuestionDraft());
                _activeQuestion = _draft.questions.length - 1;
              });
            },
            onDropTool: (kind) {
              final tools = _draft.questions[_activeQuestion].tools;
              if (tools.isNotEmpty) {
                AppToast.warning(
                  context,
                  'برای هر سوال فقط یک ابزار مجاز است. ابتدا ابزار فعلی را حذف کنید.',
                );
                return;
              }
              setState(() {
                tools.add(QuestionToolBlock.create(kind));
              });
            },
          );
          const side = QuestionToolsPanel();

          if (!wide) {
            return Column(
              children: [
                main,
                const SizedBox(height: 16),
                side,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: main),
              const SizedBox(width: 16),
              const SizedBox(width: 168, child: side),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPublishStep() {
    _syncDraftFromFields();
    return _contentFrame(
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'انتشار',
              textAlign: TextAlign.center,
              style: AppTextTheme.getTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'بازی «${_draft.title}» آماده انتشار است. با زدن دکمه انتشار، بازی در لیست بازی‌های شما ذخیره می‌شود.',
              textAlign: TextAlign.center,
              style: AppTextTheme.getTextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'نوع: ${_draft.kindLabel}  |  نتایج: ${_draft.resultsOrEmpty.length}  |  سوالات: ${_draft.questions.length}',
              textAlign: TextAlign.center,
              style: AppTextTheme.getTextStyle(
                fontSize: 13,
                color: AppColors.primaryGold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Stepper
// =============================================================================

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.currentStep,
    required this.onStepTap,
  });

  final int currentStep;
  final ValueChanged<int> onStepTap;

  static const _labels = [
    'اطلاعات اولیه',
    'نتایج',
    'سوالات بازی',
    'انتشار',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < _labels.length; i++) ...[
          if (i > 0)
            Container(
              width: 56,
              height: 1,
              margin: const EdgeInsets.only(bottom: 22, left: 12, right: 12),
              color: AppColors.textMuted.withValues(alpha: 0.4),
            ),
          Column(
            children: [
              Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: currentStep >= i ? () => onStepTap(i) : null,
                  child: Container(
                    width: currentStep == i ? 40 : 32,
                    height: currentStep == i ? 40 : 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentStep >= i
                          ? AppColors.textLight
                          : AppColors.hoverButton,
                      border: Border.all(
                        color: currentStep == i
                            ? AppColors.primaryGold
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      '${i + 1}',
                      style: AppTextTheme.getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: currentStep >= i
                            ? AppColors.textBlack
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: currentStep >= i ? () => onStepTap(i) : null,
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    _labels[i],
                    style: AppTextTheme.getTextStyle(
                      fontSize: 12,
                      fontWeight:
                          currentStep == i ? FontWeight.bold : FontWeight.w500,
                      color: currentStep == i
                          ? AppColors.textLight
                          : AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// =============================================================================
// Step 1 — info form + preview
// =============================================================================

class _InfoForm extends StatelessWidget {
  const _InfoForm({
    required this.titleController,
    required this.descriptionController,
    required this.kind,
    required this.onKindChanged,
    required this.onChanged,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final GameKind kind;
  final ValueChanged<GameKind> onKindChanged;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'اطلاعات بازی',
          style: AppTextTheme.getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 20),
        _label('عنوان بازی'),
        const SizedBox(height: 8),
        _outlinedField(
          controller: titleController,
          hint: 'اسم بازی',
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 18),
        _label('نوع بازی'),
        const SizedBox(height: 10),
        Row(
          children: [
            _KindChip(
              label: 'کوییز',
              selected: kind == GameKind.quiz,
              onTap: () => onKindChanged(GameKind.quiz),
            ),
            const SizedBox(width: 10),
            _KindChip(
              label: 'نظرسنجی',
              selected: kind == GameKind.poll,
              onTap: () => onKindChanged(GameKind.poll),
            ),
            const SizedBox(width: 10),
            _KindChip(
              label: 'تست',
              selected: kind == GameKind.personality,
              onTap: () => onKindChanged(GameKind.personality),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _label('توضیحات بازی'),
        const SizedBox(height: 8),
        _outlinedField(
          controller: descriptionController,
          hint: 'توضیحات کوتاه درباره بازی...',
          maxLines: 5,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 18),
        _label('اضافه کردن تصویر'),
        const SizedBox(height: 10),
        Row(
          children: List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.only(left: index < 2 ? 12 : 0),
              child: _ImageSlot(filled: index == 0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: AppTextTheme.getTextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textLight,
      ),
    );
  }

  Widget _outlinedField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    required ValueChanged<String> onChanged,
  }) {
    final orangeBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.primaryGold, width: 1.2),
    );

    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      cursorColor: AppColors.primaryGold,
      style: AppTextTheme.getTextStyle(
        fontSize: 14,
        color: AppColors.textLight,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextTheme.getTextStyle(
          fontSize: 13,
          color: AppColors.textMuted,
        ),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: orangeBorder,
        enabledBorder: orangeBorder,
        focusedBorder: orangeBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.primaryGold, width: 1.6),
        ),
      ),
    );
  }
}

class _KindChip extends StatelessWidget {
  const _KindChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryGold : AppColors.backgroundDark,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: AppTextTheme.getTextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.textBlack : AppColors.textLight,
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageSlot extends StatelessWidget {
  const _ImageSlot({required this.filled});

  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.textMuted.withValues(alpha: 0.45),
          style: BorderStyle.solid,
        ),
        image: filled
            ? const DecorationImage(
                image: AssetImage(DashboardAssets.thumb1),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: filled
          ? null
          : Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.image_outlined,
                    color: AppColors.textMuted,
                    size: 28,
                  ),
                ),
                Positioned(
                  left: 6,
                  bottom: 6,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: AppColors.errorColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, size: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
    );
  }
}

class _LivePreview extends StatelessWidget {
  const _LivePreview({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  final String title;
  final String description;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextTheme.getTextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '«$description»',
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.getTextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Footer
// =============================================================================

class _FooterActions extends StatelessWidget {
  const _FooterActions({
    required this.onCancel,
    required this.onContinue,
    required this.continueLabel,
  });

  final VoidCallback onCancel;
  final VoidCallback onContinue;
  final String continueLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: onCancel,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.backgroundDark,
                foregroundColor: AppColors.textLight,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'انصراف',
                style: AppTextTheme.getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGold,
                foregroundColor: AppColors.textBlack,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                continueLabel,
                style: AppTextTheme.getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
