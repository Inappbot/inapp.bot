import 'package:in_app_bot/in_app_bot/features/user/data/services/firestore_service.dart';
import 'package:in_app_bot/in_app_bot/features/user/domain/repositories/user_repository.dart';

/// Concrete implementation of [UserRepository]
class UserRepositoryImpl implements UserRepository {
  final FirestoreService _firestoreService;

  /// Constructor that receives an instance of [FirestoreService]
  UserRepositoryImpl({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  @override
  Future<void> saveUser(String appUserId) async {
    try {
      await _firestoreService.saveUserInFirestore(appUserId);
    } catch (e) {
      // Here you could handle repository-specific errors
      // For example, transform Firestore exceptions into domain exceptions
      throw UserRepositoryException('Error saving user: ${e.toString()}');
    }
  }
}

/// Custom exception for user repository errors
class UserRepositoryException implements Exception {
  final String message;

  UserRepositoryException(this.message);

  @override
  String toString() => 'UserRepositoryException: $message';
}
