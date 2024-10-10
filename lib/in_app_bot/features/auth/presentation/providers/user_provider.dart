import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class User {
  final String id;

  User({required this.id});
}

class UserState {
  final User? user;

  UserState({this.user});

  UserState copyWith({User? user}) {
    return UserState(user: user ?? this.user);
  }
}

class UserStateNotifier extends StateNotifier<UserState> {
  UserStateNotifier() : super(UserState());

  final _storage = const FlutterSecureStorage();

  Future<void> loadUserId() async {
    final userId = await _storage.read(key: 'userId');
    if (userId != null) {
      state = UserState(user: User(id: userId));
    }
  }

  Future<void> setUserId(String id) async {
    state = UserState(user: User(id: id));
    await _storage.write(key: 'userId', value: id);
  }

  Future<void> clearUserId() async {
    state = UserState();
    await _storage.delete(key: 'userId');
  }
}

final userProvider = StateNotifierProvider<UserStateNotifier, UserState>((ref) {
  return UserStateNotifier();
});
