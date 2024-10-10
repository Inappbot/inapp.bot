import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/auth/domain/entities/status.dart';
import 'package:in_app_bot/playground/auth/domain/usecases/log_out_usecase.dart';
import 'package:in_app_bot/playground/auth/domain/usecases/sign_in_with_apple_usecase.dart';
import 'package:in_app_bot/playground/auth/domain/usecases/sign_in_with_github_usecase.dart';
import 'package:in_app_bot/playground/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:in_app_bot/playground/auth/presentation/providers/auth_state.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final SignInWithGithubUsecase signInWithGithubUsecase;
  final SignInWithGoogleUsecase signInWithGoogleUsecase;
  final SignInWithAppleUsecase signInWithAppleUsecase;
  final LogOutUsecase logOutUsecase;

  AuthStateNotifier({
    required this.signInWithGithubUsecase,
    required this.signInWithGoogleUsecase,
    required this.signInWithAppleUsecase,
    required this.logOutUsecase,
  }) : super(AuthState.initialState());

  Future<void> signInWithGithub() async {
    state = state.copyWith(status: AuthStatus.checking);
    try {
      final user = await signInWithGithubUsecase.call();
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      log("signInWithGithub: $e");
      state =
          state.copyWith(status: AuthStatus.notAuthenticated, message: '$e');
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(status: AuthStatus.checking);
    try {
      final user = await signInWithGoogleUsecase.call();
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      if (e.toString().contains('Sign in cancelled by user')) {
        log("signInWithGoogle cancelled by user");
        state = state.copyWith(
            status: AuthStatus.notAuthenticated, message: 'Sign in cancelled');
      } else {
        log("signInWithGoogle error: $e");
        state =
            state.copyWith(status: AuthStatus.notAuthenticated, message: '$e');
      }
    }
  }

  Future<void> signInApple() async {
    state = state.copyWith(status: AuthStatus.checking);
    try {
      final user = await signInWithAppleUsecase.call();
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
      log("Status updated after authentication with Apple: ${state.toString()}");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'ERROR_ABORTED_BY_USER' || e.code == 'user-cancelled') {
        log("signInApple cancelled by user");
        state = state.copyWith(
            status: AuthStatus.notAuthenticated, message: 'Sign in cancelled');
      } else {
        log("signInApple: $e");
        state =
            state.copyWith(status: AuthStatus.notAuthenticated, message: '$e');
      }
    } catch (e) {
      log("signInApple: $e");
      state =
          state.copyWith(status: AuthStatus.notAuthenticated, message: '$e');
    }
  }

  Future<void> logOut() async {
    try {
      await logOutUsecase.call();
      state = const AuthState(
          user: null, message: null, status: AuthStatus.initial);
    } catch (e) {
      log("logOut: $e");
      state =
          state.copyWith(status: AuthStatus.notAuthenticated, message: '$e');
    }
  }
}
