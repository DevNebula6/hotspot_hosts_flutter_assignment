import 'package:equatable/equatable.dart';
import 'package:hotspot_hosts_flutter_assignment/models/experience.dart';

/// Base class for Experience states
abstract class ExperienceState extends Equatable {
  const ExperienceState();

  @override
  List<Object> get props => [];
}

/// Initial state
class ExperienceInitial extends ExperienceState {
  const ExperienceInitial();
}

/// Loading state
class ExperienceLoading extends ExperienceState {
  const ExperienceLoading();
}

/// Success state with experiences data
class ExperienceLoaded extends ExperienceState {
  final List<Experience> experiences;

  const ExperienceLoaded(this.experiences);

  @override
  List<Object> get props => [experiences];
}

/// Error state
class ExperienceError extends ExperienceState {
  final String message;

  const ExperienceError(this.message);

  @override
  List<Object> get props => [message];
}
