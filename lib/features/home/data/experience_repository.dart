import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/experience_model.dart';

/// Repository for fetching experience entries from Supabase.
class ExperienceRepository {
  const ExperienceRepository({SupabaseClient? supabaseClient})
      : _supabaseClient = supabaseClient;

  final SupabaseClient? _supabaseClient;

  SupabaseClient get _client => _supabaseClient ?? Supabase.instance.client;

  /// Fetches active experiences from the `experience` table in Supabase ordered by `sort_order` ascending.
  Future<List<ExperienceModel>> getExperiences() async {
    final response = await _client
        .from('experience')
        .select()
        .eq('is_active', true)
        .order('sort_order', ascending: true);

    return (response as List<dynamic>)
        .map((json) => ExperienceModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
