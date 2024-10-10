import 'package:cloud_firestore/cloud_firestore.dart';

Future<DocumentSnapshot> getFirestoreDocument({
  required String collectionGroup,
  required String? documentId,
  String? subCollection,
}) async {
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection(collectionGroup);

  if (subCollection != null) {
    collectionRef = collectionRef.doc(documentId).collection(subCollection);
  }

  if (documentId != null && subCollection == null) {
    return await collectionRef.doc(documentId).get();
  } else {
    final QuerySnapshot snapshot = await collectionRef.limit(1).get();
    return snapshot.docs.first;
  }
}

Future<DocumentSnapshot> getSelectedAvatarDocument() async {
  CollectionReference collectionRef = FirebaseFirestore.instance
      .collection('chatbots')
      .doc('avatars')
      .collection('avatar_character');

  final QuerySnapshot snapshot =
      await collectionRef.where('is_selected', isEqualTo: true).limit(1).get();

  if (snapshot.docs.isNotEmpty) {
    return snapshot.docs.first;
  } else {
    return await collectionRef
        .limit(1)
        .get()
        .then((snapshot) => snapshot.docs.first);
  }
}

Future<Map<String, String>> getAvatarVideoUrls(String avatarId) async {
  final DocumentSnapshot avatarDoc = await getSelectedAvatarDocument();

  if (avatarDoc.exists && avatarDoc.data() != null) {
    Map<String, dynamic> data = avatarDoc.data() as Map<String, dynamic>;
    return {
      'idle': data['video_chat'] ?? '',
      'talking': data['video_talking'] ?? '',
      'avatar_loading': data['avatar_loading'] ?? ''
    };
  } else {
    return {
      'idle': 'assets/avatars/eneia/avatar_Idle.mp4',
      'talking': 'assets/avatars/eneia/avatar_talking.mp4',
      'avatar_loading': 'assets/avatars/eneia/avatar_loading.jpg'
    };
  }
}

Future<String> getDefaultAvatarId() async {
  final DocumentSnapshot snapshot = await getSelectedAvatarDocument();

  if (snapshot.exists) {
    return (snapshot.data() as Map<String, dynamic>)['name'] ?? '';
  } else {
    return '';
  }
}

Future<String> getSelectedAvatarId() async {
  final DocumentSnapshot selectedAvatarSnapshot =
      await getSelectedAvatarDocument();

  if (selectedAvatarSnapshot.exists && selectedAvatarSnapshot.data() != null) {
    return (selectedAvatarSnapshot.data() as Map<String, dynamic>)['name'] ??
        await getDefaultAvatarId();
  } else {
    return await getDefaultAvatarId();
  }
}
