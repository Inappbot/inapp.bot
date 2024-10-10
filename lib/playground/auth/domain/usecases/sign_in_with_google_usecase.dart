import 'package:in_app_bot/playground/auth/domain/entities/user_entity.dart';
import 'package:in_app_bot/playground/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogleUsecase {
  final AuthRepository authRepository;

  SignInWithGoogleUsecase({required this.authRepository});

  Future<UserEntity> call() {
    return authRepository.signInWithGoogle();
  }
}
