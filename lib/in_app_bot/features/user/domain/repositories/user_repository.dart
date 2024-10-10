/// Abstract interface that defines the operations of the user repository
abstract class UserRepository {
  /// Saves a user in the repository
  ///
  /// [appUserId] is the user ID in the application
  /// Throws a [UserRepositoryException] if an error occurs during the process
  Future<void> saveUser(String appUserId);
}

/// Custom exception for user repository errors
class UserRepositoryException implements Exception {
  final String message;

  UserRepositoryException(this.message);

  @override
  String toString() => 'UserRepositoryException: $message';
}
