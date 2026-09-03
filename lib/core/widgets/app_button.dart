import 'package:flutter/material.dart';

import '../constants/app_fonts.dart';
import '../constants/app_sizes.dart';
import '../utils/responsive.dart';

enum AppButtonVariant { primary, secondary, ghost }

enum AppButtonSize { sm, md, lg }

/// Accessible button used across the shell. Built on Material button
/// primitives — never a bare GestureDetector.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.icon,
    this.expanded = false,
    this.tooltip,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool expanded;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bp = breakpointOf(constraints);
        final padding = switch (size) {
          AppButtonSize.sm => const EdgeInsets.symmetric(
              horizontal: AppSizes.s16,
              vertical: AppSizes.s8,
            ),
          AppButtonSize.md => const EdgeInsets.symmetric(
              horizontal: AppSizes.s24,
              vertical: AppSizes.s12,
            ),
          AppButtonSize.lg => const EdgeInsets.symmetric(
              horizontal: AppSizes.s32,
              vertical: AppSizes.s16,
            ),
        };

        final child = Row(
          mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: AppSizes.s8),
            ],
            Flexible(
              child: Text(
                label,
                style: AppFonts.button(bp),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );

        final Widget button = switch (variant) {
          AppButtonVariant.primary => ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(padding: padding),
              child: child,
            ),
          AppButtonVariant.secondary => OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(padding: padding),
              child: child,
            ),
          AppButtonVariant.ghost => TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(padding: padding),
              child: child,
            ),
        };

        final sized =
            expanded ? SizedBox(width: double.infinity, child: button) : button;

        if (tooltip == null) return sized;
        return Tooltip(message: tooltip!, child: sized);
      },
    );
  }
}
