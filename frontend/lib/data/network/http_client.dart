import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/data/repository/auth_repository.dart';

/// Set true temporarily when debugging API traffic.
const bool _verboseHttp = false;

Dio httpClient = Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 12),
    receiveTimeout: const Duration(seconds: 20),
    sendTimeout: const Duration(seconds: 20),
  ),
)..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final requiresAuth = (options.extra['requiresAuth'] ?? true) as bool;
        if (requiresAuth) {
          final token =
              AuthRepository.authChangeNotifier.value?.accessToken ?? '';
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        if (kDebugMode && _verboseHttp) {
          debugPrint('HTTP → ${options.method} ${options.uri}');
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        if (kDebugMode) {
          debugPrint(
            'HTTP ✗ ${error.requestOptions.method} '
            '${error.requestOptions.uri}: ${error.message}',
          );
        }
        return handler.next(error);
      },
    ),
  );
