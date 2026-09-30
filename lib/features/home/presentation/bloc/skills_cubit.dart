import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/skills_repository.dart';
import 'skills_state.dart';

/// Cubit managing skills data loading from [SkillsRepository].
class SkillsCubit extends Cubit<SkillsState> {
  SkillsCubit({
    SkillsRepository repository = const SkillsRepository(),
  })  : _repository = repository,
        super(const SkillsState());

  final SkillsRepository _repository;

  /// Loads skills asynchronously from Supabase.
  Future<void> loadSkills() async {
    emit(state.copyWith(status: SkillsStatus.loading));
    try {
      final skills = await _repository.getSkills();
      emit(state.copyWith(
        status: SkillsStatus.loaded,
        skills: skills,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SkillsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
