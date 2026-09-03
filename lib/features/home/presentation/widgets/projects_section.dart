import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/locale_keys.g.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_button.dart';
import 'shell_section.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ShellSection(
      eyebrowKey: LocaleKeys.projects_eyebrow,
      titleKey: LocaleKeys.projects_title,
      bodyKey: LocaleKeys.projects_body,
      trailing: AppButton(
        label: LocaleKeys.projects_viewAll.tr(),
        variant: AppButtonVariant.secondary,
        onPressed: () => context.goNamed(AppRoutes.projects),
      ),
    );
  }
}
