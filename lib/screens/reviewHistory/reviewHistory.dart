// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:book_reading_app/models/reviewModel.dart';
import 'package:book_reading_app/services/dbFuture.dart';
import 'package:flutter/material.dart';

import '../../../models/reviewModel.dart';
import 'local_widgets/eachReview.dart';

class ReviewHistory extends StatefulWidget {
  final String? groupId;
  final String? bookId;

  // ignore: use_key_in_widget_constructors
  const ReviewHistory({this.groupId, this.bookId});

  @override
  _ReviewHistoryState createState() => _ReviewHistoryState();
}

class _ReviewHistoryState extends State<ReviewHistory> {
  late Future<List<ReviewModel>> reviews;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    reviews = DBFuture().getReviewHistory(widget.groupId!, widget.bookId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: reviews,
        builder:
            (BuildContext context, AsyncSnapshot<List<ReviewModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data!.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const BackButton(),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: EachReview(
                      review: snapshot.data?[index - 1],
                    ),
                  );
                }
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
