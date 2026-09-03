import 'package:flutter/material.dart';

import '../../../../core/constants/locale_keys.g.dart';
import 'shell_section.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShellSection(
      eyebrowKey: LocaleKeys.experience_eyebrow,
      titleKey: LocaleKeys.experience_title,
      bodyKey: LocaleKeys.experience_body,
    );
  }
}
