import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/projects_repository.dart';
import 'projects_state.dart';

/// Cubit managing projects state, async loading, filtering, and selection.
class ProjectsCubit extends Cubit<ProjectsState> {
  ProjectsCubit({
    ProjectsRepository repository = const ProjectsRepository(),
  })  : _repository = repository,
        super(const ProjectsState());

  final ProjectsRepository _repository;

  /// Loads all projects asynchronously from Supabase via [ProjectsRepository].
  Future<void> loadProjects() async {
    emit(state.copyWith(status: ProjectsStatus.loading));
    try {
      final projects = await _repository.getProjects();
      final tags = _repository.getAllTags(projects);

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

  /// Filters projects by [tag]/category from the already-loaded list.
  void filterByTag(String tag) {
    try {
      final filtered = _repository.filterByTag(state.allProjects, tag);
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

  /// Loads and selects a project by its [id] from Supabase.
  ///
  /// Emits [ProjectsStatus.loading] immediately, then [ProjectsStatus.loaded]
  /// once the project is retrieved (or [ProjectsStatus.error] on failure).
  Future<void> selectProjectById(String id) async {
    emit(state.copyWith(status: ProjectsStatus.loading));
    try {
      // Check in-memory cache first (avoids a round-trip if already loaded).
      final cached = state.allProjects.where((p) => p.id == id).firstOrNull;
      if (cached != null) {
        emit(state.copyWith(
          status: ProjectsStatus.loaded,
          selectedProject: () => cached,
        ));
        return;
      }

      // Fall back to fetching from Supabase.
      final project = await _repository.getProjectById(id);
      emit(state.copyWith(
        status: project != null ? ProjectsStatus.loaded : ProjectsStatus.error,
        selectedProject: () => project,
        errorMessage: project == null ? 'Project not found.' : null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProjectsStatus.error,
        selectedProject: () => null,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Clears the currently selected project.
  void clearSelectedProject() {
    emit(state.copyWith(selectedProject: () => null));
  }
}
