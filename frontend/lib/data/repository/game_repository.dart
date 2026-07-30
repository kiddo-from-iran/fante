import 'package:frontend/data/network/http_client.dart';
import 'package:frontend/data/source/game_data_source.dart';
import 'package:frontend/models/game_model.dart';

final gameRepository = GameRepository(GameRemoteData(httpClient));

class GameRepository {
  GameRepository(this._gameDataSource);

  final IGameDataSource _gameDataSource;

  Future<List<GameListItem>> getGames({
    int skip = 0,
    int limit = 100,
    String? gameType,
    String? search,
  }) =>
      _gameDataSource.getGames(
        skip: skip,
        limit: limit,
        gameType: gameType,
        search: search,
      );

  Future<GameDetail> getGame(int id) => _gameDataSource.getGame(id);

  Future<GameDetail> getGameWithFallback(int id) async {
    try {
      return await getGame(id);
    } catch (_) {
      final demo = GameListItem.demoGames.firstWhere(
        (game) => game.id == id,
        orElse: () => GameListItem.demoGames.first,
      );
      return GameDetail.fromListItem(
        demo,
        galleryImages: [
          demo.picture,
          'assets/images/game_2.png',
          'assets/images/game_3.png',
        ],
      );
    }
  }

  Future<List<GameListItem>> getGamesWithFallback({
    String? gameType,
    String? search,
  }) async {
    try {
      final games = await getGames(gameType: gameType, search: search);
      if (games.isNotEmpty) {
        return games;
      }
    } catch (_) {}

    var games = GameListItem.demoGames;
    if (gameType != null && gameType.isNotEmpty) {
      games = games.where((game) => game.gameType == gameType).toList();
    }
    if (search != null && search.isNotEmpty) {
      final query = search.trim();
      games = games
          .where((game) => game.title.contains(query))
          .toList();
    }
    return games;
  }
}
