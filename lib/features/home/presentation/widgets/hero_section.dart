import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/locale_keys.g.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../cv/presentation/bloc/cv_cubit.dart';
import '../../../cv/presentation/bloc/cv_state.dart';
import '../bloc/scroll_cubit.dart';
import '../bloc/scroll_state.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bp = breakpointOf(constraints);
        final stacked =
            bp == AppBreakpoint.mobile || bp == AppBreakpoint.tablet;
        final hPad = horizontalPaddingOf(constraints);
        final vertical = switch (bp) {
          AppBreakpoint.mobile => AppSizes.s64,
          AppBreakpoint.tablet => AppSizes.s80,
          AppBreakpoint.laptop || AppBreakpoint.desktop => AppSizes.s96,
        };

        final copy = _HeroCopy(bp: bp);
        final portrait = _HeroMonogram(bp: bp);

        return Align(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSizes.maxWideWidth),
            child: Padding(
              padding: EdgeInsets.fromLTRB(hPad, vertical, hPad, vertical),
              child: stacked
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        copy,
                        const SizedBox(height: AppSizes.s48),
                        Center(child: portrait),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 6, child: copy),
                        const SizedBox(width: AppSizes.s64),
                        Expanded(flex: 4, child: Center(child: portrait)),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.bp});

  final AppBreakpoint bp;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final compact = bp == AppBreakpoint.mobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.hero_kicker.tr().toUpperCase(),
          style: AppFonts.label(bp).copyWith(color: scheme.secondary),
        ),
        const SizedBox(height: AppSizes.s12),
        Semantics(
          header: true,
          child: Text(
            LocaleKeys.hero_name.tr(),
            style: AppFonts.displayHero(bp).copyWith(color: scheme.onSurface),
          ),
        ),
        const SizedBox(height: AppSizes.s8),
        _HeroAnimatedRole(bp: bp),
        const SizedBox(height: AppSizes.s16),
        _HeroTitleWithAnimatedFlutter(bp: bp),
        const SizedBox(height: AppSizes.s16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            LocaleKeys.hero_subtitle.tr(),
            style: AppFonts.body(bp).copyWith(color: scheme.onSurfaceVariant),
          ),
        ),
        const SizedBox(height: AppSizes.s16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: scheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSizes.s8),
            Text(
              LocaleKeys.hero_availability.tr(),
              style: AppFonts.bodySmall(bp).copyWith(color: scheme.secondary),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.s32),
        _HeroActions(compact: compact),
      ],
    );
  }
}

class _HeroAnimatedRole extends StatelessWidget {
  const _HeroAnimatedRole({required this.bp});

  final AppBreakpoint bp;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textStyle = AppFonts.label(bp).copyWith(
      color: scheme.secondary,
      fontWeight: FontWeight.w600,
    );

    final roles = [
      LocaleKeys.app_role.tr(),
      LocaleKeys.experience_items_logofy_role.tr(),
      LocaleKeys.experience_items_edutech_role.tr(),
    ];

    if (!shouldAnimate(context)) {
      return Text(
        roles.first,
        style: textStyle,
      );
    }

    return SizedBox(
      height: 32,
      child: AnimatedTextKit(
        key: ValueKey('hero-animated-roles-${context.locale.languageCode}'),
        repeatForever: true,
        pause: const Duration(milliseconds: 1500),
        displayFullTextOnTap: true,
        animatedTexts: roles.map((role) {
          return TypewriterAnimatedText(
            role,
            textStyle: textStyle,
            speed: const Duration(milliseconds: 80),
          );
        }).toList(),
      ),
    );
  }
}

class _HeroActions extends StatelessWidget {
  const _HeroActions({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CvCubit, CvState>(
      listener: (context, state) {
        if (state.status == CvStatus.error && state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message!)),
          );
        }
      },
      child: Wrap(
        spacing: AppSizes.s12,
        runSpacing: AppSizes.s12,
        children: [
          SizedBox(
            width: compact ? double.infinity : null,
            child: AppButton(
              label: LocaleKeys.hero_ctaProjects.tr(),
              expanded: compact,
              onPressed: () {
                final anchors = HomeAnchorScope.maybeOf(context);
                if (anchors != null) {
                  context.read<ScrollCubit>().setActive(HomeSection.projects);
                  anchors.scrollTo(HomeSection.projects);
                } else {
                  context.goNamed(AppRoutes.projects);
                }
              },
            ),
          ),
          SizedBox(
            width: compact ? double.infinity : null,
            child: AppButton(
              label: LocaleKeys.hero_ctaContact.tr(),
              variant: AppButtonVariant.secondary,
              expanded: compact,
              onPressed: () {
                final anchors = HomeAnchorScope.maybeOf(context);
                if (anchors != null) {
                  context.read<ScrollCubit>().setActive(HomeSection.contact);
                  anchors.scrollTo(HomeSection.contact);
                } else {
                  context.goNamed(AppRoutes.contact);
                }
              },
            ),
          ),
          SizedBox(
            width: compact ? double.infinity : null,
            child: AppButton(
              label: LocaleKeys.cv_view.tr(),
              variant: AppButtonVariant.ghost,
              icon: Icons.open_in_new,
              tooltip: LocaleKeys.cv_view.tr(),
              expanded: compact,
              onPressed: () => context.read<CvCubit>().openCvInNewTab(),
            ),
          ),
          SizedBox(
            width: compact ? double.infinity : null,
            child: AppButton(
              label: LocaleKeys.cv_download.tr(),
              variant: AppButtonVariant.ghost,
              icon: Icons.download,
              tooltip: LocaleKeys.cv_download.tr(),
              expanded: compact,
              onPressed: () => context.read<CvCubit>().downloadCv(),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMonogram extends StatelessWidget {
  const _HeroMonogram({required this.bp});

  final AppBreakpoint bp;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final size = switch (bp) {
      AppBreakpoint.mobile => 220.0,
      AppBreakpoint.tablet => 280.0,
      AppBreakpoint.laptop => 320.0,
      AppBreakpoint.desktop => 360.0,
    };

    return Semantics(
      image: true,
      label: LocaleKeys.hero_name.tr(),
      child: SizedBox(
        width: size,
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusXl),
            border: Border.all(color: scheme.outline),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.s24),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      border: Border.all(color: scheme.outline),
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  LocaleKeys.hero_monogram.tr(),
                  style: AppFonts.displayHero(bp).copyWith(
                    color: scheme.onSurface,
                    fontSize: size * 0.28,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroTitleWithAnimatedFlutter extends StatelessWidget {
  const _HeroTitleWithAnimatedFlutter({required this.bp});

  final AppBreakpoint bp;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final baseStyle = AppFonts.heading(bp).copyWith(
      color: scheme.onSurface,
      fontWeight: FontWeight.w600,
      height: 1.25,
    );

    final fullTitle = LocaleKeys.hero_title.tr();
    const flutterWord = 'Flutter';

    if (!fullTitle.contains(flutterWord)) {
      return Semantics(
        header: true,
        child: Text(fullTitle, style: baseStyle),
      );
    }

    final parts = fullTitle.split(flutterWord);
    final prefix = parts[0];
    final suffix = parts.length > 1 ? parts[1] : '';

    final flutterTextStyle = AppFonts.heading(bp).copyWith(
      fontWeight: FontWeight.w800,
      letterSpacing: 0.5,
    );

    Widget flutterWidget = ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          Color(0xFF00D2FF),
          Color(0xFF3B82F6),
          Color(0xFF8B5CF6),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        flutterWord,
        style: flutterTextStyle.copyWith(color: Colors.white),
      ),
    );

    if (shouldAnimate(context)) {
      flutterWidget = flutterWidget
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .shimmer(
            duration: 2500.ms,
            color: Colors.white.withValues(alpha: 0.6),
          )
          .scale(
            duration: 2000.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.04, 1.04),
            curve: Curves.easeInOut,
          );
    }

    return Semantics(
      header: true,
      label: fullTitle,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.start,
        children: [
          if (prefix.isNotEmpty) Text(prefix, style: baseStyle),
          flutterWidget,
          if (suffix.isNotEmpty) Text(suffix, style: baseStyle),
        ],
      ),
    );
  }
}
