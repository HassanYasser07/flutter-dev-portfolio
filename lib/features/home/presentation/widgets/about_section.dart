import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_texts.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_section.dart';
import '../../../cv/presentation/bloc/cv_cubit.dart';
import '../../data/models/about_model.dart';
import '../bloc/about_cubit.dart';
import '../bloc/about_state.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSection(
      id: 'about',
      child: BlocBuilder<AboutCubit, AboutState>(
        builder: (context, state) {
          if (state.status == AboutStatus.loading ||
              state.status == AboutStatus.initial) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final about = state.about;

          return _AboutContent(about: about);
        },
      ),
    );
  }
}

class _AboutContent extends StatelessWidget {
  const _AboutContent({this.about});

  final AboutModel? about;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bp = breakpointOf(constraints);
        final isDesktop = constraints.maxWidth > 1000;

        final bodyText = (about != null && about!.description.isNotEmpty)
            ? about!.description
            : AppTexts.aboutBody;

        final hasImage =
            about?.imageUrl != null && about!.imageUrl!.trim().isNotEmpty;

        final leftItem = _buildAboutItem(
          context: context,
          maxWidth: isDesktop ? 490 : double.infinity,
          title: AppTexts.aboutMe,
          subTitle: AppTexts.aboutWhoIAm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasImage) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  child: Image.network(
                    about!.imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(height: AppSizes.s16),
              ],
              Text(
                bodyText,
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
                    label: AppTexts.cvView,
                    variant: AppButtonVariant.secondary,
                    icon: Icons.open_in_new,
                    tooltip: AppTexts.cvView,
                    onPressed: () =>
                        context.read<CvCubit>().openCvInNewTab(about?.cvUrl),
                  ),
                  AppButton(
                    label: AppTexts.cvDownload,
                    variant: AppButtonVariant.ghost,
                    icon: Icons.download,
                    tooltip: AppTexts.cvDownload,
                    onPressed: () =>
                        context.read<CvCubit>().downloadCv(about?.cvUrl),
                  ),
                ],
              ),
            ],
          ),
        );

        final rightItem = _buildAboutItem(
          context: context,
          maxWidth: isDesktop ? 500 : double.infinity,
          title: AppTexts.aboutTechStack,
          subTitle: AppTexts.aboutWhatImGoodAt,
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
                    title: AppTexts.aboutSpecialty,
                    subTitle: AppTexts.aboutSpecialtyValue,
                  );
                  final educationWidget = _buildAboutItem(
                    context: context,
                    title: AppTexts.aboutEducation,
                    subTitle: AppTexts.aboutEducationValue,
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
              color: scheme.secondary,
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
      (
        name: 'Firebase',
        path: 'assets/icons/icons8-google-firebase-console-48.png'
      ),
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
