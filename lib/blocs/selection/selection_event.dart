import 'package:equatable/equatable.dart';

/// Base class for Selection events
abstract class SelectionEvent extends Equatable {
  const SelectionEvent();

  @override
  List<Object> get props => [];
}

/// Event to toggle experience selection
class ToggleExperienceSelection extends SelectionEvent {
  final int experienceId;

  const ToggleExperienceSelection(this.experienceId);

  @override
  List<Object> get props => [experienceId];
}

/// Event to update note for an experience
class UpdateExperienceNote extends SelectionEvent {
  final int experienceId;
  final String note;

  const UpdateExperienceNote(this.experienceId, this.note);

  @override
  List<Object> get props => [experienceId, note];
}

/// Event to clear all selections
class ClearSelections extends SelectionEvent {
  const ClearSelections();
}
