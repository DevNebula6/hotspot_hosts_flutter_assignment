import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';

/// Utility class for handling app permissions
class PermissionHelper {
  static final _logger = Logger();

  /// Request camera permission
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    _logger.d('Camera permission status: $status');
    return status.isGranted;
  }

  /// Request microphone permission
  static Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    _logger.d('Microphone permission status: $status');
    return status.isGranted;
  }

  /// Request storage permission
  static Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    _logger.d('Storage permission status: $status');
    return status.isGranted || status.isLimited;
  }

  /// Request all media permissions (camera, microphone, storage)
  static Future<Map<Permission, PermissionStatus>> requestMediaPermissions() async {
    final statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
    ].request();
    
    _logger.d('Media permissions statuses: $statuses');
    return statuses;
  }

  /// Check if camera permission is granted
  static Future<bool> hasCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Check if microphone permission is granted
  static Future<bool> hasMicrophonePermission() async {
    final status = await Permission.microphone.status;
    return status.isGranted;
  }

  /// Check if storage permission is granted
  static Future<bool> hasStoragePermission() async {
    final status = await Permission.storage.status;
    return status.isGranted || status.isLimited;
  }

  /// Open app settings
  static Future<bool> openAppSettings() async {
    return await openAppSettings();
  }
}
