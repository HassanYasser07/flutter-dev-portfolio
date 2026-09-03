import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';

enum VideoPlayerStatus { initial, loading, ready, playing, paused, error }

class VideoPlayerState extends Equatable {
  const VideoPlayerState({
    this.status = VideoPlayerStatus.initial,
    this.controller,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.errorMessage,
  });

  final VideoPlayerStatus status;
  final VideoPlayerController? controller;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final String? errorMessage;

  VideoPlayerState copyWith({
    VideoPlayerStatus? status,
    VideoPlayerController? Function()? controller,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    String? errorMessage,
  }) {
    return VideoPlayerState(
      status: status ?? this.status,
      controller: controller != null ? controller() : this.controller,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isPlaying,
        position,
        duration,
        errorMessage,
      ];
}
