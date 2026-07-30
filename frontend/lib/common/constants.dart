import 'package:frontend/config/app_config.dart';
import 'package:frontend/config/environment.dart';

class Urls {
  Urls._();

  /// FanteQuiz backend base URL (from [Environment]).
  static String get baseUrl =>
      (Environment.instance().config as AppConfig).url;

  /// Legacy bus-app API — kept for unused template data sources.
  static const legacyBaseUrl = 'https://bus.karbabar.ir';

  // ========================================
  // FANTE QUIZ AUTH
  // ========================================
  static String get otpRequestUrl => '$baseUrl/api/v1/auth/otp/request';
  static String get otpRequestLoginUrl =>
      '$baseUrl/api/v1/auth/otp/request/login';
  static String get otpRequestRegisterUrl =>
      '$baseUrl/api/v1/auth/otp/request/register';
  static String get otpValidateUrl => '$baseUrl/api/v1/auth/otp/validate';
  static String get otpVerifyUrl => '$baseUrl/api/v1/auth/otp/verify';
  static String get registerUrl => '$baseUrl/api/v1/auth/register';
  static String get loginUrl => '$baseUrl/api/v1/auth/login';
  static String get loginPasswordUrl => '$baseUrl/api/v1/auth/login/password';
  static String get googleAuthUrl => '$baseUrl/api/v1/auth/google';
  static String get meUrl => '$baseUrl/api/v1/auth/me';
  static String get profileMeUrl => '$baseUrl/api/v1/profile/me';
  static String get leaderboardUrl => '$baseUrl/api/v1/leaderboard';
  static String get gamesUrl => '$baseUrl/api/v1/games/';
  static String gameDetailUrl(int id) => '$baseUrl/api/v1/games/$id';

  static String userUrl(String identifier) =>
      '$baseUrl/api/v1/user/$identifier';

  // ========================================
  // LEGACY BUS TEMPLATE ENDPOINTS
  // ========================================
  static const signInUrl = '$legacyBaseUrl/api/auth-token/';
  static const signUpUrl = '$legacyBaseUrl/api/auth/register/';
  static const refreshTokeUrl = '$legacyBaseUrl/api/auth/refresh/';
  static const String getDashboardList = '$legacyBaseUrl/api/dashboard';
  static const getBusList = '$legacyBaseUrl/api/v1/buses/';
  static const postBus = '$legacyBaseUrl/api/v1/buses/';
  static String getBusDetailUrl(int busId) =>
      '$legacyBaseUrl/api/v1/buses/$busId/';
  static String updateBusDetails(int busId) =>
      '$legacyBaseUrl/api/v1/buses/$busId/';
  static String deleteBus(int busId) => '$legacyBaseUrl/api/v1/buses/$busId/';
  static const String getBusLocation =
      '$legacyBaseUrl/api/bus-location-update/';
  static const String getRecentBusLocations =
      '$legacyBaseUrl/api/bus-locations/';
  static const String getDriverList = '$legacyBaseUrl/api/v1/drivers/';
  static const String postDriver = '$legacyBaseUrl/api/v1/drivers/';
  static String getDriverDetailUrl(int driverId) =>
      '$legacyBaseUrl/api/v1/drivers/$driverId/';
  static String updateDriverDetails(int driverId) =>
      '$legacyBaseUrl/api/v1/drivers/$driverId/';
  static String deleteDriver(int driverId) =>
      '$legacyBaseUrl/api/v1/drivers/$driverId/';
  static const String getRouteList = '$legacyBaseUrl/api/v1/route/';
  static const String postRoute = '$legacyBaseUrl/api/v1/route/';
  static String getRouteDetailUrl(int routeId) =>
      '$legacyBaseUrl/api/v1/route/$routeId/';
  static String updateRouteDetails(int routeId) =>
      '$legacyBaseUrl/api/v1/route/$routeId/';
  static String deleteRoute(int routeId) =>
      '$legacyBaseUrl/api/v1/route/$routeId/';
  static const String getStopList = '$legacyBaseUrl/api/v1/station/';
  static const String postStop = '$legacyBaseUrl/api/v1/station/';
  static String getStopDetailUrl(int stopId) =>
      '$legacyBaseUrl/api/v1/station/$stopId/';
  static String updateStopDetails(int stopId) =>
      '$legacyBaseUrl/api/v1/station/$stopId/';
  static String deleteStop(int stopId) =>
      '$legacyBaseUrl/api/v1/station/$stopId/';
  static const getScheduleList = '$legacyBaseUrl/api/v1/schedule';
  static const postSchedule = '$legacyBaseUrl/api/v1/schedule/';
  static String getScheduleDetailUrl(int scheduleId) =>
      '$legacyBaseUrl/api/v1/schedule/$scheduleId/';
  static String updateScheduleDetails(int scheduleId) =>
      '$legacyBaseUrl/api/v1/schedule/$scheduleId/';
  static String deleteSchedule(int scheduleId) =>
      '$legacyBaseUrl/api/v1/schedule/$scheduleId/';
}
