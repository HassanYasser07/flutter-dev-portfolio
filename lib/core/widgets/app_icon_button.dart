import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';

/// Icon action with a required tooltip — accessibility is non-negotiable.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.semanticLabel,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        minimumSize: const Size(AppSizes.minTapTarget, AppSizes.minTapTarget),
        maximumSize: const Size(AppSizes.s48, AppSizes.s48),
      ),
      constraints: const BoxConstraints(
        minWidth: AppSizes.minTapTarget,
        minHeight: AppSizes.minTapTarget,
      ),
    );
  }
}
