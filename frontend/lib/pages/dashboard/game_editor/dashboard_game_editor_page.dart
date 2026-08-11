import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard/dashboard_assets.dart';
import 'package:frontend/pages/dashboard/dashboard_nav.dart';
import 'package:frontend/pages/dashboard/dashboard_routes.dart';
import 'package:frontend/pages/dashboard/game_editor/player_game.dart';
import 'package:frontend/pages/dashboard/game_editor/question_tools/image_pick_helper.dart';
import 'package:frontend/pages/dashboard/game_editor/question_tools/question_tools_panel.dart';
import 'package:frontend/pages/dashboard/game_editor/question_tools/questions_editor_panel.dart';
import 'package:frontend/pages/dashboard/game_editor/question_tools/results_editor_panel.dart';
import 'package:frontend/pages/dashboard/widgets/dashboard_shell.dart';
import 'package:frontend/pages/game/models/game_kind.dart';
import 'package:frontend/pages/game/utils/game_picture_helper.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:frontend/widgets/toast/app_toast.dart';

class DashboardGameEditorPage extends StatefulWidget {
  const DashboardGameEditorPage({
    super.key,
    this.gameId,
    this.initialKind,
  });

  final String? gameId;
  final GameKind? initialKind;

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
        kind: widget.initialKind ?? GameKind.quiz,
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
              coverImage: _draft.imagePath,
              playBackground: _draft.playBackgroundPath,
              onKindChanged: (kind) => setState(() {
                _draft.kind = kind;
                if (kind == GameKind.quiz) {
                  for (final q in _draft.questions) {
                    q.tools.removeWhere((t) => t.kind == QuestionToolKind.range);
                  }
                }
              }),
              onCoverChanged: (path) => setState(() => _draft.imagePath = path),
              onPlayBackgroundChanged: (path) =>
                  setState(() => _draft.playBackgroundPath = path),
            );
            final preview = _LivePreview(
              titleController: _titleController,
              descriptionController: _descriptionController,
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
            gameKind: _draft.kind,
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
              if (_draft.kind == GameKind.quiz &&
                  kind == QuestionToolKind.range) {
                AppToast.warning(
                  context,
                  'ابزار بازه برای کوییز در دسترس نیست.',
                );
                return;
              }
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
          final side = QuestionToolsPanel(gameKind: _draft.kind);

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
              SizedBox(width: 168, child: side),
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
    required this.coverImage,
    required this.playBackground,
    required this.onKindChanged,
    required this.onCoverChanged,
    required this.onPlayBackgroundChanged,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final GameKind kind;
  final String? coverImage;
  final String? playBackground;
  final ValueChanged<GameKind> onKindChanged;
  final ValueChanged<String?> onCoverChanged;
  final ValueChanged<String?> onPlayBackgroundChanged;

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
        ),
        const SizedBox(height: 18),
        _label('تصاویر بازی'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _EditableImageSlot(
              label: 'کاور / کارت بازی',
              hint: 'نمایش در لیست و صفحه معرفی',
              imageData: coverImage,
              onChanged: onCoverChanged,
            ),
            _EditableImageSlot(
              label: 'پس‌زمینه بازی',
              hint: 'نمایش زیر فرم سوالات هنگام بازی',
              imageData: playBackground,
              onChanged: onPlayBackgroundChanged,
            ),
          ],
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
  }) {
    final orangeBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.primaryGold, width: 1.2),
    );

    return TextField(
      controller: controller,
      maxLines: maxLines,
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

class _EditableImageSlot extends StatefulWidget {
  const _EditableImageSlot({
    required this.label,
    required this.hint,
    required this.imageData,
    required this.onChanged,
  });

  final String label;
  final String hint;
  final String? imageData;
  final ValueChanged<String?> onChanged;

  @override
  State<_EditableImageSlot> createState() => _EditableImageSlotState();
}

class _EditableImageSlotState extends State<_EditableImageSlot> {
  bool _busy = false;

  Future<void> _pick() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final dataUrl = await pickImageAsDataUrl();
      if (!mounted) return;
      if (dataUrl == null || dataUrl.isEmpty) return;
      widget.onChanged(dataUrl);
    } catch (_) {
      if (mounted) {
        AppToast.error(context, 'خطا در انتخاب تصویر');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget? _preview() {
    final data = widget.imageData;
    if (data == null || data.isEmpty) return null;
    return GamePictureHelper.image(picture: data);
  }

  @override
  Widget build(BuildContext context) {
    final preview = _preview();
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.label,
            style: AppTextTheme.getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.hint,
            style: AppTextTheme.getTextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _busy ? null : _pick,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 110,
                decoration: BoxDecoration(
                  color: AppColors.backgroundDark,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: preview != null
                        ? AppColors.primaryGold
                        : AppColors.textMuted.withValues(alpha: 0.45),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (preview != null)
                      preview
                    else
                      Center(
                        child: _busy
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primaryGold,
                                ),
                              )
                            : const Icon(
                                Icons.add_photo_alternate_outlined,
                                color: AppColors.textMuted,
                                size: 28,
                              ),
                      ),
                    if (preview != null)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Material(
                          color: Colors.black54,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () => widget.onChanged(null),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
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

class _LivePreview extends StatelessWidget {
  const _LivePreview({
    required this.titleController,
    required this.descriptionController,
    required this.imagePath,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
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
            child: GamePictureHelper.image(picture: imagePath),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: ListenableBuilder(
              listenable: Listenable.merge([
                titleController,
                descriptionController,
              ]),
              builder: (context, _) {
                final title = titleController.text.trim().isEmpty
                    ? 'دنیای انیمه'
                    : titleController.text.trim();
                final description = descriptionController.text.trim().isEmpty
                    ? 'توضیحات بازی اینجا نمایش داده می‌شود.'
                    : descriptionController.text.trim();
                return Column(
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
                );
              },
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
