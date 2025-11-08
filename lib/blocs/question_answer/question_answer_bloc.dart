import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotspot_hosts_flutter_assignment/blocs/question_answer/question_answer_event.dart';
import 'package:hotspot_hosts_flutter_assignment/blocs/question_answer/question_answer_state.dart';
import 'package:hotspot_hosts_flutter_assignment/models/question_answer.dart';

/// BLoC for managing question answers
class QuestionAnswerBloc extends Bloc<QuestionAnswerEvent, QuestionAnswerState> {
  final String questionId;

  QuestionAnswerBloc(this.questionId)
      : super(QuestionAnswerState(QuestionAnswer(questionId: questionId))) {
    on<UpdateTextAnswer>(_onUpdateTextAnswer);
    on<UpdateAudioAnswer>(_onUpdateAudioAnswer);
    on<UpdateVideoAnswer>(_onUpdateVideoAnswer);
    on<DeleteAudioAnswer>(_onDeleteAudioAnswer);
    on<DeleteVideoAnswer>(_onDeleteVideoAnswer);
    on<ClearAnswers>(_onClearAnswers);
  }

  /// Handle updating text answer
  void _onUpdateTextAnswer(
    UpdateTextAnswer event,
    Emitter<QuestionAnswerState> emit,
  ) {
    emit(QuestionAnswerState(
      state.answer.copyWith(
        textAnswer: event.text,
        answerType: AnswerType.text,
      ),
    ));
  }

  /// Handle updating audio answer
  void _onUpdateAudioAnswer(
    UpdateAudioAnswer event,
    Emitter<QuestionAnswerState> emit,
  ) {
    emit(QuestionAnswerState(
      state.answer.copyWith(
        audioPath: event.audioPath,
        answerType: AnswerType.audio,
      ),
    ));
  }

  /// Handle updating video answer
  void _onUpdateVideoAnswer(
    UpdateVideoAnswer event,
    Emitter<QuestionAnswerState> emit,
  ) {
    emit(QuestionAnswerState(
      state.answer.copyWith(
        videoPath: event.videoPath,
        answerType: AnswerType.video,
      ),
    ));
  }

  /// Handle deleting audio answer
  void _onDeleteAudioAnswer(
    DeleteAudioAnswer event,
    Emitter<QuestionAnswerState> emit,
  ) {
    emit(QuestionAnswerState(state.answer.clearAudio()));
  }

  /// Handle deleting video answer
  void _onDeleteVideoAnswer(
    DeleteVideoAnswer event,
    Emitter<QuestionAnswerState> emit,
  ) {
    emit(QuestionAnswerState(state.answer.clearVideo()));
  }

  /// Handle clearing all answers
  void _onClearAnswers(
    ClearAnswers event,
    Emitter<QuestionAnswerState> emit,
  ) {
    emit(QuestionAnswerState(QuestionAnswer(questionId: questionId)));
  }
}
