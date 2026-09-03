import 'package:flutter/material.dart';

import '../constants/app_fonts.dart';
import '../constants/app_sizes.dart';
import '../utils/responsive.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bp = breakpointOf(constraints);
        final compact = bp == AppBreakpoint.mobile;

        final titles = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eyebrow.toUpperCase(),
              style: AppFonts.label(bp).copyWith(color: scheme.secondary),
            ),
            const SizedBox(height: AppSizes.s8),
            Semantics(
              header: true,
              child: Text(
                title,
                style: AppFonts.displaySection(bp)
                    .copyWith(color: scheme.onSurface),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSizes.s16),
              ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: AppSizes.maxNarrowWidth),
                child: Text(
                  subtitle!,
                  style: AppFonts.body(bp)
                      .copyWith(color: scheme.onSurfaceVariant),
                ),
              ),
            ],
          ],
        );

        if (trailing == null || compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titles,
              if (trailing != null) ...[
                const SizedBox(height: AppSizes.s24),
                trailing!,
              ],
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: titles),
            const SizedBox(width: AppSizes.s24),
            trailing!,
          ],
        );
      },
    );
  }
}
