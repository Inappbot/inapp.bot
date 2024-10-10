import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/data/repositories/third_page_animation_repository.dart';
import 'package:in_app_bot/playground/onboarding/domain/usecases/third_page_get_updated_titles_usecase.dart';
import 'package:in_app_bot/playground/onboarding/presentation/pages/third_page/widgets/animated/animation_view_model.dart';

final animationViewModelProvider = Provider((ref) => AnimationViewModel(
    ThirdLottieAnimationRepository(), GetUpdatedTitlesUseCase()));
