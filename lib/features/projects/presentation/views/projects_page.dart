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
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_section.dart';
import '../../../home/presentation/widgets/footer_widget.dart';
import '../bloc/projects_cubit.dart';
import '../bloc/projects_state.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProjectsCubit()..loadProjects(),
      child: AppScaffold(
        body: ListView(
          children: [
            AppSection(
              id: 'projects-page',
              eyebrow: LocaleKeys.projects_eyebrow.tr(),
              title: LocaleKeys.projects_title.tr(),
              subtitle: LocaleKeys.projects_body.tr(),
              trailing: AppButton(
                label: LocaleKeys.common_back.tr(),
                variant: AppButtonVariant.ghost,
                icon: Icons.arrow_back,
                onPressed: () => context.goNamed(AppRoutes.home),
              ),
              child: BlocBuilder<ProjectsCubit, ProjectsState>(
                builder: (context, state) {
                  final cubit = context.read<ProjectsCubit>();

                  if (state.status == ProjectsStatus.loading ||
                      state.status == ProjectsStatus.initial) {
                    return const SizedBox(
                      height: 300,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (state.status == ProjectsStatus.error) {
                    return SizedBox(
                      height: 300,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.errorMessage ??
                                  LocaleKeys.projects_notFound.tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                            const SizedBox(height: AppSizes.s16),
                            AppButton(
                              label: LocaleKeys.common_back.tr(),
                              variant: AppButtonVariant.secondary,
                              onPressed: () => cubit.loadProjects(),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Filter Tag Bar
                      if (state.availableTags.isNotEmpty) ...[
                        _TagFilterBar(
                          tags: ['all', ...state.availableTags],
                          selectedTag: state.selectedTag,
                          onTagSelected: (tag) => cubit.filterByTag(tag),
                        ),
                        const SizedBox(height: AppSizes.s24),
                      ],

                      // Empty Projects View
                      if (state.filteredProjects.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.s48,
                          ),
                          child: Center(
                            child: Text(
                              LocaleKeys.projects_empty.tr(),
                              style:
                                  AppFonts.body(AppBreakpoint.desktop).copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ),
                        )
                      else
                        // Projects Grid
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final bp =
                                BreakpointScope.maybeOf(context)?.breakpoint ??
                                    breakpointOf(constraints);
                            final columns = switch (bp) {
                              AppBreakpoint.mobile => 1,
                              AppBreakpoint.tablet => 2,
                              AppBreakpoint.laptop ||
                              AppBreakpoint.desktop =>
                                3,
                            };

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                mainAxisSpacing: AppSizes.s16,
                                crossAxisSpacing: AppSizes.s16,
                                childAspectRatio: 0.85,
                              ),
                              itemCount: state.filteredProjects.length,
                              itemBuilder: (context, index) {
                                final project = state.filteredProjects[index];
                                return AppCard(
                                  semanticLabel: project.titleKey.tr(),
                                  onPressed: () => context.goNamed(
                                    AppRoutes.projectDetail,
                                    pathParameters: {'id': project.id},
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Thumbnail
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            AppSizes.radiusSm),
                                        child: AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: Image.asset(
                                            project.thumbAsset,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
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
                                      // Title
                                      Text(
                                        project.titleKey.tr(),
                                        style: AppFonts.title(bp).copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: AppSizes.s8),
                                      // Description
                                      Expanded(
                                        child: Text(
                                          project.descriptionKey.tr(),
                                          style:
                                              AppFonts.bodySmall(bp).copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(height: AppSizes.s12),
                                      // Tags
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
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppSizes.radiusPill),
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                              ),
                                            ),
                                            child: Text(
                                              tag,
                                              style:
                                                  AppFonts.label(bp).copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
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
                        ),
                    ],
                  );
                },
              ),
            ),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }
}

class _TagFilterBar extends StatelessWidget {
  const _TagFilterBar({
    required this.tags,
    required this.selectedTag,
    required this.onTagSelected,
  });

  final List<String> tags;
  final String selectedTag;
  final ValueChanged<String> onTagSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: AppSizes.s8,
      runSpacing: AppSizes.s8,
      children: tags.map((tag) {
        final isSelected = selectedTag.toLowerCase() == tag.toLowerCase() ||
            (selectedTag == 'all' && tag == 'all');

        return ChoiceChip(
          label: Text(
            tag == 'all' ? LocaleKeys.projects_viewAll.tr() : tag,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isSelected ? scheme.onPrimary : scheme.onSurface,
                ),
          ),
          selected: isSelected,
          selectedColor: scheme.primary,
          backgroundColor: scheme.surface,
          onSelected: (_) => onTagSelected(tag),
        );
      }).toList(),
    );
  }
}
