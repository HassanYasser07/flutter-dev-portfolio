import 'package:equatable/equatable.dart';

import '../../data/models/skill_model.dart';

enum SkillsStatus { initial, loading, loaded, error }

class SkillsState extends Equatable {
  const SkillsState({
    this.status = SkillsStatus.initial,
    this.skills = const [],
    this.errorMessage,
  });

  final SkillsStatus status;
  final List<SkillModel> skills;
  final String? errorMessage;

  SkillsState copyWith({
    SkillsStatus? status,
    List<SkillModel>? skills,
    String? errorMessage,
  }) {
    return SkillsState(
      status: status ?? this.status,
      skills: skills ?? this.skills,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, skills, errorMessage];
}
