// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';

class AuthModel {
  late String uid;
  String? email;

  AuthModel({
    required this.uid,
    this.email,
  });

  AuthModel.fromUser({User? user}) {
    uid = user!.uid;
    email = user.email;
  }
}
