import 'package:flutter/material.dart';

import 'app_sizes.dart';

/// Typography tokens built from local families only.
///
/// - Display: SpaceGrotesk (weights 400 / 500 / 700)
/// - Body: Inter (weights 400 / 500 / 600 / 700)
/// - Label / mono: JetBrainsMono (weights 400 / 500)
///
/// Never reference a weight that is not declared in `pubspec.yaml`.
@immutable
class AppFonts {
  const AppFonts._();

  static const String displayFamily = 'SpaceGrotesk';
  static const String bodyFamily = 'Inter';
  static const String monoFamily = 'JetBrainsMono';

  static double _scale(
      AppBreakpoint bp, double mobile, double tablet, double desktop) {
    return switch (bp) {
      AppBreakpoint.mobile => mobile,
      AppBreakpoint.tablet => tablet,
      AppBreakpoint.laptop || AppBreakpoint.desktop => desktop,
    };
  }

  static TextStyle displayHero(AppBreakpoint bp) => TextStyle(
        fontFamily: displayFamily,
        fontWeight: FontWeight.w500,
        fontSize: _scale(bp, 40, 56, 80),
        height: 1.05,
        letterSpacing: -1.6,
      );

  static TextStyle displaySection(AppBreakpoint bp) => TextStyle(
        fontFamily: displayFamily,
        fontWeight: FontWeight.w500,
        fontSize: _scale(bp, 28, 36, 44),
        height: 1.15,
        letterSpacing: -0.8,
      );

  static TextStyle heading(AppBreakpoint bp) => TextStyle(
        fontFamily: displayFamily,
        fontWeight: FontWeight.w500,
        fontSize: _scale(bp, 22, 24, 28),
        height: 1.25,
        letterSpacing: -0.4,
      );

  static TextStyle title(AppBreakpoint bp) => TextStyle(
        fontFamily: displayFamily,
        fontWeight: FontWeight.w500,
        fontSize: _scale(bp, 18, 18, 20),
        height: 1.3,
        letterSpacing: -0.2,
      );

  static TextStyle body(AppBreakpoint bp) => TextStyle(
        fontFamily: bodyFamily,
        fontWeight: FontWeight.w400,
        fontSize: _scale(bp, 15, 16, 16),
        height: 1.6,
        letterSpacing: 0,
      );

  static TextStyle bodySmall(AppBreakpoint bp) => TextStyle(
        fontFamily: bodyFamily,
        fontWeight: FontWeight.w400,
        fontSize: _scale(bp, 13, 14, 14),
        height: 1.55,
      );

  static TextStyle label(AppBreakpoint bp) => TextStyle(
        fontFamily: monoFamily,
        fontWeight: FontWeight.w500,
        fontSize: _scale(bp, 11, 12, 12),
        height: 1.4,
        letterSpacing: 0.8,
      );

  static TextStyle button(AppBreakpoint bp) => TextStyle(
        fontFamily: bodyFamily,
        fontWeight: FontWeight.w600,
        fontSize: _scale(bp, 14, 14, 15),
        height: 1.2,
        letterSpacing: 0.1,
      );

  static TextStyle nav(AppBreakpoint bp) => TextStyle(
        fontFamily: bodyFamily,
        fontWeight: FontWeight.w500,
        fontSize: _scale(bp, 14, 14, 14),
        height: 1.2,
      );

  /// ThemeData.textTheme — sizes are the desktop defaults; widgets should
  /// prefer the breakpoint-aware helpers above.
  static TextTheme textTheme(Color color) {
    return TextTheme(
      displayLarge: displayHero(AppBreakpoint.desktop).copyWith(color: color),
      displayMedium:
          displaySection(AppBreakpoint.desktop).copyWith(color: color),
      headlineMedium: heading(AppBreakpoint.desktop).copyWith(color: color),
      titleLarge: title(AppBreakpoint.desktop).copyWith(color: color),
      titleMedium: title(AppBreakpoint.mobile).copyWith(color: color),
      bodyLarge: body(AppBreakpoint.desktop).copyWith(color: color),
      bodyMedium: body(AppBreakpoint.mobile).copyWith(color: color),
      bodySmall: bodySmall(AppBreakpoint.desktop).copyWith(color: color),
      labelLarge: button(AppBreakpoint.desktop).copyWith(color: color),
      labelMedium: label(AppBreakpoint.desktop).copyWith(color: color),
      labelSmall: label(AppBreakpoint.mobile).copyWith(color: color),
    ).apply(bodyColor: color, displayColor: color, decorationColor: color);
  }

  static TextTheme darkTextTheme() => textTheme(const Color(0xFFF4F2EC));

  static TextTheme lightTextTheme() => textTheme(const Color(0xFF1A1C22));
}
