import 'package:frontend/pages/game/models/game_kind.dart';
import 'package:frontend/pages/dashboard/game_editor/question_tools/question_tool_models.dart';

export 'package:frontend/pages/dashboard/game_editor/question_tools/question_tool_models.dart';

/// Local draft / owned game used by the dashboard Games pages (demo store).
class PlayerGame {
  PlayerGame({
    required this.id,
    required this.title,
    required this.description,
    required this.kind,
    required this.createdAt,
    this.imagePath,
    List<GameResultDraft>? results,
    this.questions = const [],
    this.isPublished = false,
  }) : results = results ?? <GameResultDraft>[];

  final String id;
  String title;
  String description;
  GameKind kind;
  DateTime createdAt;
  String? imagePath;
  List<GameResultDraft> results;
  List<GameQuestionDraft> questions;
  bool isPublished;

  /// Hot-reload / legacy-safe accessor — never returns null.
  List<GameResultDraft> get resultsOrEmpty {
    final value = results as List<GameResultDraft>?;
    return value ?? <GameResultDraft>[];
  }

  void ensureResults() {
    final value = results as List<GameResultDraft>?;
    if (value == null) {
      results = <GameResultDraft>[];
      return;
    }
    // Repair duplicate ids created in the same microsecond (hot-reload / old drafts).
    final seen = <String>{};
    for (var i = 0; i < results.length; i++) {
      final current = results[i];
      if (seen.add(current.id)) continue;
      results[i] = GameResultDraft(
        id: 'result-${DateTime.now().microsecondsSinceEpoch}-$i-fix',
        title: current.title,
        description: current.description,
      );
      seen.add(results[i].id);
    }
  }

  String get kindLabel {
    switch (kind) {
      case GameKind.quiz:
        return 'کوییز';
      case GameKind.poll:
        return 'نظرسنجی';
      case GameKind.personality:
        return 'تست';
    }
  }

  PlayerGame copy() {
    ensureResults();
    return PlayerGame(
      id: id,
      title: title,
      description: description,
      kind: kind,
      createdAt: createdAt,
      imagePath: imagePath,
      isPublished: isPublished,
      results: resultsOrEmpty.map((r) => r.copy()).toList(),
      questions: questions.map((q) => q.copy()).toList(),
    );
  }
}

/// In-memory store for the current session (until backend create API exists).
class PlayerGamesStore {
  PlayerGamesStore._();

  static final PlayerGamesStore instance = PlayerGamesStore._();

  final List<PlayerGame> _games = [
    PlayerGame(
      id: '1',
      title: 'دنیای انیمه',
      description: 'کوییز جذاب درباره شخصیت‌های محبوب انیمه',
      kind: GameKind.quiz,
      createdAt: DateTime(2026, 5, 12),
      imagePath: 'assets/images/game_1.png',
      results: [
        GameResultDraft(id: 'r1', title: 'قهرمان ماجراجو', description: ''),
        GameResultDraft(id: 'r2', title: 'تحلیل‌گر آرام', description: ''),
      ],
      questions: [
        GameQuestionDraft(
          prompt: 'سوال اول',
          tools: [
            QuestionToolBlock(
              id: 'seed-1',
              kind: QuestionToolKind.multipleChoice,
              options: ['گزینه ۱', 'گزینه ۲'],
              optionScores: [
                {'r1': 50, 'r2': 20},
                {'r1': 10, 'r2': 40},
              ],
            ),
          ],
        ),
      ],
      isPublished: true,
    ),
    PlayerGame(
      id: '2',
      title: 'نظرسنجی فصل جدید',
      description: 'کدام فصل را بیشتر دوست دارید؟',
      kind: GameKind.poll,
      createdAt: DateTime(2026, 6, 2),
      imagePath: 'assets/images/game_2.png',
      results: [
        GameResultDraft(id: 'r-poll-1', title: 'نتیجه ۱'),
      ],
      questions: [
        GameQuestionDraft(
          prompt: 'سوال',
          tools: [
            QuestionToolBlock(
              id: 'seed-2',
              kind: QuestionToolKind.multipleChoice,
              options: ['بهار', 'تابستان', 'پاییز'],
            ),
          ],
        ),
      ],
      isPublished: true,
    ),
    PlayerGame(
      id: '3',
      title: 'تست شخصیت ماجراجو',
      description: 'ببینید شخصیت شما بیشتر شبیه کیست',
      kind: GameKind.personality,
      createdAt: DateTime(2026, 7, 1),
      imagePath: 'assets/images/game_3.png',
      results: [
        GameResultDraft(id: 'r-a', title: 'شخصیت الف'),
        GameResultDraft(id: 'r-b', title: 'شخصیت ب'),
      ],
      questions: [
        GameQuestionDraft(
          prompt: 'سوال',
          tools: [
            QuestionToolBlock(
              id: 'seed-3',
              kind: QuestionToolKind.multipleChoice,
              options: ['الف', 'ب'],
            ),
          ],
        ),
      ],
      isPublished: false,
    ),
  ];

  PlayerGame? byId(String id) {
    try {
      final game = _games.firstWhere((g) => g.id == id);
      game.ensureResults();
      return game;
    } catch (_) {
      return null;
    }
  }

  List<PlayerGame> get all {
    for (final game in _games) {
      game.ensureResults();
    }
    return List.unmodifiable(_games);
  }

  void upsert(PlayerGame game) {
    final index = _games.indexWhere((g) => g.id == game.id);
    if (index >= 0) {
      _games[index] = game;
    } else {
      _games.insert(0, game);
    }
  }

  void delete(String id) {
    _games.removeWhere((g) => g.id == id);
  }

  String nextId() => DateTime.now().millisecondsSinceEpoch.toString();
}
