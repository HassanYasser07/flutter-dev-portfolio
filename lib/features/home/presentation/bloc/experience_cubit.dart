import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/experience_repository.dart';
import 'experience_state.dart';

/// Cubit managing experience timeline data loading from [ExperienceRepository].
class ExperienceCubit extends Cubit<ExperienceState> {
  ExperienceCubit({
    ExperienceRepository repository = const ExperienceRepository(),
  })  : _repository = repository,
        super(const ExperienceState());

  final ExperienceRepository _repository;

  /// Loads experiences asynchronously from Supabase.
  Future<void> loadExperiences() async {
    emit(state.copyWith(status: ExperienceStatus.loading));
    try {
      final experiences = await _repository.getExperiences();
      emit(state.copyWith(
        status: ExperienceStatus.loaded,
        experiences: experiences,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ExperienceStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
