import 'package:in_app_bot/in_app_bot/features/modes/product_mode/domain/entities/previous_product_entity.dart';

abstract class PreviousProductRepository {
  Future<PreviousProductEntity> checkPreviousProductQuestion(
      String question, String productbotId);
}
