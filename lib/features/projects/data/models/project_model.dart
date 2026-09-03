import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Data model representing a portfolio project.
@immutable
class ProjectModel extends Equatable {
  const ProjectModel({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.tags,
    required this.thumbAsset,
    required this.screenshotAssets,
    this.videoAsset,
    this.githubUrl,
    this.liveUrl,
  });

  final String id;
  final String titleKey;
  final String descriptionKey;
  final List<String> tags;
  final String thumbAsset;
  final List<String> screenshotAssets;
  final String? videoAsset;
  final String? githubUrl;
  final String? liveUrl;

  @override
  List<Object?> get props => [
        id,
        titleKey,
        descriptionKey,
        tags,
        thumbAsset,
        screenshotAssets,
        videoAsset,
        githubUrl,
        liveUrl,
      ];
}
