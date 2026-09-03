import 'package:equatable/equatable.dart';

import '../../data/models/project_model.dart';

enum ProjectsStatus { initial, loading, loaded, error }

class ProjectsState extends Equatable {
  const ProjectsState({
    this.status = ProjectsStatus.initial,
    this.allProjects = const [],
    this.filteredProjects = const [],
    this.selectedProject,
    this.selectedTag = 'all',
    this.availableTags = const [],
    this.errorMessage,
  });

  final ProjectsStatus status;
  final List<ProjectModel> allProjects;
  final List<ProjectModel> filteredProjects;
  final ProjectModel? selectedProject;
  final String selectedTag;
  final List<String> availableTags;
  final String? errorMessage;

  ProjectsState copyWith({
    ProjectsStatus? status,
    List<ProjectModel>? allProjects,
    List<ProjectModel>? filteredProjects,
    ProjectModel? Function()? selectedProject,
    String? selectedTag,
    List<String>? availableTags,
    String? errorMessage,
  }) {
    return ProjectsState(
      status: status ?? this.status,
      allProjects: allProjects ?? this.allProjects,
      filteredProjects: filteredProjects ?? this.filteredProjects,
      selectedProject:
          selectedProject != null ? selectedProject() : this.selectedProject,
      selectedTag: selectedTag ?? this.selectedTag,
      availableTags: availableTags ?? this.availableTags,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allProjects,
        filteredProjects,
        selectedProject,
        selectedTag,
        availableTags,
        errorMessage,
      ];
}
