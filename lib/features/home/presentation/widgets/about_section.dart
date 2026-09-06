import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/locale_keys.g.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_section.dart';
import '../../../cv/presentation/bloc/cv_cubit.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppSection(
      id: 'about',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bp = breakpointOf(constraints);
          final isDesktop = constraints.maxWidth > 1000;

          final leftItem = _buildAboutItem(
            context: context,
            maxWidth: isDesktop ? 490 : double.infinity,
            title: LocaleKeys.about_me.tr(),
            subTitle: LocaleKeys.about_whoIAm.tr(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.about_body.tr(),
                  style: AppFonts.body(bp).copyWith(
                    fontSize: 16,
                    color: scheme.onSurfaceVariant,
                    height: 1.6,
                  ),
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
                      onPressed: () => context.read<CvCubit>().openCvInNewTab(),
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
          );

          final rightItem = _buildAboutItem(
            context: context,
            maxWidth: isDesktop ? 500 : double.infinity,
            title: LocaleKeys.about_techStack.tr(),
            subTitle: LocaleKeys.about_whatImGoodAt.tr(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.s12),
                const _AboutSkillsWidget(),
                const SizedBox(height: AppSizes.s24),
                LayoutBuilder(
                  builder: (context, subConstraints) {
                    final isRow = subConstraints.maxWidth >= 480;
                    final specialtyWidget = _buildAboutItem(
                      context: context,
                      title: LocaleKeys.about_specialty.tr(),
                      subTitle: LocaleKeys.about_specialtyValue.tr(),
                    );
                    final educationWidget = _buildAboutItem(
                      context: context,
                      title: LocaleKeys.about_education.tr(),
                      subTitle: LocaleKeys.about_educationValue.tr(),
                    );

                    if (isRow) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: specialtyWidget),
                          const SizedBox(width: AppSizes.s16),
                          Expanded(child: educationWidget),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          specialtyWidget,
                          const SizedBox(height: AppSizes.s16),
                          educationWidget,
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          );

          if (isDesktop) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: leftItem),
                const SizedBox(width: AppSizes.s48),
                Expanded(child: rightItem),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                leftItem,
                const SizedBox(height: AppSizes.s48),
                rightItem,
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildAboutItem({
    required BuildContext context,
    required String title,
    required String subTitle,
    Widget? child,
    double? maxWidth,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      constraints: maxWidth == null ? null : BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.all(AppSizes.s8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppFonts.label(AppBreakpoint.desktop).copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: scheme.primary,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: AppSizes.s4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              subTitle,
              maxLines: 1,
              style: AppFonts.heading(AppBreakpoint.desktop).copyWith(
                fontSize: (child == null) ? 16 : 28,
                fontWeight: (child == null) ? FontWeight.w500 : FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
          ),
          if (child != null) ...[
            const SizedBox(height: AppSizes.s12),
            child,
          ],
        ],
      ),
    );
  }
}

class _AboutSkillsWidget extends StatelessWidget {
  const _AboutSkillsWidget();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Real PNG icons from assets/icons/
    final skillIcons = [
      (name: 'Flutter', path: 'assets/icons/icons8-flutter-48.png'),
      (name: 'Dart', path: 'assets/icons/icons8-dart-48.png'),
      (name: 'Android Studio', path: 'assets/icons/android-studio.png'),
      (name: 'Postman', path: 'assets/icons/Postman_.png'),
      (name: 'Firebase', path: 'assets/icons/icons8-google-firebase-console-48.png'),
      (name: 'Supabase', path: 'assets/icons/supabase-logo-icon.png'),
      (name: 'GitHub', path: 'assets/icons/icone-github-violet.png'),
      (name: 'Figma', path: 'assets/icons/icons8-figma-48.png'),
    ];

    return Card(
      elevation: 2,
      shadowColor: scheme.shadow.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        side: BorderSide(color: scheme.outline),
      ),
      color: scheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s16,
          vertical: AppSizes.s12,
        ),
        child: Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSizes.s12,
            runSpacing: AppSizes.s12,
            children: skillIcons.map((item) {
              return Tooltip(
                message: item.name,
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.s8),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    border: Border.all(
                      color: scheme.outline.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Image.asset(
                    item.path,
                    width: 28,
                    height: 28,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.code,
                      size: 28,
                      color: scheme.primary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
