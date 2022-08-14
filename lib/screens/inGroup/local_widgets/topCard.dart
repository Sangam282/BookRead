// ignore_for_file: file_names, unnecessary_null_comparison, no_leading_underscores_for_local_identifiers, deprecated_member_use

import 'dart:async';
import 'package:book_reading_app/models/authModel.dart';
import 'package:book_reading_app/screens/addBook/addBook.dart';
import 'package:book_reading_app/screens/review/review.dart';
import 'package:book_reading_app/services/dbFuture.dart';
import 'package:book_reading_app/utils/timeLeft.dart';
import 'package:book_reading_app/models/book.dart';
import 'package:book_reading_app/models/groupModel.dart';
import 'package:book_reading_app/models/userModel.dart';
import 'package:book_reading_app/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopCard extends StatefulWidget {
  const TopCard({Key? key}) : super(key: key);

  @override
  State<TopCard> createState() => _TopCardState();
}

class _TopCardState extends State<TopCard> {
  String _timeUntil = "loading...";
  late AuthModel _authModel;
  bool _doneWithBook = true;
  late Timer _timer;
  late BookModel _currentBook;
  late GroupModel _groupModel;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _timeUntil =
              TimeLeft().timeLeft(_currentBook.dateCompleted!.toDate());
        });
      }
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _authModel = Provider.of<AuthModel>(context);
    _groupModel = Provider.of<GroupModel>(context);
    if (_groupModel != null) {
      isUserDoneWithBook();
      _currentBook = await DBFuture()
          .getCurrentBook(_groupModel.id!, _groupModel.currentBookId!);
      _startTimer();
    }
  }

  void _goToAddBook(BuildContext context) {
    UserModel _currentUser = Provider.of<UserModel>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBook(
          onGroupCreation: false,
          onError: true,
          currentUser: _currentUser,
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  isUserDoneWithBook() async {
    if (await DBFuture().isUserDoneWithBook(
        _groupModel.id!, _groupModel.currentBookId!, _authModel.uid)) {
      _doneWithBook = true;
    } else {
      _doneWithBook = false;
    }
  }

  void _goToReview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Review(
          groupModel: _groupModel,
        ),
      ),
    );
  }

  Widget noNextBook() {
    if (_authModel != null && _groupModel != null) {
      if (_groupModel.currentBookId == "waiting") {
        if (_authModel.uid == _groupModel.leader) {
          return Column(
            children: <Widget>[
              const Text(
                "Nobody picked the next book. Leader needs to step in and pick!",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: () => _goToAddBook(context),
                textColor: Colors.white,
                child: const Text("Pick Next Book"),
              )
            ],
          );
        } else {
          return const Center(
            child: Text(
              "Nobody picked the next book. Leader needs to step in and pick!",
              style: TextStyle(fontSize: 20),
            ),
          );
        }
      } else {
        return const Center(
          child: Text("loading..."),
        );
      }
    } else {
      return const Center(
        child: Text("loading..."),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentBook == null) {
      return ShadowContainer(child: noNextBook());
    }
    return ShadowContainer(
      child: Column(
        children: <Widget>[
          Text(
            _currentBook.name!,
            style: TextStyle(
              fontSize: 30,
              color: Colors.grey[600],
            ),
          ),
          Text(
            _currentBook.author!,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              children: <Widget>[
                Text(
                  "Due In: ",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.grey[600],
                  ),
                ),
                Expanded(
                  child: Text(
                    _timeUntil,
                    style: const TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          RaisedButton(
            onPressed: _doneWithBook ? null : _goToReview,
            child: const Text(
              "Finished Book",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
