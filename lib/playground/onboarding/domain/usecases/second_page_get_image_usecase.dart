import 'package:in_app_bot/playground/onboarding/domain/entities/second_page_image_entity.dart';

class GetImageUseCase {
  ImageEntity call(double screenWidth) {
    final double imageSize = screenWidth * 0.5;
    return ImageEntity(
      imagePath: 'lib/playground/onboarding/assets/images/hand.webp',
      size: imageSize,
    );
  }
}
