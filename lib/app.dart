import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_texts.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/widgets/app_initial_loader.dart';
import 'features/cv/presentation/bloc/cv_cubit.dart';
import 'features/home/presentation/bloc/about_cubit.dart';
import 'features/home/presentation/bloc/experience_cubit.dart';
import 'features/home/presentation/bloc/scroll_cubit.dart';
import 'features/home/presentation/bloc/skills_cubit.dart';
import 'features/projects/presentation/bloc/projects_cubit.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => ScrollCubit()),
        BlocProvider(create: (_) => CvCubit()),
        BlocProvider(create: (_) => AboutCubit()..loadAbout()),
        BlocProvider(create: (_) => ProjectsCubit()..loadProjects()),
        BlocProvider(create: (_) => SkillsCubit()..loadSkills()),
        BlocProvider(create: (_) => ExperienceCubit()..loadExperiences()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: AppTexts.appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            routerConfig: AppRouter.router,
            builder: (context, child) {
              return AppInitialLoader(
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
