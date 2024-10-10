import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/user/data/repositories/user_repository_impl.dart';
import 'package:in_app_bot/in_app_bot/features/user/data/services/firestore_service.dart';
import 'package:in_app_bot/in_app_bot/features/user/domain/repositories/user_repository.dart';
import 'package:in_app_bot/in_app_bot/features/user/domain/usecases/save_user_usecase.dart';
import 'package:in_app_bot/in_app_bot/features/user/presentation/presenters/user_presenter.dart';

/// Provider for the Firestore service
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

/// Provider for the user repository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return UserRepositoryImpl(firestoreService: firestoreService);
});

/// Provider for the save user use case
final saveUserUseCaseProvider = Provider<SaveUserUseCase>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return SaveUserUseCase(userRepository: userRepository);
});

/// Provider for the user presenter
final userPresenterProvider = Provider<UserPresenter>((ref) {
  final saveUserUseCase = ref.watch(saveUserUseCaseProvider);
  return UserPresenter(saveUserUseCase: saveUserUseCase);
});

/// State provider to handle the user saving process
final saveUserStateProvider =
    StateNotifierProvider<SaveUserNotifier, SaveUserState>((ref) {
  final presenter = ref.watch(userPresenterProvider);
  return SaveUserNotifier(presenter);
});

/// State notifier for the user saving process
class SaveUserNotifier extends StateNotifier<SaveUserState> {
  final UserPresenter _presenter;

  SaveUserNotifier(this._presenter) : super(SaveUserState.initial());

  Future<void> saveUser(String appUserId) async {
    state = SaveUserState.loading();
    try {
      // We explicitly use the Future result
      final result = _presenter.saveUser(appUserId);
      await result.then((_) {
        // The Future completed without errors
        state = SaveUserState.success();
      });
    } on UserPresenterException catch (e) {
      state = SaveUserState.error(e.toString());
    } catch (e) {
      state = SaveUserState.error('Unexpected error: ${e.toString()}');
    }
  }
}

/// State for the user saving process
class SaveUserState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  SaveUserState({
    required this.isLoading,
    this.error,
    required this.isSuccess,
  });

  factory SaveUserState.initial() =>
      SaveUserState(isLoading: false, isSuccess: false);
  factory SaveUserState.loading() =>
      SaveUserState(isLoading: true, isSuccess: false);
  factory SaveUserState.success() =>
      SaveUserState(isLoading: false, isSuccess: true);
  factory SaveUserState.error(String message) =>
      SaveUserState(isLoading: false, isSuccess: false, error: message);
}
