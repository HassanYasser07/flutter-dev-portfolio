import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/locale_keys.g.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_section.dart';
import '../../../home/presentation/widgets/footer_widget.dart';
import '../../data/projects_repository.dart';
import '../widgets/project_gallery.dart';

class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({
    super.key,
    required this.projectId,
    this.repository = const ProjectsRepository(),
  });

  final String projectId;
  final ProjectsRepository repository;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final project = repository.getProjectById(projectId);

    if (project == null) {
      return AppScaffold(
        body: ListView(
          children: [
            AppSection(
              id: 'project-detail-not-found',
              eyebrow: LocaleKeys.projects_eyebrow.tr(),
              title: LocaleKeys.projects_detailTitle.tr(),
              subtitle: LocaleKeys.projects_notFound.tr(),
              trailing: AppButton(
                label: LocaleKeys.common_back.tr(),
                variant: AppButtonVariant.ghost,
                icon: Icons.arrow_back,
                onPressed: () => context.goNamed(AppRoutes.projects),
              ),
              child: const SizedBox(height: 200),
            ),
            const FooterWidget(),
          ],
        ),
      );
    }

    return AppScaffold(
      body: ListView(
        children: [
          AppSection(
            id: 'project-detail',
            eyebrow: LocaleKeys.projects_eyebrow.tr(),
            title: project.titleKey.tr(),
            subtitle: project.descriptionKey.tr(),
            trailing: AppButton(
              label: LocaleKeys.common_back.tr(),
              variant: AppButtonVariant.ghost,
              icon: Icons.arrow_back,
              onPressed: () => context.goNamed(AppRoutes.projects),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bp = breakpointOf(constraints);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tags list
                    Wrap(
                      spacing: AppSizes.s8,
                      runSpacing: AppSizes.s8,
                      children: project.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.s12,
                            vertical: AppSizes.s4,
                          ),
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerHigh,
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusPill),
                            border: Border.all(color: scheme.outline),
                          ),
                          child: Text(
                            tag,
                            style: AppFonts.label(bp).copyWith(
                              color: scheme.secondary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSizes.s24),

                    // Embedded Image Gallery Widget
                    ProjectGalleryWidget(
                      screenshots: project.screenshotAssets,
                      height: bp == AppBreakpoint.mobile ? 320 : 480,
                    ),
                    const SizedBox(height: AppSizes.s24),

                    // Actions / External Links
                    Row(
                      children: [
                        if (project.githubUrl != null) ...[
                          AppButton(
                            label: 'GitHub',
                            variant: AppButtonVariant.secondary,
                            icon: Icons.code,
                            onPressed: () {
                              // Action handled via URL helper or launchUrl in later task
                            },
                          ),
                          const SizedBox(width: AppSizes.s12),
                        ],
                        if (project.screenshotAssets.isNotEmpty)
                          AppButton(
                            label: LocaleKeys.projects_galleryTitle.tr(),
                            variant: AppButtonVariant.ghost,
                            icon: Icons.fullscreen,
                            onPressed: () => context.goNamed(
                              AppRoutes.projectGallery,
                              pathParameters: {'id': projectId},
                            ),
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          const FooterWidget(),
        ],
      ),
    );
  }
}

class ProjectGalleryPage extends StatelessWidget {
  const ProjectGalleryPage({
    super.key,
    required this.projectId,
    this.repository = const ProjectsRepository(),
  });

  final String projectId;
  final ProjectsRepository repository;

  @override
  Widget build(BuildContext context) {
    final project = repository.getProjectById(projectId);

    return AppScaffold(
      body: ListView(
        children: [
          AppSection(
            id: 'project-gallery-fullscreen',
            eyebrow: LocaleKeys.projects_eyebrow.tr(),
            title: project != null
                ? project.titleKey.tr()
                : LocaleKeys.projects_galleryTitle.tr(),
            subtitle: LocaleKeys.projects_galleryTitle.tr(),
            trailing: AppButton(
              label: LocaleKeys.common_close.tr(),
              variant: AppButtonVariant.ghost,
              icon: Icons.close,
              onPressed: () => context.goNamed(
                AppRoutes.projectDetail,
                pathParameters: {'id': projectId},
              ),
            ),
            child: project != null
                ? ProjectGalleryWidget(
                    screenshots: project.screenshotAssets,
                    height: 600,
                  )
                : const SizedBox(height: 200),
          ),
          const FooterWidget(),
        ],
      ),
    );
  }
}
