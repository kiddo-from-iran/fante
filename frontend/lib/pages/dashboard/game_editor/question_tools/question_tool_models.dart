/// Tool kinds that can be dragged into a question canvas.
enum QuestionToolKind {
  multipleChoice,
  multipleChoiceImage,
  range,
}

extension QuestionToolKindX on QuestionToolKind {
  String get label {
    switch (this) {
      case QuestionToolKind.multipleChoice:
        return 'چند گزینه‌ای';
      case QuestionToolKind.multipleChoiceImage:
        return 'چند گزینه‌ای با تصویر';
      case QuestionToolKind.range:
        return 'بازه';
    }
  }

  String get shortLabel {
    switch (this) {
      case QuestionToolKind.multipleChoice:
        return 'چند گزینه‌ای';
      case QuestionToolKind.multipleChoiceImage:
        return 'تصویری';
      case QuestionToolKind.range:
        return 'بازه';
    }
  }
}

/// A predefined game outcome that options can contribute points to.
class GameResultDraft {
  GameResultDraft({
    required this.id,
    this.title = '',
    this.description = '',
  });

  final String id;
  String title;
  String description;

  static int _idSeq = 0;

  factory GameResultDraft.create({String? title}) {
    _idSeq += 1;
    return GameResultDraft(
      id: 'result-${DateTime.now().microsecondsSinceEpoch}-$_idSeq',
      title: title ?? '',
    );
  }

  GameResultDraft copy() => GameResultDraft(
        id: id,
        title: title,
        description: description,
      );
}

/// Points this answer contributes toward each result (`resultId` → points).
typedef ResultScoreMap = Map<String, int>;

/// How image multiple-choice options are laid out in the editor/preview.
enum ImageChoiceLayout {
  /// One choice per row: image beside text.
  list,

  /// Grid tiles: image on top, text below (2 or 3 per row).
  tiles,
}

extension ImageChoiceLayoutX on ImageChoiceLayout {
  String get label {
    switch (this) {
      case ImageChoiceLayout.list:
        return 'لیستی';
      case ImageChoiceLayout.tiles:
        return 'کاشی‌ای';
    }
  }
}

/// A dropped tool instance inside one question.
class QuestionToolBlock {
  QuestionToolBlock({
    required this.id,
    required this.kind,
    List<String>? options,
    List<String?>? optionImages,
    List<String>? rangeLabels,
    List<ResultScoreMap>? optionScores,
    this.imageLayout = ImageChoiceLayout.list,
    this.tileColumns = 2,
  })  : options = options ?? _defaultOptions(kind),
        optionImages = optionImages ??
            List<String?>.filled(
              (options ?? _defaultOptions(kind)).length,
              null,
            ),
        rangeLabels = rangeLabels ??
            List<String>.generate(5, (i) => '${i + 1}'),
        optionScores = optionScores ??
            List<ResultScoreMap>.generate(
              kind == QuestionToolKind.range
                  ? 5
                  : (options ?? _defaultOptions(kind)).length,
              (_) => <String, int>{},
            );

  final String id;
  final QuestionToolKind kind;
  List<String> options;
  List<String?> optionImages;
  List<String> rangeLabels;
  ImageChoiceLayout imageLayout;
  int tileColumns;

  /// Parallel to [options] (or range buttons for [QuestionToolKind.range]).
  List<ResultScoreMap> optionScores;

  int get choiceCount =>
      kind == QuestionToolKind.range ? rangeLabels.length : options.length;

  static List<String> _defaultOptions(QuestionToolKind kind) {
    switch (kind) {
      case QuestionToolKind.multipleChoice:
      case QuestionToolKind.multipleChoiceImage:
        return ['', ''];
      case QuestionToolKind.range:
        return const [];
    }
  }

  void ensureScoreSlots() {
    final scores = optionScores as List<ResultScoreMap>?;
    if (scores == null) {
      optionScores = <ResultScoreMap>[];
    }
    final needed = choiceCount;
    while (optionScores.length < needed) {
      optionScores.add(<String, int>{});
    }
    while (optionScores.length > needed) {
      optionScores.removeLast();
    }
  }

  void addChoice({String text = '', String? image}) {
    if (kind == QuestionToolKind.range) return;
    options.add(text);
    optionImages.add(image);
    optionScores.add(<String, int>{});
  }

  void removeChoiceAt(int index) {
    if (kind == QuestionToolKind.range) return;
    if (options.length <= 2) return;
    options.removeAt(index);
    if (index < optionImages.length) optionImages.removeAt(index);
    if (index < optionScores.length) optionScores.removeAt(index);
  }

  ResultScoreMap scoresFor(int index) {
    ensureScoreSlots();
    return optionScores[index];
  }

  int totalAssignedPoints(int index) {
    return scoresFor(index).values.fold(0, (sum, v) => sum + v);
  }

  QuestionToolBlock copy() {
    ensureScoreSlots();
    return QuestionToolBlock(
      id: id,
      kind: kind,
      options: List<String>.from(options),
      optionImages: List<String?>.from(optionImages),
      rangeLabels: List<String>.from(rangeLabels),
      optionScores: optionScores
          .map((m) => Map<String, int>.from(m))
          .toList(),
      imageLayout: imageLayout,
      tileColumns: tileColumns,
    );
  }

  factory QuestionToolBlock.create(QuestionToolKind kind) {
    return QuestionToolBlock(
      id: 'tool-${DateTime.now().microsecondsSinceEpoch}',
      kind: kind,
      rangeLabels: kind == QuestionToolKind.range
          ? List<String>.generate(5, (i) => '${i + 1}')
          : null,
      optionScores: List<ResultScoreMap>.generate(
        kind == QuestionToolKind.range ? 5 : 2,
        (_) => <String, int>{},
      ),
    );
  }
}

class GameQuestionDraft {
  GameQuestionDraft({
    this.prompt = '',
    List<QuestionToolBlock>? tools,
  }) : tools = tools ?? <QuestionToolBlock>[];

  String prompt;
  List<QuestionToolBlock> tools;

  /// First multiple-choice options, used by older summary helpers.
  List<String> get options {
    for (final tool in tools) {
      if (tool.kind == QuestionToolKind.multipleChoice ||
          tool.kind == QuestionToolKind.multipleChoiceImage) {
        return tool.options;
      }
    }
    return const [];
  }

  GameQuestionDraft copy() => GameQuestionDraft(
        prompt: prompt,
        tools: tools.map((t) => t.copy()).toList(),
      );
}
