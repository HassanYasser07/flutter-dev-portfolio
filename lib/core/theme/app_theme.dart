import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';
import '../constants/app_sizes.dart';

@immutable
class AppTheme {
  const AppTheme._();

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        scheme: AppColors.darkScheme,
        textTheme: AppFonts.darkTextTheme(),
        scaffold: AppColors.darkBackground,
        overlay: AppColors.darkSurfaceElevated,
        overlayFg: AppColors.darkTextPrimary,
        overlayMuted: AppColors.darkTextSecondary,
        overlayBorder: AppColors.darkBorder,
        overlayAccent: AppColors.darkAccent,
        overlayError: AppColors.darkError,
        overlayScrim: AppColors.darkScrim,
        overlayOnPrimary: AppColors.darkOnPrimary,
      );

  static ThemeData get light => _build(
        brightness: Brightness.light,
        scheme: AppColors.lightScheme,
        textTheme: AppFonts.lightTextTheme(),
        scaffold: AppColors.lightBackground,
        overlay: AppColors.lightSurface,
        overlayFg: AppColors.lightTextPrimary,
        overlayMuted: AppColors.lightTextSecondary,
        overlayBorder: AppColors.lightBorder,
        overlayAccent: AppColors.lightAccent,
        overlayError: AppColors.lightError,
        overlayScrim: AppColors.lightScrim,
        overlayOnPrimary: AppColors.lightOnPrimary,
      );

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme scheme,
    required TextTheme textTheme,
    required Color scaffold,
    required Color overlay,
    required Color overlayFg,
    required Color overlayMuted,
    required Color overlayBorder,
    required Color overlayAccent,
    required Color overlayError,
    required Color overlayScrim,
    required Color overlayOnPrimary,
  }) {
    final isDark = brightness == Brightness.dark;

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
    );

    WidgetStateProperty<OutlinedBorder?> focusedShape({
      required Color restBorder,
    }) {
      return WidgetStateProperty.resolveWith((states) {
        final focused = states.contains(WidgetState.focused);
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          side: BorderSide(
            color: focused ? overlayAccent : restBorder,
            width: focused ? AppSizes.focusRing : AppSizes.hairline,
          ),
        );
      });
    }

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      canvasColor: scaffold,
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.standard,
      fontFamily: AppFonts.bodyFamily,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      iconTheme: IconThemeData(color: overlayFg, size: 20),
      dividerColor: overlayBorder,
      dividerTheme: DividerThemeData(
        color: overlayBorder,
        space: 1,
        thickness: AppSizes.hairline,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: scaffold.withValues(alpha: 0.92),
        foregroundColor: overlayFg,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        titleTextStyle: textTheme.titleMedium,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(AppSizes.minTapTarget, AppSizes.minTapTarget),
          ),
          maximumSize: const WidgetStatePropertyAll(Size.infinite),
          padding: const WidgetStatePropertyAll(EdgeInsets.all(AppSizes.s8)),
          shape: focusedShape(restBorder: Colors.transparent),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed) ||
                states.contains(WidgetState.focused)) {
              return overlayAccent.withValues(alpha: 0.12);
            }
            return null;
          }),
          foregroundColor: WidgetStatePropertyAll(overlayFg),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(AppSizes.minTapTarget, AppSizes.minTapTarget),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(
                horizontal: AppSizes.s24, vertical: AppSizes.s12),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return overlayFg.withValues(alpha: 0.24);
            }
            return scheme.primary;
          }),
          foregroundColor: WidgetStatePropertyAll(overlayOnPrimary),
          elevation: const WidgetStatePropertyAll(0),
          shape: focusedShape(restBorder: Colors.transparent),
          textStyle: WidgetStatePropertyAll(
            AppFonts.button(AppBreakpoint.desktop)
                .copyWith(color: overlayOnPrimary),
          ),
          overlayColor:
              WidgetStatePropertyAll(overlayOnPrimary.withValues(alpha: 0.08)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(AppSizes.minTapTarget, AppSizes.minTapTarget),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(
                horizontal: AppSizes.s24, vertical: AppSizes.s12),
          ),
          foregroundColor: WidgetStatePropertyAll(overlayFg),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.focused)) {
              return BorderSide(
                  color: overlayAccent, width: AppSizes.focusRing);
            }
            return BorderSide(color: overlayBorder);
          }),
          shape: WidgetStatePropertyAll(buttonShape),
          textStyle:
              WidgetStatePropertyAll(AppFonts.button(AppBreakpoint.desktop)),
          overlayColor:
              WidgetStatePropertyAll(overlayAccent.withValues(alpha: 0.08)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(AppSizes.minTapTarget, AppSizes.minTapTarget),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(
                horizontal: AppSizes.s16, vertical: AppSizes.s8),
          ),
          foregroundColor: WidgetStatePropertyAll(overlayFg),
          shape: focusedShape(restBorder: Colors.transparent),
          textStyle:
              WidgetStatePropertyAll(AppFonts.button(AppBreakpoint.desktop)),
          overlayColor:
              WidgetStatePropertyAll(overlayAccent.withValues(alpha: 0.08)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: overlay,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s16,
          vertical: AppSizes.s16,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: overlayMuted),
        labelStyle: textTheme.bodyMedium?.copyWith(color: overlayMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(color: overlayBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(color: overlayBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide:
              BorderSide(color: overlayAccent, width: AppSizes.focusRing),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(color: overlayError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide:
              BorderSide(color: overlayError, width: AppSizes.focusRing),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        waitDuration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s12,
          vertical: AppSizes.s8,
        ),
        decoration: BoxDecoration(
          color: overlayFg,
          borderRadius: BorderRadius.circular(AppSizes.radiusXs),
        ),
        textStyle: AppFonts.bodySmall(AppBreakpoint.desktop).copyWith(
          color: scaffold,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: overlay,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          side: BorderSide(color: overlayBorder),
        ),
        textStyle: textTheme.bodyMedium,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: overlay,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: overlay,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          side: BorderSide(color: overlayBorder),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: overlayFg,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: scaffold),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(overlayMuted.withValues(alpha: 0.5)),
        thickness: const WidgetStatePropertyAll(6),
        radius: const Radius.circular(AppSizes.radiusPill),
      ),
      cardTheme: CardThemeData(
        color: overlay,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          side: BorderSide(color: overlayBorder),
        ),
      ),
      focusColor: overlayAccent.withValues(alpha: 0.18),
      hoverColor: overlayAccent.withValues(alpha: 0.08),
      highlightColor: overlayAccent.withValues(alpha: 0.12),
    );
  }
}
