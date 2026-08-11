import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

mixin HttpResponseValidator {
  Future<T> validateResponse<T>(Future<Response> futureResponse) async {
    try {
      final res = await futureResponse;
      final statusCode = res.statusCode ?? 0;
      final data = res.data;

      if (data == null) {
        throw Exception('No data received from server');
      }
      if (statusCode >= 200 && statusCode < 300) {
        return data as T;
      }

      final errorMessage = _extractErrorMessage(data);
      if (kDebugMode) {
        debugPrint('HTTP $statusCode: $errorMessage');
      }
      if (statusCode == 400) {
        throw Exception('Bad request: $errorMessage');
      } else if (statusCode == 401) {
        throw Exception('Unauthorized: $errorMessage');
      } else if (statusCode == 403) {
        throw Exception('Forbidden: $errorMessage');
      } else if (statusCode == 404) {
        throw Exception('Not Found: $errorMessage');
      }
      throw Exception('Unexpected error: ${res.statusMessage}');
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('Dio error: ${e.message}');
      }
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Unknown error: $e');
    }
  }

  String _extractErrorMessage(dynamic data) {
    if (data is Map) {
      if (data.containsKey('detail')) {
        final detail = data['detail'];
        if (detail is String) return detail;
        return detail.toString();
      } else if (data.containsKey('error')) {
        return data['error'].toString();
      } else if (data.containsKey('message')) {
        return data['message'].toString();
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
