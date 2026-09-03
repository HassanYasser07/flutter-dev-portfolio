import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;

import '../constants/app_sizes.dart';

/// Breakpoint helpers. Feature widgets must go through [LayoutBuilder] or
/// [ResponsiveWidget] — never `MediaQuery.of(context).size.width`.
AppBreakpoint breakpointOf(BoxConstraints constraints) {
  final width = constraints.maxWidth;
  if (width < Breakpoints.mobile) return AppBreakpoint.mobile;
  if (width < Breakpoints.tablet) return AppBreakpoint.tablet;
  if (width < Breakpoints.desktop) return AppBreakpoint.laptop;
  return AppBreakpoint.desktop;
}

double horizontalPaddingOf(BoxConstraints constraints) {
  return switch (breakpointOf(constraints)) {
    AppBreakpoint.mobile => AppSizes.s16,
    AppBreakpoint.tablet => AppSizes.s32,
    AppBreakpoint.laptop || AppBreakpoint.desktop => AppSizes.s80,
  };
}

bool isCompact(BoxConstraints constraints) =>
    breakpointOf(constraints) == AppBreakpoint.mobile;

bool isWide(BoxConstraints constraints) =>
    breakpointOf(constraints) == AppBreakpoint.desktop;

/// True when motion should run. Gates every animation site.
bool shouldAnimate(BuildContext context) {
  return !MediaQuery.disableAnimationsOf(context);
}

/// Pointer devices get hover; touch does not.
bool get canHover {
  if (kIsWeb) {
    return defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux;
  }
  return false;
}

/// Page-level breakpoint captured once at the shell, so nested widgets
/// don't mis-read their own tight [LayoutBuilder] constraints.
class BreakpointScope extends InheritedWidget {
  const BreakpointScope({
    super.key,
    required this.breakpoint,
    required this.constraints,
    required super.child,
  });

  final AppBreakpoint breakpoint;
  final BoxConstraints constraints;

  static BreakpointScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BreakpointScope>();
  }

  static BreakpointScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, 'BreakpointScope missing — wrap the shell with it.');
    return scope!;
  }

  @override
  bool updateShouldNotify(BreakpointScope oldWidget) {
    return breakpoint != oldWidget.breakpoint ||
        constraints != oldWidget.constraints;
  }
}

/// Resolves the page breakpoint: [BreakpointScope] if present, otherwise
/// a local [LayoutBuilder].
AppBreakpoint pageBreakpoint(BuildContext context) {
  return BreakpointScope.maybeOf(context)?.breakpoint ?? AppBreakpoint.desktop;
}

/// Picks a widget tree per breakpoint. Tablet falls back to desktop, then mobile.
class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bp = BreakpointScope.maybeOf(context)?.breakpoint ??
            breakpointOf(constraints);
        return switch (bp) {
          AppBreakpoint.mobile => mobile,
          AppBreakpoint.tablet => tablet ?? desktop ?? mobile,
          AppBreakpoint.laptop ||
          AppBreakpoint.desktop =>
            desktop ?? tablet ?? mobile,
        };
      },
    );
  }
}

/// Applies max-width + responsive horizontal padding.
class AppContainer extends StatelessWidget {
  const AppContainer({
    super.key,
    required this.child,
    this.maxWidth = AppSizes.maxContentWidth,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final page =
            BreakpointScope.maybeOf(context)?.constraints ?? constraints;
        final hPad = horizontalPaddingOf(page);
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: padding ?? EdgeInsets.symmetric(horizontal: hPad),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
