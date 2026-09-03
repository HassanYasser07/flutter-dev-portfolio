import 'package:flutter/material.dart';

/// Spacing, radius, layout, and breakpoint tokens.
///
/// Spacing scale (only these values): 4, 8, 12, 16, 24, 32, 48, 64, 80, 96, 128.
@immutable
class AppSizes {
  const AppSizes._();

  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s48 = 48;
  static const double s64 = 64;
  static const double s80 = 80;
  static const double s96 = 96;
  static const double s128 = 128;

  // Radii — nest concentrically: outer = inner + padding.
  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusPill = 999;

  // Layout
  static const double navHeight = 72;
  static const double navHeightCompact = 64;
  static const double maxContentWidth = 1120;
  static const double maxWideWidth = 1280;
  static const double maxNarrowWidth = 720;
  static const double minTapTarget = 44;

  // Hairline
  static const double hairline = 1;
  static const double focusRing = 2;
}

/// Viewport breakpoints. Always resolve via [LayoutBuilder], never raw MediaQuery.
@immutable
class Breakpoints {
  const Breakpoints._();

  /// Mobile < 600
  static const double mobile = 600;

  /// Tablet 600–1024
  static const double tablet = 1024;

  /// Desktop / laptop ≥ 1024; wide desktop ≥ 1280
  static const double desktop = 1280;
}

enum AppBreakpoint { mobile, tablet, laptop, desktop }

/// Shared motion tokens. Pair with [shouldAnimate].
@immutable
class AppMotion {
  const AppMotion._();

  static const Duration micro = Duration(milliseconds: 80);
  static const Duration quick = Duration(milliseconds: 180);
  static const Duration hover = Duration(milliseconds: 220);
  static const Duration fast = Duration(milliseconds: 280);
  static const Duration navIndicator = Duration(milliseconds: 280);
  static const Duration route = Duration(milliseconds: 320);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration section = Duration(milliseconds: 480);
  static const Duration hero = Duration(milliseconds: 620);

  static const Curve easeOut = Curves.easeOut;
  static const Curve easeOutCubic = Curves.easeOutCubic;
  static const Curve easeInOut = Curves.easeInOut;
}
