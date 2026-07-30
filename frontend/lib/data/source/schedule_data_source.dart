import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/data/network/http_response_validator.dart';
import 'package:frontend/data/repository/auth_repository.dart';
import 'package:frontend/models/schedule.dart';

abstract class IScheduleDataSource {
  Future<List<Schedule>> getScheduleList({int offset = 0, int limit = 10});
  Future<List<Schedule>> getSchedulesByRoute(int routeId, {bool? includeRound});
  Future<Schedule> getScheduleDetails(int scheduleId);
  Future<String> updateScheduleDetails(
      int scheduleId, Schedule updatedSchedule);
  Future<String> patchScheduleDetails(
      int scheduleId, Map<String, dynamic> updatedFields);
  Future<String> deleteSchedule(int scheduleId);
  Future<String> postSchedule(Schedule newSchedule);
}

class ScheduleRemoteDataSource
    with HttpResponseValidator
    implements IScheduleDataSource {
  final Dio httpClient;

  ScheduleRemoteDataSource(this.httpClient);

  // GET: List of schedules
  @override
  Future<List<Schedule>> getScheduleList(
      {int offset = 0, int limit = 10}) async {
    final url = Urls.getScheduleList;
    final token = AuthRepository.authChangeNotifier.value?.accessToken ?? '';
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json',
          },
        ),
      ),
    );
    
    // Handle new API response structure with 'result' field
    final result = response['result'] as List<dynamic>?;
    if (result == null) {
      throw Exception('Invalid response format: missing result field');
    }
    
    return result
        .map((e) => Schedule.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // GET: Schedules by route ID
  @override
  Future<List<Schedule>> getSchedulesByRoute(int routeId, {bool? includeRound}) async {
    // Build URL with query parameters
    final queryParams = <String, String>{
      'include_deleted': 'false', // Always false as per requirements
    };
    
    // Add include_round parameter only when specified
    if (includeRound != null) {
      queryParams['include_round'] = includeRound.toString();
    }
    
    // Build query string
    final queryString = queryParams.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    
    final url = '${Urls.baseUrl}/api/v1/schedule/$routeId/?$queryString';
    
    final token = AuthRepository.authChangeNotifier.value?.accessToken ?? '';
    
    // Prepare headers
    final headers = <String, dynamic>{
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
    };
    
    print('Schedule API request URL: $url');
    print('Schedule API request headers: $headers');
    print('Query parameters: $queryParams');
    
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.get(
        url,
        options: Options(headers: headers),
      ),
    );
    
    // Handle new API response structure with 'result' field
    final result = response['result'] as List<dynamic>?;
    if (result == null) {
      throw Exception('Invalid response format: missing result field');
    }
    
    return result
        .map((e) => Schedule.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // GET: Schedule by ID
  @override
  Future<Schedule> getScheduleDetails(int scheduleId) async {
    final url = Urls.getScheduleDetailUrl(scheduleId);
    final token = AuthRepository.authChangeNotifier.value?.accessToken ?? '';
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json',
          },
        ),
      ),
    );
    
    // Handle new API response structure with 'result' field
    final result = response['result'] as Map<String, dynamic>?;
    if (result == null) {
      throw Exception('Invalid response format: missing result field');
    }
    
    return Schedule.fromJson(result);
  }

  // PUT: Update schedule by ID
  @override
  Future<String> updateScheduleDetails(
      int scheduleId, Schedule updatedSchedule) async {
    final url = Urls.updateScheduleDetails(scheduleId);
    final token = AuthRepository.authChangeNotifier.value?.accessToken ?? '';
    debugPrint(
        'Sending updated schedule to server2: ${updatedSchedule.toJson()}');
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.put(
        url,
        data: updatedSchedule.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json',
          },
        ),
      ),
    );
    
    // Handle new API response structure
    final message = response['message'] ?? 'Schedule updated successfully.';
    return message.toString();
  }

  // PATCH: Partially update schedule by ID
  @override
  Future<String> patchScheduleDetails(
      int scheduleId, Map<String, dynamic> updatedFields) async {
    final url = Urls.updateScheduleDetails(scheduleId);
    final token = AuthRepository.authChangeNotifier.value?.accessToken ?? '';
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.patch(
        url,
        data: updatedFields,
        options: Options(
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json',
          },
        ),
      ),
    );
    
    // Handle new API response structure
    final message = (response['message'] ??
        'Schedule partially updated successfully.') as String;
    return message.toString();
  }

  @override
  Future<String> deleteSchedule(int scheduleId) async {
    final url = Urls.deleteSchedule(scheduleId);
    final token = AuthRepository.authChangeNotifier.value?.accessToken ?? '';
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.delete(
        url,
        options: Options(
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json',
          },
        ),
      ),
    );
    
    // Handle new API response structure
    final message = (response['message'] ?? 'Schedule deleted successfully.') as String;
    return message.toString();
  }

  // POST: Create new schedule
  @override
  Future<String> postSchedule(Schedule newSchedule) async {
    final url = Urls.postSchedule;
    final token = AuthRepository.authChangeNotifier.value?.accessToken ?? '';
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.post(
        url,
        data: newSchedule.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json',
          },
        ),
      ),
    );
    
    // Handle new API response structure
    final message = (response['message'] ?? 'Schedule created successfully.') as String;
    return message.toString();
  }
}
