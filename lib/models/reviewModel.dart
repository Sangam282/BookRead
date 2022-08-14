// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String? userId;
  int? rating;
  String? review;

  ReviewModel({
    this.userId,
    this.rating,
    this.review,
  });

  ReviewModel.fromDocumentSnapshot({DocumentSnapshot? doc}) {
    userId = doc?.id;
    rating = doc?["rating"];
    review = doc?["review"];
  }
}
