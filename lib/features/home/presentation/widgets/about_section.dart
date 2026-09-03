import 'package:flutter/material.dart';

import '../../../../core/constants/locale_keys.g.dart';
import 'shell_section.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShellSection(
      eyebrowKey: LocaleKeys.about_eyebrow,
      titleKey: LocaleKeys.about_title,
      bodyKey: LocaleKeys.about_body,
    );
  }
}
