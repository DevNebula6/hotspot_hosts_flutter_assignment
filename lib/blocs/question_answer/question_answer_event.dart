import 'package:equatable/equatable.dart';

/// Base class for QuestionAnswer events
abstract class QuestionAnswerEvent extends Equatable {
  const QuestionAnswerEvent();

  @override
  List<Object?> get props => [];
}

/// Event to update text answer
class UpdateTextAnswer extends QuestionAnswerEvent {
  final String text;

  const UpdateTextAnswer(this.text);

  @override
  List<Object> get props => [text];
}

/// Event to update audio answer
class UpdateAudioAnswer extends QuestionAnswerEvent {
  final String audioPath;

  const UpdateAudioAnswer(this.audioPath);

  @override
  List<Object> get props => [audioPath];
}

/// Event to update video answer
class UpdateVideoAnswer extends QuestionAnswerEvent {
  final String videoPath;

  const UpdateVideoAnswer(this.videoPath);

  @override
  List<Object> get props => [videoPath];
}

/// Event to delete audio answer
class DeleteAudioAnswer extends QuestionAnswerEvent {
  const DeleteAudioAnswer();
}

/// Event to delete video answer
class DeleteVideoAnswer extends QuestionAnswerEvent {
  const DeleteVideoAnswer();
}

/// Event to clear all answers
class ClearAnswers extends QuestionAnswerEvent {
  const ClearAnswers();
}
