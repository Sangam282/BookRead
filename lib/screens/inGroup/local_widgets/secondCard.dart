// ignore_for_file: file_names, unnecessary_null_comparison, deprecated_member_use

import 'package:book_reading_app/models/book.dart';
import 'package:book_reading_app/models/groupModel.dart';
import 'package:book_reading_app/models/userModel.dart';
import 'package:book_reading_app/screens/addBook/addBook.dart';
import 'package:book_reading_app/services/dbFuture.dart';
import 'package:book_reading_app/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecondCard extends StatefulWidget {
  const SecondCard({Key? key}) : super(key: key);

  @override
  State<SecondCard> createState() => _SecondCardState();
}

class _SecondCardState extends State<SecondCard> {
  late GroupModel _groupModel;
  late UserModel _currentUser;
  late UserModel _pickingUser;
  late BookModel _nextBook;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _groupModel = Provider.of<GroupModel>(context);
    _currentUser = Provider.of<UserModel>(context);
    if (_groupModel != null) {
      _pickingUser = (await DBFuture()
          .getUser(_groupModel.members![_groupModel.indexPickingBook!]))!;
      _nextBook = (await DBFuture()
          .getCurrentBook(_groupModel.id!, _groupModel.nextBookId!));

      setState(() {});
    }
  }

  void _goToAddBook(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBook(
          onGroupCreation: false,
          currentUser: _currentUser,
        ),
      ),
    );
  }

  Widget _displayText() {
    Widget retVal;

    if (_pickingUser != null) {
      if (_groupModel.nextBookId == "waiting") {
        if (_pickingUser.uid == _currentUser.uid) {
          retVal = RaisedButton(
            child: const Text("Select Next Book"),
            onPressed: () {
              _goToAddBook(context);
            },
          );
        } else {
          retVal = Text(
            "Waiting ${_pickingUser.fullName} to pick",
            style: TextStyle(
              fontSize: 30,
              color: Colors.grey[600],
            ),
          );
        }
      } else {
        retVal = Column(
          children: [
            const Text(
              "Next Book:",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              (_nextBook != null) ? _nextBook.name! : "loading..",
              style: TextStyle(
                fontSize: 30,
                color: Colors.grey[600],
              ),
            ),
            Text(
              (_nextBook != null) ? _nextBook.author! : "loading..",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
              ),
            ),
          ],
        );
      }
    } else {
      retVal = Text(
        "Loading...",
        style: TextStyle(
          fontSize: 30,
          color: Colors.grey[600],
        ),
      );
    }

    return retVal;
  }

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: _displayText(),
      ),
    );
  }
}
