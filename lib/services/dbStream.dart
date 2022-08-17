// ignore_for_file: file_names

import 'package:book_reading_app/models/groupModel.dart';
import 'package:book_reading_app/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBStream {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<UserModel> getCurrentUser(String uid) {
    return _firestore
        .collection("users")
        .doc(uid)
        .snapshots()
        .map((docSnapshot) => UserModel.fromDocumentSnapshot(doc: docSnapshot));
  }

  Stream<GroupModel> getCurrentGroup(String groupId) {
    return _firestore.collection("groups").doc(groupId).snapshots().map(
        (docSnapshot) => GroupModel.fromDocumentSnapshot(doc: docSnapshot));
  }
}
