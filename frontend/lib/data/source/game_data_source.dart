import 'package:dio/dio.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/data/network/http_response_validator.dart';
import 'package:frontend/models/game_model.dart';

abstract class IGameDataSource {
  Future<List<GameListItem>> getGames({
    int skip = 0,
    int limit = 100,
    String? gameType,
    String? search,
  });

  Future<GameDetail> getGame(int id);
}

class GameRemoteData with HttpResponseValidator implements IGameDataSource {
  GameRemoteData(this.httpClient);

  final Dio httpClient;

  @override
  Future<List<GameListItem>> getGames({
    int skip = 0,
    int limit = 100,
    String? gameType,
    String? search,
  }) async {
    final query = <String, dynamic>{
      'skip': skip,
      'limit': limit,
      if (gameType != null && gameType.isNotEmpty) 'game_type': gameType,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final response = await validateResponse<List<dynamic>>(
      httpClient.get(
        Urls.gamesUrl,
        queryParameters: query,
        options: Options(extra: {'requiresAuth': false}),
      ),
    );

    return response
        .map((item) => GameListItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<GameDetail> getGame(int id) async {
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.get(
        Urls.gameDetailUrl(id),
        options: Options(extra: {'requiresAuth': false}),
      ),
    );
    return GameDetail.fromJson(response);
  }
}
