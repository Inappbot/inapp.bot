import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportService {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  ReportService({required this.firestore, required this.storage});

  Future<DocumentReference> saveReport(String email, String description) async {
    return firestore
        .collection('chatbots')
        .doc('app_report')
        .collection('Reports')
        .add({
      'email': email,
      'description': description,
      'timestamp': DateTime.now(),
    });
  }

  Future<String> uploadImage(File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference = storage.ref().child('report_images/$fileName');
    TaskSnapshot snapshot = await storageReference.putFile(image);
    return snapshot.ref.getDownloadURL();
  }
}

final reportServiceProvider = Provider<ReportService>((ref) {
  return ReportService(
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
  );
});
