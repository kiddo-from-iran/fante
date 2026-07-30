// driver_data_source.dart
import 'package:dio/dio.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/data/network/http_response_validator.dart';
import 'package:frontend/data/repository/auth_repository.dart';
import 'package:frontend/models/driver.dart';

abstract class IDriverDataSource {
  Future<List<Driver>> getDriverList({int offset = 0, int limit = 20});
  Future<Driver> getDriverDetails(int driverId);
  Future<String> updateDriverDetails(Driver updatedDriver);
  Future<String> patchDriverDetails(
      int driverId, Map<String, dynamic> updatedFields);
  Future<String> deleteDriver(int driverId);
  Future<String> postDriver(Driver newDriver);
}

class DriverRemoteDataSource
    with HttpResponseValidator
    implements IDriverDataSource {
  final Dio httpClient;

  DriverRemoteDataSource(this.httpClient);

  @override
  Future<List<Driver>> getDriverList({int offset = 0, int limit = 20}) async {
    final url = Urls.getDriverList;
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.get(
        url, 
        queryParameters: {'offset': offset, 'limit': limit},
        options: Options(
          headers: {
            'Authorization': 'Token ${AuthRepository.authChangeNotifier.value?.accessToken ?? ''}',
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
        .map((e) => Driver.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Driver> getDriverDetails(int driverId) async {
    final url = Urls.getDriverDetailUrl(driverId);
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Token ${AuthRepository.authChangeNotifier.value?.accessToken ?? ''}',
          },
        ),
      ),
    );
    return Driver.fromJson(response);
  }

  @override
  Future<String> updateDriverDetails(Driver updatedDriver) async {
    final url = Urls.updateDriverDetails(updatedDriver.id);
    final requestData = updatedDriver.toJson();
    
    // Debug: Print the request data
    print('PUT Driver Request Data: $requestData');
    
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.put(
        url,
        data: requestData,
        options: Options(
          headers: {
            'Authorization':
                'Token ${AuthRepository.authChangeNotifier.value?.accessToken ?? ''}',
            'Content-Type': 'application/json',
          },
        ),
      ),
    );
    // Handle new API response structure
    final message = response['message'] ?? 'Driver updated successfully.';
    return message.toString();
  }

  @override
  Future<String> patchDriverDetails(
      int driverId, Map<String, dynamic> updatedFields) async {
    final url = Urls.updateDriverDetails(driverId);
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.patch(
        url, 
        data: updatedFields,
        options: Options(
          headers: {
            'Authorization': 'Token ${AuthRepository.authChangeNotifier.value?.accessToken ?? ''}',
            'Content-Type': 'application/json',
          },
        ),
      ),
    );
    final message = (response['message'] ??
        'Driver partially updated successfully.') as String;
    return message;
  }

  @override
  Future<String> deleteDriver(int driverId) async {
    final url = Urls.deleteDriver(driverId);
    try {
      final response = await httpClient.delete(
        url,
        options: Options(
          headers: {
            'Authorization':
                'Token ${AuthRepository.authChangeNotifier.value?.accessToken ?? ''}',
            'Content-Type': 'application/json',
          },
        ),
      );
      
      // Check if the response is successful
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        // If response has data and it's a map, extract message
        if (response.data != null && response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          return (data['message'] ?? 'Driver deleted successfully.') as String;
        } else {
          // If response is empty or string, return success message
          return 'Driver deleted successfully.';
        }
      } else {
        throw Exception('Failed to delete driver: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Driver not found');
      } else if (e.response?.statusCode == 403) {
        throw Exception('Permission denied to delete driver');
      } else {
        throw Exception('Failed to delete driver: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to delete driver: $e');
    }
  }

  @override
  Future<String> postDriver(Driver newDriver) async {
    final url = Urls.postDriver;
    final requestData = newDriver.toJson();
    
    // Debug: Print the request data
    print('POST Driver Request Data: $requestData');
    
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.post(
        url,
        data: requestData,
        options: Options(
          headers: {
            'Authorization':
                'Token ${AuthRepository.authChangeNotifier.value?.accessToken ?? ''}',
            'Content-Type': 'application/json',
          },
        ),
      ),
    );
    // Handle new API response structure
    final message = response['message'] ?? 'Driver created successfully.';
    return message.toString();
  }
}
