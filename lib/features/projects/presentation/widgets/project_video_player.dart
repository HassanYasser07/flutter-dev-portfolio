import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/responsive.dart';
import '../bloc/video_player_cubit.dart';
import '../bloc/video_player_state.dart';

/// Performance-optimized Project Video Player widget powered by Chewie.
///
/// **Lazy Loading Guarantee**: Does NOT allocate or initialize [VideoPlayerController]
/// or [ChewieController] until the user explicitly taps the play button.
class ProjectVideoPlayer extends StatelessWidget {
  const ProjectVideoPlayer({
    super.key,
    required this.videoAsset,
    required this.posterAsset,
    this.height = 400,
  });

  final String videoAsset;
  final String posterAsset;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (videoAsset.isEmpty) {
      return const SizedBox.shrink();
    }

    return BlocProvider(
      create: (_) => VideoPlayerCubit(),
      child: _ProjectVideoPlayerContent(
        videoAsset: videoAsset,
        posterAsset: posterAsset,
        height: height,
      ),
    );
  }
}

class _ProjectVideoPlayerContent extends StatelessWidget {
  const _ProjectVideoPlayerContent({
    required this.videoAsset,
    required this.posterAsset,
    required this.height,
  });

  final String videoAsset;
  final String posterAsset;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bp = breakpointOf(
        BoxConstraints(maxWidth: MediaQuery.of(context).size.width));

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: scheme.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
        builder: (context, state) {
          final cubit = context.read<VideoPlayerCubit>();

          // 1. Initial State (Poster + Play Button; ZERO controller allocation)
          if (state.status == VideoPlayerStatus.initial) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  posterAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: scheme.surfaceContainerHighest,
                      child: Center(
                        child: Icon(
                          Icons.movie_outlined,
                          size: 48,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  color: Colors.black.withValues(alpha: 0.35),
                ),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.s24,
                        vertical: AppSizes.s16,
                      ),
                      backgroundColor: scheme.primary,
                      foregroundColor: scheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusPill),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow, size: 28),
                    label: Text(
                      'Play Demo Video',
                      style: AppFonts.button(bp),
                    ),
                    onPressed: () => cubit.initialize(videoAsset),
                  ),
                ),
              ],
            );
          }

          // 2. Loading State (Initializing Video & Chewie Controllers)
          if (state.status == VideoPlayerStatus.loading) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  posterAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: scheme.surfaceContainerHighest),
                ),
                Container(color: Colors.black.withValues(alpha: 0.5)),
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: AppSizes.s16),
                      Text(
                        'Loading Demo Video...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          // 3. Error State
          if (state.status == VideoPlayerStatus.error) {
            return Container(
              color: scheme.surfaceContainerHighest,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.s24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: scheme.error,
                      ),
                      const SizedBox(height: AppSizes.s12),
                      Text(
                        'Unable to load video stream',
                        style: AppFonts.title(bp).copyWith(color: scheme.error),
                      ),
                      const SizedBox(height: AppSizes.s8),
                      Text(
                        state.errorMessage ?? 'Video asset path not found',
                        style: AppFonts.bodySmall(bp).copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.s16),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        onPressed: () => cubit.initialize(videoAsset),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // 4. Ready State -> Chewie Video Player with built-in controls
          final chewieController = state.chewieController;
          if (chewieController != null) {
            return Center(
              child: Chewie(
                controller: chewieController,
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
