import 'models/project_model.dart';

/// Repository responsible for providing portfolio projects from static local data.
class ProjectsRepository {
  const ProjectsRepository();

  static const List<ProjectModel> _projects = [
    ProjectModel(
      id: 'logofy',
      titleKey: 'projects.items.logofy.title',
      descriptionKey: 'projects.items.logofy.description',
      tags: ['Flutter', 'Dart', 'BLoC', 'AI'],
      thumbAsset: 'assets/images/projects/logo_maker/logo.png',
      screenshotAssets: [
        'assets/images/projects/logo_maker/logo.png',
        'assets/images/projects/logo_maker/logo.png',
      ],
      videoAsset: 'assets/videos/projects/logofy/demo.mp4',
      githubUrl: 'https://github.com/HassanYasser07',
      liveUrl:
          'https://play.google.com/store/apps/details?id=com.logofy.logogenerator.app',
    ),
    ProjectModel(
      id: 'tutoring',
      titleKey: 'projects.items.tutoring.title',
      descriptionKey: 'projects.items.tutoring.description',
      tags: ['Flutter Web', 'easy_localization', 'BLoC'],
      thumbAsset: 'assets/images/projects/logo_maker/logo.png',
      screenshotAssets: [
        'assets/images/projects/logo_maker/logo.png',
      ],
      videoAsset: null,
      githubUrl:
          'https://github.com/HassanYasser07/intelligent_tutoring_system',
      liveUrl: null,
    ),
    ProjectModel(
      id: 'portfolio',
      titleKey: 'projects.items.portfolio.title',
      descriptionKey: 'projects.items.portfolio.description',
      tags: ['Flutter Web', 'Clean Architecture', 'BLoC', 'i18n'],
      thumbAsset: 'assets/images/projects/portfolio/thumb.png',
      screenshotAssets: [
        'assets/images/projects/portfolio/screenshot_1.png',
      ],
      videoAsset: null,
      githubUrl: 'https://github.com/HassanYasser07/portfolio',
      liveUrl: null,
    ),
  ];

  /// Retrieves all portfolio projects.
  List<ProjectModel> getProjects() => _projects;

  /// Retrieves a project by its unique [id], returning `null` if not found.
  ProjectModel? getProjectById(String id) {
    try {
      return _projects.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Filters projects containing the specified [tag].
  List<ProjectModel> getProjectsByTag(String tag) {
    if (tag.isEmpty || tag.toLowerCase() == 'all') {
      return _projects;
    }
    return _projects
        .where((p) => p.tags.any((t) => t.toLowerCase() == tag.toLowerCase()))
        .toList();
  }

  /// Returns a list of all unique tags across projects.
  List<String> getAllTags() {
    final tagsSet = <String>{};
    for (final project in _projects) {
      tagsSet.addAll(project.tags);
    }
    return tagsSet.toList();
  }
}
