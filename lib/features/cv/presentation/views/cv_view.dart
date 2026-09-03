import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/locale_keys.g.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_section.dart';
import '../../../home/presentation/widgets/footer_widget.dart';

class CvView extends StatelessWidget {
  const CvView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: ListView(
        children: [
          AppSection(
            id: 'cv',
            eyebrow: LocaleKeys.nav_cv.tr(),
            title: LocaleKeys.cv_title.tr(),
            subtitle: LocaleKeys.cv_body.tr(),
            trailing: AppButton(
              label: LocaleKeys.common_back.tr(),
              variant: AppButtonVariant.ghost,
              icon: Icons.arrow_back,
              onPressed: () => context.goNamed(AppRoutes.home),
            ),
            child: AppCard(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  AppButton(
                    label: LocaleKeys.cv_view.tr(),
                    onPressed: () {},
                  ),
                  AppButton(
                    label: LocaleKeys.cv_download.tr(),
                    variant: AppButtonVariant.secondary,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          const FooterWidget(),
        ],
      ),
    );
  }
}
