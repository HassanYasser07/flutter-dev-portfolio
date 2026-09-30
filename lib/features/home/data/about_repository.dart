import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/about_model.dart';

/// Repository for fetching About section content from Supabase.
class AboutRepository {
  const AboutRepository({SupabaseClient? supabaseClient})
      : _supabaseClient = supabaseClient;

  final SupabaseClient? _supabaseClient;

  SupabaseClient get _client => _supabaseClient ?? Supabase.instance.client;

  /// Fetches the active About record from the `about` table where `is_active = true`.
  Future<AboutModel?> getAbout() async {
    final response = await _client
        .from('about')
        .select()
        .eq('is_active', true)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;
    return AboutModel.fromJson(response);
  }
}
