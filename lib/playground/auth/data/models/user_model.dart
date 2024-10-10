import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_app_bot/playground/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String uid,
    required String displayName,
    required String email,
    required String photoURL,
    required String token,
  }) : super(
          uid: uid,
          displayName: displayName,
          email: email,
          photoURL: photoURL,
          token: token,
        );

  factory UserModel.fromUserCredential(
      UserCredential userCredential, String token) {
    final user = userCredential.user;
    final additionalUserInfo = userCredential.additionalUserInfo;

    if (user == null) {
      throw Exception('Failed to get user from UserCredential');
    }

    String displayName = user.displayName ?? '';
    if (displayName.isEmpty && additionalUserInfo?.profile != null) {
      displayName = additionalUserInfo!.profile!['name'] as String? ??
          additionalUserInfo.profile!['login'] as String? ??
          'Usuario';
    }

    final email = user.email ?? user.uid;
    final firstChar = displayName.isNotEmpty
        ? displayName[0].toUpperCase()
        : email[0].toUpperCase();

    return UserModel(
      uid: user.uid,
      displayName: displayName,
      email: email,
      photoURL: user.photoURL ?? generateAvatarUrl(firstChar),
      token: token,
    );
  }

  static String generateAvatarUrl(String char) {
    final color =
        (char.codeUnitAt(0) * 0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return 'https://ui-avatars.com/api/?name=$char&background=$color&color=ffffff';
  }
}
