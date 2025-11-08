import 'package:equatable/equatable.dart';

/// Enum for the type of answer
enum AnswerType {
  text,
  audio,
  video,
}

/// Model representing a question answer with different media types
class QuestionAnswer extends Equatable {
  final String questionId;
  final String? textAnswer;
  final String? audioPath;
  final String? videoPath;
  final AnswerType? answerType;

  const QuestionAnswer({
    required this.questionId,
    this.textAnswer,
    this.audioPath,
    this.videoPath,
    this.answerType,
  });

  bool get hasTextAnswer => textAnswer != null && textAnswer!.isNotEmpty;
  bool get hasAudioAnswer => audioPath != null && audioPath!.isNotEmpty;
  bool get hasVideoAnswer => videoPath != null && videoPath!.isNotEmpty;
  bool get hasAnyAnswer => hasTextAnswer || hasAudioAnswer || hasVideoAnswer;

  QuestionAnswer copyWith({
    String? questionId,
    String? textAnswer,
    String? audioPath,
    String? videoPath,
    AnswerType? answerType,
  }) {
    return QuestionAnswer(
      questionId: questionId ?? this.questionId,
      textAnswer: textAnswer ?? this.textAnswer,
      audioPath: audioPath ?? this.audioPath,
      videoPath: videoPath ?? this.videoPath,
      answerType: answerType ?? this.answerType,
    );
  }

  QuestionAnswer clearAudio() {
    return QuestionAnswer(
      questionId: questionId,
      textAnswer: textAnswer,
      audioPath: null,
      videoPath: videoPath,
      answerType: hasVideoAnswer ? AnswerType.video : (hasTextAnswer ? AnswerType.text : null),
    );
  }

  QuestionAnswer clearVideo() {
    return QuestionAnswer(
      questionId: questionId,
      textAnswer: textAnswer,
      audioPath: audioPath,
      videoPath: null,
      answerType: hasAudioAnswer ? AnswerType.audio : (hasTextAnswer ? AnswerType.text : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'text_answer': textAnswer,
      'audio_path': audioPath,
      'video_path': videoPath,
      'answer_type': answerType?.name,
    };
  }

  @override
  List<Object?> get props => [questionId, textAnswer, audioPath, videoPath, answerType];
}
