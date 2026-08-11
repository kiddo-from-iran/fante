import 'package:frontend/models/game_model.dart';
import 'package:frontend/pages/dashboard/dashboard_assets.dart';
import 'package:frontend/pages/dashboard/game_editor/player_game.dart';
import 'package:frontend/pages/game/game_assets.dart';
import 'package:frontend/pages/game/models/game_kind.dart';
import 'package:frontend/pages/game/models/game_session_data.dart';

/// Bridges dashboard [PlayerGame] drafts into catalog / play models.
class PlayerGameMapper {
  PlayerGameMapper._();

  static int numericId(PlayerGame game) =>
      int.tryParse(game.id) ?? game.id.hashCode.abs();

  static String coverOf(PlayerGame game) =>
      (game.imagePath != null && game.imagePath!.isNotEmpty)
          ? game.imagePath!
          : DashboardAssets.thumb1;

  static String playBackgroundOf(PlayerGame game) =>
      (game.playBackgroundPath != null && game.playBackgroundPath!.isNotEmpty)
          ? game.playBackgroundPath!
          : GameAssets.backgroundForest;

  static String apiTypeOf(GameKind kind) {
    switch (kind) {
      case GameKind.quiz:
        return 'quiz';
      case GameKind.poll:
        return 'vote';
      case GameKind.personality:
        return 'test';
    }
  }

  static GameListItem toListItem(PlayerGame game) {
    return GameListItem(
      id: numericId(game),
      title: game.title,
      description: game.description,
      picture: coverOf(game),
      gameType: apiTypeOf(game.kind),
      createdAt: game.createdAt,
      questionsCount: game.questions.length,
      creatorName: 'شما',
    );
  }

  static GameDetail toDetail(PlayerGame game) {
    final base = toListItem(game);
    return GameDetail(
      id: base.id,
      title: base.title,
      description: base.description,
      picture: base.picture,
      gameType: base.gameType,
      createdAt: base.createdAt,
      questionsCount: base.questionsCount,
      creatorName: base.creatorName,
      rating: base.rating,
      reviewCount: base.reviewCount,
      galleryImages: [base.picture],
    );
  }

  static GameSidebarData sidebarOf(PlayerGame game) {
    return GameSidebarData(
      thumbnail: coverOf(game),
      description: game.description.isEmpty
          ? 'بازی ساخته‌شده توسط شما در فانته‌کوییز.'
          : game.description,
      timeAgo: 'همین الان',
      participants: 0,
      secondaryTitle: game.title,
    );
  }

  /// Builds play payloads for each question that has a usable tool.
  static List<GameSessionData> buildPlaySteps(PlayerGame game) {
    final bg = playBackgroundOf(game);
    final sidebar = sidebarOf(game);
    final steps = <GameSessionData>[];

    for (var i = 0; i < game.questions.length; i++) {
      final q = game.questions[i];
      if (q.tools.isEmpty) continue;
      final tool = q.tools.first;
      final prompt = q.prompt.trim().isEmpty ? 'سوال ${i + 1}' : q.prompt.trim();

      switch (tool.kind) {
        case QuestionToolKind.multipleChoice:
        case QuestionToolKind.multipleChoiceImage:
          final options = tool.options
              .map((o) => o.trim().isEmpty ? 'گزینه' : o.trim())
              .toList();
          if (options.isEmpty) continue;
          if (game.kind == GameKind.poll) {
            steps.add(
              PollPlayData(
                title: game.title,
                designerName: 'شما',
                background: bg,
                sidebar: sidebar,
                question: prompt,
                options: [
                  for (var oi = 0; oi < options.length; oi++)
                    GameOptionData(
                      label: options[oi],
                      percent: 0,
                      isSelected: oi == 0,
                    ),
                ],
                selectedIndex: 0,
                showPercentages: false,
              ),
            );
          } else {
            final isQuiz = game.kind == GameKind.quiz;
            steps.add(
              QuizPlayData(
                title: game.title,
                designerName: 'شما',
                background: bg,
                sidebar: sidebar,
                questionNumber: steps.length + 1,
                question: prompt,
                options: options,
                selectedIndex: -1,
                correctIndex:
                    isQuiz ? tool.resolveCorrectIndexForQuiz() : null,
              ),
            );
          }
          break;
        case QuestionToolKind.range:
          final labels = List.generate(5, (i) => '${i + 1}');
          final isQuiz = game.kind == GameKind.quiz;
          steps.add(
            QuizPlayData(
              title: game.title,
              designerName: 'شما',
              background: bg,
              sidebar: sidebar,
              questionNumber: steps.length + 1,
              question: prompt,
              options: labels,
              selectedIndex: -1,
              correctIndex: isQuiz ? tool.resolveCorrectIndexForQuiz() : null,
            ),
          );
          break;
      }
    }

    return steps;
  }

  static GameSessionData buildResult(PlayerGame game, {int score = 0}) {
    final bg = playBackgroundOf(game);
    final sidebar = sidebarOf(game);
    final total = game.questions.isEmpty ? 1 : game.questions.length;

    switch (game.kind) {
      case GameKind.poll:
        return PollResultData(
          title: game.title,
          designerName: 'شما',
          background: bg,
          sidebar: sidebar,
          successMessage: 'رأی شما ثبت شد!',
          options: const [
            GameOptionData(label: 'نتیجه', percent: 100, isSelected: true),
          ],
          totalVotes: 1,
          footerMessage: 'از مشارکت شما متشکریم.',
        );
      case GameKind.personality:
        final results = game.resultsOrEmpty;
        final top = results.isNotEmpty ? results.first : null;
        return WorldDiscoveryResultData(
          title: game.title,
          designerName: 'شما',
          background: bg,
          sidebar: sidebar,
          bannerTitle: top?.title.isNotEmpty == true ? top!.title : 'نتیجه شما',
          subtitle: top?.description.isNotEmpty == true
              ? top!.description
              : 'بر اساس پاسخ‌های شما این نتیجه پیشنهاد شد.',
          selectedImages: [coverOf(game)],
          explorerName: 'شما',
          explorationScore: '$score / $total',
          highlightMessage: 'بازی را دوباره امتحان کنید یا با دوستان به اشتراک بگذارید.',
        );
      case GameKind.quiz:
        return QuizScoreResultData(
          title: game.title,
          designerName: 'شما',
          background: bg,
          sidebar: sidebar,
          score: score,
          totalQuestions: total,
          xpEarned: score * 10,
          rank: 1,
          totalPlayers: 1,
          summary: 'شما $score از $total سوال را پاسخ دادید.',
        );
    }
  }
}
