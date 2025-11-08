import 'package:equatable/equatable.dart';

/// Model representing an experience/activity that hosts can offer
class Experience extends Equatable {
  final int id;
  final String name;
  final String tagline;
  final String description;
  final String imageUrl;
  final String iconUrl;

  const Experience({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.imageUrl,
    required this.iconUrl,
  });

  /// Create Experience from JSON
  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'] as int,
      name: json['name'] as String,
      tagline: json['tagline'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String,
      iconUrl: json['icon_url'] as String? ?? '',
    );
  }

  /// Convert Experience to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'description': description,
      'image_url': imageUrl,
      'icon_url': iconUrl,
    };
  }

  Experience copyWith({
    int? id,
    String? name,
    String? tagline,
    String? description,
    String? imageUrl,
    String? iconUrl,
  }) {
    return Experience(
      id: id ?? this.id,
      name: name ?? this.name,
      tagline: tagline ?? this.tagline,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }

  @override
  List<Object?> get props => [id, name, tagline, description, imageUrl, iconUrl];
}
