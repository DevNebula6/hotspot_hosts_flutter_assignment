import 'package:equatable/equatable.dart';

/// Base class for Experience events
abstract class ExperienceEvent extends Equatable {
  const ExperienceEvent();

  @override
  List<Object> get props => [];
}

/// Event to fetch experiences from API
class FetchExperiences extends ExperienceEvent {
  const FetchExperiences();
}

/// Event to retry fetching experiences after an error
class RetryFetchExperiences extends ExperienceEvent {
  const RetryFetchExperiences();
}
