import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_colors.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_spacing.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_text_styles.dart';
import 'package:video_player/video_player.dart';

/// Video player widget with playback controls
class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  final VoidCallback onDelete;

  const VideoPlayerWidget({
    super.key,
    required this.videoPath,
    required this.onDelete,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initPlayer() async {
    try {
      _controller = VideoPlayerController.file(File(widget.videoPath));
      await _controller!.initialize();
      
      _controller!.addListener(() {
        if (mounted) {
          setState(() {
            _isPlaying = _controller!.value.isPlaying;
          });
        }
      });
      
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing video player: $e');
    }
  }

  Future<void> _togglePlayPause() async {
    if (_controller == null) return;

    try {
      if (_isPlaying) {
        await _controller!.pause();
      } else {
        await _controller!.play();
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
          // Header with title and delete button
          Row(
            children: [
              Icon(Icons.video_file, color: AppColors.primaryAccent, size: 40),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Video Recording',
                      style: AppTextStyles.bodyBBold.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                    if (_isInitialized && _controller != null)
                      Text(
                        _formatDuration(_controller!.value.duration),
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
                  _controller?.pause();
                  widget.onDelete();
                },
              ),
            ],
          ),
          
          SizedBox(height: AppSpacing.md),
          
          // Video preview
          if (_isInitialized && _controller != null)
            AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_controller!),
                  
                  // Play/pause overlay
                  if (!_isPlaying)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.play_circle_outline,
                          color: AppColors.text1,
                          size: 64,
                        ),
                        onPressed: _togglePlayPause,
                      ),
                    ),
                  
                  // Pause button when playing
                  if (_isPlaying)
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: _togglePlayPause,
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                ],
              ),
            )
          else
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.base,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
                ),
              ),
            ),
          
          if (_isInitialized && _controller != null) ...[
            SizedBox(height: AppSpacing.sm),
            
            // Progress bar
            VideoProgressIndicator(
              _controller!,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: AppColors.primaryAccent,
                bufferedColor: AppColors.border1,
                backgroundColor: AppColors.base,
              ),
            ),
            
            SizedBox(height: AppSpacing.xs),
            
            // Time display and controls
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: AppColors.primaryAccent,
                  ),
                  onPressed: _togglePlayPause,
                ),
                
                SizedBox(width: AppSpacing.sm),
                
                ValueListenableBuilder(
                  valueListenable: _controller!,
                  builder: (context, VideoPlayerValue value, child) {
                    return Text(
                      '${_formatDuration(value.position)} / ${_formatDuration(value.duration)}',
                      style: AppTextStyles.bodyR2Regular.copyWith(
                        color: AppColors.text2,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
