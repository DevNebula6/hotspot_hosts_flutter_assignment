import 'package:hotspot_hosts_flutter_assignment/models/experience.dart';

class ExperiencesResponse {
  final String message;
  final ExperiencesData data;

  const ExperiencesResponse({
    required this.message,
    required this.data,
  });

  factory ExperiencesResponse.fromJson(Map<String, dynamic> json) {
    return ExperiencesResponse(
      message: json['message'] as String? ?? '',
      data: ExperiencesData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
    };
  }
}

/// Model representing the data field in experiences response
class ExperiencesData {
  final List<Experience> experiences;

  const ExperiencesData({
    required this.experiences,
  });

  factory ExperiencesData.fromJson(Map<String, dynamic> json) {
    final experiencesList = json['experiences'] as List<dynamic>? ?? [];
    return ExperiencesData(
      experiences: experiencesList
          .map((e) => Experience.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'experiences': experiences.map((e) => e.toJson()).toList(),
    };
  }
}
