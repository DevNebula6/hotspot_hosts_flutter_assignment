/// Application-wide constants
class AppConstants {
  AppConstants._();

  // Text Field Limits
  static const int experienceTextLimit = 250;
  static const int questionAnswerTextLimit = 600;

  // App Info
  static const String appName = 'Hotspot Hosts';
  
  // Error Messages
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String noInternetMessage = 'No internet connection. Please check your network.';
  static const String timeoutErrorMessage = 'Request timeout. Please try again.';
}
