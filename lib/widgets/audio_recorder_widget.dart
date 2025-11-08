import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_colors.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_spacing.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_text_styles.dart';
import 'package:hotspot_hosts_flutter_assignment/utils/audio_recorder_helper.dart';
import 'package:hotspot_hosts_flutter_assignment/utils/permission_helper.dart';
import 'package:hotspot_hosts_flutter_assignment/widgets/custom_buttons.dart';

/// Audio recorder widget with waveform visualization
class AudioRecorderWidget extends StatefulWidget {
  final Function(String audioPath) onSave;

  const AudioRecorderWidget({
    super.key,
    required this.onSave,
  });

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  final AudioRecorderHelper _recorderHelper = AudioRecorderHelper();
  bool _isRecording = false;
  bool _isPaused = false;
  bool _hasRecording = false;
  String _recordingPath = '';
  Duration _duration = Duration.zero;
  Timer? _timer;
  List<double> _amplitudes = [];
  StreamSubscription? _amplitudeSubscription;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _amplitudeSubscription?.cancel();
    _recorderHelper.dispose();
    super.dispose();
  }

  Future<void> _requestPermission() async {
    final granted = await PermissionHelper.requestMicrophonePermission();
    if (!granted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Microphone permission is required to record audio'),
          backgroundColor: AppColors.negative,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _startRecording() async {
    try {
      await _recorderHelper.startRecording();
      setState(() {
        _isRecording = true;
        _isPaused = false;
        _duration = Duration.zero;
        _amplitudes.clear();
      });

      // Start timer
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _duration = Duration(seconds: _duration.inSeconds + 1);
        });
      });

      // Listen to amplitude for waveform
      _amplitudeSubscription = _recorderHelper.amplitudeStream.listen((amplitude) {
        setState(() {
          _amplitudes.add(amplitude);
          // Keep only last 50 samples for visualization
          if (_amplitudes.length > 50) {
            _amplitudes.removeAt(0);
          }
        });
      });
    } catch (e) {
      debugPrint('Error starting recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting recording: $e'),
            backgroundColor: AppColors.negative,
          ),
        );
      }
    }
  }

  Future<void> _pauseRecording() async {
    await _recorderHelper.pauseRecording();
    _timer?.cancel();
    setState(() {
      _isPaused = true;
    });
  }

  Future<void> _resumeRecording() async {
    await _recorderHelper.resumeRecording();
    
    // Restart timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration = Duration(seconds: _duration.inSeconds + 1);
      });
    });
    
    setState(() {
      _isPaused = false;
    });
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    _amplitudeSubscription?.cancel();
    
    final path = await _recorderHelper.stopRecording();
    
    setState(() {
      _isRecording = false;
      _isPaused = false;
      _hasRecording = path != null;
      _recordingPath = path ?? '';
    });
  }

  void _cancel() {
    _timer?.cancel();
    _amplitudeSubscription?.cancel();
    if (_isRecording) {
      _recorderHelper.stopRecording();
    }
    Navigator.pop(context);
  }

  void _save() {
    if (_hasRecording && _recordingPath.isNotEmpty) {
      widget.onSave(_recordingPath);
      Navigator.pop(context);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border1,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            SizedBox(height: AppSpacing.lg),
            
            // Title
            Text(
              'Record Audio',
              style: AppTextStyles.h3Bold.copyWith(color: AppColors.text1),
            ),
            
            SizedBox(height: AppSpacing.lg),
            
            // Waveform visualization
            Container(
              height: 120,
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.base,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border1),
              ),
              child: _isRecording
                  ? CustomPaint(
                      painter: WaveformPainter(
                        amplitudes: _amplitudes,
                        color: AppColors.primaryAccent,
                      ),
                      size: const Size(double.infinity, 100),
                    )
                  : Center(
                      child: Text(
                        _hasRecording 
                            ? 'Recording complete!'
                            : 'Press the button to start recording',
                        style: AppTextStyles.bodyR2Regular.copyWith(
                          color: AppColors.text2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
            
            SizedBox(height: AppSpacing.md),
            
            // Duration
            Text(
              _formatDuration(_duration),
              style: AppTextStyles.h2Bold.copyWith(
                color: AppColors.text1,
              ),
            ),
            
            SizedBox(height: AppSpacing.lg),
            
            // Recording controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isRecording && !_hasRecording) ...[
                  // Start recording button
                  _RecordButton(
                    icon: Icons.mic,
                    label: 'Start',
                    onTap: _startRecording,
                    isPrimary: true,
                  ),
                ] else if (_isRecording) ...[
                  // Pause/Resume button
                  _RecordButton(
                    icon: _isPaused ? Icons.play_arrow : Icons.pause,
                    label: _isPaused ? 'Resume' : 'Pause',
                    onTap: _isPaused ? _resumeRecording : _pauseRecording,
                  ),
                  SizedBox(width: AppSpacing.md),
                  // Stop button
                  _RecordButton(
                    icon: Icons.stop,
                    label: 'Stop',
                    onTap: _stopRecording,
                    color: AppColors.negative,
                  ),
                ],
              ],
            ),
            
            SizedBox(height: AppSpacing.lg),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: 'Cancel',
                    onPressed: _cancel,
                  ),
                ),
                if (_hasRecording) ...[
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Save',
                      onPressed: _save,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Record button widget
class _RecordButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;
  final Color? color;

  const _RecordButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? (isPrimary ? AppColors.primaryAccent : AppColors.surface);
    
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: buttonColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: isPrimary ? Colors.transparent : AppColors.border1,
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              color: isPrimary ? AppColors.text1 : AppColors.text2,
              size: 32,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTextStyles.bodyR2Regular.copyWith(
              color: AppColors.text2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Waveform painter
class WaveformPainter extends CustomPainter {
  final List<double> amplitudes;
  final Color color;

  WaveformPainter({
    required this.amplitudes,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (amplitudes.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final barWidth = size.width / 50; // Fixed 50 bars
    final centerY = size.height / 2;

    for (int i = 0; i < amplitudes.length; i++) {
      final x = i * barWidth;
      final normalizedAmplitude = amplitudes[i].clamp(0.0, 1.0);
      final barHeight = normalizedAmplitude * size.height * 0.8;

      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return oldDelegate.amplitudes != amplitudes;
  }
}
