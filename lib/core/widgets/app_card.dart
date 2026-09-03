import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';
import '../utils/responsive.dart';

/// Quiet surface used for skills, project placeholders, and info blocks.
class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onPressed,
    this.padding,
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final String? semanticLabel;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final animate = shouldAnimate(context);
    final hoverEnabled = canHover && widget.onPressed != null;

    final content = AnimatedScale(
      scale: (hoverEnabled && _hovered) ? 1.01 : 1,
      duration: animate ? AppMotion.hover : Duration.zero,
      curve: AppMotion.easeOutCubic,
      child: AnimatedContainer(
        duration: animate ? AppMotion.hover : Duration.zero,
        curve: AppMotion.easeOutCubic,
        padding: widget.padding ?? const EdgeInsets.all(AppSizes.s24),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          border: Border.all(
            color: _hovered ? scheme.outlineVariant : scheme.outline,
          ),
        ),
        child: widget.child,
      ),
    );

    if (widget.onPressed == null) {
      return content;
    }

    return MouseRegion(
      onEnter: hoverEnabled ? (_) => setState(() => _hovered = true) : null,
      onExit: hoverEnabled ? (_) => setState(() => _hovered = false) : null,
      child: Semantics(
        button: true,
        label: widget.semanticLabel,
        child: OutlinedButton(
          onPressed: widget.onPressed,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusXl),
            ),
            backgroundColor: Colors.transparent,
            overlayColor: scheme.secondary.withValues(alpha: 0.06),
          ),
          child: content,
        ),
      ),
    );
  }
}
