/// API configuration constants
class ApiConstants {
  ApiConstants._();

  /// Base URL for the API
  static const String baseUrl = 'https://staging.chamberofsecrets.8club.co';

  /// API version
  static const String apiVersion = '/v1';

  /// Full base URL with version
  static const String fullBaseUrl = '$baseUrl$apiVersion';

  // Endpoints
  static const String experiencesEndpoint = '/experiences';

  // Query Parameters
  static const String activeParam = 'active';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
