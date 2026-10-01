import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_texts.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../contact/data/contact_repository.dart';
import '../../../cv/presentation/bloc/cv_cubit.dart';
import '../../../cv/presentation/bloc/cv_state.dart';
import '../bloc/about_cubit.dart';
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
          AppTexts.heroKicker.toUpperCase(),
          style: AppFonts.label(bp).copyWith(color: scheme.secondary),
        ),
        const SizedBox(height: AppSizes.s12),
        Semantics(
          header: true,
          child: Text(
            AppTexts.heroName,
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
            AppTexts.heroSubtitle,
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
              AppTexts.heroAvailability,
              style: AppFonts.bodySmall(bp).copyWith(color: scheme.secondary),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.s32),
        _HeroActions(compact: compact),
        const SizedBox(height: AppSizes.s32),
        _HeroContactInfoRow(bp: bp),
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
      AppTexts.appRole,
      AppTexts.experienceLogofyRole,
      AppTexts.experienceEdutechRole,
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
        key: const ValueKey('hero-animated-roles'),
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
    final about = context.watch<AboutCubit>().state.about;
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
              label: AppTexts.heroCtaProjects,
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
              label: AppTexts.heroCtaContact,
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
              label: AppTexts.cvView,
              variant: AppButtonVariant.ghost,
              icon: Icons.open_in_new,
              tooltip: AppTexts.cvView,
              expanded: compact,
              onPressed: () =>
                  context.read<CvCubit>().openCvInNewTab(about?.cvUrl),
            ),
          ),
          SizedBox(
            width: compact ? double.infinity : null,
            child: AppButton(
              label: AppTexts.cvDownload,
              variant: AppButtonVariant.ghost,
              icon: Icons.download,
              tooltip: AppTexts.cvDownload,
              expanded: compact,
              onPressed: () => context.read<CvCubit>().downloadCv(about?.cvUrl),
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
      AppBreakpoint.mobile => 170.0,
      AppBreakpoint.tablet => 210.0,
      AppBreakpoint.laptop => 240.0,
      AppBreakpoint.desktop => 270.0,
    };

    return Semantics(
      image: true,
      label: AppTexts.heroName,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: scheme.surface,
          border: Border.all(
            color: scheme.outline,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.1),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: scheme.primary.withValues(alpha: 0.08),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppSizes.s8),
        child: ClipOval(
          child: Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: [
              Transform.translate(
                offset: const Offset(6.0, 0.0),
                child: Image.asset(
                  'assets/images/profile.png',
                  fit: BoxFit.cover,
                  // alignment.y: -1.0 = top of image, 0.0 = center, +1.0 = bottom
                  alignment: const Alignment(0.0, -0.75),
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text(
                        AppTexts.heroMonogram,
                        style: AppFonts.displayHero(bp).copyWith(
                          color: scheme.onSurface,
                          fontSize: size * 0.28,
                          height: 1,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: scheme.outline.withValues(alpha: 0.3),
                    width: 1,
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

    final fullTitle = AppTexts.heroTitle;
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

class _HeroContactInfoRow extends StatelessWidget {
  const _HeroContactInfoRow({
    required this.bp,
  });

  final AppBreakpoint bp;
  static const repository = ContactRepository();

  Future<void> _launchUrlString(String urlString,
      {bool isEmail = false}) async {
    final uri =
        isEmail ? Uri.parse('mailto:$urlString') : Uri.tryParse(urlString);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: isEmail
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.s24,
      runSpacing: AppSizes.s12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _HeroContactItem(
          svgPath: 'assets/svgs/location.svg',
          label: 'Alexandria, Egypt',
          bp: bp,
        ),
        _HeroContactItem(
          svgPath: 'assets/svgs/linkedin.svg',
          label: AppTexts.contactLinkedin,
          bp: bp,
          onTap: () => _launchUrlString(repository.linkedinUrl),
        ),
        _HeroContactItem(
          svgPath: 'assets/svgs/github (1).svg',
          label: AppTexts.contactGithub,
          bp: bp,
          onTap: () => _launchUrlString(repository.githubUrl),
        ),
        _HeroContactItem(
          svgPath: 'assets/svgs/envelope.svg',
          label: AppTexts.contactEmail,
          bp: bp,
          onTap: () => _launchUrlString(repository.email, isEmail: true),
        ),
      ],
    );
  }
}

class _HeroContactItem extends StatefulWidget {
  const _HeroContactItem({
    required this.svgPath,
    required this.label,
    required this.bp,
    this.onTap,
  });

  final String svgPath;
  final String label;
  final AppBreakpoint bp;
  final VoidCallback? onTap;

  @override
  State<_HeroContactItem> createState() => _HeroContactItemState();
}

class _HeroContactItemState extends State<_HeroContactItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final compact = widget.bp == AppBreakpoint.mobile;
    final isClickable = widget.onTap != null;

    final defaultColor = scheme.onSurfaceVariant;
    final hoverColor = scheme.secondary;

    final targetColor = (isClickable && _isHovered) ? hoverColor : defaultColor;

    final child = TweenAnimationBuilder<Color?>(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      tween: ColorTween(end: targetColor),
      builder: (context, color, _) {
        final currentColor = color ?? defaultColor;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              widget.svgPath,
              width: compact ? 16 : 18,
              height: compact ? 16 : 18,
              colorFilter: ColorFilter.mode(
                currentColor,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: AppSizes.s8),
            Text(
              widget.label,
              style: AppFonts.bodySmall(widget.bp).copyWith(
                color: currentColor,
                fontWeight: (isClickable && _isHovered)
                    ? FontWeight.w600
                    : FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );

    if (!isClickable) {
      return child;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: child,
      ),
    );
  }
}
