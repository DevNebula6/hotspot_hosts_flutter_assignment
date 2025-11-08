import 'package:equatable/equatable.dart';

/// Model representing a selected experience with user's note
class SelectedExperience extends Equatable {
  final int experienceId;
  final String note;

  const SelectedExperience({
    required this.experienceId,
    required this.note,
  });

  SelectedExperience copyWith({
    int? experienceId,
    String? note,
  }) {
    return SelectedExperience(
      experienceId: experienceId ?? this.experienceId,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'experience_id': experienceId,
      'note': note,
    };
  }

  @override
  List<Object?> get props => [experienceId, note];
}
