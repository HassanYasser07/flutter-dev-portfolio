import 'package:flutter/material.dart';

import '../../../../core/constants/locale_keys.g.dart';
import 'shell_section.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShellSection(
      eyebrowKey: LocaleKeys.skills_eyebrow,
      titleKey: LocaleKeys.skills_title,
      bodyKey: LocaleKeys.skills_body,
    );
  }
}
