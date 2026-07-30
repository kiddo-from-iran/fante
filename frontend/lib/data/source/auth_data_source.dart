import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/data/network/http_response_validator.dart';
import 'package:frontend/models/auth_info.dart';
import 'package:frontend/pages/auth/models/auth_flow_args.dart';

abstract class IAuthDataSource {
  Future<OtpRequestResult> requestLoginOtp(String phoneNumber);
  Future<OtpRequestResult> requestRegisterOtp(String phoneNumber);
  Future<void> validateOtp(String phoneNumber, String code);
  Future<AuthInfo> verifyOtpLogin(String phoneNumber, String code);
  Future<AuthInfo> loginWithPassword(String phoneNumber, String password);
  Future<AuthInfo> loginWithGoogle(String idToken);
  Future<AuthInfo> registerWithOtp({
    required String phoneNumber,
    required String code,
    required String fullName,
    required String password,
  });
}

class AuthRemoteData with HttpResponseValidator implements IAuthDataSource {
  AuthRemoteData(this.httpClient);

  final Dio httpClient;

  @override
  Future<OtpRequestResult> requestLoginOtp(String phoneNumber) async {
    if (kDebugMode) {
      debugPrint('Auth login OTP → POST ${Urls.otpRequestLoginUrl}');
    }
    return _requestOtp(Urls.otpRequestLoginUrl, phoneNumber);
  }

  @override
  Future<OtpRequestResult> requestRegisterOtp(String phoneNumber) async {
    if (kDebugMode) {
      debugPrint('Auth register OTP → POST ${Urls.otpRequestRegisterUrl}');
    }
    return _requestOtp(Urls.otpRequestRegisterUrl, phoneNumber);
  }

  Future<OtpRequestResult> _requestOtp(String url, String phoneNumber) async {
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.post(
        url,
        data: {'phone_number': phoneNumber},
        options: Options(extra: {'requiresAuth': false}),
      ),
    );

    final debugCode = response['debug_code']?.toString();
    if (kDebugMode && debugCode != null) {
      const banner = '══════════════════════════════════════';
      debugPrint(banner);
      debugPrint('FanteQuiz OTP for $phoneNumber: $debugCode');
      debugPrint(banner);
      print('FanteQuiz OTP for $phoneNumber: $debugCode');
    }

    return OtpRequestResult(
      message: response['message']?.toString() ?? 'OTP sent',
      debugCode: debugCode,
    );
  }

  @override
  Future<void> validateOtp(String phoneNumber, String code) async {
    await validateResponse<Map<String, dynamic>>(
      httpClient.post(
        Urls.otpValidateUrl,
        data: {'phone_number': phoneNumber, 'code': code},
        options: Options(extra: {'requiresAuth': false}),
      ),
    );
  }

  @override
  Future<AuthInfo> verifyOtpLogin(String phoneNumber, String code) async {
    if (kDebugMode) {
      debugPrint('Auth OTP login → POST ${Urls.otpVerifyUrl}');
    }
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.post(
        Urls.otpVerifyUrl,
        data: {'phone_number': phoneNumber, 'code': code},
        options: Options(extra: {'requiresAuth': false}),
      ),
    );
    return AuthInfo.fromJson(response);
  }

  @override
  Future<AuthInfo> loginWithGoogle(String idToken) async {
    if (kDebugMode) {
      debugPrint('Auth Google → POST ${Urls.googleAuthUrl}');
    }
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.post(
        Urls.googleAuthUrl,
        data: {'id_token': idToken},
        options: Options(extra: {'requiresAuth': false}),
      ),
    );
    return AuthInfo.fromJson(response);
  }

  @override
  Future<AuthInfo> loginWithPassword(
    String phoneNumber,
    String password,
  ) async {
    if (kDebugMode) {
      debugPrint('Auth password login → POST ${Urls.loginPasswordUrl}');
    }
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.post(
        Urls.loginPasswordUrl,
        data: {
          'phone_number': phoneNumber,
          'password': password,
        },
        options: Options(extra: {'requiresAuth': false}),
      ),
    );
    return AuthInfo.fromJson(response);
  }

  @override
  Future<AuthInfo> registerWithOtp({
    required String phoneNumber,
    required String code,
    required String fullName,
    required String password,
  }) async {
    if (kDebugMode) {
      debugPrint('Auth register → POST ${Urls.registerUrl}');
    }
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.post(
        Urls.registerUrl,
        data: {
          'phone_number': phoneNumber,
          'code': code,
          'full_name': fullName,
          'password': password,
        },
        options: Options(extra: {'requiresAuth': false}),
      ),
    );
    return AuthInfo.fromJson(response);
  }
}
