import 'models/experience_model.dart';
import 'models/skill_model.dart';

/// Centralized static data source for portfolio skills and experience.
class PortfolioData {
  const PortfolioData._();

  /// List of technical skills with SVG icon asset paths and categories.
  static const List<SkillModel> skills = [
    SkillModel(
      name: 'Flutter',
      iconPath: 'assets/icons/tech/flutter.svg',
      category: 'Mobile & Web',
    ),
    SkillModel(
      name: 'Dart',
      iconPath: 'assets/icons/tech/dart.svg',
      category: 'Language',
    ),
    SkillModel(
      name: 'BLoC / Cubit',
      iconPath: 'assets/icons/tech/bloc.svg',
      category: 'State Management',
    ),
    SkillModel(
      name: 'Firebase',
      iconPath: 'assets/icons/tech/firebase.svg',
      category: 'Backend',
    ),
    SkillModel(
      name: 'REST API',
      iconPath: 'assets/icons/tech/api.svg',
      category: 'Networking',
    ),
    SkillModel(
      name: 'Git & GitHub',
      iconPath: 'assets/icons/tech/git.svg',
      category: 'Tools',
    ),
    SkillModel(
      name: 'Figma',
      iconPath: 'assets/icons/tech/figma.svg',
      category: 'Design',
    ),
    SkillModel(
      name: 'CI / CD',
      iconPath: 'assets/icons/tech/cicd.svg',
      category: 'DevOps',
    ),
  ];

  /// Timeline of professional experiences using localization keys for strings.
  static const List<ExperienceModel> experiences = [
    ExperienceModel(
      companyKey: 'experience.items.logofy.company',
      roleKey: 'experience.items.logofy.role',
      durationKey: 'experience.items.logofy.duration',
      descriptionKey: 'experience.items.logofy.description',
      technologies: ['Flutter', 'Dart', 'BLoC', 'REST API', 'Figma'],
    ),
    ExperienceModel(
      companyKey: 'experience.items.edutech.company',
      roleKey: 'experience.items.edutech.role',
      durationKey: 'experience.items.edutech.duration',
      descriptionKey: 'experience.items.edutech.description',
      technologies: ['Flutter Web', 'easy_localization', 'BLoC', 'Firebase'],
    ),
  ];
}
