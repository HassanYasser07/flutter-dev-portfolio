import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Data model representing a technical skill category and its tools.
@immutable
class SkillModel extends Equatable {
  const SkillModel({
    required this.category,
    required this.skills,
    this.iconPath = '',
    this.id,
    this.sortOrder,
    this.isActive,
  });

  final String? id;
  final String category;
  final List<String> skills;
  final String iconPath;
  final int? sortOrder;
  final bool? isActive;

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    final skillsRaw = json['skills'];
    final List<String> skillsList = switch (skillsRaw) {
      List list => list.map((e) => e.toString()).toList(),
      String str => [str],
      _ => const <String>[],
    };

    return SkillModel(
      id: json['id'] as String?,
      category: json['category'] as String? ?? '',
      skills: skillsList,
      iconPath: json['icon_url'] as String? ?? '',
      sortOrder: json['sort_order'] != null
          ? (json['sort_order'] as num).toInt()
          : null,
      isActive: json['is_active'] as bool?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        category,
        skills,
        iconPath,
        sortOrder,
        isActive,
      ];
}
