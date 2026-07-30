import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:frontend/data/network/http_client.dart';
import 'package:frontend/data/source/auth_data_source.dart';
import 'package:frontend/config/app_config.dart';
import 'package:frontend/config/environment.dart';
import 'package:frontend/data/source/google_sign_in_service.dart';
import 'package:frontend/data/source/user_data_source.dart';
import 'package:frontend/models/auth_info.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/pages/auth/models/auth_flow_args.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepository = AuthRepository(
  AuthRemoteData(httpClient),
  UserRemoteData(httpClient),
);

abstract class IAuthRepository {
  Future<OtpRequestResult> requestLoginOtp(String phoneNumber);
  Future<OtpRequestResult> requestRegisterOtp(String phoneNumber);
  Future<void> validateOtp(String phoneNumber, String code);
  Future<AuthInfo> verifyOtpLogin(String phoneNumber, String code);
  Future<AuthInfo> signInWithGoogle();
  Future<AuthInfo> loginWithPassword(String phoneNumber, String password);
  Future<AuthInfo> registerWithOtp({
    required String phoneNumber,
    required String code,
    required String fullName,
    required String password,
  });
  Future<UserModel> fetchCurrentUser();
  Future<void> loadAuthInfo();
  Future<bool> isSignedIn();
  Future<String?> getAccessToken();
  Future<void> signOut();
}

class AuthRepository implements IAuthRepository {
  static final ValueNotifier<AuthInfo?> authChangeNotifier =
      ValueNotifier<AuthInfo?>(null);

  AuthRepository(this._authDataSource, this._userDataSource);

  final IAuthDataSource _authDataSource;
  final IUserDataSource _userDataSource;
  GoogleSignInService? _googleSignIn;

  GoogleSignInService get _googleSignInService {
    _googleSignIn ??= GoogleSignInService(
      webClientId:
          (Environment.instance().config as AppConfig).googleWebClientId,
    );
    return _googleSignIn!;
  }

  static const _tokenKey = 'access_token';
  static const _userIdKey = 'user_id';
  static const _userJsonKey = 'user_json';

  @override
  Future<OtpRequestResult> requestLoginOtp(String phoneNumber) {
    return _authDataSource.requestLoginOtp(phoneNumber);
  }

  @override
  Future<OtpRequestResult> requestRegisterOtp(String phoneNumber) {
    return _authDataSource.requestRegisterOtp(phoneNumber);
  }

  @override
  Future<AuthInfo> verifyOtpLogin(String phoneNumber, String code) async {
    final authInfo = await _authDataSource.verifyOtpLogin(phoneNumber, code);
    await _persistAuth(authInfo);
    authChangeNotifier.value = authInfo;
    return authInfo;
  }

  @override
  Future<void> validateOtp(String phoneNumber, String code) {
    return _authDataSource.validateOtp(phoneNumber, code);
  }

  @override
  Future<AuthInfo> signInWithGoogle() async {
    final idToken = await _googleSignInService.signInAndGetIdToken();
    if (idToken == null) {
      throw StateError('GOOGLE_SIGN_IN_CANCELLED');
    }
    final authInfo = await _authDataSource.loginWithGoogle(idToken);
    await _persistAuth(authInfo);
    authChangeNotifier.value = authInfo;
    return authInfo;
  }

  @override
  Future<AuthInfo> loginWithPassword(
    String phoneNumber,
    String password,
  ) async {
    final authInfo =
        await _authDataSource.loginWithPassword(phoneNumber, password);
    await _persistAuth(authInfo);
    authChangeNotifier.value = authInfo;
    return authInfo;
  }

  @override
  Future<AuthInfo> registerWithOtp({
    required String phoneNumber,
    required String code,
    required String fullName,
    required String password,
  }) async {
    final authInfo = await _authDataSource.registerWithOtp(
      phoneNumber: phoneNumber,
      code: code,
      fullName: fullName,
      password: password,
    );
    await _persistAuth(authInfo);
    authChangeNotifier.value = authInfo;
    return authInfo;
  }

  @override
  Future<UserModel> fetchCurrentUser() async {
    final user = await _userDataSource.getCurrentUser();
    final current = authChangeNotifier.value;
    if (current != null) {
      final updated = current.copyWith(user: user, userId: user.id);
      await _persistAuth(updated);
      authChangeNotifier.value = updated;
    }
    return user;
  }

  Future<void> _persistAuth(AuthInfo authInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, authInfo.accessToken);
    if (authInfo.userId != null) {
      await prefs.setInt(_userIdKey, authInfo.userId!);
    }
    if (authInfo.user != null) {
      await prefs.setString(
        _userJsonKey,
        jsonEncode(authInfo.user!.toJson()),
      );
    }
  }

  @override
  Future<void> loadAuthInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString(_tokenKey) ?? '';
    final userId = prefs.getInt(_userIdKey);

    if (accessToken.isEmpty) {
      authChangeNotifier.value = null;
      return;
    }

    authChangeNotifier.value = AuthInfo(
      accessToken: accessToken,
      userId: userId,
    );

    try {
      await fetchCurrentUser();
    } catch (e) {
      debugPrint('Failed to refresh user profile: $e');
    }
  }

  @override
  Future<bool> isSignedIn() async {
    await loadAuthInfo();
    return authChangeNotifier.value?.isAuthenticated ?? false;
  }

  @override
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignInService.signOut();
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userJsonKey);
    authChangeNotifier.value = null;
  }
}

final userRepository = UserRepository(UserRemoteData(httpClient));

class UserRepository {
  UserRepository(this._userDataSource);

  final IUserDataSource _userDataSource;

  Future<UserModel> getCurrentUser() => _userDataSource.getCurrentUser();

  Future<UserModel> getUser(String identifier) =>
      _userDataSource.getUser(identifier);
}
