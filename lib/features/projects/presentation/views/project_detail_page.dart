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

class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppScaffold(
      body: ListView(
        children: [
          AppSection(
            id: 'project-detail',
            eyebrow: LocaleKeys.projects_eyebrow.tr(),
            title: LocaleKeys.projects_detailTitle.tr(),
            subtitle: LocaleKeys.projects_notFound.tr(),
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
                    Text(
                      projectId,
                      style:
                          AppFonts.label(bp).copyWith(color: scheme.secondary),
                    ),
                    const SizedBox(height: AppSizes.s24),
                    AppButton(
                      label: LocaleKeys.projects_galleryTitle.tr(),
                      variant: AppButtonVariant.secondary,
                      onPressed: () => context.goNamed(
                        AppRoutes.projectGallery,
                        pathParameters: {'id': projectId},
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

class ProjectGalleryPage extends StatelessWidget {
  const ProjectGalleryPage({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: ListView(
        children: [
          AppSection(
            id: 'project-gallery',
            eyebrow: LocaleKeys.projects_eyebrow.tr(),
            title: LocaleKeys.projects_galleryTitle.tr(),
            trailing: AppButton(
              label: LocaleKeys.common_close.tr(),
              variant: AppButtonVariant.ghost,
              onPressed: () => context.goNamed(
                AppRoutes.projectDetail,
                pathParameters: {'id': projectId},
              ),
            ),
            child: const SizedBox.shrink(),
          ),
          const FooterWidget(),
        ],
      ),
    );
  }
}
