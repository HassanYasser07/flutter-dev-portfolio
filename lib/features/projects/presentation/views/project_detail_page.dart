import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_texts.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_section.dart';
import '../../../home/presentation/widgets/footer_widget.dart';
import '../../data/models/project_model.dart';
import '../bloc/projects_cubit.dart';
import '../bloc/projects_state.dart';
import '../widgets/project_gallery.dart';
import '../widgets/project_video_player.dart';

/// Detail page for a single project. Loads project data asynchronously from
/// Supabase via [ProjectsCubit].
class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({
    super.key,
    required this.projectId,
  });

  final String projectId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProjectsCubit()..selectProjectById(projectId),
      child: BlocBuilder<ProjectsCubit, ProjectsState>(
        builder: (context, state) {
          // Show loading while the cubit is in initial or loading state.
          if (state.status == ProjectsStatus.initial ||
              state.status == ProjectsStatus.loading) {
            return _buildLoadingScaffold(context);
          }

          final project = state.selectedProject;

          // Project not found or error.
          if (project == null) {
            return _buildNotFoundScaffold(context);
          }

          return _buildDetailScaffold(context, project);
        },
      ),
    );
  }

  Widget _buildLoadingScaffold(BuildContext context) {
    return AppScaffold(
      body: ListView(
        children: [
          AppSection(
            id: 'project-detail-loading',
            eyebrow: AppTexts.projectsEyebrow,
            title: AppTexts.projectsDetailTitle,
            subtitle: '',
            trailing: AppButton(
              label: AppTexts.commonBack,
              variant: AppButtonVariant.ghost,
              icon: Icons.arrow_back,
              onPressed: () => context.goNamed(AppRoutes.projects),
            ),
            child: const SizedBox(
              height: 300,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          const FooterWidget(),
        ],
      ),
    );
  }

  Widget _buildNotFoundScaffold(BuildContext context) {
    return AppScaffold(
      body: ListView(
        children: [
          AppSection(
            id: 'project-detail-not-found',
            eyebrow: AppTexts.projectsEyebrow,
            title: AppTexts.projectsDetailTitle,
            subtitle: AppTexts.projectsNotFound,
            trailing: AppButton(
              label: AppTexts.commonBack,
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

  Widget _buildDetailScaffold(BuildContext context, ProjectModel project) {
    final scheme = Theme.of(context).colorScheme;

    return AppScaffold(
      body: ListView(
        children: [
          AppSection(
            id: 'project-detail',
            eyebrow: AppTexts.projectsEyebrow,
            title: project.title,
            subtitle: project.description,
            trailing: AppButton(
              label: AppTexts.commonBack,
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
                    if (project.tags.isNotEmpty) ...[
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
                    ],

                    // Image Gallery (loaded from project_images via imageUrls)
                    ProjectGalleryWidget(
                      screenshots: project.imageUrls,
                      height: bp == AppBreakpoint.mobile ? 320 : 480,
                    ),
                    const SizedBox(height: AppSizes.s24),

                    // Video Player (lazy — only rendered when videoUrl is present)
                    if (project.videoUrl != null &&
                        project.videoUrl!.isNotEmpty) ...[
                      Text(
                        AppTexts.projectsDemoVideo,
                        style: AppFonts.heading(bp).copyWith(
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSizes.s16),
                      ProjectVideoPlayer(
                        videoAsset: project.videoUrl!,
                        posterAsset: project.thumbnailUrl ?? '',
                        height: bp == AppBreakpoint.mobile ? 240 : 420,
                      ),
                      const SizedBox(height: AppSizes.s24),
                    ],

                    // Actions / External Links
                    Wrap(
                      spacing: AppSizes.s12,
                      runSpacing: AppSizes.s8,
                      children: [
                        if (project.githubUrl != null)
                          AppButton(
                            label: AppTexts.projectsGithubLabel,
                            variant: AppButtonVariant.secondary,
                            icon: Icons.code,
                            onPressed: () async {
                              final uri = Uri.tryParse(project.githubUrl!);
                              if (uri != null && await canLaunchUrl(uri)) {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                          ),
                        if (project.liveUrl != null)
                          AppButton(
                            label: AppTexts.projectsLiveLabel,
                            variant: AppButtonVariant.ghost,
                            icon: Icons.open_in_new,
                            onPressed: () async {
                              final uri = Uri.tryParse(project.liveUrl!);
                              if (uri != null && await canLaunchUrl(uri)) {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                          ),
                        if (project.imageUrls.isNotEmpty)
                          AppButton(
                            label: AppTexts.projectsGalleryTitle,
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

/// Full-screen gallery page for a single project's images.
class ProjectGalleryPage extends StatelessWidget {
  const ProjectGalleryPage({
    super.key,
    required this.projectId,
  });

  final String projectId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProjectsCubit()..selectProjectById(projectId),
      child: BlocBuilder<ProjectsCubit, ProjectsState>(
        builder: (context, state) {
          final project = state.selectedProject;

          return AppScaffold(
            body: ListView(
              children: [
                AppSection(
                  id: 'project-gallery-fullscreen',
                  eyebrow: AppTexts.projectsEyebrow,
                  title: project != null
                      ? project.title
                      : AppTexts.projectsGalleryTitle,
                  subtitle: AppTexts.projectsGalleryTitle,
                  trailing: AppButton(
                    label: AppTexts.commonClose,
                    variant: AppButtonVariant.ghost,
                    icon: Icons.close,
                    onPressed: () => context.goNamed(
                      AppRoutes.projectDetail,
                      pathParameters: {'id': projectId},
                    ),
                  ),
                  child: state.status == ProjectsStatus.loading ||
                          state.status == ProjectsStatus.initial
                      ? const SizedBox(
                          height: 300,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : project != null
                          ? ProjectGalleryWidget(
                              screenshots: project.imageUrls,
                              height: 600,
                            )
                          : const SizedBox(height: 200),
                ),
                const FooterWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
