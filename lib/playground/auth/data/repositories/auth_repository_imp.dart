import 'package:in_app_bot/playground/auth/data/data_sources/auth_data_source.dart';
import 'package:in_app_bot/playground/auth/domain/entities/user_entity.dart';
import 'package:in_app_bot/playground/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImp implements AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepositoryImp({required this.authDataSource});
  @override
  Future<UserEntity> signInWithGitHub() {
    return authDataSource.signInWithGitHub();
  }

  @override
  Future<UserEntity> signInWithGoogle() {
    return authDataSource.signInWithGoogle();
  }

  @override
  Future<UserEntity> signInWithApple() {
    return authDataSource.signInWithApple();
  }

  @override
  Future<void> logOut() {
    return authDataSource.logOut();
  }
}
