import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Data model representing a technical skill category and its tools.
@immutable
class SkillModel extends Equatable {
  const SkillModel({
    required this.category,
    required this.skills,
    this.iconPath = '',
  });

  final String category;
  final List<String> skills;
  final String iconPath;

  @override
  List<Object?> get props => [
        category,
        skills,
        iconPath,
      ];
}
