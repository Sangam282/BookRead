// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String uid;
  late String email;
  late String? fullName;
  late Timestamp? accountCreated;
  late String? groupId;
  late String? notifToken;

  UserModel({
    required this.uid,
    required this.email,
    required this.accountCreated,
    required this.fullName,
    required this.groupId,
    required this.notifToken,
  });

  UserModel.fromDocumentSnapshot({DocumentSnapshot? doc}) {
    uid = doc!.id;
    email = doc['email'];
    accountCreated = doc['accountCreated'];
    fullName = doc['fullName'];
    groupId = doc['groupId'];
    notifToken = doc['notifToken'];
  }
}
