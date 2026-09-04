import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/locale_keys.g.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_section.dart';
import '../../data/models/skill_model.dart';
import '../../data/portfolio_data.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({
    super.key,
    this.skills = PortfolioData.skills,
  });

  final List<SkillModel> skills;

  @override
  Widget build(BuildContext context) {
    return AppSection(
      id: 'skills',
      eyebrow: LocaleKeys.skills_eyebrow.tr(),
      title: LocaleKeys.skills_title.tr(),
      subtitle: LocaleKeys.skills_body.tr(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bp = breakpointOf(constraints);
          final crossAxisCount = switch (bp) {
            AppBreakpoint.mobile => 2,
            AppBreakpoint.tablet => 3,
            AppBreakpoint.laptop || AppBreakpoint.desktop => 4,
          };

          final spacing =
              bp == AppBreakpoint.mobile ? AppSizes.s12 : AppSizes.s16;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: skills.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              childAspectRatio: bp == AppBreakpoint.mobile ? 1.35 : 1.55,
            ),
            itemBuilder: (context, index) {
              final skill = skills[index];
              return _SkillCard(skill: skill, bp: bp);
            },
          );
        },
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({
    required this.skill,
    required this.bp,
  });

  final SkillModel skill;
  final AppBreakpoint bp;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final compact = bp == AppBreakpoint.mobile;

    return AppCard(
      padding: EdgeInsets.all(compact ? AppSizes.s12 : AppSizes.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: compact ? 36 : 40,
                height: compact ? 36 : 40,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border:
                      Border.all(color: scheme.primary.withValues(alpha: 0.2)),
                ),
                child: Center(
                  child: _SkillIcon(
                    iconPath: skill.iconPath,
                    name: skill.name,
                    compact: compact,
                  ),
                ),
              ),
              const Spacer(),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.s8,
                    vertical: AppSizes.s4,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                    border: Border.all(color: scheme.outline),
                  ),
                  child: Text(
                    skill.category,
                    style: AppFonts.label(bp).copyWith(
                      fontSize: compact ? 9 : 10,
                      color: scheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.s12),
          Text(
            skill.name,
            style: AppFonts.heading(bp).copyWith(
              fontSize: compact ? 15 : 17,
              fontWeight: FontWeight.bold,
              color: scheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _SkillIcon extends StatelessWidget {
  const _SkillIcon({
    required this.iconPath,
    required this.name,
    required this.compact,
  });

  final String iconPath;
  final String name;
  final bool compact;

  IconData _fallbackIcon(String name) {
    return switch (name.toLowerCase()) {
      'flutter' => Icons.flutter_dash,
      'dart' => Icons.code,
      'bloc / cubit' => Icons.account_tree_outlined,
      'firebase' => Icons.local_fire_department_outlined,
      'rest api' => Icons.api_outlined,
      'git & github' => Icons.source_outlined,
      'figma' => Icons.palette_outlined,
      'ci / cd' => Icons.integration_instructions_outlined,
      _ => Icons.terminal_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final size = compact ? 20.0 : 22.0;

    return SvgPicture.asset(
      iconPath,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(scheme.primary, BlendMode.srcIn),
      placeholderBuilder: (_) => Icon(
        _fallbackIcon(name),
        size: size,
        color: scheme.primary,
      ),
      errorBuilder: (_, __, ___) => Icon(
        _fallbackIcon(name),
        size: size,
        color: scheme.primary,
      ),
    );
  }
}
