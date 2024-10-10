import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_app_bot/playground/auth/data/models/user_model.dart';

abstract class AuthDataSource {
  Future<UserModel> signInWithGitHub();
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithApple();
  Future<void> logOut();
  String? get token;
}

class AuthDataSourceImp implements AuthDataSource {
  String? _token;

  @override
  String? get token => _token;

  AuthDataSourceImp._private();

  static final AuthDataSourceImp _instance = AuthDataSourceImp._private();

  factory AuthDataSourceImp() {
    return _instance;
  }

  FirebaseAuth? _firebaseAuth;

  FirebaseAuth auth() {
    return _firebaseAuth ??= FirebaseAuth.instance;
  }

  @override
  Future<UserModel> signInWithGitHub() async {
    GithubAuthProvider githubProvider = GithubAuthProvider();
    final UserCredential userCredential;
    try {
      if (kIsWeb) {
        userCredential = await auth().signInWithPopup(githubProvider);
      } else {
        userCredential = await auth().signInWithProvider(githubProvider);
      }

      _token = await userCredential.user!.getIdToken();
      final userModel = UserModel.fromUserCredential(userCredential, _token!);
      return userModel;
    } on FirebaseAuthException catch (e) {
      log("$e");
      throw '${e.message}';
    } catch (e) {
      log("$e");
      rethrow;
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final UserCredential userCredential;

      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential = await auth().signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        if (googleUser == null) {
          throw Exception('Sign in cancelled by user');
        }

        final GoogleSignInAuthentication? googleAuth =
            await googleUser.authentication;

        if (googleAuth?.accessToken == null && googleAuth?.idToken == null) {
          throw Exception('Failed to obtain Google Auth tokens');
        }

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        userCredential = await auth().signInWithCredential(credential);
      }

      _token = await userCredential.user!.getIdToken();
      final userModel = UserModel.fromUserCredential(userCredential, _token!);
      return userModel;
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException: $e");
      throw '${e.message}';
    } on PlatformException catch (e) {
      log("PlatformException: $e");
      throw '${e.message}';
    } catch (e) {
      log("Unknown error in signInWithGoogle: $e");
      rethrow;
    }
  }

  @override
  Future<UserModel> signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider()
        ..addScope('email')
        ..addScope('name');

      final UserCredential userCredential;
      if (kIsWeb) {
        userCredential = await auth().signInWithPopup(appleProvider);
      } else {
        userCredential = await auth().signInWithProvider(appleProvider);
      }

      _token = await userCredential.user?.getIdToken();
      if (_token == null) {
        throw Exception('Failed to get user token');
      }

      final userModel = UserModel.fromUserCredential(userCredential, _token!);
      log("Authenticated Apple User: ${userModel.toString()}");
      return userModel;
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuth error on signInWithApple: ${e.code} - ${e.message}");
      throw "${e.message}";
    } catch (e) {
      log("Unknown error in signInWithApple: $e");
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await auth().signOut();
      _token = null;
      log("User logged out successfully");
    } catch (e) {
      rethrow;
    }
  }
}
