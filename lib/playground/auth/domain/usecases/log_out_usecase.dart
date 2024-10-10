import 'package:in_app_bot/playground/auth/domain/repositories/auth_repository.dart';

class LogOutUsecase {
  final AuthRepository authRepository;

  LogOutUsecase({required this.authRepository});

  Future<void> call() {
    return authRepository.logOut();
  }
}
