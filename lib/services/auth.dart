// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:book_reading_app/models/userModel.dart';
import 'package:book_reading_app/services/dbFuture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/authModel.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Stream<AuthModel?> get user {
    return _auth.authStateChanges().map((User? firebaseUser) =>
        (firebaseUser != null) ? AuthModel.fromUser(user: firebaseUser) : null);
  }

  Future<String> signOut() async {
    String retVal = "error";
    try {
      await _auth.signOut();
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> signUpUser(
      String email, String password, String fullName) async {
    String retVal = "error";
    try {
      final FirebaseAuth = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      UserModel user = UserModel(
        uid: FirebaseAuth.user!.uid,
        email: FirebaseAuth.user!.email!,
        fullName: fullName.trim(),
        accountCreated: Timestamp.now(),
        notifToken: await _fcm.getToken(),
        groupId: '',
      );
      String returnString = await DBFuture().createUser(user);
      if (returnString == "success") {
        retVal = "success";
      }
    } on PlatformException catch (e) {
      retVal = e.toString();
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> loginUserWithEmail(String email, String password) async {
    String retVal = "error";

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on PlatformException catch (e) {
      retVal = e.toString();
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> loginUserWithGoogle() async {
    String retVal = "error";
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    try {
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth!.idToken, accessToken: googleAuth.accessToken);
      UserCredential authResult = await _auth.signInWithCredential(credential);
      if (authResult.additionalUserInfo!.isNewUser) {
        UserModel user = UserModel(
          uid: authResult.user!.uid,
          email: authResult.user!.email!,
          fullName: authResult.user?.displayName,
          accountCreated: Timestamp.now(),
          notifToken: await _fcm.getToken(),
          groupId: '',
        );
        String returnString = await DBFuture().createUser(user);
        if (returnString == "success") {
          retVal = "success";
        }
      }
      retVal = "success";
    } on PlatformException catch (e) {
      retVal = e.toString();
    } catch (e) {
      print(e);
    }

    return retVal;
  }
}
