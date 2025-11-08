import 'package:equatable/equatable.dart';
import 'package:hotspot_hosts_flutter_assignment/models/question_answer.dart';

/// State for question answer
class QuestionAnswerState extends Equatable {
  final QuestionAnswer answer;

  const QuestionAnswerState(this.answer);

  /// Convenience getters
  bool get hasTextAnswer => answer.hasTextAnswer;
  bool get hasAudioAnswer => answer.hasAudioAnswer;
  bool get hasVideoAnswer => answer.hasVideoAnswer;
  bool get hasAnyAnswer => answer.hasAnyAnswer;

  String? get textAnswer => answer.textAnswer;
  String? get audioPath => answer.audioPath;
  String? get videoPath => answer.videoPath;
  AnswerType? get answerType => answer.answerType;

  QuestionAnswerState copyWith({
    QuestionAnswer? answer,
  }) {
    return QuestionAnswerState(answer ?? this.answer);
  }

  @override
  List<Object?> get props => [answer];
}
