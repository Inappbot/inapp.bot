import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/auth/data/data_sources/auth_data_source.dart';
import 'package:in_app_bot/playground/auth/data/repositories/auth_repository_imp.dart';
import 'package:in_app_bot/playground/auth/domain/repositories/auth_repository.dart';
import 'package:in_app_bot/playground/auth/domain/usecases/log_out_usecase.dart';
import 'package:in_app_bot/playground/auth/domain/usecases/sign_in_with_apple_usecase.dart';
import 'package:in_app_bot/playground/auth/domain/usecases/sign_in_with_github_usecase.dart';
import 'package:in_app_bot/playground/auth/domain/usecases/sign_in_with_google_usecase.dart';

import 'auth_state.dart';
import 'auth_state_notifier.dart';

final authProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(
    signInWithGithubUsecase: ref.watch(_signInWithGithubUsecase),
    signInWithGoogleUsecase: ref.watch(_signInWithGoogleUseCase),
    signInWithAppleUsecase: ref.watch(_signInWithAppleUseCase),
    logOutUsecase: ref.watch(_logOutUsecase),
  );
});

final _signInWithGithubUsecase = Provider<SignInWithGithubUsecase>((ref) {
  return SignInWithGithubUsecase(authRepository: ref.watch(_authRepository));
});

final _authRepository = Provider<AuthRepository>((ref) {
  return AuthRepositoryImp(
    authDataSource: ref.watch(_authDataSource),
  );
});

final _authDataSource = Provider<AuthDataSource>((ref) {
  return AuthDataSourceImp();
});

final _signInWithGoogleUseCase = Provider<SignInWithGoogleUsecase>((ref) {
  return SignInWithGoogleUsecase(authRepository: ref.watch(_authRepository));
});

final _signInWithAppleUseCase = Provider<SignInWithAppleUsecase>((ref) {
  return SignInWithAppleUsecase(authRepository: ref.watch(_authRepository));
});

final _logOutUsecase = Provider<LogOutUsecase>((ref) {
  return LogOutUsecase(authRepository: ref.watch(_authRepository));
});
