import 'package:frontend/models/game_model.dart';

class GameOverviewArgs {
  const GameOverviewArgs({
    required this.gameId,
    this.preview,
    this.playerGameId,
  });

  final int gameId;
  final GameListItem? preview;

  /// When set, overview / play use the local [PlayerGamesStore] draft.
  final String? playerGameId;

  factory GameOverviewArgs.fromListItem(
    GameListItem item, {
    String? playerGameId,
  }) {
    return GameOverviewArgs(
      gameId: item.id,
      preview: item,
      playerGameId: playerGameId,
    );
  }
}
