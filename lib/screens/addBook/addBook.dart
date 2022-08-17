// ignore_for_file: file_names, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, deprecated_member_use

import 'package:book_reading_app/models/book.dart';
import 'package:book_reading_app/models/userModel.dart';
import 'package:book_reading_app/screens/root/root.dart';
import 'package:book_reading_app/services/dbFuture.dart';
import 'package:book_reading_app/widgets/shadowContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddBook extends StatefulWidget {
  final bool? onGroupCreation;
  final bool? onError;
  final String? groupName;
  final UserModel? currentUser;

  // ignore: use_key_in_widget_constructors
  const AddBook({
    this.onGroupCreation,
    this.onError,
    this.groupName,
    this.currentUser,
  });

  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final addBookKey = GlobalKey<ScaffoldState>();

  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  @override
  initState() {
    super.initState();
    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, _selectedDate.hour, 0, 0, 0, 0);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked =
        await DatePicker.showDateTimePicker(context, showTitleActions: true);
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addBook(BuildContext context, String groupName, BookModel book) async {
    String _returnString;

    if (_selectedDate.isAfter(DateTime.now().add(const Duration(days: 1)))) {
      if (widget.onGroupCreation!) {
        _returnString =
            await DBFuture().createGroup(groupName, widget.currentUser!, book);
      } else if (widget.onError!) {
        _returnString =
            await DBFuture().addCurrentBook(widget.currentUser!.groupId!, book);
      } else {
        _returnString =
            await DBFuture().addNextBook(widget.currentUser!.groupId!, book);
      }

      if (_returnString == "success") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const OurRoot(),
            ),
            (route) => false);
      } else {
        addBookKey.currentState!.showSnackBar(
          const SnackBar(
            content: Text("Due date is less that a day from now!"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: const <Widget>[BackButton()],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ShadowContainer(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _bookNameController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.book),
                      hintText: "Book Name",
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _authorController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Author",
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _lengthController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.pages),
                      hintText: "Length",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    DateFormat.yMMMMd("en_US.").format(_selectedDate),
                  ),
                  Text(
                    DateFormat("H:mm").format(_selectedDate),
                  ),
                  FlatButton(
                    child: const Text("Date Change"),
                    onPressed: () => _selectDate(context),
                  ),
                  RaisedButton(
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 80),
                        child: Text(
                          "Create",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      onPressed: () {
                        BookModel book = BookModel();
                        book.name = _bookNameController.text;
                        book.author = _authorController.text;
                        book.length = int.parse(_lengthController.text);
                        book.dateCompleted = Timestamp.fromDate(_selectedDate);

                        _addBook(context, widget.groupName!, book);
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
