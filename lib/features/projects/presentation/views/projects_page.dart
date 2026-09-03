import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bp = BreakpointScope.maybeOf(context)?.breakpoint ??
                    breakpointOf(constraints);
                final columns = switch (bp) {
                  AppBreakpoint.mobile => 1,
                  AppBreakpoint.tablet => 2,
                  AppBreakpoint.laptop || AppBreakpoint.desktop => 3,
                };
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: columns,
                  mainAxisSpacing: AppSizes.s16,
                  crossAxisSpacing: AppSizes.s16,
                  childAspectRatio: 1.2,
                  children: [
                    for (var index = 0; index < 3; index++)
                      AppCard(
                        semanticLabel: LocaleKeys.projects_detailTitle.tr(),
                        onPressed: () => context.goNamed(
                          AppRoutes.projectDetail,
                          pathParameters: {'id': 'p$index'},
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                                  borderRadius:
                                      BorderRadius.circular(AppSizes.radiusSm),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSizes.s16),
                            Text(
                              LocaleKeys.projects_empty.tr(),
                              style: AppFonts.body(bp).copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
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
