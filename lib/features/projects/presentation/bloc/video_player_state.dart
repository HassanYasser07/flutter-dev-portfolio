import 'package:chewie/chewie.dart';
import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';

enum VideoPlayerStatus { initial, loading, ready, error }

class VideoPlayerState extends Equatable {
  const VideoPlayerState({
    this.status = VideoPlayerStatus.initial,
    this.videoPlayerController,
    this.chewieController,
    this.errorMessage,
  });

  final VideoPlayerStatus status;
  final VideoPlayerController? videoPlayerController;
  final ChewieController? chewieController;
  final String? errorMessage;

  /// Backward compatibility getter
  VideoPlayerController? get controller => videoPlayerController;

  VideoPlayerState copyWith({
    VideoPlayerStatus? status,
    VideoPlayerController? Function()? videoPlayerController,
    ChewieController? Function()? chewieController,
    String? errorMessage,
  }) {
    return VideoPlayerState(
      status: status ?? this.status,
      videoPlayerController: videoPlayerController != null
          ? videoPlayerController()
          : this.videoPlayerController,
      chewieController:
          chewieController != null ? chewieController() : this.chewieController,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        videoPlayerController,
        chewieController,
        errorMessage,
      ];
}
