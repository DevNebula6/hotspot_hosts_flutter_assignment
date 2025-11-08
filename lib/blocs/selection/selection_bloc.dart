import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotspot_hosts_flutter_assignment/blocs/selection/selection_event.dart';
import 'package:hotspot_hosts_flutter_assignment/blocs/selection/selection_state.dart';

/// BLoC for managing experience selections
class SelectionBloc extends Bloc<SelectionEvent, SelectionState> {
  SelectionBloc() : super(const SelectionState()) {
    on<ToggleExperienceSelection>(_onToggleExperienceSelection);
    on<UpdateExperienceNote>(_onUpdateExperienceNote);
    on<ClearSelections>(_onClearSelections);
  }

  /// Handle toggling experience selection
  void _onToggleExperienceSelection(
    ToggleExperienceSelection event,
    Emitter<SelectionState> emit,
  ) {
    final newSelections = Map<int, String>.from(state.selectedExperiences);
    
    if (newSelections.containsKey(event.experienceId)) {
      // Remove if already selected
      newSelections.remove(event.experienceId);
    } else {
      // Add with empty note if not selected
      newSelections[event.experienceId] = '';
    }
    
    emit(state.copyWith(selectedExperiences: newSelections));
  }

  /// Handle updating experience note
  void _onUpdateExperienceNote(
    UpdateExperienceNote event,
    Emitter<SelectionState> emit,
  ) {
    if (state.selectedExperiences.containsKey(event.experienceId)) {
      final newSelections = Map<int, String>.from(state.selectedExperiences);
      newSelections[event.experienceId] = event.note;
      emit(state.copyWith(selectedExperiences: newSelections));
    }
  }

  /// Handle clearing all selections
  void _onClearSelections(
    ClearSelections event,
    Emitter<SelectionState> emit,
  ) {
    emit(const SelectionState());
  }
}
