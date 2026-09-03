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
  });

  final String companyKey;
  final String roleKey;
  final String durationKey;
  final String descriptionKey;
  final List<String> technologies;

  @override
  List<Object?> get props => [
        companyKey,
        roleKey,
        durationKey,
        descriptionKey,
        technologies,
      ];
}
