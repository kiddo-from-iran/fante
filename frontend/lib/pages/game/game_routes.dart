import 'package:flutter/material.dart';
import 'package:frontend/pages/game/models/game_kind.dart';
import 'package:frontend/pages/game/models/game_session_data.dart';
import 'package:frontend/pages/game/overview/game_overview_args.dart';
import 'package:frontend/pages/game/overview/game_overview_page.dart';
import 'package:frontend/pages/game/play/game_play_page.dart';
import 'package:frontend/pages/game/result/game_result_page.dart';

class GameRoutes {
  GameRoutes._();

  static const overview = '/game/overview';
  static const playQuiz = '/game/play/quiz';
  static const playPoll = '/game/play/poll';
  static const resultPoll = '/game/result/poll';
  static const resultQuiz = '/game/result/quiz';
  static const resultWorld = '/game/result/world';

  static Map<String, WidgetBuilder> get routes => {
        overview: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is GameOverviewArgs) {
            return GameOverviewPage(args: args);
          }
          return const GameOverviewPage(
            args: GameOverviewArgs(gameId: 1),
          );
        },
        playQuiz: (_) => GamePlayPage(data: GameDemoData.quizPlay),
        playPoll: (_) => GamePlayPage(data: GameDemoData.pollPlay),
        resultPoll: (_) => GameResultPage(
              variant: GameResultVariant.pollBars,
              data: GameDemoData.pollResult,
            ),
        resultQuiz: (_) => GameResultPage(
              variant: GameResultVariant.quizScore,
              data: GameDemoData.quizScoreResult,
            ),
        resultWorld: (_) => GameResultPage(
              variant: GameResultVariant.worldDiscovery,
              data: GameDemoData.worldDiscoveryResult,
            ),
      };
}
