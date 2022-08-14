import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  String? id;
  String? name;
  String? author;
  int? length;
  Timestamp? dateCompleted;

  BookModel({
    this.id,
    this.name,
    this.author,
    this.length,
    this.dateCompleted,
  });

  BookModel.fromDocumentSnapshot({DocumentSnapshot? doc}) {
    id = doc?.id;
    name = doc?['data'];
    author = doc?['author'];
    length = doc?['length'];
    dateCompleted = doc?['dateCompleted'];
  }
}
