// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, deprecated_member_use

import 'package:book_reading_app/models/userModel.dart';
import 'package:book_reading_app/screens/root/root.dart';
import 'package:book_reading_app/services/dbFuture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_reading_app/widgets/shadowContainer.dart';

class JoinGroup extends StatefulWidget {
  const JoinGroup({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  void _joinGroup(BuildContext context, String? groupId) async {
    UserModel _currentUser = Provider.of<UserModel>(context, listen: false);
    String _returnString = await DBFuture().joinGroup(groupId!, _currentUser);
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const OurRoot(),
          ),
          (route) => false);
    }
  }

  final TextEditingController _groupIdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  TextFormField(
                    controller: _groupIdController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.group),
                      hintText: "Group Id",
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 80),
                      child: Text(
                        "Join",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    onPressed: () =>
                        _joinGroup(context, _groupIdController.text),
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
