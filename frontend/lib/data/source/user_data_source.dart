import 'package:dio/dio.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/data/network/http_response_validator.dart';
import 'package:frontend/models/user_model.dart';

abstract class IUserDataSource {
  Future<UserModel> getCurrentUser();
  Future<UserModel> getUser(String identifier);
}

class UserRemoteData with HttpResponseValidator implements IUserDataSource {
  UserRemoteData(this.httpClient);

  final Dio httpClient;

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.get(Urls.meUrl),
    );
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> getUser(String identifier) async {
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.get(Urls.userUrl(identifier)),
    );
    return UserModel.fromJson(response);
  }
}
