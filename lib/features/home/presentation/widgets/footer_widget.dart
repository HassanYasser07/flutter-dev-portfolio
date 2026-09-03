import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/locale_keys.g.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_icon_button.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key, this.onBackToTop});

  final VoidCallback? onBackToTop;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bp = breakpointOf(constraints);
        final compact =
            bp == AppBreakpoint.mobile || bp == AppBreakpoint.tablet;
        final hPad = horizontalPaddingOf(constraints);

        final copyright = Text(
          LocaleKeys.footer_copyright.tr(),
          style:
              AppFonts.bodySmall(bp).copyWith(color: scheme.onSurfaceVariant),
          textAlign: compact ? TextAlign.center : TextAlign.start,
        );
        final availability = Text(
          LocaleKeys.footer_availability.tr(),
          style:
              AppFonts.bodySmall(bp).copyWith(color: scheme.onSurfaceVariant),
          textAlign: compact ? TextAlign.center : TextAlign.end,
        );
        final back = onBackToTop == null
            ? const SizedBox.shrink()
            : AppIconButton(
                icon: Icons.arrow_upward,
                tooltip: LocaleKeys.footer_backToTop.tr(),
                onPressed: onBackToTop,
              );

        return DecoratedBox(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: scheme.outline)),
          ),
          child: Align(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: AppSizes.maxWideWidth),
              child: Padding(
                padding:
                    EdgeInsets.fromLTRB(hPad, AppSizes.s32, hPad, AppSizes.s32),
                child: compact
                    ? Column(
                        children: [
                          copyright,
                          const SizedBox(height: AppSizes.s8),
                          availability,
                          const SizedBox(height: AppSizes.s16),
                          back,
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(child: copyright),
                          back,
                          const SizedBox(width: AppSizes.s16),
                          Expanded(child: availability),
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
