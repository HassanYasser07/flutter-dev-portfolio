import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Data model representing the About section content fetched from Supabase.
@immutable
class AboutModel extends Equatable {
  const AboutModel({
    required this.title,
    required this.description,
    this.id,
    this.imageUrl,
    this.isActive,
  });

  final String? id;
  final String title;
  final String description;
  final String? imageUrl;
  final bool? isActive;

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    final titleVal = json['title'] ?? json['who_i_am'] ?? json['header'] ?? '';
    final descVal = json['description'] ??
        json['body'] ??
        json['content'] ??
        json['text'] ??
        '';
    final imageVal = json['image_url'] ??
        json['imageUrl'] ??
        json['image'] ??
        json['avatar_url'];

    return AboutModel(
      id: json['id']?.toString(),
      title: titleVal.toString(),
      description: descVal.toString(),
      imageUrl: imageVal?.toString(),
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool?,
    );
  }

  @override
  List<Object?> get props => [id, title, description, imageUrl, isActive];
}
