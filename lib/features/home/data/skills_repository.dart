import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/skill_model.dart';

/// Repository for fetching skills data from Supabase.
class SkillsRepository {
  const SkillsRepository({SupabaseClient? supabaseClient})
      : _supabaseClient = supabaseClient;

  final SupabaseClient? _supabaseClient;

  SupabaseClient get _client => _supabaseClient ?? Supabase.instance.client;

  /// Fetches active skills from the `skills` table in Supabase ordered by `sort_order` ascending.
  Future<List<SkillModel>> getSkills() async {
    final response = await _client
        .from('skills')
        .select()
        .eq('is_active', true)
        .order('sort_order', ascending: true);

    return (response as List<dynamic>)
        .map((json) => SkillModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
