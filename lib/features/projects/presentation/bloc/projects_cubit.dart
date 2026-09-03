import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/projects_repository.dart';
import 'projects_state.dart';

/// Cubit managing projects state, loading, filtering, and selection.
class ProjectsCubit extends Cubit<ProjectsState> {
  ProjectsCubit({
    ProjectsRepository repository = const ProjectsRepository(),
  })  : _repository = repository,
        super(const ProjectsState());

  final ProjectsRepository _repository;

  /// Loads all projects and available tags from [ProjectsRepository].
  void loadProjects() {
    emit(state.copyWith(status: ProjectsStatus.loading));
    try {
      final projects = _repository.getProjects();
      final tags = _repository.getAllTags();

      emit(state.copyWith(
        status: ProjectsStatus.loaded,
        allProjects: projects,
        filteredProjects: projects,
        availableTags: tags,
        selectedTag: 'all',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProjectsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Filters projects by tag/category.
  void filterByTag(String tag) {
    try {
      final filtered = _repository.getProjectsByTag(tag);
      emit(state.copyWith(
        selectedTag: tag,
        filteredProjects: filtered,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProjectsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Selects a project by its [id]. Sets [selectedProject] to null if not found.
  void selectProjectById(String id) {
    try {
      final project = _repository.getProjectById(id);
      emit(state.copyWith(
        selectedProject: () => project,
      ));
    } catch (e) {
      emit(state.copyWith(
        selectedProject: () => null,
      ));
    }
  }

  /// Clears the currently selected project.
  void clearSelectedProject() {
    emit(state.copyWith(
      selectedProject: () => null,
    ));
  }
}
