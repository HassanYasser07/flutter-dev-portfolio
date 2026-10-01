import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_texts.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_icon_button.dart';
import '../../../../core/widgets/theme_toggle.dart';
import '../bloc/scroll_cubit.dart';
import '../bloc/scroll_state.dart';

class _NavDestination {
  const _NavDestination({
    required this.label,
    required this.section,
    this.routeName,
  });

  final String label;
  final HomeSection section;
  final String? routeName;
}

const _destinations = <_NavDestination>[
  _NavDestination(label: AppTexts.navAbout, section: HomeSection.about),
  _NavDestination(label: AppTexts.navSkills, section: HomeSection.skills),
  _NavDestination(
    label: AppTexts.navProjects,
    section: HomeSection.projects,
    routeName: AppRoutes.projects,
  ),
  _NavDestination(
    label: AppTexts.navExperience,
    section: HomeSection.experience,
  ),
  _NavDestination(
    label: AppTexts.navContact,
    section: HomeSection.contact,
    routeName: AppRoutes.contact,
  ),
];

void _navigateHomeSection(BuildContext context, _NavDestination destination) {
  final anchors = HomeAnchorScope.maybeOf(context);
  if (anchors != null) {
    context.read<ScrollCubit>().setActive(destination.section);
    anchors.scrollTo(destination.section);
    return;
  }
  context.goNamed(AppRoutes.home);
}

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.compact,
    this.onLogoPressed,
  });

  final bool compact;
  final VoidCallback? onLogoPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: scheme.outline)),
        ),
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: compact ? AppSizes.navHeightCompact : AppSizes.navHeight,
            child: AppContainerInner(
              child: Row(
                children: [
                  _BrandMark(onPressed: onLogoPressed),
                  const Spacer(),
                  if (!compact) const _DesktopLinks(),
                  const ThemeToggle(),
                  if (compact)
                    AppIconButton(
                      icon: Icons.menu,
                      tooltip: AppTexts.navMenu,
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppContainerInner extends StatelessWidget {
  const AppContainerInner({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final hPad = horizontalPaddingOf(constraints);
        return Align(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSizes.maxWideWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bp = breakpointOf(constraints);

        return InkWell(
          onTap: () {
            onPressed?.call();
            context.goNamed(AppRoutes.home);
          },
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s8,
              vertical: AppSizes.s4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '<  HY  / >',
                  style: AppFonts.title(bp).copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DesktopLinks extends StatelessWidget {
  const _DesktopLinks();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScrollCubit, ScrollState>(
      builder: (context, state) {
        final location = GoRouterState.of(context).matchedLocation;
        return Row(
          children: [
            for (final destination in _destinations)
              _NavLink(
                destination: destination,
                selected: _isSelected(destination, state.active, location),
              ),
          ],
        );
      },
    );
  }
}

bool _isSelected(
    _NavDestination destination, HomeSection active, String location) {
  if (destination.routeName == AppRoutes.projects) {
    return location.startsWith('/project');
  }
  if (destination.routeName == AppRoutes.contact) {
    return location == '/contact';
  }
  if (location == '/') {
    return active == destination.section;
  }
  return false;
}

class _NavLink extends StatefulWidget {
  const _NavLink({
    required this.destination,
    required this.selected,
  });

  final _NavDestination destination;
  final bool selected;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final animate = shouldAnimate(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bp = breakpointOf(constraints);
        final color = widget.selected || _hovered
            ? scheme.onSurface
            : scheme.onSurfaceVariant;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.s4),
          child: MouseRegion(
            onEnter: canHover ? (_) => setState(() => _hovered = true) : null,
            onExit: canHover ? (_) => setState(() => _hovered = false) : null,
            child: TextButton(
              onPressed: () =>
                  _navigateHomeSection(context, widget.destination),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.destination.label,
                    style: AppFonts.nav(bp).copyWith(
                      color: color,
                      fontWeight:
                          widget.selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppSizes.s4),
                  AnimatedContainer(
                    duration: animate ? AppMotion.navIndicator : Duration.zero,
                    curve: AppMotion.easeOutCubic,
                    height: 2,
                    width: widget.selected ? 22 : 0,
                    color: scheme.secondary,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s16,
            vertical: AppSizes.s24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '< HY / >',
                      style: AppFonts.title(AppBreakpoint.mobile).copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  AppIconButton(
                    icon: Icons.close,
                    tooltip: AppTexts.navCloseMenu,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.s32),
              BlocBuilder<ScrollCubit, ScrollState>(
                builder: (context, state) {
                  final location = GoRouterState.of(context).matchedLocation;
                  return Column(
                    children: [
                      for (final destination in _destinations)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(destination.label),
                          selected:
                              _isSelected(destination, state.active, location),
                          selectedColor: scheme.secondary,
                          onTap: () {
                            Navigator.of(context).pop();
                            _navigateHomeSection(context, destination);
                          },
                        ),
                    ],
                  );
                },
              ),
              const Spacer(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.description_outlined),
                title: Text(AppTexts.navCv),
                onTap: () {
                  Navigator.of(context).pop();
                  context.goNamed(AppRoutes.cv);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
