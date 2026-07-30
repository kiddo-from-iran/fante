import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/data/repository/auth_repository.dart';

Dio httpClient = Dio()
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final requiresAuth = (options.extra['requiresAuth'] ?? true) as bool;
      if (requiresAuth) {
        final token =
            AuthRepository.authChangeNotifier.value?.accessToken ?? '';
        if (token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        debugPrint('Authorization: ${options.headers['Authorization']}');
      } else {
        debugPrint('Authorization skipped for this request');
      }

      debugPrint('Sending request to: ${options.uri}');
      return handler.next(options);
    },
  ));
