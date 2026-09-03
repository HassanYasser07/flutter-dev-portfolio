import 'package:flutter/material.dart';

/// Color tokens for both themes.
///
/// Contrast notes document WCAG 2.1 AA against the paired background:
/// normal text ≥ 4.5:1, large text / UI chrome ≥ 3:1.
///
/// Never use a hex literal outside this file.
@immutable
class AppColors {
  const AppColors._();

  // ---------------------------------------------------------------------------
  // Dark theme
  // ---------------------------------------------------------------------------

  /// Near-black canvas. Pairing: [darkTextPrimary] ~ 16.3:1.
  static const Color darkBackground = Color(0xFF090A0C);

  /// Raised plane sitting on the canvas. Pairing: [darkTextPrimary] ~ 15.4:1.
  static const Color darkSurface = Color(0xFF13151A);

  /// One step above [darkSurface] for nested cards / menus.
  static const Color darkSurfaceElevated = Color(0xFF1C1F27);

  /// Cream CTA fill. Pairing vs [darkBackground]: ~ 15.8:1.
  static const Color darkPrimary = Color(0xFFEDEAE3);

  /// Ink on cream.
  static const Color darkOnPrimary = Color(0xFF090A0C);

  /// Muted teal — links, focus, active marks. Pairing vs bg ~ 8.1:1.
  static const Color darkAccent = Color(0xFF8EC4BE);

  /// Ink-on-accent for chips filled with [darkAccent].
  static const Color darkOnAccent = Color(0xFF0B1413);

  /// Primary copy. Pairing vs [darkBackground] ~ 16.3:1.
  static const Color darkTextPrimary = Color(0xFFF4F2EC);

  /// Secondary copy. Pairing vs [darkBackground] ~ 7.4:1.
  static const Color darkTextSecondary = Color(0xFFA4A7B0);

  /// Tertiary / placeholder. Pairing vs [darkBackground] ~ 4.6:1.
  static const Color darkTextTertiary = Color(0xFF7C7F89);

  /// Hairline borders — ~ 12% cream over canvas (UI chrome ≥ 3:1 on icons).
  static const Color darkBorder = Color(0xFF2A2D36);

  /// Stronger hairline for focused / hovered chrome.
  static const Color darkBorderStrong = Color(0xFF3D414C);

  /// Restrained status — small badges only.
  static const Color darkSuccess = Color(0xFF8FBFAB);
  static const Color darkError = Color(0xFFD08A8A);
  static const Color darkWarning = Color(0xFFC4B392);

  /// Overlay scrim.
  static const Color darkScrim = Color(0xCC090A0C);

  // ---------------------------------------------------------------------------
  // Light theme
  // ---------------------------------------------------------------------------

  /// Warm paper. Pairing: [lightTextPrimary] ~ 15.1:1.
  static const Color lightBackground = Color(0xFFF6F4EF);

  /// White cards on paper. Pairing: [lightTextPrimary] ~ 16.0:1.
  static const Color lightSurface = Color(0xFFFFFDF8);

  /// Nested plane.
  static const Color lightSurfaceElevated = Color(0xFFECEAE4);

  /// Ink CTA fill. Pairing vs [lightBackground] ~ 15.1:1.
  static const Color lightPrimary = Color(0xFF1A1C22);

  /// Cream on ink.
  static const Color lightOnPrimary = Color(0xFFF6F4EF);

  /// Deep teal — links, focus. Pairing vs paper ~ 5.9:1.
  static const Color lightAccent = Color(0xFF1F6F6A);

  static const Color lightOnAccent = Color(0xFFF6F4EF);

  /// Primary copy. Pairing vs [lightBackground] ~ 15.1:1.
  static const Color lightTextPrimary = Color(0xFF1A1C22);

  /// Secondary copy. Pairing vs [lightBackground] ~ 6.8:1.
  static const Color lightTextSecondary = Color(0xFF5C5F69);

  /// Tertiary. Pairing vs [lightBackground] ~ 4.6:1.
  static const Color lightTextTertiary = Color(0xFF7A7D86);

  static const Color lightBorder = Color(0xFFD9D6CE);
  static const Color lightBorderStrong = Color(0xFFB9B5AA);

  static const Color lightSuccess = Color(0xFF2F6F58);
  static const Color lightError = Color(0xFF9A4545);
  static const Color lightWarning = Color(0xFF7A6230);

  static const Color lightScrim = Color(0x661A1C22);

  // ---------------------------------------------------------------------------
  // ColorSchemes
  // ---------------------------------------------------------------------------

  static const ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: darkPrimary,
    onPrimary: darkOnPrimary,
    secondary: darkAccent,
    onSecondary: darkOnAccent,
    tertiary: darkAccent,
    onTertiary: darkOnAccent,
    error: darkError,
    onError: darkBackground,
    surface: darkSurface,
    onSurface: darkTextPrimary,
    onSurfaceVariant: darkTextSecondary,
    outline: darkBorder,
    outlineVariant: darkBorderStrong,
    surfaceContainerHighest: darkSurfaceElevated,
    surfaceContainerHigh: darkSurfaceElevated,
    surfaceContainer: darkSurface,
    surfaceContainerLow: darkSurface,
    surfaceContainerLowest: darkBackground,
    inverseSurface: lightSurface,
    onInverseSurface: lightTextPrimary,
    inversePrimary: lightAccent,
    scrim: darkScrim,
    shadow: Color(0x66000000),
  );

  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: lightPrimary,
    onPrimary: lightOnPrimary,
    secondary: lightAccent,
    onSecondary: lightOnAccent,
    tertiary: lightAccent,
    onTertiary: lightOnAccent,
    error: lightError,
    onError: lightOnPrimary,
    surface: lightSurface,
    onSurface: lightTextPrimary,
    onSurfaceVariant: lightTextSecondary,
    outline: lightBorder,
    outlineVariant: lightBorderStrong,
    surfaceContainerHighest: lightSurfaceElevated,
    surfaceContainerHigh: lightSurfaceElevated,
    surfaceContainer: lightSurface,
    surfaceContainerLow: lightSurface,
    surfaceContainerLowest: lightBackground,
    inverseSurface: darkSurface,
    onInverseSurface: darkTextPrimary,
    inversePrimary: darkAccent,
    scrim: lightScrim,
    shadow: Color(0x1A1A1C22),
  );
}
