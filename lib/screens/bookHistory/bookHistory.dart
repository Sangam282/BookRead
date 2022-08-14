// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:book_reading_app/models/book.dart';
import 'package:book_reading_app/screens/bookHistory/local_widgets/eachBook.dart';
import 'package:book_reading_app/services/dbFuture.dart';
import 'package:flutter/material.dart';

class BookHistory extends StatefulWidget {
  final String? groupId;

  const BookHistory({
    this.groupId,
  });

  @override
  State<BookHistory> createState() => _BookHistoryState();
}

class _BookHistoryState extends State<BookHistory> {
  late Future<List<BookModel>> books;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    books = DBFuture().getBookHistory(widget.groupId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: books,
      builder: (BuildContext context, AsyncSnapshot<List<BookModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemCount: snapshot.data!.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: const [
                      BackButton(),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: EachBook(
                      book: snapshot.data![index - 1],
                      groupId: widget.groupId!),
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
    ));
  }
}
