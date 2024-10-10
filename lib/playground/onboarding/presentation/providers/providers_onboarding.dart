import 'package:flutter_riverpod/flutter_riverpod.dart';

class UIState {
  static final showMessage = StateProvider<bool>((ref) => false);
  static final showImage = StateProvider<bool>((ref) => false);
  static final showImage2 = StateProvider<bool>((ref) => false);
  static final currentPage = StateProvider<int>((ref) => 0);
  static final showForm = StateProvider<bool>((ref) => false);
  static final formOpacity = StateProvider<double>((ref) => 0.0);
  static final keyboardVisibility = StateProvider<bool>((ref) => false);
  static final videoState = StateProvider<bool>((ref) => false);
}

class AnimationState {
  static final progressAnimation = StateProvider<double>((ref) => 0.0);
  static final progressAnimation3 = StateProvider<double>((ref) => 0.0);
  static final lottieAnimationIndex = StateProvider<int>((ref) => 0);
  static final lottieAnimationIndex3 = StateProvider<int>((ref) => 0);
  static final lottieTitles = StateProvider<List<String>>((ref) => []);
  static final lottieTitles3 = StateProvider<List<String>>((ref) => []);
}

class AppConfig {
  static final language = StateProvider<String>((ref) => 'en');
}

class UIConfig {
  static final dropdownButtonEnabled = StateProvider<bool>((ref) => true);
}
