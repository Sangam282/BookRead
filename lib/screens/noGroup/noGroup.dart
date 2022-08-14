// ignore_for_file: file_names, deprecated_member_use

import 'package:book_reading_app/screens/createGroup/createGroup.dart';
import 'package:book_reading_app/screens/joinGroup/joinGroup.dart';
import 'package:flutter/material.dart';

class NoGroup extends StatelessWidget {
  const NoGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _goToJoin(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => const JoinGroup()),
        ),
      );
    }

    void _goToCreate(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => const CreateGroup()),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 20, 0),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.exit_to_app),
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ],
          ),
          const Spacer(
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(80.0),
            child: Image.asset("assets/logo.png"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              "Welcome to the app",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.grey[600],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Since you are not in a book club, you can select either to join a club or create a club.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.grey[600],
              ),
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  onPressed: () => _goToCreate(context),
                  color: Theme.of(context).canvasColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(
                      color: Theme.of(context).secondaryHeaderColor,
                      width: 2,
                    ),
                  ),
                  child: const Text("Create"),
                ),
                RaisedButton(
                  child: const Text(
                    "Join",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => _goToJoin(context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
