import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/about_repository.dart';
import 'about_state.dart';

/// Cubit managing About section data loading from [AboutRepository].
class AboutCubit extends Cubit<AboutState> {
  AboutCubit({
    AboutRepository repository = const AboutRepository(),
  })  : _repository = repository,
        super(const AboutState());

  final AboutRepository _repository;

  /// Loads About content asynchronously from Supabase.
  Future<void> loadAbout() async {
    emit(state.copyWith(status: AboutStatus.loading));
    try {
      final about = await _repository.getAbout();
      emit(state.copyWith(
        status: AboutStatus.loaded,
        about: () => about,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AboutStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
