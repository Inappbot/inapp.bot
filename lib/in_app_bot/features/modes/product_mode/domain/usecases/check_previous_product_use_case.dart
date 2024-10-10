import 'package:in_app_bot/in_app_bot/features/modes/product_mode/domain/entities/previous_product_entity.dart';
import 'package:in_app_bot/in_app_bot/features/modes/product_mode/domain/repositories/previous_product_repository.dart';

class CheckPreviousProductUseCase {
  final PreviousProductRepository repository;

  CheckPreviousProductUseCase(this.repository);

  Future<PreviousProductEntity> execute(
      String question, String productbotId) async {
    return await repository.checkPreviousProductQuestion(
        question, productbotId);
  }
}
