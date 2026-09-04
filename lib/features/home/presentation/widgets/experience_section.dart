import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/locale_keys.g.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_section.dart';
import '../../data/models/experience_model.dart';
import '../../data/portfolio_data.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({
    super.key,
    this.experiences = PortfolioData.experiences,
  });

  final List<ExperienceModel> experiences;

  @override
  Widget build(BuildContext context) {
    return AppSection(
      id: 'experience',
      eyebrow: LocaleKeys.experience_eyebrow.tr(),
      title: LocaleKeys.experience_title.tr(),
      subtitle: LocaleKeys.experience_body.tr(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bp = breakpointOf(constraints);

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: experiences.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSizes.s24),
            itemBuilder: (context, index) {
              final isLast = index == experiences.length - 1;
              return _ExperienceTimelineItem(
                experience: experiences[index],
                bp: bp,
                isLast: isLast,
              );
            },
          );
        },
      ),
    );
  }
}

class _ExperienceTimelineItem extends StatelessWidget {
  const _ExperienceTimelineItem({
    required this.experience,
    required this.bp,
    required this.isLast,
  });

  final ExperienceModel experience;
  final AppBreakpoint bp;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final compact = bp == AppBreakpoint.mobile;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator line & node
          Column(
            children: [
              Container(
                width: compact ? 36 : 44,
                height: compact ? 36 : 44,
                decoration: BoxDecoration(
                  color: scheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: scheme.primary, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.business_center_outlined,
                  size: compact ? 18 : 20,
                  color: scheme.primary,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: AppSizes.s8),
                    color: scheme.outline,
                  ),
                ),
            ],
          ),
          SizedBox(width: compact ? AppSizes.s12 : AppSizes.s24),
          // Content Card
          Expanded(
            child: AppCard(
              padding: EdgeInsets.all(compact ? AppSizes.s16 : AppSizes.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Role & Duration
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: AppSizes.s12,
                    runSpacing: AppSizes.s8,
                    children: [
                      Text(
                        experience.roleKey.tr(),
                        style: AppFonts.heading(bp).copyWith(
                          fontWeight: FontWeight.bold,
                          color: scheme.onSurface,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.s12,
                          vertical: AppSizes.s4,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.primary.withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusPill),
                          border: Border.all(
                            color: scheme.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          experience.durationKey.tr(),
                          style: AppFonts.label(bp).copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.s8),
                  // Company
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.business,
                        size: 16,
                        color: scheme.secondary,
                      ),
                      const SizedBox(width: AppSizes.s8),
                      Text(
                        experience.companyKey.tr(),
                        style: AppFonts.body(bp).copyWith(
                          color: scheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.s16),
                  // Description
                  Text(
                    experience.descriptionKey.tr(),
                    style: AppFonts.body(bp).copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.6,
                    ),
                  ),
                  if (experience.technologies.isNotEmpty) ...[
                    const SizedBox(height: AppSizes.s24),
                    // Tech Tags
                    Wrap(
                      spacing: AppSizes.s8,
                      runSpacing: AppSizes.s8,
                      children: experience.technologies.map((tech) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.s8,
                            vertical: AppSizes.s4,
                          ),
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerHighest,
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusSm),
                            border: Border.all(color: scheme.outline),
                          ),
                          child: Text(
                            tech,
                            style: AppFonts.label(bp).copyWith(
                              fontSize: compact ? 10 : 11,
                              color: scheme.onSurface,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
