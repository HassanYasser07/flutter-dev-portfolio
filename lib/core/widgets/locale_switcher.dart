import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/app_fonts.dart';
import '../constants/app_sizes.dart';
import '../constants/locale_keys.g.dart';
import '../localization/app_localization.dart';
import '../utils/responsive.dart';

class LocaleSwitcher extends StatelessWidget {
  const LocaleSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final current = context.locale;
    final scheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bp = breakpointOf(constraints);
        return PopupMenuButton<Locale>(
          tooltip: LocaleKeys.locale_label.tr(),
          initialValue: current,
          position: PopupMenuPosition.under,
          onSelected: (locale) => AppLocalization.setLocale(context, locale),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s12,
              vertical: AppSizes.s8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.translate, size: 18, color: scheme.onSurface),
                const SizedBox(width: AppSizes.s8),
                Text(
                  AppLocalization.codeOf(current),
                  style: AppFonts.label(bp).copyWith(
                    color: scheme.onSurface,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
          itemBuilder: (context) {
            return [
              for (final locale in AppLocalization.supportedLocales)
                PopupMenuItem<Locale>(
                  value: locale,
                  child: Row(
                    children: [
                      SizedBox(
                        width: AppSizes.s24,
                        child: locale.languageCode == current.languageCode
                            ? Icon(Icons.check,
                                size: 16, color: scheme.secondary)
                            : const SizedBox.shrink(),
                      ),
                      const SizedBox(width: AppSizes.s8),
                      Text(
                        AppLocalization.languageLabels[locale.languageCode]!
                            .tr(),
                        style: AppFonts.body(bp),
                      ),
                    ],
                  ),
                ),
            ];
          },
        );
      },
    );
  }
}
