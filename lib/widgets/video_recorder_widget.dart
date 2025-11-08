import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_colors.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_spacing.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_text_styles.dart';
import 'package:hotspot_hosts_flutter_assignment/utils/permission_helper.dart';
import 'package:hotspot_hosts_flutter_assignment/utils/video_recorder_helper.dart';

/// Video recorder widget with full-screen camera preview
class VideoRecorderWidget extends StatefulWidget {
  final Function(String videoPath) onSave;

  const VideoRecorderWidget({
    super.key,
    required this.onSave,
  });

  @override
  State<VideoRecorderWidget> createState() => _VideoRecorderWidgetState();
}

class _VideoRecorderWidgetState extends State<VideoRecorderWidget> {
  VideoRecorderHelper? _recorderHelper;
  bool _isInitialized = false;
  bool _isRecording = false;
  String _recordingPath = '';
  Duration _duration = Duration.zero;
  Timer? _timer;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorderHelper?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      // Request permissions
      final cameraGranted = await PermissionHelper.requestCameraPermission();
      final micGranted = await PermissionHelper.requestMicrophonePermission();

      if (!cameraGranted || !micGranted) {
        setState(() {
          _errorMessage = 'Camera and microphone permissions are required';
        });
        return;
      }

      // Initialize video recorder
      _recorderHelper = await VideoRecorderHelper.create();

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      setState(() {
        _errorMessage = 'Error initializing camera: $e';
      });
    }
  }

  Future<void> _startRecording() async {
    if (_recorderHelper == null || !_isInitialized) return;

    try {
      final path = await _recorderHelper!.startRecording();
      
      setState(() {
        _isRecording = true;
        _recordingPath = path;
        _duration = Duration.zero;
      });

      // Start timer
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _duration = Duration(seconds: _duration.inSeconds + 1);
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

  Future<void> _stopRecording() async {
    if (_recorderHelper == null) return;

    _timer?.cancel();

    try {
      final path = await _recorderHelper!.stopRecording();
      
      setState(() {
        _isRecording = false;
        _recordingPath = path;
      });
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error stopping recording: $e'),
            backgroundColor: AppColors.negative,
          ),
        );
      }
    }
  }

  void _cancel() {
    _timer?.cancel();
    Navigator.pop(context);
  }

  void _save() {
    if (_recordingPath.isNotEmpty) {
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
    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.base,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColors.negative,
                  size: 64,
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  _errorMessage!,
                  style: AppTextStyles.bodyR2Regular.copyWith(
                    color: AppColors.text1,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.lg),
                ElevatedButton(
                  onPressed: _cancel,
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (!_isInitialized || _recorderHelper == null) {
      return Scaffold(
        backgroundColor: AppColors.base,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                'Initializing camera...',
                style: AppTextStyles.bodyR2Regular.copyWith(
                  color: AppColors.text2,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.base,
      body: Stack(
        children: [
          // Camera preview
          SizedBox.expand(
            child: CameraPreview(_recorderHelper!.controller),
          ),

          // Top bar with close button and timer
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    // Close button
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.text1,
                        size: 28,
                      ),
                      onPressed: _cancel,
                    ),
                    
                    const Spacer(),
                    
                    // Recording indicator and timer
                    if (_isRecording) ...[
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppColors.negative,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        _formatDuration(_duration),
                        style: AppTextStyles.h3Bold.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isRecording && _recordingPath.isEmpty)
                      Text(
                        'Tap to start recording',
                        style: AppTextStyles.bodyR2Regular.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    
                    SizedBox(height: AppSpacing.md),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Placeholder for alignment
                        if (_isRecording || _recordingPath.isNotEmpty)
                          const SizedBox(width: 64),
                        
                        // Record/Stop button
                        GestureDetector(
                          onTap: _isRecording ? _stopRecording : _startRecording,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.text1,
                                width: 4,
                              ),
                            ),
                            child: Center(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: _isRecording ? 32 : 64,
                                height: _isRecording ? 32 : 64,
                                decoration: BoxDecoration(
                                  color: AppColors.negative,
                                  borderRadius: _isRecording
                                      ? BorderRadius.circular(8)
                                      : BorderRadius.circular(32),
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        // Save button (shown after recording)
                        if (_recordingPath.isNotEmpty && !_isRecording)
                          GestureDetector(
                            onTap: _save,
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: AppColors.primaryAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: AppColors.text1,
                                size: 32,
                              ),
                            ),
                          )
                        else if (_isRecording)
                          const SizedBox(width: 64),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
