import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Data model representing a portfolio project fetched from Supabase.
@immutable
class ProjectModel extends Equatable {
  const ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
    required this.imageUrls,
    this.thumbnailUrl,
    this.videoUrl,
    this.githubUrl,
    this.liveUrl,
    this.sortOrder,
    this.isActive,
  });

  final String id;

  /// The display title of the project (plain text from Supabase, not a locale key).
  final String title;

  /// The description of the project (plain text from Supabase, not a locale key).
  final String description;

  /// Technology/category tags, parsed from the `tags_text` column.
  final List<String> tags;

  /// Ordered list of image URLs from the `project_images` table.
  final List<String> imageUrls;

  /// Thumbnail URL from the `projects.thumbnail_url` column. May be null.
  final String? thumbnailUrl;

  /// Video URL from the `projects.video_url` column. May be null.
  final String? videoUrl;

  final String? githubUrl;
  final String? liveUrl;
  final int? sortOrder;
  final bool? isActive;

  factory ProjectModel.fromJson(
    Map<String, dynamic> json, {
    List<String> imageUrls = const [],
  }) {
    final tagsRaw = json['tags'] ?? json['tags_text'];
    final List<String> tagsList = switch (tagsRaw) {
      List list => list.map((e) => e.toString()).toList(),
      String str => [str],
      _ => const <String>[],
    };

    return ProjectModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      tags: tagsList,
      imageUrls: imageUrls,
      thumbnailUrl: json['thumbnail_url'] as String?,
      videoUrl: json['video_url'] as String?,
      githubUrl: json['github_url'] as String?,
      liveUrl: json['live_url'] as String?,
      sortOrder: json['sort_order'] != null
          ? (json['sort_order'] as num).toInt()
          : null,
      isActive: json['is_active'] as bool?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        tags,
        imageUrls,
        thumbnailUrl,
        videoUrl,
        githubUrl,
        liveUrl,
        sortOrder,
        isActive,
      ];
}
