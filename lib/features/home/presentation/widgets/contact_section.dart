import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/locale_keys.g.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_button.dart';
import 'shell_section.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ShellSection(
      eyebrowKey: LocaleKeys.contact_eyebrow,
      titleKey: LocaleKeys.contact_title,
      bodyKey: LocaleKeys.contact_body,
      trailing: AppButton(
        label: LocaleKeys.hero_ctaContact.tr(),
        onPressed: () => context.goNamed(AppRoutes.contact),
      ),
    );
  }
}
