import 'package:in_app_bot/in_app_bot/features/user/domain/usecases/save_user_usecase.dart';

/// Presenter to handle presentation logic related to users
class UserPresenter {
  final SaveUserUseCase _saveUserUseCase;

  /// Constructor that receives an instance of [SaveUserUseCase]
  UserPresenter({required SaveUserUseCase saveUserUseCase})
      : _saveUserUseCase = saveUserUseCase;

  /// Saves a user
  ///
  /// [appUserId] is the user ID in the application
  /// Returns a [Future] that completes when the user has been saved
  /// May throw a [UserPresenterException] if an error occurs during the process
  Future<void> saveUser(String appUserId) async {
    try {
      // We use await and return the Future to properly handle the result
      return await _saveUserUseCase.execute(appUserId);
    } catch (e) {
      // We transform any exception into a UserPresenterException
      throw UserPresenterException('Error saving the user: ${e.toString()}');
    }
  }
}

/// Custom exception for errors in the presentation layer
class UserPresenterException implements Exception {
  final String message;

  UserPresenterException(this.message);

  @override
  String toString() => 'UserPresenterException: $message';
}
