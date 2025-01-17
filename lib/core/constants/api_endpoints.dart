// lib/core/constants/api_endpoints.dart
class ApiEndpoints {
  static const String baseUrl = 'your-api-base-url';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String refreshToken = '/auth/refresh-token';

  // Vehicle Endpoints
  static const String vehicles = '/vehicles';
  static const String vehicleById = '/vehicles/'; // Append vehicle ID
  static const String vehicleStatus = '/vehicles/status/'; // Append vehicle ID

  // Fuel Tracking Endpoints
  static const String fuelRecords = '/fuel-records';
  static const String fuelRecordById = '/fuel-records/'; // Append record ID
  static const String fuelStats = '/fuel-records/stats';

  // User Endpoints
  static const String userProfile = '/users/profile';
  static const String updateProfile = '/users/profile/update';
  static const String changePassword = '/users/change-password';
}