// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers, avoid_print, avoid_function_literals_in_foreach_calls

import 'package:book_reading_app/models/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import "package:book_reading_app/models/userModel.dart";

import '../models/reviewModel.dart';

class DBFuture {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createGroup(
      String groupName, UserModel user, BookModel initialBook) async {
    String retVal = "error";
    List<String> members = [];
    List<String> tokens = [];

    try {
      members.add(user.uid!);
      tokens.add(user.notifToken!);
      DocumentReference _docRef;
      if (user.notifToken != null) {
        _docRef = await _firestore.collection("groups").add({
          'name': groupName.trim(),
          'leader': user.uid,
          'members': members,
          'tokens': tokens,
          'groupCreated': Timestamp.now(),
          'nextBookId': "waiting",
          'indexPickingBook': 0
        });
      } else {
        _docRef = await _firestore.collection("groups").add({
          'name': groupName.trim(),
          'leader': user.uid,
          'members': members,
          'groupCreated': Timestamp.now(),
          'nextBookId': "waiting",
          'indexPickingBook': 0
        });
      }

      await _firestore.collection("users").doc(user.uid).update({
        'groupId': _docRef.id,
      });

      addBook(_docRef.id, initialBook);

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> joinGroup(String groupId, UserModel userModel) async {
    String retVal = "error";
    List<String> members = [];
    List<String> tokens = [];
    try {
      members.add(userModel.uid!);
      tokens.add(userModel.notifToken!);
      await _firestore.collection("groups").doc(groupId).update({
        'members': FieldValue.arrayUnion(members),
        'tokens': FieldValue.arrayUnion(tokens),
      });

      await _firestore.collection("users").doc(userModel.uid).update({
        'groupId': groupId,
      });

      retVal = "success";
    } on PlatformException catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> leaveGroup(String groupId, UserModel userModel) async {
    String retVal = "error";
    List<String> members = [];
    List<String> tokens = [];
    try {
      members.add(userModel.uid!);
      tokens.add(userModel.notifToken!);
      await _firestore.collection("groups").doc(groupId).update({
        'members': FieldValue.arrayRemove(members),
        'tokens': FieldValue.arrayRemove(tokens),
      });

      await _firestore.collection("users").doc(userModel.uid).update({
        'groupId': null,
      });
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> addBook(String groupId, BookModel book) async {
    String retVal = "error";

    try {
      DocumentReference _docRef = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .add({
        'name': book.name,
        'author': book.author,
        'length': book.length,
        'dateCompleted': book.dateCompleted,
      });

      await _firestore.collection("groups").doc(groupId).update({
        "currentBookId": _docRef.id,
        "currentBookDue": book.dateCompleted,
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> addNextBook(String groupId, BookModel book) async {
    String retVal = "error";

    try {
      DocumentReference _docRef = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .add({
        'name': book.name,
        'author': book.author,
        'length': book.length,
        'dateCompleted': book.dateCompleted,
      });

      await _firestore.collection("groups").doc(groupId).update({
        "nextBookId": _docRef.id,
        "nextBookDue": book.dateCompleted,
      });

      DocumentSnapshot doc =
          await _firestore.collection("groups").doc(groupId).get();
      createNotifications(
          List<String>.from(doc["tokens"]), book.name!, book.author!);
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> addCurrentBook(String groupId, BookModel book) async {
    String retVal = "error";

    try {
      DocumentReference _docRef = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .add({
        'name': book.name,
        'author': book.author,
        'length': book.length,
        'dateCompleted': book.dateCompleted,
      });
      await _firestore.collection("groups").doc(groupId).update({
        "currentBookId": _docRef.id,
        "currentBookDue": book.dateCompleted,
      });
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<BookModel> getCurrentBook(String groupId, String bookId) async {
    BookModel? retVal;

    try {
      DocumentSnapshot _docSnapshot = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .get();
      retVal = BookModel.fromDocumentSnapshot(doc: _docSnapshot);
    } catch (e) {
      print(e);
    }

    return retVal!;
  }

  Future<bool> isUserDoneWithBook(
      String groupId, String bookId, String uid) async {
    bool retVal = false;
    try {
      DocumentSnapshot _docSnapshot = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .collection("reviews")
          .doc(uid)
          .get();

      if (_docSnapshot.exists) {
        retVal = true;
      }
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> createUser(UserModel user) async {
    String retVal = "error";

    try {
      await _firestore.collection("users").doc(user.uid).set({
        'fullName': user.fullName!.trim(),
        'email': user.email!.trim(),
        'accountCreated': Timestamp.now(),
        'notifToken': user.notifToken,
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<UserModel?> getUser(String uid) async {
    UserModel? retVal;

    try {
      DocumentSnapshot _docSnapshot =
          await _firestore.collection("users").doc(uid).get();
      retVal = UserModel.fromDocumentSnapshot(doc: _docSnapshot);
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> createNotifications(
      List<String> tokens, String bookName, String author) async {
    String retVal = "error";

    try {
      await _firestore.collection("notifications").add({
        'bookName': bookName.trim(),
        'author': author.trim(),
        'tokens': tokens,
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<List<BookModel>> getBookHistory(String groupId) async {
    List<BookModel> retVal = [];

    try {
      QuerySnapshot query = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .orderBy("dateCompleted", descending: true)
          .get();

      query.docs.forEach((element) {
        retVal.add(BookModel.fromDocumentSnapshot(doc: element));
      });
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> finishedBook(
    String groupId,
    String bookId,
    String uid,
    int rating,
    String review,
  ) async {
    String retVal = "error";
    try {
      await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .collection("reviews")
          .doc(uid)
          .set({
        'rating': rating,
        'review': review,
      });
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<List<ReviewModel>> getReviewHistory(
      String groupId, String bookId) async {
    List<ReviewModel> retVal = [];

    try {
      QuerySnapshot query = await _firestore
          .collection("groups")
          .doc(groupId)
          .collection("books")
          .doc(bookId)
          .collection("reviews")
          .get();

      query.docs.forEach((element) {
        retVal.add(ReviewModel.fromDocumentSnapshot(doc: element));
      });
    } catch (e) {
      print(e);
    }
    return retVal;
  }
}
