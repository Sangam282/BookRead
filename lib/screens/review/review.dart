// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, deprecated_member_use

import 'package:book_reading_app/models/authModel.dart';
import 'package:book_reading_app/models/groupModel.dart';
import 'package:book_reading_app/screens/root/root.dart';
import 'package:book_reading_app/services/dbFuture.dart';
import 'package:book_reading_app/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Review extends StatefulWidget {
  final GroupModel groupModel;

  const Review({required this.groupModel});
  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  final reviewKey = GlobalKey<ScaffoldState>();
  final TextEditingController _reviewController = TextEditingController();
  late int _dropdownValue;
  late AuthModel _authModel;

  @override
  void didChangeDependencies() {
    _authModel = Provider.of<AuthModel>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: reviewKey,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: const <Widget>[BackButton()],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ShadowContainer(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      const Text("Rate book 1-10:"),
                      DropdownButton<int>(
                        value: _dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                        underline: Container(
                          height: 2,
                          color: Theme.of(context).canvasColor,
                        ),
                        onChanged: (int? newValue) {
                          setState(() {
                            _dropdownValue = newValue!;
                          });
                        },
                        items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _reviewController,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      hintText: "Add A Review",
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 80),
                      child: Text(
                        "Add Review",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      // ignore: unnecessary_null_comparison
                      if (_dropdownValue != null) {
                        DBFuture().finishedBook(
                            widget.groupModel.id!,
                            widget.groupModel.currentBookId!,
                            _authModel.uid,
                            _dropdownValue,
                            _reviewController.text);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OurRoot(),
                          ),
                          (route) => false,
                        );
                      } else {
                        reviewKey.currentState!.showSnackBar(const SnackBar(
                          content: Text("Need to add rating!"),
                        ));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
