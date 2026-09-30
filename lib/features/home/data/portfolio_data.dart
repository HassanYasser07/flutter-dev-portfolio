import 'models/experience_model.dart';
import 'models/skill_model.dart';

/// Centralized static data source for portfolio skills and experience.
class PortfolioData {
  const PortfolioData._();

  /// List of technical skills with SVG icon asset paths and categories.
  static const List<SkillModel> skills = [
    SkillModel(
      category: 'Mobile',
      skills: ['Flutter', 'Dart', 'Android', 'iOS'],
    ),
    SkillModel(
      category: 'Web & Desktop',
      skills: ['Flutter Web', 'Flutter Desktop'],
    ),
    SkillModel(
      category: 'State Management',
      skills: ['BLoC / Cubit', 'ٌRiverpod'],
    ),
    SkillModel(
      category: 'Architecture',
      skills: ['  Clean Architecture', 'MVVM', 'Solid' ,'Repository Pattern'],
    ),
    SkillModel(
      category: 'Backend & APIs',
      skills: ['Rest APIs' , 'Firebase' ,'Firebase FCM', 'Dio' ,'Retrofit' ,'JSON Serialization'],
    ),
    SkillModel(
      category: 'Tools',
      skills: ['Git', 'GitHub', 'Postman'],
    ),
    SkillModel(
      category: 'Design',
      skills: ['Figma'],
    ),
    SkillModel(
      category: 'DevOps',
      skills: ['CI / CD', 'Codemagic'],
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
