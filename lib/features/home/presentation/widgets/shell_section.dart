import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_texts.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_section.dart';

/// Placeholder body used by shell sections until feature content lands.
class ShellSection extends StatelessWidget {
  const ShellSection({
    super.key,
    required this.eyebrowKey,
    required this.titleKey,
    required this.bodyKey,
    this.trailing,
  });

  final String eyebrowKey;
  final String titleKey;
  final String bodyKey;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppSection(
      id: titleKey,
      eyebrow: eyebrowKey,
      title: titleKey,
      subtitle: bodyKey,
      trailing: trailing,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bp = breakpointOf(constraints);
          return AppCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSizes.s4,
                  height: AppSizes.s48,
                  decoration: BoxDecoration(
                    color: scheme.secondary,
                    borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                  ),
                ),
                const SizedBox(width: AppSizes.s16),
                Expanded(
                  child: Text(
                    AppTexts.commonComingSoon,
                    style: AppFonts.body(bp)
                        .copyWith(color: scheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
