import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define a FutureProvider to manage the onboarding state
final onBoardingProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('onboardingViewed') ?? false;
});

// Function to set the onboarding viewed status
Future<void> setOnboardingViewed(bool viewed) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('onboardingViewed', viewed);
}

// Define a provider for the SplashNotifier
final splashProvider = StateProvider<bool?>((ref) {
  final asyncState = ref.watch(onBoardingProvider);

  return asyncState.when(
    data: (state) => state,
    loading: () => null,
    error: (err, stack) => null,
  );
});
