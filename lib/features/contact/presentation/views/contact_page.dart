import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/locale_keys.g.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_section.dart';
import '../../../home/presentation/widgets/footer_widget.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: ListView(
        children: [
          AppSection(
            id: 'contact-page',
            eyebrow: LocaleKeys.contact_eyebrow.tr(),
            title: LocaleKeys.contact_pageTitle.tr(),
            subtitle: LocaleKeys.contact_body.tr(),
            trailing: AppButton(
              label: LocaleKeys.common_back.tr(),
              variant: AppButtonVariant.ghost,
              icon: Icons.arrow_back,
              onPressed: () => context.goNamed(AppRoutes.home),
            ),
            child: const SizedBox.shrink(),
          ),
          const FooterWidget(),
        ],
      ),
    );
  }
}
