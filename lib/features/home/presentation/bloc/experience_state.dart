import 'package:equatable/equatable.dart';

import '../../data/models/experience_model.dart';

enum ExperienceStatus { initial, loading, loaded, error }

class ExperienceState extends Equatable {
  const ExperienceState({
    this.status = ExperienceStatus.initial,
    this.experiences = const [],
    this.errorMessage,
  });

  final ExperienceStatus status;
  final List<ExperienceModel> experiences;
  final String? errorMessage;

  ExperienceState copyWith({
    ExperienceStatus? status,
    List<ExperienceModel>? experiences,
    String? errorMessage,
  }) {
    return ExperienceState(
      status: status ?? this.status,
      experiences: experiences ?? this.experiences,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, experiences, errorMessage];
}
