import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import 'video_player_state.dart';

/// Cubit managing project demo video playback and controller lifecycle.
class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  VideoPlayerCubit() : super(const VideoPlayerState());

  VideoPlayerController? _controller;

  /// Initializes a [VideoPlayerController] for the specified [videoAsset].
  /// Autoplay is strictly disabled by default.
  Future<void> initialize(String videoAsset) async {
    if (videoAsset.isEmpty) {
      emit(state.copyWith(
        status: VideoPlayerStatus.error,
        errorMessage: 'Empty video asset path',
      ));
      return;
    }

    await _disposeController();

    emit(state.copyWith(
      status: VideoPlayerStatus.loading,
      errorMessage: null,
    ));

    try {
      _controller = VideoPlayerController.asset(videoAsset);
      await _controller!.initialize();

      _controller!.addListener(_onControllerUpdated);

      emit(state.copyWith(
        status: VideoPlayerStatus.ready,
        controller: () => _controller,
        isPlaying: false,
        duration: _controller!.value.duration,
        position: Duration.zero,
      ));
    } catch (e) {
      await _disposeController();
      emit(state.copyWith(
        status: VideoPlayerStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onControllerUpdated() {
    if (_controller == null || isClosed) return;

    final value = _controller!.value;
    if (value.hasError) {
      emit(state.copyWith(
        status: VideoPlayerStatus.error,
        errorMessage: value.errorDescription ?? 'Video playback error',
      ));
      return;
    }

    emit(state.copyWith(
      status: value.isPlaying
          ? VideoPlayerStatus.playing
          : VideoPlayerStatus.paused,
      isPlaying: value.isPlaying,
      position: value.position,
      duration: value.duration,
    ));
  }

  /// Starts video playback.
  Future<void> play() async {
    if (_controller != null && _controller!.value.isInitialized) {
      await _controller!.play();
    }
  }

  /// Pauses video playback.
  Future<void> pause() async {
    if (_controller != null && _controller!.value.isInitialized) {
      await _controller!.pause();
    }
  }

  /// Toggles between play and pause states.
  Future<void> togglePlay() async {
    if (_controller != null && _controller!.value.isInitialized) {
      if (_controller!.value.isPlaying) {
        await pause();
      } else {
        await play();
      }
    }
  }

  Future<void> _disposeController() async {
    if (_controller != null) {
      _controller!.removeListener(_onControllerUpdated);
      await _controller!.dispose();
      _controller = null;
    }
  }

  @override
  Future<void> close() async {
    await _disposeController();
    return super.close();
  }
}
