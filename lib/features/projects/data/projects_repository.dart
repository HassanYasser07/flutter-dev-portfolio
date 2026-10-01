import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/project_model.dart';

/// Repository for fetching projects and their images from Supabase.
///
/// Fetch flow:
/// 1. Query `projects` (is_active=true, ordered by sort_order ASC).
/// 2. For each project, query `project_images` matching project_id
///    (is_active=true, ordered by sort_order ASC).
/// 3. Return assembled [ProjectModel] list with image URLs attached.
class ProjectsRepository {
  const ProjectsRepository({SupabaseClient? supabaseClient})
      : _supabaseClient = supabaseClient;

  final SupabaseClient? _supabaseClient;

  SupabaseClient get _client => _supabaseClient ?? Supabase.instance.client;

  /// Fetches active projects from Supabase, ordered by [sort_order] ASC,
  /// with each project's active images loaded and ordered by [sort_order] ASC.
  Future<List<ProjectModel>> getProjects() async {
    // 1. Fetch active projects ordered by sort_order.
    final projectsResponse = await _client
        .from('projects')
        .select()
        .eq('is_active', true)
        .order('sort_order', ascending: true);

    final projectRows = projectsResponse as List<dynamic>;

    if (projectRows.isEmpty) return const [];

    // 2. Collect all project IDs for a single batch image query.
    final projectIds =
        projectRows.map((r) => (r as Map<String, dynamic>)['id']).toList();

    // 3. Fetch all active project_images for these projects in one query.
    final imagesResponse = await _client
        .from('project_images')
        .select()
        .inFilter('project_id', projectIds)
        .eq('is_active', true)
        .order('sort_order', ascending: true);

    final imageRows = imagesResponse as List<dynamic>;

    // 4. Group images by project_id.
    final Map<String, List<String>> imagesByProjectId = {};
    for (final row in imageRows) {
      final map = row as Map<String, dynamic>;
      final projectId = map['project_id']?.toString() ?? '';
      final imageUrl = map['image_url'] as String?;
      if (projectId.isNotEmpty && imageUrl != null && imageUrl.isNotEmpty) {
        imagesByProjectId.putIfAbsent(projectId, () => []).add(imageUrl);
      }
    }

    // 5. Assemble ProjectModel instances.
    return projectRows.map((row) {
      final json = row as Map<String, dynamic>;
      final id = json['id']?.toString() ?? '';
      return ProjectModel.fromJson(
        json,
        imageUrls: imagesByProjectId[id] ?? const [],
      );
    }).toList();
  }

  /// Retrieves a project by its unique [id].
  /// Returns `null` if no active project with that id exists.
  Future<ProjectModel?> getProjectById(String id) async {
    if (id.isEmpty) return null;

    final projectResponse = await _client
        .from('projects')
        .select()
        .eq('id', id)
        .eq('is_active', true)
        .maybeSingle();

    if (projectResponse == null) return null;

    final imagesResponse = await _client
        .from('project_images')
        .select()
        .eq('project_id', id)
        .eq('is_active', true)
        .order('sort_order', ascending: true);

    final imageUrls = (imagesResponse as List<dynamic>)
        .map((r) => (r as Map<String, dynamic>)['image_url'] as String?)
        .whereType<String>()
        .where((url) => url.isNotEmpty)
        .toList();

    return ProjectModel.fromJson(
      projectResponse,
      imageUrls: imageUrls,
    );
  }

  /// Filters projects by [tag]. Pass an empty string or `'all'` to get all.
  List<ProjectModel> filterByTag(List<ProjectModel> projects, String tag) {
    if (tag.isEmpty || tag.toLowerCase() == 'all') return projects;
    return projects
        .where((p) => p.tags.any((t) => t.toLowerCase() == tag.toLowerCase()))
        .toList();
  }

  /// Returns all unique tags across the provided [projects] list.
  List<String> getAllTags(List<ProjectModel> projects) {
    final tagsSet = <String>{};
    for (final project in projects) {
      tagsSet.addAll(project.tags);
    }
    return tagsSet.toList();
  }
}
