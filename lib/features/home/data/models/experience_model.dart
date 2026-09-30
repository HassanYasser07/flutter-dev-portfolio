import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Data model representing a professional experience / role timeline entry.
@immutable
class ExperienceModel extends Equatable {
  const ExperienceModel({
    required this.companyKey,
    required this.roleKey,
    required this.durationKey,
    required this.descriptionKey,
    required this.technologies,
    this.id,
    this.sortOrder,
    this.isActive,
  });

  final String? id;
  final String companyKey;
  final String roleKey;
  final String durationKey;
  final String descriptionKey;
  final List<String> technologies;
  final int? sortOrder;
  final bool? isActive;

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    final techRaw = json['technologies'] ??
        json['tech_stack'] ??
        json['skills'] ??
        json['techs'];
    final List<String> techList = switch (techRaw) {
      List list => list.map((e) => e.toString()).toList(),
      String str => [str],
      _ => const <String>[],
    };

    final company =
        json['company'] ?? json['company_name'] ?? json['company_title'] ?? '';
    final role = json['role'] ??
        json['title'] ??
        json['job_title'] ??
        json['role_title'] ??
        '';
    final duration = json['date'] ??
        json['duration'] ??
        json['period'] ??
        json['time'] ??
        json['dates'] ??
        '';
    final description = json['description'] ??
        json['details'] ??
        json['desc'] ??
        json['summary'] ??
        '';

    return ExperienceModel(
      id: json['id']?.toString(),
      companyKey: company.toString(),
      roleKey: role.toString(),
      durationKey: duration.toString(),
      descriptionKey: description.toString(),
      technologies: techList,
      sortOrder: json['sort_order'] != null
          ? (json['sort_order'] as num).toInt()
          : (json['order'] != null ? (json['order'] as num).toInt() : null),
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        companyKey,
        roleKey,
        durationKey,
        descriptionKey,
        technologies,
        sortOrder,
        isActive,
      ];
}
