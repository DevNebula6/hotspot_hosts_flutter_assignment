import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotspot_hosts_flutter_assignment/blocs/experience/experience_event.dart';
import 'package:hotspot_hosts_flutter_assignment/blocs/experience/experience_state.dart';
import 'package:hotspot_hosts_flutter_assignment/core/utils/result.dart';
import 'package:hotspot_hosts_flutter_assignment/repositories/experience_repository.dart';

/// BLoC for managing experiences data
class ExperienceBloc extends Bloc<ExperienceEvent, ExperienceState> {
  final ExperienceRepository _repository;

  ExperienceBloc(this._repository) : super(const ExperienceInitial()) {
    on<FetchExperiences>(_onFetchExperiences);
    on<RetryFetchExperiences>(_onRetryFetchExperiences);
  }

  /// Handle fetching experiences
  Future<void> _onFetchExperiences(
    FetchExperiences event,
    Emitter<ExperienceState> emit,
  ) async {
    emit(const ExperienceLoading());
    
    final result = await _repository.getExperiences();
    
    if (result is Success) {
      emit(ExperienceLoaded((result as Success).data));
    } else if (result is Error) {
      emit(ExperienceError((result as Error).message));
    }
  }

  /// Handle retry after error
  Future<void> _onRetryFetchExperiences(
    RetryFetchExperiences event,
    Emitter<ExperienceState> emit,
  ) async {
    await _onFetchExperiences(const FetchExperiences(), emit);
  }
}
