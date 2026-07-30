import 'package:frontend/models/user_model.dart';

class AuthInfo {
  const AuthInfo({
    required this.accessToken,
    this.userId,
    this.user,
  });

  final String accessToken;
  final int? userId;
  final UserModel? user;

  factory AuthInfo.fromJson(Map<String, dynamic> json) {
    return AuthInfo(
      accessToken: json['token']?.toString() ??
          json['access']?.toString() ??
          json['access_token']?.toString() ??
          '',
      userId: json['user_id'] is int
          ? json['user_id'] as int
          : int.tryParse(json['user_id']?.toString() ?? ''),
      user: json['user'] is Map<String, dynamic>
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'user_id': userId,
        if (user != null) 'user': user!.toJson(),
      };

  AuthInfo copyWith({
    String? accessToken,
    int? userId,
    UserModel? user,
  }) {
    return AuthInfo(
      accessToken: accessToken ?? this.accessToken,
      userId: userId ?? this.userId,
      user: user ?? this.user,
    );
  }

  bool get isAuthenticated => accessToken.isNotEmpty;
}
