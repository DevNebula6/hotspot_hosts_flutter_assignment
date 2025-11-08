import 'dart:async';
import 'dart:io';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

/// Utility class for audio recording
class AudioRecorderHelper {
  final AudioRecorder _recorder = AudioRecorder();
  final Logger _logger = Logger();
  Timer? _amplitudeTimer;
  final StreamController<double> _amplitudeController = StreamController<double>.broadcast();

  /// Stream of amplitude values for waveform visualization
  Stream<double> get amplitudeStream => _amplitudeController.stream;

  /// Check if recording is supported
  Future<bool> isRecordingSupported() async {
    return await _recorder.hasPermission();
  }

  /// Start recording audio
  Future<void> startRecording() async {
    try {
      if (await _recorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final path = '${directory.path}/audio_$timestamp.m4a';

        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: path,
        );
        
        _logger.d('Started recording to: $path');
        
        // Start amplitude monitoring
        _startAmplitudeMonitoring();
      } else {
        _logger.e('Recording permission not granted');
        throw Exception('Recording permission not granted');
      }
    } catch (e) {
      _logger.e('Error starting recording', error: e);
      rethrow;
    }
  }

  /// Pause recording
  Future<void> pauseRecording() async {
    try {
      await _recorder.pause();
      _amplitudeTimer?.cancel();
      _logger.d('Recording paused');
    } catch (e) {
      _logger.e('Error pausing recording', error: e);
      rethrow;
    }
  }

  /// Resume recording
  Future<void> resumeRecording() async {
    try {
      await _recorder.resume();
      _startAmplitudeMonitoring();
      _logger.d('Recording resumed');
    } catch (e) {
      _logger.e('Error resuming recording', error: e);
      rethrow;
    }
  }

  /// Stop recording and return file path
  Future<String?> stopRecording() async {
    try {
      _amplitudeTimer?.cancel();
      final path = await _recorder.stop();
      _logger.d('Stopped recording. File saved at: $path');
      return path;
    } catch (e) {
      _logger.e('Error stopping recording', error: e);
      rethrow;
    }
  }

  /// Cancel recording
  Future<void> cancelRecording() async {
    try {
      _amplitudeTimer?.cancel();
      await _recorder.cancel();
      _logger.d('Recording cancelled');
    } catch (e) {
      _logger.e('Error cancelling recording', error: e);
      rethrow;
    }
  }

  /// Check if currently recording
  Future<bool> isRecording() async {
    return await _recorder.isRecording();
  }

  /// Get recording amplitude (for waveform visualization)
  Future<Amplitude> getAmplitude() async {
    return await _recorder.getAmplitude();
  }

  /// Start monitoring amplitude for waveform
  void _startAmplitudeMonitoring() {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      try {
        final amplitude = await getAmplitude();
        // Normalize amplitude current value to 0-1 range
        final normalized = (amplitude.current + 50) / 50; // Assuming amplitude range is -50 to 0 dB
        _amplitudeController.add(normalized.clamp(0.0, 1.0));
      } catch (e) {
        // Ignore errors during amplitude monitoring
      }
    });
  }

  /// Dispose recorder
  void dispose() {
    _amplitudeTimer?.cancel();
    _amplitudeController.close();
    _recorder.dispose();
  }

  /// Delete audio file
  static Future<void> deleteAudioFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        Logger().d('Deleted audio file: $path');
      }
    } catch (e) {
      Logger().e('Error deleting audio file', error: e);
    }
  }
}
