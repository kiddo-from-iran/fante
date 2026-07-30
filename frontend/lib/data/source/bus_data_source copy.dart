import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/data/network/http_response_validator.dart';
import 'package:frontend/data/repository/auth_repository.dart';
import 'package:frontend/models/bus.dart';
import 'package:frontend/models/bus_location.dart';
import 'package:frontend/utils/app_strings.dart';

abstract class IBusDataSource {
  Future<List<Bus>> getBusList({int offset = 0, int limit = 20});
  Future<Bus> getBusDetails(int busId);
  Future<String> updateBusDetails(Bus updatedBus);
  Future<String> patchBusDetails(int busId, Map<String, dynamic> updatedFields);
  Future<String> deleteBus(int busId);
  Future<String> postBus(Bus newBus);
  Future<List<BusLocation>> getRecentBusLocations();
}

class BusRemoteDataSource with HttpResponseValidator implements IBusDataSource {
  final Dio httpClient;

  BusRemoteDataSource(this.httpClient);

  // GET: List of buses
  @override
  Future<List<Bus>> getBusList({int offset = 0, int limit = 20}) async {
    final token = AuthRepository.authChangeNotifier.value?.accessToken ?? '';
    debugPrint('Authorization: Token ${token}');
    final url = Urls.getBusList;
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.get(
        url, 
        queryParameters: {'offset': offset, 'limit': limit},
        options: Options(
          headers: {
            'Authorization': 'Token $token',
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
        .map((e) => Bus.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // GET: recent bus locations
  @override
  Future<List<BusLocation>> getRecentBusLocations() async {
    final token = AuthRepository.authChangeNotifier.value?.accessToken ?? '';
    final url = Urls.getRecentBusLocations;
    final response = await validateResponse<List<dynamic>>(
      httpClient.get(
        url,
        options: Options(headers: {
          'Authorization': 'Token $token',
        }),
      ),
    );
    return response
        .map((e) => BusLocation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // GET: Bus by ID
  @override
  Future<Bus> getBusDetails(int busId) async {
    final token = AuthRepository.authChangeNotifier.value?.accessToken ?? '';
    final url = Urls.getBusDetailUrl(busId);
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Token $token',
          },
        ),
      ),
    );
    return Bus.fromJson(response);
  }

  // PUT: Update bus by ID
  @override
  Future<String> updateBusDetails(Bus updatedBus) async {
    final url = Urls.updateBusDetails(updatedBus.id);
    final token = AuthRepository.authChangeNotifier.value?.accessToken ?? '';
    
    // Only send required fields according to new API spec
    final requestData = <String, dynamic>{
      'identifier': updatedBus.identifier,
      'model': updatedBus.model,
      'year': int.tryParse(updatedBus.year) ?? 2025, // Convert string to int
      'capacity': updatedBus.capacity,
      'status': updatedBus.status == AppStrings.active
          ? 'active'
          : updatedBus.status == AppStrings.inactive
              ? 'inactive'
              : 'maintenance',
      'code': updatedBus.code, // Include the code field
    };
    
    print('PUT Bus Request Data: $requestData');
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.put(url,
          data: requestData,
          options: Options(
            headers: {
              'Authorization': 'Token $token',
              'Content-Type': 'application/json',
            },
          )),
    );
    
    // Handle new API response structure
    final message = response['message'] ?? 'Bus updated successfully.';
    return message.toString();
  }

  // PATCH: Partially update bus by ID
  @override
  Future<String> patchBusDetails(
      int busId, Map<String, dynamic> updatedFields) async {
    final token = AuthRepository.authChangeNotifier.value?.accessToken ?? '';
    final url = Urls.updateBusDetails(busId);
    
    // Filter only allowed fields according to new API spec
    final allowedFields = <String, String>{};
    if (updatedFields.containsKey('identifier')) {
      allowedFields['identifier'] = updatedFields['identifier'].toString();
    }
    if (updatedFields.containsKey('model')) {
      allowedFields['model'] = updatedFields['model'].toString();
    }
    if (updatedFields.containsKey('year')) {
      final year = updatedFields['year'] is String 
          ? int.tryParse(updatedFields['year'] as String) ?? 1404
          : updatedFields['year'];
      allowedFields['year'] = year.toString();
    }
    if (updatedFields.containsKey('capacity')) {
      allowedFields['capacity'] = updatedFields['capacity'].toString();
    }
    if (updatedFields.containsKey('code')) {
      allowedFields['code'] = updatedFields['code'].toString();
    }
    if (updatedFields.containsKey('status')) {
      // Convert status to API format
      final status = updatedFields['status'].toString();
      if (status == AppStrings.active) {
        allowedFields['status'] = 'active';
      } else if (status == AppStrings.inactive) {
        allowedFields['status'] = 'inactive';
      } else if (status == AppStrings.maintenance) {
        allowedFields['status'] = 'maintenance';
      } else {
        allowedFields['status'] = status;
      }
    }
    
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.patch(
        url,
        data: allowedFields,
        options: Options(
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json',
          },
        ),
      ),
    );
    
    // Handle new API response structure
    final message = response['message'] ?? 'Bus partially updated successfully.';
    return message.toString();
  }

  // DELETE: Delete bus by ID
  @override
  Future<String> deleteBus(int busId) async {
    final url = Urls.deleteBus(busId);
    await validateResponse<String>(
      httpClient.delete(
        url,
        options: Options(
          headers: {
            'Authorization':
                // ignore: lines_longer_than_80_chars
                'Token ${AuthRepository.authChangeNotifier.value?.accessToken ?? ''}',
            'Content-Type': 'application/json',
          },
        ),
      ),
    );
    return 'Bus deleted successfully.';
  }

  // POST: Create new bus
  @override
  Future<String> postBus(Bus newBus) async {
    final url = Urls.postBus;
    final token = AuthRepository.authChangeNotifier.value?.accessToken ?? '';
    
    // Only send required fields according to new API spec
    final requestData = <String, dynamic>{
      'identifier': newBus.identifier,
      'model': newBus.model,
      'year': int.tryParse(newBus.year) ?? 2025, // Convert string to int
      'capacity': newBus.capacity,
      'status': newBus.status == AppStrings.active
          ? 'active'
          : newBus.status == AppStrings.inactive
              ? 'inactive'
              : 'maintenance',
      'code': newBus.code, // Include the code field
    };
    
    print('POST Bus Request Data: $requestData');
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.post(url,
          data: requestData,
          options: Options(
            headers: {
              'Authorization': 'Token $token',
              'Content-Type': 'application/json',
            },
          )),
    );
    
    // Handle new API response structure
    final message = response['message'] ?? 'Bus created successfully.';
    return message.toString();
  }
}
