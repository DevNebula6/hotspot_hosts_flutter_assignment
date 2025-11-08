import 'dart:io';
import 'package:camera/camera.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

/// Utility class for video recording
class VideoRecorderHelper {
  CameraController? _controller;
  final Logger _logger = Logger();
  String? _currentRecordingPath;

  /// Private constructor
  VideoRecorderHelper._();

  /// Factory method to create and initialize VideoRecorderHelper
  static Future<VideoRecorderHelper> create() async {
    final helper = VideoRecorderHelper._();
    await helper.initializeCamera();
    return helper;
  }

  /// Initialize camera
  Future<CameraController> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw Exception('No cameras available');
      }

      // Use front camera if available, otherwise use first camera
      final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: true,
      );

      await _controller!.initialize();
      _logger.d('Camera initialized successfully');
      
      return _controller!;
    } catch (e) {
      _logger.e('Error initializing camera', error: e);
      rethrow;
    }
  }

  /// Start video recording and return the path where it will be saved
  Future<String> startRecording() async {
    try {
      if (_controller == null || !_controller!.value.isInitialized) {
        throw Exception('Camera not initialized');
      }

      if (_controller!.value.isRecordingVideo) {
        throw Exception('Already recording');
      }

      // Generate path for the video file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _currentRecordingPath = '${directory.path}/video_$timestamp.mp4';

      await _controller!.startVideoRecording();
      _logger.d('Started video recording to: $_currentRecordingPath');
      
      return _currentRecordingPath!;
    } catch (e) {
      _logger.e('Error starting video recording', error: e);
      rethrow;
    }
  }

  /// Stop video recording and return file path
  Future<String> stopRecording() async {
    try {
      if (_controller == null || !_controller!.value.isInitialized) {
        throw Exception('Camera not initialized');
      }

      if (!_controller!.value.isRecordingVideo) {
        throw Exception('Not recording');
      }

      final videoFile = await _controller!.stopVideoRecording();
      _logger.d('Stopped video recording. File saved at: ${videoFile.path}');
      
      return videoFile.path;
    } catch (e) {
      _logger.e('Error stopping video recording', error: e);
      rethrow;
    }
  }

  /// Check if currently recording
  bool isRecording() {
    return _controller?.value.isRecordingVideo ?? false;
  }

  /// Get camera controller (non-nullable for widget use)
  CameraController get controller {
    if (_controller == null) {
      throw Exception('Camera controller not initialized');
    }
    return _controller!;
  }

  /// Dispose camera controller
  void dispose() {
    _controller?.dispose();
    _controller = null;
    _logger.d('Camera controller disposed');
  }

  /// Delete video file
  static Future<void> deleteVideoFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        Logger().d('Deleted video file: $path');
      }
    } catch (e) {
      Logger().e('Error deleting video file', error: e);
    }
  }
}
