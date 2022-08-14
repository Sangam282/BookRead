// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api, unnecessary_null_comparison

import 'package:book_reading_app/models/reviewModel.dart';
import 'package:book_reading_app/models/userModel.dart';
import 'package:book_reading_app/services/dbFuture.dart';
import 'package:book_reading_app/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';

class EachReview extends StatefulWidget {
  final ReviewModel? review;

  const EachReview({this.review});

  @override
  _EachReviewState createState() => _EachReviewState();
}

class _EachReviewState extends State<EachReview> {
  late UserModel user;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    user = (await DBFuture().getUser(widget.review!.userId!))!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Column(
        children: [
          Text(
            (user != null) ? user.fullName! : "loading...",
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Rating: ${widget.review!.rating}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          (widget.review?.review != null)
              ? Text(
                  widget.review!.review!,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[600],
                  ),
                )
              : const Text(""),
        ],
      ),
    );
  }
}
