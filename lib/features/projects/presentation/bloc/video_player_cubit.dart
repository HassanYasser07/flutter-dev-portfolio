import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import 'video_player_state.dart';

/// Cubit managing project demo video playback, VideoPlayerController,
/// and ChewieController lifecycle with strict lazy-loading support.
class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  VideoPlayerCubit() : super(const VideoPlayerState());

  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  /// Initializes both [VideoPlayerController] and [ChewieController]
  /// for the specified [videoAsset].
  /// This should only be triggered after explicit user interaction.
  Future<void> initialize(String videoAsset) async {
    if (videoAsset.isEmpty) {
      emit(state.copyWith(
        status: VideoPlayerStatus.error,
        errorMessage: 'Empty video asset path',
      ));
      return;
    }

    await _disposeControllers();

    emit(state.copyWith(
      status: VideoPlayerStatus.loading,
      errorMessage: null,
    ));

    try {
      _videoPlayerController = VideoPlayerController.asset(videoAsset);
      await _videoPlayerController!.initialize();

      if (isClosed) {
        await _disposeControllers();
        return;
      }

      _videoPlayerController!.addListener(_onControllerError);

      final double aspectRatio = _videoPlayerController!.value.aspectRatio > 0
          ? _videoPlayerController!.value.aspectRatio
          : 16 / 9;

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        aspectRatio: aspectRatio,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      );

      emit(state.copyWith(
        status: VideoPlayerStatus.ready,
        videoPlayerController: () => _videoPlayerController,
        chewieController: () => _chewieController,
      ));
    } catch (e) {
      await _disposeControllers();
      if (!isClosed) {
        emit(state.copyWith(
          status: VideoPlayerStatus.error,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  void _onControllerError() {
    if (_videoPlayerController == null || isClosed) return;

    final value = _videoPlayerController!.value;
    if (value.hasError) {
      emit(state.copyWith(
        status: VideoPlayerStatus.error,
        errorMessage: value.errorDescription ?? 'Video playback error',
      ));
    }
  }

  /// Starts video playback.
  Future<void> play() async {
    if (_videoPlayerController != null &&
        _videoPlayerController!.value.isInitialized) {
      await _videoPlayerController!.play();
    }
  }

  /// Pauses video playback.
  Future<void> pause() async {
    if (_videoPlayerController != null &&
        _videoPlayerController!.value.isInitialized) {
      await _videoPlayerController!.pause();
    }
  }

  /// Toggles between play and pause states.
  Future<void> togglePlay() async {
    if (_videoPlayerController != null &&
        _videoPlayerController!.value.isInitialized) {
      if (_videoPlayerController!.value.isPlaying) {
        await pause();
      } else {
        await play();
      }
    }
  }

  Future<void> _disposeControllers() async {
    _chewieController?.dispose();
    _chewieController = null;

    if (_videoPlayerController != null) {
      _videoPlayerController!.removeListener(_onControllerError);
      await _videoPlayerController!.dispose();
      _videoPlayerController = null;
    }
  }

  @override
  Future<void> close() async {
    await _disposeControllers();
    return super.close();
  }
}
