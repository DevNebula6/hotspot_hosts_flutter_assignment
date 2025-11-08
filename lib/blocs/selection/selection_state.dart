import 'package:equatable/equatable.dart';
import 'package:hotspot_hosts_flutter_assignment/models/selected_experience.dart';

/// State for selected experiences
class SelectionState extends Equatable {
  final Map<int, String> selectedExperiences;

  const SelectionState({
    this.selectedExperiences = const {},
  });

  /// Check if experience is selected
  bool isSelected(int experienceId) => selectedExperiences.containsKey(experienceId);

  /// Get note for experience
  String getNote(int experienceId) => selectedExperiences[experienceId] ?? '';

  /// Get list of selected experience IDs
  List<int> get selectedIds => selectedExperiences.keys.toList();

  /// Get list of selected experiences with notes
  List<SelectedExperience> get selectedExperiencesList {
    return selectedExperiences.entries
        .map((entry) => SelectedExperience(
              experienceId: entry.key,
              note: entry.value,
            ))
        .toList();
  }

  /// Check if any experience is selected
  bool get hasSelections => selectedExperiences.isNotEmpty;

  SelectionState copyWith({
    Map<int, String>? selectedExperiences,
  }) {
    return SelectionState(
      selectedExperiences: selectedExperiences ?? this.selectedExperiences,
    );
  }

  @override
  List<Object> get props => [selectedExperiences];
}
