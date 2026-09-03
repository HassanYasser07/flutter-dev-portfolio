import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';
import '../utils/responsive.dart';
import 'section_header.dart';

/// Shared vertical section: max-width container, responsive padding,
/// optional header. Used by every home-page block.
class AppSection extends StatelessWidget {
  const AppSection({
    super.key,
    required this.id,
    required this.child,
    this.eyebrow,
    this.title,
    this.subtitle,
    this.trailing,
    this.background,
  });

  final String id;
  final Widget child;
  final String? eyebrow;
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bp = breakpointOf(constraints);
        final vertical = switch (bp) {
          AppBreakpoint.mobile => AppSizes.s64,
          AppBreakpoint.tablet => AppSizes.s80,
          AppBreakpoint.laptop || AppBreakpoint.desktop => AppSizes.s96,
        };
        final hPad = horizontalPaddingOf(constraints);

        return ColoredBox(
          color: background ?? Colors.transparent,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: AppSizes.maxWideWidth),
              child: Padding(
                padding: EdgeInsets.fromLTRB(hPad, vertical, hPad, vertical),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null && eyebrow != null) ...[
                      SectionHeader(
                        eyebrow: eyebrow!,
                        title: title!,
                        subtitle: subtitle,
                        trailing: trailing,
                      ),
                      const SizedBox(height: AppSizes.s48),
                    ],
                    child,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
