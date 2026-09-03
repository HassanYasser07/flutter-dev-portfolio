import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Data model representing a technical skill or tool.
@immutable
class SkillModel extends Equatable {
  const SkillModel({
    required this.name,
    required this.iconPath,
    required this.category,
  });

  final String name;
  final String iconPath;
  final String category;

  @override
  List<Object?> get props => [
        name,
        iconPath,
        category,
      ];
}
