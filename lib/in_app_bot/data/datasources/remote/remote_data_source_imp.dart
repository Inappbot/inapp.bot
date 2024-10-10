import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_bot/in_app_bot/data/datasources/remote/remote_data_source.dart';
import 'package:in_app_bot/in_app_bot/features/avatar/data/models/avatar_model.dart';

class RemoteDataSourceImp implements RemoteDataSource {
  RemoteDataSourceImp._private();
  static final RemoteDataSourceImp _instance = RemoteDataSourceImp._private();

  factory RemoteDataSourceImp() {
    return _instance;
  }

  FirebaseFirestore? _firebaseFirestore;

  FirebaseFirestore getDatabase() {
    return _firebaseFirestore ??= FirebaseFirestore.instance;
  }

  final cacheOptions = const GetOptions(source: Source.serverAndCache);

  @override
  Future<AvatarModel> getSelectedAvatar() async {
    try {
      final db = getDatabase();

      final avatarCollectionRef = db
          .collection('chatbots')
          .doc('avatars')
          .collection('avatar_character');

      final querySnapshot = await avatarCollectionRef
          .where('is_selected', isEqualTo: true)
          .limit(1)
          .get(cacheOptions);
      final Map<String, dynamic> data;
      if (querySnapshot.docs.isNotEmpty) {
        data = querySnapshot.docs.first.data();
      } else {
        final qs = await avatarCollectionRef.limit(1).get(cacheOptions);
        data = qs.docs.first.data();
      }
      final avatar = await compute(AvatarModel.fromMap, data);
      return avatar;
    } catch (e) {
      rethrow;
    }
  }
}
