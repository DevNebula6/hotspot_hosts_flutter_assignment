import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_colors.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_spacing.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_text_styles.dart';

/// Audio player widget with playback controls
class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;
  final VoidCallback onDelete;

  const AudioPlayerWidget({
    super.key,
    required this.audioPath,
    required this.onDelete,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initPlayer() async {
    try {
      // Set source
      await _audioPlayer.setSource(DeviceFileSource(widget.audioPath));

      // Listen to duration
      _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          _duration = duration;
        });
      });

      // Listen to position
      _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
        setState(() {
          _position = position;
        });
      });

      // Listen to player state
      _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((state) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
        
        // Reset to beginning when completed
        if (state == PlayerState.completed) {
          _audioPlayer.seek(Duration.zero);
        }
      });
    } catch (e) {
      debugPrint('Error initializing audio player: $e');
    }
  }

  Future<void> _togglePlayPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.resume();
      }
    } catch (e) {
      debugPrint('Error toggling play/pause: $e');
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
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.audio_file, color: AppColors.primaryAccent, size: 40),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Audio Recording',
                      style: AppTextStyles.bodyBBold.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                    if (_duration.inSeconds > 0)
                      Text(
                        _formatDuration(_duration),
                        style: AppTextStyles.bodyR2Regular.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: AppColors.negative),
                onPressed: () {
                  _audioPlayer.stop();
                  widget.onDelete();
                },
              ),
            ],
          ),
          
          SizedBox(height: AppSpacing.sm),
          
          // Progress slider
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              activeTrackColor: AppColors.primaryAccent,
              inactiveTrackColor: AppColors.border1,
              thumbColor: AppColors.primaryAccent,
              overlayColor: AppColors.primaryAccent.withOpacity(0.2),
            ),
            child: Slider(
              value: _position.inSeconds.toDouble(),
              max: _duration.inSeconds > 0 ? _duration.inSeconds.toDouble() : 1.0,
              onChanged: (value) async {
                await _audioPlayer.seek(Duration(seconds: value.toInt()));
              },
            ),
          ),
          
          // Play/pause button and time display
          Row(
            children: [
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause_circle : Icons.play_circle,
                  color: AppColors.primaryAccent,
                  size: 40,
                ),
                onPressed: _togglePlayPause,
              ),
              
              SizedBox(width: AppSpacing.sm),
              
              Text(
                '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
                style: AppTextStyles.bodyR2Regular.copyWith(
                  color: AppColors.text2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
