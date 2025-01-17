// lib/core/constants/app_constants.dart
class AppConstants {
  // App Info
  static const String appName = 'Fuel Monitoring';
  static const String appVersion = '1.0.0';

  // API and Endpoints
  static const int timeoutDuration = 30; // seconds
  static const String apiBaseUrl = 'your-api-base-url';

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String rememberMeKey = 'remember_me';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const double maxFuelCapacity = 1000.0;

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String vehiclesCollection = 'vehicles';
  static const String fuelRecordsCollection = 'fuel_records';

  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
}