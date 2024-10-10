import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/domain/usecases/lottie_animation_use_case.dart';
import 'package:in_app_bot/playground/onboarding/domain/usecases/third_page_get_updated_titles_usecase.dart';

class AnimationViewModel {
  final LottieAnimationUseCase _lottieAnimationUseCase;
  final GetUpdatedTitlesUseCase _getUpdatedTitlesUseCase;

  AnimationViewModel(
      this._lottieAnimationUseCase, this._getUpdatedTitlesUseCase);

  String getAnimationPath(int index) {
    return _lottieAnimationUseCase.getAnimationPath(index);
  }

  Map<int, String> getUpdatedTitles(WidgetRef ref) {
    return _getUpdatedTitlesUseCase.execute(ref);
  }
}
