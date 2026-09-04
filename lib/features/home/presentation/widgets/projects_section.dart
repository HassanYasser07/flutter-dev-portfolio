import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/locale_keys.g.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_section.dart';
import '../../../projects/data/models/project_model.dart';
import '../../../projects/presentation/bloc/projects_cubit.dart';
import '../../../projects/presentation/bloc/projects_state.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProjectsCubit()..loadProjects(),
      child: VisibilityDetector(
        key: const Key('projects-section-visibility'),
        onVisibilityChanged: (info) {
          if (!_visible && info.visibleFraction > 0.1) {
            if (mounted) setState(() => _visible = true);
          }
        },
        child: AppSection(
          id: 'projects',
          eyebrow: LocaleKeys.projects_eyebrow.tr(),
          title: LocaleKeys.projects_title.tr(),
          subtitle: LocaleKeys.projects_body.tr(),
          trailing: AppButton(
            label: LocaleKeys.projects_viewAll.tr(),
            variant: AppButtonVariant.secondary,
            onPressed: () => context.goNamed(AppRoutes.projects),
          ),
          child: BlocBuilder<ProjectsCubit, ProjectsState>(
            builder: (context, state) {
              if (state.status == ProjectsStatus.loading ||
                  state.status == ProjectsStatus.initial) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state.status == ProjectsStatus.error ||
                  state.allProjects.isEmpty) {
                return const SizedBox.shrink();
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  final bp = breakpointOf(constraints);
                  final columns = switch (bp) {
                    AppBreakpoint.mobile => 1,
                    AppBreakpoint.tablet => 2,
                    AppBreakpoint.laptop || AppBreakpoint.desktop => 3,
                  };

                  // Limit preview to top 3 projects for the home page section.
                  // No video player — thumbnail only as per AGENT.md Media Rules.
                  final previewProjects = state.allProjects.take(3).toList();
                  final animate = shouldAnimate(context);

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisSpacing: AppSizes.s16,
                      crossAxisSpacing: AppSizes.s16,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: previewProjects.length,
                    itemBuilder: (context, index) {
                      final project = previewProjects[index];
                      final card = _ProjectCard(project: project, bp: bp);

                      // Tier 1 — stagger ≤8 items; 60–80ms per card
                      if (animate && _visible) {
                        return card
                            .animate()
                            .fadeIn(
                              delay: Duration(milliseconds: 80 * index),
                              duration: AppMotion.section,
                              curve: AppMotion.easeOut,
                            )
                            .slideY(
                              begin: 0.12,
                              end: 0,
                              delay: Duration(milliseconds: 80 * index),
                              duration: AppMotion.section,
                              curve: AppMotion.easeOut,
                            );
                      }
                      return card;
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({
    required this.project,
    required this.bp,
  });

  final ProjectModel project;
  final AppBreakpoint bp;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: project.titleKey.tr(),
      child: AppCard(
        semanticLabel: project.titleKey.tr(),
        onPressed: () => context.goNamed(
          AppRoutes.projectDetail,
          pathParameters: {'id': project.id},
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail — compressed image only; NO video widget here
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  project.thumbAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: Icon(
                          Icons.work_outline,
                          size: 36,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          semanticLabel: project.titleKey.tr(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSizes.s16),
            // Title
            Text(
              project.titleKey.tr(),
              style: AppFonts.title(bp).copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSizes.s8),
            // Description
            Expanded(
              child: Text(
                project.descriptionKey.tr(),
                style: AppFonts.bodySmall(bp).copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: AppSizes.s12),
            // Tech tags
            Wrap(
              spacing: AppSizes.s8,
              runSpacing: AppSizes.s8,
              children: project.tags.map((tag) {
                return ExcludeSemantics(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.s8,
                      vertical: AppSizes.s4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: Text(
                      tag,
                      style: AppFonts.label(bp).copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
