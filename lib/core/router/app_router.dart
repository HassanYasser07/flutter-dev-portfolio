import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/contact/presentation/views/contact_page.dart';
import '../../features/cv/presentation/views/cv_view.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../features/projects/presentation/views/project_detail_page.dart';
import '../../features/projects/presentation/views/projects_page.dart';
import '../constants/app_sizes.dart';

class AppRoutes {
  const AppRoutes._();

  static const String home = 'home';
  static const String projects = 'projects';
  static const String projectDetail = 'projectDetail';
  static const String projectGallery = 'projectGallery';
  static const String contact = 'contact';
  static const String cv = 'cv';
}

class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name: AppRoutes.home,
        path: '/',
        pageBuilder: (context, state) => _fade(state, const HomeView()),
      ),
      GoRoute(
        name: AppRoutes.projects,
        path: '/projects',
        pageBuilder: (context, state) => _fade(state, const ProjectsPage()),
      ),
      GoRoute(
        name: AppRoutes.projectDetail,
        path: '/project/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return _fade(state, ProjectDetailPage(projectId: id));
        },
        routes: [
          GoRoute(
            name: AppRoutes.projectGallery,
            path: 'gallery',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return _fade(state, ProjectGalleryPage(projectId: id));
            },
          ),
        ],
      ),
      GoRoute(
        name: AppRoutes.contact,
        path: '/contact',
        pageBuilder: (context, state) => _fade(state, const ContactPage()),
      ),
      GoRoute(
        name: AppRoutes.cv,
        path: '/cv',
        pageBuilder: (context, state) => _fade(state, const CvView()),
      ),
    ],
  );

  static CustomTransitionPage<void> _fade(GoRouterState state, Widget child) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      name: state.name,
      child: child,
      transitionDuration: AppMotion.route,
      reverseTransitionDuration: AppMotion.quick,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: AppMotion.easeInOut,
        );
        return FadeTransition(opacity: curved, child: child);
      },
    );
  }
}
