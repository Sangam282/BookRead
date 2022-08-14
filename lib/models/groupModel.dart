// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  String? id;
  String? name;
  String? leader;
  List<String>? members;
  List<String>? tokens;
  Timestamp? groupCreated;
  String? currentBookId;
  int? indexPickingBook;
  String? nextBookId;
  Timestamp? currentBookDue;
  Timestamp? nextBookDue;

  GroupModel({
    this.id,
    this.name,
    this.leader,
    this.members,
    this.tokens,
    this.groupCreated,
    this.currentBookId,
    this.indexPickingBook,
    this.nextBookId,
    this.currentBookDue,
    this.nextBookDue,
  });

  GroupModel.fromDocumentSnapshot({DocumentSnapshot? doc}) {
    id = doc?.id;
    name = doc?['data'];
    leader = doc?['leader'];
    members = List<String>.from(doc?["members"]);
    tokens = List<String>.from(doc?["tokens"] ?? []);
    groupCreated = doc?['groupCreated'];
    currentBookId = doc?['currentBookId'];
    indexPickingBook = doc?['indexPickingBook'];
    nextBookId = doc?['nextBookId'];
    currentBookDue = doc?["currentBookDue"];
    nextBookDue = doc?["nextBookDue"];
  }
}
