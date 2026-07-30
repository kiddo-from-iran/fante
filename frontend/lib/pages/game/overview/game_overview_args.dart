import 'package:frontend/models/game_model.dart';

class GameOverviewArgs {
  const GameOverviewArgs({
    required this.gameId,
    this.preview,
  });

  final int gameId;
  final GameListItem? preview;

  factory GameOverviewArgs.fromListItem(GameListItem item) {
    return GameOverviewArgs(gameId: item.id, preview: item);
  }
}
