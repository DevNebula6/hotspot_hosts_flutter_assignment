import 'package:equatable/equatable.dart';

/// Base class for API result states
sealed class Result<T> extends Equatable {
  const Result();
}

/// Success state with data
class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  List<Object?> get props => [data];
}

/// Loading state
class Loading<T> extends Result<T> {
  const Loading();

  @override
  List<Object?> get props => [];
}

/// Error state with message
class Error<T> extends Result<T> {
  final String message;
  final Exception? exception;

  const Error(this.message, [this.exception]);

  @override
  List<Object?> get props => [message, exception];
}
