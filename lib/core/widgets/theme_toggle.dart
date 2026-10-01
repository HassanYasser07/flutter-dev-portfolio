import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/app_texts.dart';
import '../theme/theme_cubit.dart';
import 'app_icon_button.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        final isDark = mode == ThemeMode.dark;
        final tooltip = isDark ? AppTexts.themeToLight : AppTexts.themeToDark;
        return AppIconButton(
          icon: isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          tooltip: tooltip,
          onPressed: () => context.read<ThemeCubit>().toggle(),
        );
      },
    );
  }
}
