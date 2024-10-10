import 'package:in_app_bot/in_app_bot/features/user/domain/repositories/user_repository.dart';

/// Use case for saving a user
class SaveUserUseCase {
  final UserRepository _userRepository;

  /// Constructor that receives an instance of [UserRepository]
  SaveUserUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  /// Executes the use case
  ///
  /// [appUserId] is the user ID in the application
  /// Returns a [Future] that completes when the user has been saved
  /// May throw a [SaveUserException] if an error occurs during the process
  Future<void> execute(String appUserId) async {
    try {
      // We use await and return the Future to properly handle the result
      return await _userRepository.saveUser(appUserId);
    } catch (e) {
      // We transform any exception into a SaveUserException
      throw SaveUserException('Error saving the user: ${e.toString()}');
    }
  }
}

/// Custom exception for errors in the save user use case
class SaveUserException implements Exception {
  final String message;

  SaveUserException(this.message);

  @override
  String toString() => 'SaveUserException: $message';
}
