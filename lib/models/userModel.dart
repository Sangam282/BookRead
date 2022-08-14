// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  String? fullName;
  Timestamp? accountCreated;
  String? groupId;
  String? notifToken;

  UserModel({
    this.uid,
    this.email,
    this.accountCreated,
    this.fullName,
    this.groupId,
    this.notifToken,
  });

  UserModel.fromDocumentSnapshot({DocumentSnapshot? doc}) {
    uid = doc?.id;
    email = doc?['email'];
    accountCreated = doc?['accountCreated'];
    fullName = doc?['fullName'];
    groupId = doc?['groupId'];
    notifToken = doc?['notifToken'];
  }
}
