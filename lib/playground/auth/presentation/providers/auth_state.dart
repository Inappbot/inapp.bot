import 'package:equatable/equatable.dart';
import 'package:in_app_bot/playground/auth/domain/entities/status.dart';
import 'package:in_app_bot/playground/auth/domain/entities/user_entity.dart';

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;
  final String? message;

  const AuthState({
    required this.status,
    this.user,
    this.message,
  });

  factory AuthState.initialState() =>
      const AuthState(status: AuthStatus.initial);

  @override
  List<Object?> get props => [
        status,
        user,
        message,
      ];

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }

  @override
  bool get stringify => true;
}

extension LoginStateExtension on AuthState {
  bool get _isLoading => status == AuthStatus.checking;
  bool get _isFailure => status == AuthStatus.notAuthenticated;
  bool get isLoading => _isLoading && user == null;
  bool get isFailure => _isFailure && user == null && message != null;
  bool get isSuccess => status == AuthStatus.authenticated && user != null;
}
