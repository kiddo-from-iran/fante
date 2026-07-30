import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

mixin HttpResponseValidator {
  Future<T> validateResponse<T>(Future<Response> futureResponse) async {
    try {
      final res = await futureResponse;
      final statusCode = res.statusCode ?? 0;
      final data = res.data;
      
      debugPrint('Response status code: $statusCode');
      debugPrint('Response data: $data');
      
      if (data == null) {
        throw Exception('No data received from server');
      }
      if (statusCode >= 200 && statusCode < 300) {
        return data as T;
      } else if (statusCode == 400) {
        final errorMessage = _extractErrorMessage(data);
        debugPrint('400 Bad Request Error: $errorMessage');
        throw Exception('Bad request: $errorMessage');
      } else if (statusCode == 401) {
        final errorMessage = _extractErrorMessage(data);
        debugPrint('401 Unauthorized Error: $errorMessage');
        throw Exception('Unauthorized: $errorMessage');
      } else if (statusCode == 403) {
        final errorMessage = _extractErrorMessage(data);
        debugPrint('403 Forbidden Error: $errorMessage');
        throw Exception('Forbidden: $errorMessage');
      } else if (statusCode == 404) {
        final errorMessage = _extractErrorMessage(data);
        debugPrint('404 Not Found Error: $errorMessage');
        throw Exception('Not Found: $errorMessage');
      } else {
        debugPrint('Unexpected error: ${res.statusMessage}');
        throw Exception('Unexpected error: ${res.statusMessage}');
      }
    } on DioException catch (e) {
      debugPrint('Dio error: ${e.message}');
      debugPrint('Dio error response: ${e.response?.data}');
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      debugPrint('Unknown error: $e');
      throw Exception('Unknown error: $e');
    }
  }

  String _extractErrorMessage(dynamic data) {
    if (data is Map) {
      if (data.containsKey('detail')) {
        return data['detail'] as String;
      } else if (data.containsKey('error')) {
        return data['error'] as String;
      } else if (data.containsKey('message')) {
        return data['message'] as String;
      } else if (data.containsKey('errors')) {
        final errors = data['errors'];
        if (errors is Map) {
          return errors.values.join(', ');
        } else if (errors is List) {
          return errors.join(', ');
        }
        return errors.toString();
      }
    }
    return data.toString();
  }
}
