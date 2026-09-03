import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/locale_keys.g.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_section.dart';
import '../../../projects/presentation/bloc/projects_cubit.dart';
import '../../../projects/presentation/bloc/projects_state.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProjectsCubit()..loadProjects(),
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

                // Limit preview to top 3 projects for the home page section
                final previewProjects = state.allProjects.take(3).toList();

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
                    return AppCard(
                      semanticLabel: project.titleKey.tr(),
                      onPressed: () => context.goNamed(
                        AppRoutes.projectDetail,
                        pathParameters: {'id': project.id},
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusSm),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.asset(
                                project.thumbAsset,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest,
                                    child: Center(
                                      child: Icon(
                                        Icons.work_outline,
                                        size: 36,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSizes.s16),
                          Text(
                            project.titleKey.tr(),
                            style: AppFonts.title(bp).copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSizes.s8),
                          Expanded(
                            child: Text(
                              project.descriptionKey.tr(),
                              style: AppFonts.bodySmall(bp).copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: AppSizes.s12),
                          Wrap(
                            spacing: AppSizes.s8,
                            runSpacing: AppSizes.s8,
                            children: project.tags.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.s8,
                                  vertical: AppSizes.s4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHigh,
                                  borderRadius: BorderRadius.circular(
                                      AppSizes.radiusPill),
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                                child: Text(
                                  tag,
                                  style: AppFonts.label(bp).copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
