import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/locale_keys.g.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_section.dart';
import '../bloc/skills_cubit.dart';
import '../bloc/skills_state.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final animate = shouldAnimate(context);

    return VisibilityDetector(
      key: const Key('skills-section-visibility'),
      onVisibilityChanged: (info) {
        if (!_visible && info.visibleFraction > 0.1) {
          if (mounted) setState(() => _visible = true);
        }
      },
      child: AppSection(
        id: 'skills',
        eyebrow: LocaleKeys.skills_eyebrow.tr(),
        title: LocaleKeys.skills_title.tr(),
        subtitle: LocaleKeys.skills_body.tr(),
        child: BlocBuilder<SkillsCubit, SkillsState>(
          builder: (context, state) {
            if (state.status == SkillsStatus.loading ||
                state.status == SkillsStatus.initial) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state.status == SkillsStatus.error || state.skills.isEmpty) {
              return const SizedBox.shrink();
            }

            final skills = state.skills;

            return LayoutBuilder(
              builder: (context, constraints) {
                final bp = breakpointOf(constraints);
                final crossAxisCount = switch (bp) {
                  AppBreakpoint.mobile => 1,
                  AppBreakpoint.tablet => 2,
                  AppBreakpoint.laptop || AppBreakpoint.desktop => 3,
                };

                final spacing =
                    bp == AppBreakpoint.mobile ? AppSizes.s12 : AppSizes.s24;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: skills.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: spacing,
                    crossAxisSpacing: spacing,
                    mainAxisExtent: bp == AppBreakpoint.mobile ? 200 : 220,
                  ),
                  itemBuilder: (context, index) {
                    final categoryModel = skills[index];
                    Widget card = _SkillCategoryCard(
                      category: categoryModel.category,
                      skills: categoryModel.skills,
                      bp: bp,
                    );

                    if (animate && _visible) {
                      card = card
                          .animate()
                          .fadeIn(
                            delay: Duration(milliseconds: 90 * index),
                            duration: AppMotion.section,
                            curve: AppMotion.easeOut,
                          )
                          .slideY(
                            begin: 0.15,
                            end: 0,
                            delay: Duration(milliseconds: 90 * index),
                            duration: AppMotion.section,
                            curve: AppMotion.easeOutCubic,
                          );
                    }

                    return card;
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _SkillCategoryCard extends StatefulWidget {
  const _SkillCategoryCard({
    required this.category,
    required this.skills,
    required this.bp,
  });

  final String category;
  final List<String> skills;
  final AppBreakpoint bp;

  @override
  State<_SkillCategoryCard> createState() => _SkillCategoryCardState();
}

class _SkillCategoryCardState extends State<_SkillCategoryCard> {
  bool _isHovered = false;

  IconData _getCategoryIcon(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('mobile') || lower.contains('web')) {
      return Icons.devices_outlined;
    }
    if (lower.contains('language')) {
      return Icons.code_outlined;
    }
    if (lower.contains('state')) {
      return Icons.account_tree_outlined;
    }
    if (lower.contains('backend') || lower.contains('api')) {
      return Icons.api_outlined;
    }
    if (lower.contains('tool') || lower.contains('git')) {
      return Icons.handyman_outlined;
    }
    if (lower.contains('design')) {
      return Icons.palette_outlined;
    }
    if (lower.contains('devops') || lower.contains('ci')) {
      return Icons.integration_instructions_outlined;
    }
    if (lower.contains('storage')) {
      return Icons.storage_outlined;
    }
    if (lower.contains('architecture')) {
      return Icons.architecture_outlined;
    }
    return Icons.widgets_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final compact = widget.bp == AppBreakpoint.mobile;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -5 : 0, 0),
        decoration: BoxDecoration(
          color: _isHovered
              ? scheme.surfaceContainerHighest.withValues(alpha: 0.8)
              : scheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(
            color: _isHovered
                ? scheme.primary.withValues(alpha: 0.5)
                : scheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ]
              : [],
        ),
        padding: EdgeInsets.all(compact ? AppSizes.s16 : AppSizes.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  width: compact ? 36 : 42,
                  height: compact ? 36 : 42,
                  decoration: BoxDecoration(
                    color: scheme.surface.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    border: Border.all(
                      color: _isHovered
                          ? scheme.primary.withValues(alpha: 0.3)
                          : scheme.outline.withValues(alpha: 0.2),
                    ),
                    boxShadow: _isHovered
                        ? [
                            BoxShadow(
                              color: scheme.primary.withValues(alpha: 0.2),
                              blurRadius: 8,
                            )
                          ]
                        : [],
                  ),
                  child: Center(
                    child: AnimatedScale(
                      scale: _isHovered ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      child: Icon(
                        _getCategoryIcon(widget.category),
                        color: scheme.primary,
                        size: compact ? 18 : 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.s12),
                Expanded(
                  child: Text(
                    widget.category,
                    style: AppFonts.heading(widget.bp).copyWith(
                      fontSize: compact ? 15 : 17,
                      fontWeight: FontWeight.bold,
                      color: scheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.s12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              height: 2,
              width: _isHovered ? 60 : 24,
              decoration: BoxDecoration(
                color: _isHovered
                    ? scheme.primary
                    : scheme.primary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: scheme.primary.withValues(alpha: 0.5),
                          blurRadius: 4,
                        )
                      ]
                    : [],
              ),
            ),
            const SizedBox(height: AppSizes.s16),
            Expanded(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Wrap(
                  spacing: AppSizes.s8,
                  runSpacing: AppSizes.s8,
                  children: widget.skills.map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.s12,
                        vertical: AppSizes.s8,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.surface.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        border: Border.all(
                          color: scheme.outline.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Text(
                        skill,
                        style: AppFonts.body(widget.bp).copyWith(
                          fontSize: compact ? 11 : 12,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
