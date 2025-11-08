import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:hotspot_hosts_flutter_assignment/blocs/question_answer/question_answer_bloc.dart';
import 'package:hotspot_hosts_flutter_assignment/blocs/question_answer/question_answer_event.dart';
import 'package:hotspot_hosts_flutter_assignment/blocs/question_answer/question_answer_state.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_colors.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_spacing.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_text_styles.dart';
import 'package:hotspot_hosts_flutter_assignment/widgets/audio_player_widget.dart';
import 'package:hotspot_hosts_flutter_assignment/widgets/custom_text_field.dart';
import 'package:hotspot_hosts_flutter_assignment/widgets/video_player_widget.dart';
import 'package:hotspot_hosts_flutter_assignment/utils/audio_recorder_helper.dart';
import 'package:hotspot_hosts_flutter_assignment/utils/video_recorder_helper.dart';
import 'package:hotspot_hosts_flutter_assignment/utils/permission_helper.dart';

/// Question screen
class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final TextEditingController _textController = TextEditingController();
  
  // Audio recording state
  AudioRecorderHelper? _audioRecorder;
  bool _isRecordingAudio = false;
  bool _showAudioRecordingUI = false;
  String _audioRecordingDuration = '00:00';
  
  // Video recording state
  VideoRecorderHelper? _videoRecorder;
  CameraController? _cameraController;
  bool _isRecordingVideo = false;
  bool _showVideoRecordingUI = false;
  String _videoRecordingDuration = '00:00';

  @override
  void dispose() {
    _textController.dispose();
    _audioRecorder?.dispose();
    _videoRecorder?.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create QuestionAnswerBloc for this screen
    return BlocProvider(
      create: (context) => QuestionAnswerBloc('onboarding_q1'),
      child: Scaffold(
        backgroundColor: AppColors.base,
        appBar: AppBar(
          backgroundColor: AppColors.base2Dark,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.text1),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: _ProgressIndicator(currentStep: 2, totalSteps: 3),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.text1),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/icons/image25.png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.base,
                ),
              ),
            ),
            // Content
            SafeArea(
              child: BlocBuilder<QuestionAnswerBloc, QuestionAnswerState>(
                builder: (context, state) {
                  // Debug logging
                  debugPrint('BLoC State - hasTextAnswer: ${state.hasTextAnswer}, hasAudioAnswer: ${state.hasAudioAnswer}, hasVideoAnswer: ${state.hasVideoAnswer}');
                  
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Spacer(),
                      
                      // Question text
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Why do you want to host with us?',
                              style: AppTextStyles.h2Bold.copyWith(
                                color: AppColors.text1,
                                fontSize: 24,
                                height: 1.3,
                              ),
                            ),
                            
                            SizedBox(height: AppSpacing.sm),
                            
                            Text(
                              'Tell us about your intent and what motivates you to create experiences.',
                              style: AppTextStyles.bodyR2Regular.copyWith(
                                color: AppColors.text2,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: AppSpacing.lg),
                      
                      // Text input field
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        child: CustomTextField(
                          controller: _textController,
                          hintText: '/ Start typing here',
                          maxLines: 6,
                          maxLength: 600,
                          onChanged: (value) {
                            context.read<QuestionAnswerBloc>().add(
                              UpdateTextAnswer(value),
                            );
                          },
                        ),
                      ),
                      
                      SizedBox(height: AppSpacing.md),
                      
                      // Inline audio recording feedback
                      if (_showAudioRecordingUI) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                          child: Container(
                            padding: EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.surface.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.border1,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Status icon
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _isRecordingAudio 
                                        ? AppColors.negative.withOpacity(0.2)
                                        : AppColors.primaryAccent.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _isRecordingAudio ? Icons.mic : Icons.check,
                                    color: _isRecordingAudio 
                                        ? AppColors.negative 
                                        : AppColors.primaryAccent,
                                    size: 20,
                                  ),
                                ),
                                
                                SizedBox(width: AppSpacing.md),
                                
                                // Recording info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _isRecordingAudio 
                                            ? 'Recording Audio...' 
                                            : 'Audio Recorded',
                                        style: AppTextStyles.bodyBBold.copyWith(
                                          color: AppColors.text1,
                                          fontSize: 14,
                                        ),
                                      ),
                                      if (_isRecordingAudio)
                                        Row(
                                          children: [
                                            // Waveform visualization
                                            Expanded(
                                              child: Container(
                                                height: 20,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: List.generate(
                                                    20,
                                                    (index) => Container(
                                                      width: 2,
                                                      height: 4 + (index % 3) * 4.0,
                                                      decoration: BoxDecoration(
                                                        color: AppColors.primaryAccent,
                                                        borderRadius: BorderRadius.circular(1),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: AppSpacing.sm),
                                            Text(
                                              _audioRecordingDuration,
                                              style: AppTextStyles.bodyR2Regular.copyWith(
                                                color: AppColors.primaryAccent,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                
                                SizedBox(width: AppSpacing.sm),
                                
                                // Action button (Stop recording or close)
                                if (_isRecordingAudio)
                                  IconButton(
                                    icon: Icon(
                                      Icons.stop_circle,
                                      color: AppColors.negative,
                                      size: 28,
                                    ),
                                    onPressed: () => _stopAudioRecording(context),
                                  )
                                else
                                  IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: AppColors.text2,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _showAudioRecordingUI = false;
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),
                      ],
                      
                      // Inline video recording feedback
                      if (_showVideoRecordingUI) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                          child: Container(
                            padding: EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.surface.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.border1,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Camera preview or status icon
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: _isRecordingVideo 
                                        ? Colors.black
                                        : AppColors.primaryAccent.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: _isRecordingVideo && _cameraController != null && _cameraController!.value.isInitialized
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: CameraPreview(_cameraController!),
                                        )
                                      : Icon(
                                          _isRecordingVideo ? Icons.videocam : Icons.check,
                                          color: _isRecordingVideo 
                                              ? AppColors.negative 
                                              : AppColors.primaryAccent,
                                          size: 24,
                                        ),
                                ),
                                
                                SizedBox(width: AppSpacing.md),
                                
                                // Recording info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _isRecordingVideo 
                                            ? 'Recording Video...' 
                                            : 'Video Recorded',
                                        style: AppTextStyles.bodyBBold.copyWith(
                                          color: AppColors.text1,
                                          fontSize: 14,
                                        ),
                                      ),
                                      if (_isRecordingVideo)
                                        Row(
                                          children: [
                                            // Recording indicator dot
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color: AppColors.negative,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            SizedBox(width: AppSpacing.sm),
                                            Text(
                                              _videoRecordingDuration,
                                              style: AppTextStyles.bodyR2Regular.copyWith(
                                                color: AppColors.negative,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                
                                SizedBox(width: AppSpacing.sm),
                                
                                // Action button (Stop recording or close)
                                if (_isRecordingVideo)
                                  IconButton(
                                    icon: Icon(
                                      Icons.stop_circle,
                                      color: AppColors.negative,
                                      size: 28,
                                    ),
                                    onPressed: () => _stopVideoRecording(context),
                                  )
                                else
                                  IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: AppColors.text2,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _showVideoRecordingUI = false;
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),
                      ],
                      
                      // Audio preview (if audio answer exists)
                      if (state.hasAudioAnswer) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                          child: AudioPlayerWidget(
                            audioPath: state.answer.audioPath ?? '',
                            onDelete: () {
                              context.read<QuestionAnswerBloc>().add(
                                const DeleteAudioAnswer(),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),
                      ],
                      
                      // Video preview (if video answer exists)
                      if (state.hasVideoAnswer) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                          child: VideoPlayerWidget(
                            videoPath: state.answer.videoPath ?? '',
                            onDelete: () {
                              context.read<QuestionAnswerBloc>().add(
                                const DeleteVideoAnswer(),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),
                      ],
                      
                      // Next button
                      SafeArea(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: AppSpacing.md,
                            bottom: AppSpacing.xxl,
                            left: AppSpacing.lg,
                            right: AppSpacing.lg,
                          ),
                          child: Row(
                            children: [
                              // Show media buttons only if no media response exists
                              if (!state.hasAudioAnswer && !state.hasVideoAnswer) ...[
                                // Audio and Video buttons
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.border1,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _MediaButton(
                                            icon: Icons.mic_none,
                                            isActive: _isRecordingAudio || _showAudioRecordingUI,
                                            onTap: () {
                                              if (_isRecordingAudio) {
                                                _stopAudioRecording(context);
                                              } else {
                                                _startAudioRecording(context);
                                              }
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: 3,
                                          height: 40,
                                          color: AppColors.border1,
                                        ),
                                        Expanded(
                                          child: _MediaButton(
                                            icon: Icons.videocam_outlined,
                                            isActive: _isRecordingVideo || _showVideoRecordingUI,
                                            onTap: () {
                                              if (_isRecordingVideo) {
                                                _stopVideoRecording(context);
                                              } else {
                                                _startVideoRecording(context);
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: AppSpacing.md),
                              ],
                              
                              Expanded(
                                flex: (state.hasAudioAnswer || state.hasVideoAnswer) ? 1 : 4,
                                child: AnimatedSize(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  child: Padding(
                                    padding: (state.hasAudioAnswer || state.hasVideoAnswer)
                                        ? EdgeInsets.zero
                                        : const EdgeInsets.only(left: 16.0),
                                    child: Container(
                                    decoration: BoxDecoration(
                                      gradient: (state.hasTextAnswer || 
                                                 state.hasAudioAnswer || 
                                                 state.hasVideoAnswer)
                                          ? LinearGradient(
                                              colors: [
                                                const Color(0xFF2A2A2A), 
                                                const Color(0xFF404040), 
                                                const Color(0xFF2A2A2A),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.centerRight,
                                              stops: const [0.0, 0.5, 1.0],
                                            )
                                          : null,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: (state.hasTextAnswer || 
                                               state.hasAudioAnswer || 
                                               state.hasVideoAnswer)
                                            ? const Color(0xFF555555)
                                            : AppColors.border1,
                                        width: 1,
                                      ),
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: (state.hasTextAnswer || 
                                                         state.hasAudioAnswer || 
                                                         state.hasVideoAnswer)
                                            ? Colors.transparent
                                            : AppColors.border1,
                                        shadowColor: Colors.transparent,
                                        padding: EdgeInsets.symmetric(
                                          vertical: AppSpacing.md,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: (state.hasTextAnswer || 
                                                 state.hasAudioAnswer || 
                                                 state.hasVideoAnswer)
                                          ? () {
                                              // Log answer data
                                              debugPrint('=== Answer Data ===');
                                              debugPrint('Question ID: ${state.answer.questionId}');
                                              debugPrint('Answer Type: ${state.answer.answerType}');
                                              debugPrint('Text: ${state.answer.textAnswer}');
                                              debugPrint('Audio: ${state.answer.audioPath}');
                                              debugPrint('Video: ${state.answer.videoPath}');
                                              
                                              // Show success message
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Answer submitted successfully!'),
                                                  backgroundColor: AppColors.positive,
                                                ),
                                              );
                                            }
                                          : null,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Next',
                                            style: AppTextStyles.buttonBold.copyWith(
                                              fontSize: 20,
                                              color: (state.hasTextAnswer || 
                                                     state.hasAudioAnswer || 
                                                     state.hasVideoAnswer)
                                                  ? AppColors.textPrimary
                                                  : AppColors.textTertiary,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: (state.hasTextAnswer || 
                                                   state.hasAudioAnswer || 
                                                   state.hasVideoAnswer)
                                                ? AppColors.textPrimary
                                                : AppColors.textTertiary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ), // End Padding
                              ), // End AnimatedSize
                              ), // End Expanded
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  Future<void> _startAudioRecording(BuildContext context) async {
    try {
      // Request microphone permission
      final hasPermission = await PermissionHelper.requestMicrophonePermission();
      if (!hasPermission) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Microphone permission is required'),
              backgroundColor: AppColors.negative,
            ),
          );
        }
        return;
      }

      // Initialize audio recorder
      _audioRecorder = AudioRecorderHelper();
      
      setState(() {
        _showAudioRecordingUI = true;
        _isRecordingAudio = true;
        _audioRecordingDuration = '00:00';
      });
      
      // Start recording
      await _audioRecorder!.startRecording();
      
      // Update duration
      int seconds = 0;
      Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 1));
        if (_isRecordingAudio && mounted) {
          seconds++;
          setState(() {
            final mins = (seconds ~/ 60).toString().padLeft(2, '0');
            final secs = (seconds % 60).toString().padLeft(2, '0');
            _audioRecordingDuration = '$mins:$secs';
          });
          return true;
        }
        return false;
      });
    } catch (e) {
      debugPrint('Error starting audio recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start recording: $e'),
            backgroundColor: AppColors.negative,
          ),
        );
        setState(() {
          _showAudioRecordingUI = false;
          _isRecordingAudio = false;
        });
      }
    }
  }

  Future<void> _stopAudioRecording(BuildContext context) async {
    try {
      setState(() {
        _isRecordingAudio = false;
      });
      
      // Stop recording and get path
      final audioPath = await _audioRecorder?.stopRecording();
      
      if (audioPath != null && audioPath.isNotEmpty) {
        // After 1 second, hide recording UI and show player
        await Future.delayed(const Duration(seconds: 1));
        
        if (mounted) {
          setState(() {
            _showAudioRecordingUI = false;
          });
          
          // Save audio answer
          context.read<QuestionAnswerBloc>().add(
            UpdateAudioAnswer(audioPath),
          );
        }
      }
    } catch (e) {
      debugPrint('Error stopping audio recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save recording: $e'),
            backgroundColor: AppColors.negative,
          ),
        );
        setState(() {
          _showAudioRecordingUI = false;
          _isRecordingAudio = false;
        });
      }
    }
  }

  Future<void> _startVideoRecording(BuildContext context) async {
    try {
      // Request camera and microphone permissions
      final cameraPermission = await PermissionHelper.requestCameraPermission();
      final micPermission = await PermissionHelper.requestMicrophonePermission();
      
      if (!cameraPermission || !micPermission) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Camera and microphone permissions are required'),
              backgroundColor: AppColors.negative,
            ),
          );
        }
        return;
      }

      setState(() {
        _showVideoRecordingUI = true;
      });

      // Initialize video recorder
      _videoRecorder = await VideoRecorderHelper.create();
      _cameraController = _videoRecorder!.controller;
      
      setState(() {
        _isRecordingVideo = true;
        _videoRecordingDuration = '00:00';
      });
      
      // Start recording
      await _videoRecorder!.startRecording();
      
      // Update duration
      int seconds = 0;
      Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 1));
        if (_isRecordingVideo && mounted) {
          seconds++;
          setState(() {
            final mins = (seconds ~/ 60).toString().padLeft(2, '0');
            final secs = (seconds % 60).toString().padLeft(2, '0');
            _videoRecordingDuration = '$mins:$secs';
          });
          return true;
        }
        return false;
      });
    } catch (e) {
      debugPrint('Error starting video recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start recording: $e'),
            backgroundColor: AppColors.negative,
          ),
        );
        setState(() {
          _showVideoRecordingUI = false;
          _isRecordingVideo = false;
        });
      }
    }
  }

  Future<void> _stopVideoRecording(BuildContext context) async {
    try {
      setState(() {
        _isRecordingVideo = false;
      });
      
      // Stop recording and get path
      final videoPath = await _videoRecorder?.stopRecording();
      
      debugPrint('Video recording stopped. Path: $videoPath');
      
      if (videoPath != null && videoPath.isNotEmpty) {
        // After 1 second, hide recording UI and show player
        await Future.delayed(const Duration(seconds: 1));
        
        if (mounted) {
          setState(() {
            _showVideoRecordingUI = false;
          });
          
          // Dispose camera controller
          await _cameraController?.dispose();
          _cameraController = null;
          
          debugPrint('Saving video answer to BLoC: $videoPath');
          
          // Save video answer
          context.read<QuestionAnswerBloc>().add(
            UpdateVideoAnswer(videoPath),
          );
          
          debugPrint('Video answer saved successfully');
        }
      } else {
        debugPrint('Video path is null or empty!');
      }
    } catch (e) {
      debugPrint('Error stopping video recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save recording: $e'),
            backgroundColor: AppColors.negative,
          ),
        );
        setState(() {
          _showVideoRecordingUI = false;
          _isRecordingVideo = false;
        });
      }
    }
  }
}/// Media button widget (Audio/Video)
class _MediaButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _MediaButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  colors: [
                    const Color(0xFF2A2A2A), 
                    const Color(0xFF404040), 
                    const Color(0xFF2A2A2A),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.centerRight,
                  stops: const [0.0, 0.5, 1.0],
                )
              : null,
          color: isActive 
              ? null
              : AppColors.surface.withOpacity(0.5),
        ),
        child: Center(
          child: Icon(
            icon,
            color: isActive ? AppColors.textPrimary : AppColors.text2,
            size: 26,
          ),
        ),
      ),
    );
  }
}

/// Progress indicator widget for app bar
class _ProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _ProgressIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      width: 200,
      decoration: BoxDecoration(
        color: AppColors.border1,
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: currentStep / totalSteps,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryAccent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
