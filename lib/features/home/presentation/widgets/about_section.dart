import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/locale_keys.g.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_section.dart';
import '../../../cv/presentation/bloc/cv_cubit.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppSection(
      id: 'about',
      eyebrow: LocaleKeys.about_eyebrow.tr(),
      title: LocaleKeys.about_title.tr(),
      subtitle: LocaleKeys.about_body.tr(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bp = breakpointOf(constraints);
          final compact = bp == AppBreakpoint.mobile;

          return AppCard(
            child: Padding(
              padding: EdgeInsets.all(compact ? AppSizes.s16 : AppSizes.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: AppSizes.s4,
                        height: AppSizes.s48,
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusPill),
                        ),
                      ),
                      const SizedBox(width: AppSizes.s16),
                      Expanded(
                        child: Text(
                          LocaleKeys.about_body.tr(),
                          style: AppFonts.body(bp).copyWith(
                            color: scheme.onSurface,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.s24),
                  Wrap(
                    spacing: AppSizes.s12,
                    runSpacing: AppSizes.s12,
                    children: [
                      AppButton(
                        label: LocaleKeys.cv_view.tr(),
                        variant: AppButtonVariant.secondary,
                        icon: Icons.open_in_new,
                        tooltip: LocaleKeys.cv_view.tr(),
                        onPressed: () =>
                            context.read<CvCubit>().openCvInNewTab(),
                      ),
                      AppButton(
                        label: LocaleKeys.cv_download.tr(),
                        variant: AppButtonVariant.ghost,
                        icon: Icons.download,
                        tooltip: LocaleKeys.cv_download.tr(),
                        onPressed: () => context.read<CvCubit>().downloadCv(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
