import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/home/presentation/bloc/about_cubit.dart';
import '../../features/home/presentation/bloc/about_state.dart';
import '../../features/home/presentation/bloc/experience_cubit.dart';
import '../../features/home/presentation/bloc/experience_state.dart';
import '../../features/home/presentation/bloc/skills_cubit.dart';
import '../../features/home/presentation/bloc/skills_state.dart';
import '../../features/projects/presentation/bloc/projects_cubit.dart';
import '../../features/projects/presentation/bloc/projects_state.dart';
import '../constants/app_fonts.dart';
import '../constants/app_sizes.dart';
import '../utils/pre_loader_bridge.dart';

/// Full-screen initial loading overlay widget that appears immediately on startup.
/// Displays a smooth snake-style progress bar and percentage indicator (0% -> 100%)
/// that tracks actual initial application data loading.
class AppInitialLoader extends StatefulWidget {
  const AppInitialLoader({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<AppInitialLoader> createState() => _AppInitialLoaderState();
}

class _AppInitialLoaderState extends State<AppInitialLoader>
    with TickerProviderStateMixin {
  late final AnimationController _progressController;
  late final AnimationController _fadeController;
  late final AnimationController _pulseController;

  double _targetProgress = 0.0;
  double _displayedProgress = 0.0;
  bool _showOverlay = true;
  bool _isComplete = false;
  Timer? _safetyTimer;

  @override
  void initState() {
    super.initState();

    // Seed from the HTML pre-loader's current progress so the Flutter loader
    // picks up seamlessly from where the HTML one left off (no jump).
    final htmlProgress = PreLoaderBridge.getProgress().clamp(0, 100) / 100.0;
    _displayedProgress = htmlProgress;
    _targetProgress = htmlProgress;

    _progressController = AnimationController(
      vsync: this,
      value: htmlProgress,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {
          _displayedProgress = _progressController.value;
          if (_displayedProgress >= 1.0 && !_isComplete) {
            _onLoadingFinished();
          }
        });
      });

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _showOverlay = false;
          });
        }
      });

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    // Remove the HTML pre-loader on the first frame — the Flutter overlay
    // is now rendering on top with the same visual state.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PreLoaderBridge.remove();
      _checkProgress();
    });

    // Safety timeout after 6 seconds to prevent blocking if network hangs
    _safetyTimer = Timer(const Duration(seconds: 6), () {
      if (mounted && !_isComplete) {
        _updateTargetProgress(1.0);
      }
    });
  }

  @override
  void dispose() {
    _safetyTimer?.cancel();
    _progressController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _checkProgress() {
    if (_isComplete) return;

    final aboutState = context.read<AboutCubit>().state;
    final projectsState = context.read<ProjectsCubit>().state;
    final skillsState = context.read<SkillsCubit>().state;
    final experienceState = context.read<ExperienceCubit>().state;

    int completedCount = 0;
    if (aboutState.status == AboutStatus.loaded ||
        aboutState.status == AboutStatus.error) {
      completedCount++;
    }
    if (projectsState.status == ProjectsStatus.loaded ||
        projectsState.status == ProjectsStatus.error) {
      completedCount++;
    }
    if (skillsState.status == SkillsStatus.loaded ||
        skillsState.status == SkillsStatus.error) {
      completedCount++;
    }
    if (experienceState.status == ExperienceStatus.loaded ||
        experienceState.status == ExperienceStatus.error) {
      completedCount++;
    }

    // Map 0..4 completed Cubits to target progress:
    // 0 -> 0.15 (initial boot)
    // 1 -> 0.40
    // 2 -> 0.65
    // 3 -> 0.85
    // 4 -> 1.00
    double target;
    switch (completedCount) {
      case 0:
        target = 0.15;
        break;
      case 1:
        target = 0.40;
        break;
      case 2:
        target = 0.65;
        break;
      case 3:
        target = 0.85;
        break;
      case 4:
      default:
        target = 1.0;
        break;
    }

    _updateTargetProgress(target);
  }

  void _updateTargetProgress(double target) {
    if (target <= _targetProgress) return;
    _targetProgress = target;

    // Smoothly animate towards target progress
    final double current = _displayedProgress;
    final double delta = _targetProgress - current;

    _progressController.stop();
    _progressController.value = current;

    // Duration is proportional to progress delta (min 300ms, max 800ms)
    final int durationMs = (delta * 1200).clamp(300, 800).toInt();
    _progressController.duration = Duration(milliseconds: durationMs);
    _progressController.animateTo(
      _targetProgress,
      curve: Curves.easeOutCubic,
    );
  }

  void _onLoadingFinished() {
    _isComplete = true;
    _safetyTimer?.cancel();

    // Brief delay before fading out loader
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _fadeController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AboutCubit, AboutState>(
          listener: (context, state) => _checkProgress(),
        ),
        BlocListener<ProjectsCubit, ProjectsState>(
          listener: (context, state) => _checkProgress(),
        ),
        BlocListener<SkillsCubit, SkillsState>(
          listener: (context, state) => _checkProgress(),
        ),
        BlocListener<ExperienceCubit, ExperienceState>(
          listener: (context, state) => _checkProgress(),
        ),
      ],
      child: Stack(
        children: [
          // Underlying App Content (Portfolio UI)
          widget.child,

          // Full-screen loading overlay
          if (_showOverlay)
            FadeTransition(
              opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                CurvedAnimation(
                  parent: _fadeController,
                  curve: Curves.easeInOut,
                ),
              ),
              child: _buildLoaderOverlay(context),
            ),
        ],
      ),
    );
  }

  Widget _buildLoaderOverlay(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final percentageInt = (_displayedProgress * 100).clamp(0, 100).toInt();

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          // Background ambient glowing blur effects
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final pulse = _pulseController.value;
              return Stack(
                children: [
                  // Primary color top-left soft glow
                  Positioned(
                    top: -100,
                    left: -100,
                    child: Container(
                      width: 400 + (pulse * 50),
                      height: 400 + (pulse * 50),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            scheme.primary
                                .withValues(alpha: 0.18 + (pulse * 0.05)),
                            scheme.primary.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Secondary color bottom-right soft glow
                  Positioned(
                    bottom: -100,
                    right: -100,
                    child: Container(
                      width: 450 - (pulse * 50),
                      height: 450 - (pulse * 50),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            scheme.secondary
                                .withValues(alpha: 0.15 + (pulse * 0.05)),
                            scheme.secondary.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Center loading content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.s24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Percentage number directly with progress indicator
                    Text(
                      '$percentageInt%',
                      style: TextStyle(
                        fontFamily: AppFonts.displayFamily,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: scheme.primary,
                        letterSpacing: -0.5,
                        shadows: [
                          Shadow(
                            color: scheme.primary.withValues(alpha: 0.35),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.s16),

                    // Horizontal Snake-style progress bar
                    _SnakeProgressBar(
                      progress: _displayedProgress,
                      primaryColor: scheme.primary,
                      secondaryColor: scheme.secondary,
                      pulseAnimation: _pulseController,
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

/// Snake-style progress bar widget.
/// Renders a horizontal bar with glowing snake head and gradient progress fill.
class _SnakeProgressBar extends StatelessWidget {
  const _SnakeProgressBar({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
    required this.pulseAnimation,
  });

  final double progress;
  final Color primaryColor;
  final Color secondaryColor;
  final Animation<double> pulseAnimation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trackColor =
        theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6);
    final borderColor = theme.colorScheme.outline.withValues(alpha: 0.25);

    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(double.infinity, 12),
          painter: _SnakeProgressBarPainter(
            progress: progress.clamp(0.0, 1.0),
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            trackColor: trackColor,
            borderColor: borderColor,
            pulseValue: pulseAnimation.value,
          ),
        );
      },
    );
  }
}

/// Custom painter for rendering the horizontal Snake progress bar.
class _SnakeProgressBarPainter extends CustomPainter {
  _SnakeProgressBarPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
    required this.trackColor,
    required this.borderColor,
    required this.pulseValue,
  });

  final double progress;
  final Color primaryColor;
  final Color secondaryColor;
  final Color trackColor;
  final Color borderColor;
  final double pulseValue;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(size.height / 2);
    final trackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      radius,
    );

    // 1. Paint Background Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(trackRect, trackPaint);

    // Track Border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(trackRect, borderPaint);

    if (progress <= 0.0) return;

    // 2. Paint Progress Fill (Snake Body)
    final fillWidth = size.width * progress;
    final fillRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, fillWidth, size.height),
      radius,
    );

    final fillGradient = LinearGradient(
      colors: [
        primaryColor,
        secondaryColor,
      ],
    );

    final fillPaint = Paint()
      ..shader = fillGradient
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.clipRRect(trackRect);
    canvas.drawRRect(fillRect, fillPaint);

    // 3. Paint Snake Head (Glowing leading edge highlight)
    final headX = fillWidth;
    final headCenter = Offset(headX, size.height / 2);

    // Snake head glow paint
    final headGlowPaint = Paint()
      ..color = secondaryColor.withValues(alpha: 0.8)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4 + (pulseValue * 2));

    canvas.drawCircle(
        headCenter, size.height / 2 + 1 + (pulseValue * 1), headGlowPaint);

    // Snake head core bright spot
    final headCorePaint = Paint()
      ..color = Color.lerp(secondaryColor, Colors.white, 0.7)!
      ..style = PaintingStyle.fill;

    canvas.drawCircle(headCenter, size.height / 3, headCorePaint);
  }

  @override
  bool shouldRepaint(covariant _SnakeProgressBarPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.pulseValue != pulseValue ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.borderColor != borderColor;
  }
}
