import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard/game_editor/question_tools/image_pick_helper.dart';
import 'package:frontend/pages/dashboard/game_editor/question_tools/option_score_dialog.dart';
import 'package:frontend/pages/dashboard/game_editor/question_tools/question_tool_models.dart';
import 'package:frontend/pages/game/utils/game_picture_helper.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:frontend/widgets/toast/app_toast.dart';

InputDecoration questionToolFieldDecoration({required String hint}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: AppColors.primaryGold, width: 1.2),
  );

  return InputDecoration(
    hintText: hint,
    hintStyle: AppTextTheme.getTextStyle(
      fontSize: 13,
      color: AppColors.textMuted,
    ),
    filled: true,
    fillColor: Colors.transparent,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    border: border,
    enabledBorder: border,
    focusedBorder: border.copyWith(
      borderSide: const BorderSide(color: AppColors.primaryGold, width: 1.6),
    ),
  );
}

/// Shared chrome around a dropped question tool.
class QuestionToolShell extends StatelessWidget {
  const QuestionToolShell({
    super.key,
    required this.title,
    required this.onRemove,
    required this.child,
  });

  final String title;
  final VoidCallback onRemove;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextTheme.getTextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGold,
                  ),
                ),
              ),
              IconButton(
                onPressed: onRemove,
                tooltip: 'حذف ابزار',
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

Future<void> _editScores({
  required BuildContext context,
  required QuestionToolBlock block,
  required int index,
  required String choiceLabel,
  required List<GameResultDraft> results,
  required VoidCallback onChanged,
}) async {
  block.ensureScoreSlots();
  final updated = await showOptionScoreDialog(
    context: context,
    choiceLabel: choiceLabel,
    results: results,
    initialScores: Map<String, int>.from(block.scoresFor(index)),
  );
  if (updated == null) return;
  block.optionScores[index] = updated;
  onChanged();
}

class _ScoreButton extends StatelessWidget {
  const _ScoreButton({
    required this.hasScores,
    required this.onPressed,
  });

  final bool hasScores;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: 'تخصیص امتیاز به نتایج',
      icon: Icon(
        hasScores ? Icons.stars_rounded : Icons.star_border_rounded,
        color: hasScores ? AppColors.primaryGold : AppColors.textMuted,
        size: 22,
      ),
    );
  }
}

/// Radio to mark the single correct option on quiz questions.
/// Must sit under a `RadioGroup<int>` ancestor.
class _CorrectAnswerRadio extends StatelessWidget {
  const _CorrectAnswerRadio({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'پاسخ صحیح',
      child: Radio<int>(
        value: index,
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryGold;
          }
          return AppColors.textMuted;
        }),
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

/// Multiple-choice options tool — add as many option fields as needed.
class MultipleChoiceToolWidget extends StatefulWidget {
  const MultipleChoiceToolWidget({
    super.key,
    required this.block,
    required this.results,
    required this.onChanged,
    required this.onRemove,
    this.isQuiz = false,
  });

  final QuestionToolBlock block;
  final List<GameResultDraft> results;
  final VoidCallback onChanged;
  final VoidCallback onRemove;
  final bool isQuiz;

  @override
  State<MultipleChoiceToolWidget> createState() =>
      _MultipleChoiceToolWidgetState();
}

class _MultipleChoiceToolWidgetState extends State<MultipleChoiceToolWidget> {
  QuestionToolBlock get block => widget.block;

  void _notify() {
    if (!mounted) return;
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    block.ensureScoreSlots();
    final body = Column(
      key: ValueKey('mc-opts-${block.id}-${block.options.length}'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.isQuiz) ...[
          Text(
            'پاسخ صحیح را با دکمه رادیویی مشخص کنید',
            style: AppTextTheme.getTextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),
        ],
        for (var i = 0; i < block.options.length; i++) ...[
          Row(
            children: [
              if (widget.isQuiz) _CorrectAnswerRadio(index: i),
              Expanded(
                child: TextFormField(
                  key: ValueKey('${block.id}-opt-$i-${block.options.length}'),
                  initialValue: block.options[i],
                  onChanged: (v) {
                    block.options[i] = v;
                  },
                  cursorColor: AppColors.primaryGold,
                  style: AppTextTheme.getTextStyle(
                    fontSize: 13,
                    color: AppColors.textLight,
                  ),
                  decoration: questionToolFieldDecoration(
                    hint: 'متن گزینه ${i + 1}',
                  ),
                ),
              ),
              if (!widget.isQuiz)
                _ScoreButton(
                  hasScores: block.totalAssignedPoints(i) != 0,
                  onPressed: () => _editScores(
                    context: context,
                    block: block,
                    index: i,
                    choiceLabel: block.options[i].trim().isEmpty
                        ? 'گزینه ${i + 1}'
                        : block.options[i],
                    results: widget.results,
                    onChanged: _notify,
                  ),
                ),
              if (block.options.length > 2)
                IconButton(
                  onPressed: () {
                    setState(() => block.removeChoiceAt(i));
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) widget.onChanged();
                    });
                  },
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                ),
            ],
          ),
          if (!widget.isQuiz)
            Align(
              alignment: Alignment.centerRight,
              child: OptionScoreSummary(
                scores: block.scoresFor(i),
                results: widget.results,
              ),
            ),
          const SizedBox(height: 10),
        ],
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () {
              setState(() => block.addChoice());
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) widget.onChanged();
              });
            },
            icon: const Icon(Icons.add, size: 18, color: AppColors.primaryGold),
            label: Text(
              'افزودن گزینه',
              style: AppTextTheme.getTextStyle(
                fontSize: 13,
                color: AppColors.primaryGold,
              ),
            ),
          ),
        ),
      ],
    );

    return QuestionToolShell(
      title: QuestionToolKind.multipleChoice.label,
      onRemove: widget.onRemove,
      child: widget.isQuiz
          ? RadioGroup<int>(
              groupValue: block.correctOptionIndex,
              onChanged: (value) {
                if (value == null) return;
                block.correctOptionIndex = value;
                _notify();
              },
              child: body,
            )
          : body,
    );
  }
}

/// Multiple-choice with an image slot per option (upload + list/tiles layout).
class MultipleChoiceImageToolWidget extends StatefulWidget {
  const MultipleChoiceImageToolWidget({
    super.key,
    required this.block,
    required this.results,
    required this.onChanged,
    required this.onRemove,
    this.isQuiz = false,
  });

  final QuestionToolBlock block;
  final List<GameResultDraft> results;
  final VoidCallback onChanged;
  final VoidCallback onRemove;
  final bool isQuiz;

  @override
  State<MultipleChoiceImageToolWidget> createState() =>
      _MultipleChoiceImageToolWidgetState();
}

class _MultipleChoiceImageToolWidgetState
    extends State<MultipleChoiceImageToolWidget> {
  int? _pickingIndex;
  int _optionsTick = 0;

  QuestionToolBlock get block => widget.block;

  void _notify() {
    if (!mounted) return;
    setState(() {});
    // Defer parent rebuild so it does not cancel this frame's local update.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onChanged();
    });
  }

  void _addOption() {
    setState(() {
      block.addChoice();
      _optionsTick++;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onChanged();
    });
  }

  Future<void> _pickImage(int index) async {
    if (_pickingIndex != null) return;
    setState(() => _pickingIndex = index);
    try {
      final dataUrl = await pickImageAsDataUrl();
      if (!mounted) return;
      if (dataUrl == null || dataUrl.isEmpty) return;

      while (block.optionImages.length <= index) {
        block.optionImages.add(null);
      }
      block.optionImages[index] = dataUrl;
      _notify();
    } catch (_) {
      if (mounted) {
        AppToast.error(context, 'خطا در باز کردن پنجره انتخاب تصویر');
      }
    } finally {
      if (mounted) setState(() => _pickingIndex = null);
    }
  }

  void _clearImage(int index) {
    while (block.optionImages.length <= index) {
      block.optionImages.add(null);
    }
    block.optionImages[index] = null;
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    block.ensureScoreSlots();
    final body = Column(
      key: ValueKey('img-opts-${block.id}-$_optionsTick-${block.options.length}'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ImageLayoutPicker(
          layout: block.imageLayout,
          tileColumns: block.tileColumns,
          onLayoutChanged: (layout) {
            block.imageLayout = layout;
            _notify();
          },
          onColumnsChanged: (cols) {
            block.tileColumns = cols;
            _notify();
          },
        ),
        if (widget.isQuiz) ...[
          const SizedBox(height: 10),
          Text(
            'پاسخ صحیح را با دکمه رادیویی مشخص کنید',
            style: AppTextTheme.getTextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        ],
        const SizedBox(height: 14),
        if (block.imageLayout == ImageChoiceLayout.list)
          ..._buildListLayout()
        else
          _buildTilesLayout(),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: _addOption,
            icon: const Icon(Icons.add, size: 18, color: AppColors.primaryGold),
            label: Text(
              'افزودن گزینه تصویری',
              style: AppTextTheme.getTextStyle(
                fontSize: 13,
                color: AppColors.primaryGold,
              ),
            ),
          ),
        ),
      ],
    );

    return QuestionToolShell(
      title: QuestionToolKind.multipleChoiceImage.label,
      onRemove: widget.onRemove,
      child: widget.isQuiz
          ? RadioGroup<int>(
              groupValue: block.correctOptionIndex,
              onChanged: (value) {
                if (value == null) return;
                block.correctOptionIndex = value;
                _notify();
              },
              child: body,
            )
          : body,
    );
  }

  List<Widget> _buildListLayout() {
    return [
      for (var i = 0; i < block.options.length; i++) ...[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isQuiz)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: _CorrectAnswerRadio(index: i),
              ),
            _ImageUploadSlot(
              imageData: i < block.optionImages.length
                  ? block.optionImages[i]
                  : null,
              size: 72,
              busy: _pickingIndex == i,
              onTap: () => _pickImage(i),
              onClear: () => _clearImage(i),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                key: ValueKey(
                  '${block.id}-img-opt-$i-$_optionsTick-${block.options.length}',
                ),
                initialValue: block.options[i],
                onChanged: (v) {
                  block.options[i] = v;
                },
                cursorColor: AppColors.primaryGold,
                style: AppTextTheme.getTextStyle(
                  fontSize: 13,
                  color: AppColors.textLight,
                ),
                decoration: questionToolFieldDecoration(
                  hint: 'متن گزینه ${i + 1}',
                ),
              ),
            ),
            if (!widget.isQuiz)
              _ScoreButton(
                hasScores: block.totalAssignedPoints(i) != 0,
                onPressed: () => _editScores(
                  context: context,
                  block: block,
                  index: i,
                  choiceLabel: block.options[i].trim().isEmpty
                      ? 'گزینه تصویری ${i + 1}'
                      : block.options[i],
                  results: widget.results,
                  onChanged: _notify,
                ),
              ),
                if (block.options.length > 2)
              IconButton(
                onPressed: () {
                  setState(() {
                    block.removeChoiceAt(i);
                    _optionsTick++;
                  });
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) widget.onChanged();
                  });
                },
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: AppColors.textMuted,
                  size: 20,
                ),
              ),
          ],
        ),
        if (!widget.isQuiz)
          Align(
            alignment: Alignment.centerRight,
            child: OptionScoreSummary(
              scores: block.scoresFor(i),
              results: widget.results,
            ),
          ),
        const SizedBox(height: 10),
      ],
    ];
  }

  Widget _buildTilesLayout() {
    const spacing = 12.0;
    final cols = block.tileColumns.clamp(2, 3);

    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final tileWidth = (available - spacing * (cols - 1)) / cols;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (var i = 0; i < block.options.length; i++)
              SizedBox(
                width: tileWidth,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundDark.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: block.correctOptionIndex == i && widget.isQuiz
                          ? AppColors.primaryGold
                          : AppColors.primaryGold.withValues(alpha: 0.35),
                      width: block.correctOptionIndex == i && widget.isQuiz
                          ? 1.8
                          : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: _ImageUploadSlot(
                          imageData: i < block.optionImages.length
                              ? block.optionImages[i]
                              : null,
                          size: double.infinity,
                          busy: _pickingIndex == i,
                          onTap: () => _pickImage(i),
                          onClear: () => _clearImage(i),
                          expand: true,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        key: ValueKey(
                          '${block.id}-tile-opt-$i-$_optionsTick-${block.options.length}',
                        ),
                        initialValue: block.options[i],
                        onChanged: (v) {
                          block.options[i] = v;
                        },
                        cursorColor: AppColors.primaryGold,
                        textAlign: TextAlign.center,
                        style: AppTextTheme.getTextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                        decoration: questionToolFieldDecoration(
                          hint: 'متن گزینه',
                        ).copyWith(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 10,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.isQuiz)
                            _CorrectAnswerRadio(index: i)
                          else
                            _ScoreButton(
                              hasScores: block.totalAssignedPoints(i) != 0,
                              onPressed: () => _editScores(
                                context: context,
                                block: block,
                                index: i,
                                choiceLabel: block.options[i].trim().isEmpty
                                    ? 'گزینه تصویری ${i + 1}'
                                    : block.options[i],
                                results: widget.results,
                                onChanged: _notify,
                              ),
                            ),
                          if (block.options.length > 2)
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  block.removeChoiceAt(i);
                                  _optionsTick++;
                                });
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  if (mounted) widget.onChanged();
                                });
                              },
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                color: AppColors.textMuted,
                                size: 18,
                              ),
                            ),
                        ],
                      ),
                      if (!widget.isQuiz)
                        OptionScoreSummary(
                          scores: block.scoresFor(i),
                          results: widget.results,
                        ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ImageLayoutPicker extends StatelessWidget {
  const _ImageLayoutPicker({
    required this.layout,
    required this.tileColumns,
    required this.onLayoutChanged,
    required this.onColumnsChanged,
  });

  final ImageChoiceLayout layout;
  final int tileColumns;
  final ValueChanged<ImageChoiceLayout> onLayoutChanged;
  final ValueChanged<int> onColumnsChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'نحوه نمایش',
          style: AppTextTheme.getTextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (final item in ImageChoiceLayout.values) ...[
              Expanded(
                child: InkWell(
                  onTap: () => onLayoutChanged(item),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: layout == item
                          ? AppColors.primaryGold
                          : AppColors.backgroundDark,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: layout == item
                            ? AppColors.primaryGold
                            : AppColors.textMuted.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Text(
                      item.label,
                      style: AppTextTheme.getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: layout == item
                            ? AppColors.textBlack
                            : AppColors.textLight,
                      ),
                    ),
                  ),
                ),
              ),
              if (item != ImageChoiceLayout.values.last) const SizedBox(width: 8),
            ],
          ],
        ),
        if (layout == ImageChoiceLayout.tiles) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'تعداد در هر ردیف:',
                style: AppTextTheme.getTextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(width: 10),
              for (final cols in const [2, 3]) ...[
                InkWell(
                  onTap: () => onColumnsChanged(cols),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tileColumns == cols
                          ? AppColors.primaryGold.withValues(alpha: 0.25)
                          : AppColors.backgroundDark,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: tileColumns == cols
                            ? AppColors.primaryGold
                            : AppColors.textMuted.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Text(
                      '$cols',
                      style: AppTextTheme.getTextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

class _ImageUploadSlot extends StatelessWidget {
  const _ImageUploadSlot({
    required this.imageData,
    required this.size,
    required this.busy,
    required this.onTap,
    required this.onClear,
    this.expand = false,
  });

  final String? imageData;
  final double size;
  final bool busy;
  final VoidCallback onTap;
  final VoidCallback onClear;
  final bool expand;

  bool get hasImage => imageData != null && imageData!.isNotEmpty;

  Widget? _image() {
    final data = imageData;
    if (data == null || data.isEmpty) return null;
    return GamePictureHelper.image(picture: data);
  }

  @override
  Widget build(BuildContext context) {
    final image = _image();
    final body = Stack(
      fit: expand ? StackFit.expand : StackFit.loose,
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.hoverButton,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: hasImage
                    ? AppColors.primaryGold
                    : AppColors.textMuted.withValues(alpha: 0.45),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: image ??
                  Center(
                    child: busy
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
                            size: 26,
                          ),
                  ),
            ),
          ),
        ),
        if (hasImage)
          Positioned(
            top: 4,
            left: 4,
            child: Material(
              color: Colors.black54,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onClear,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
          ),
      ],
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: busy ? null : onTap,
        borderRadius: BorderRadius.circular(10),
        child: expand ? body : SizedBox(width: size, height: size, child: body),
      ),
    );
  }
}

/// Range tool — five range circles; scoring assigns points to results.
/// Circles grow larger away from the center: 1 & 5 biggest, then 2 & 4, then 3.
class RangeToolWidget extends StatelessWidget {
  const RangeToolWidget({
    super.key,
    required this.block,
    required this.results,
    required this.onChanged,
    required this.onRemove,
  });

  final QuestionToolBlock block;
  final List<GameResultDraft> results;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

  /// Index 0..4 → display numbers 1..5. Center (3) is smallest.
  static double _radiusForIndex(int index) {
    const radii = [26.0, 21.0, 16.0, 21.0, 26.0];
    return radii[index];
  }

  @override
  Widget build(BuildContext context) {
    block.ensureScoreSlots();
    return QuestionToolShell(
      title: QuestionToolKind.range.label,
      onRemove: onRemove,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'هر دایره یک بازه است — با ستاره، امتیاز آن را به نتایج اختصاص دهید',
            style: AppTextTheme.getTextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 5; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                Column(
                  children: [
                    _RangeCircle(
                      label: '${i + 1}',
                      radius: _radiusForIndex(i),
                      selected: block.totalAssignedPoints(i) != 0,
                      onTap: () => _editScores(
                        context: context,
                        block: block,
                        index: i,
                        choiceLabel: 'بازه ${i + 1}',
                        results: results,
                        onChanged: onChanged,
                      ),
                    ),
                    const SizedBox(height: 2),
                    _ScoreButton(
                      hasScores: block.totalAssignedPoints(i) != 0,
                      onPressed: () => _editScores(
                        context: context,
                        block: block,
                        index: i,
                        choiceLabel: 'بازه ${i + 1}',
                        results: results,
                        onChanged: onChanged,
                      ),
                    ),
                    SizedBox(
                      width: 72,
                      child: OptionScoreSummary(
                        scores: block.scoresFor(i),
                        results: results,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _RangeCircle extends StatelessWidget {
  const _RangeCircle({
    required this.label,
    required this.radius,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final double radius;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final diameter = radius * 2;
    return SizedBox(
      height: 56,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: diameter,
              height: diameter,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? AppColors.primaryGold.withValues(alpha: 0.28)
                    : AppColors.primaryGold.withValues(alpha: 0.12),
                border: Border.all(
                  color: AppColors.primaryGold,
                  width: selected ? 2.2 : 1.4,
                ),
              ),
              child: Text(
                label,
                style: AppTextTheme.getTextStyle(
                  fontSize: radius * 0.6,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
