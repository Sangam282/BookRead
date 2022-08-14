// ignore_for_file: file_names, deprecated_member_use

import 'package:book_reading_app/models/book.dart';
import 'package:book_reading_app/screens/reviewHistory/reviewHistory.dart';
import 'package:book_reading_app/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';

class EachBook extends StatelessWidget {
  final BookModel book;
  final String groupId;

  void _goToReviewHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewHistory(
          groupId: groupId,
          bookId: book.id,
        ),
      ),
    );
  }

  const EachBook({Key? key, required this.book, required this.groupId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Column(
        children: [
          Text(
            book.name!,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text(
            book.author!,
            style: TextStyle(fontSize: 20, color: Colors.grey[600]),
          ),
          const SizedBox(
            height: 10,
          ),
          RaisedButton(
            child: const Text("Reviews"),
            onPressed: () => _goToReviewHistory(context),
          )
        ],
      ),
    );
  }
}
