import 'package:in_app_bot/in_app_bot/features/modes/index_mode/domain/repositories/index_previous_question_repository.dart';

class CheckPreviousQuestionUseCase {
  final PreviousQuestionRepository repository;

  CheckPreviousQuestionUseCase(this.repository);

  Future<String?> execute(String question) async {
    return await repository.checkPreviousQuestion(question);
  }
}
