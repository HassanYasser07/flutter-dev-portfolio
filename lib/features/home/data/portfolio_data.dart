import 'models/experience_model.dart';

/// Centralized static data source for portfolio experience.
class PortfolioData {
  const PortfolioData._();

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
