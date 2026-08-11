import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard/game_editor/player_game.dart';
import 'package:frontend/pages/game/models/game_kind.dart';
import 'package:frontend/pages/game/models/game_session_data.dart';
import 'package:frontend/pages/game/overview/game_overview_args.dart';
import 'package:frontend/pages/game/overview/game_overview_page.dart';
import 'package:frontend/pages/game/play/game_play_page.dart';
import 'package:frontend/pages/game/play/player_game_play_page.dart';
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
        playQuiz: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is PlayerGame) {
            return PlayerGamePlayPage(game: args);
          }
          if (args is GameSessionData) {
            return GamePlayPage(data: args);
          }
          return GamePlayPage(data: GameDemoData.quizPlay);
        },
        playPoll: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is PlayerGame) {
            return PlayerGamePlayPage(game: args);
          }
          if (args is GameSessionData) {
            return GamePlayPage(data: args);
          }
          return GamePlayPage(data: GameDemoData.pollPlay);
        },
        resultPoll: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          return GameResultPage(
            variant: GameResultVariant.pollBars,
            data: args is PollResultData ? args : GameDemoData.pollResult,
          );
        },
        resultQuiz: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          return GameResultPage(
            variant: GameResultVariant.quizScore,
            data: args is QuizScoreResultData
                ? args
                : GameDemoData.quizScoreResult,
          );
        },
        resultWorld: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          return GameResultPage(
            variant: GameResultVariant.worldDiscovery,
            data: args is WorldDiscoveryResultData
                ? args
                : GameDemoData.worldDiscoveryResult,
          );
        },
      };
}
