import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String displayName;
  final String email;
  final String photoURL;
  final String token;

  const UserEntity({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoURL,
    required this.token,
  });

  @override
  List<Object?> get props => [
        uid,
        displayName,
        email,
        photoURL,
        token,
      ];

  @override
  bool get stringify => true;
}
