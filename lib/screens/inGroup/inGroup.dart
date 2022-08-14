// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, deprecated_member_use

import 'package:book_reading_app/models/groupModel.dart';
import 'package:book_reading_app/models/userModel.dart';
import 'package:book_reading_app/screens/bookHistory/bookHistory.dart';
import 'package:book_reading_app/screens/root/root.dart';
import 'package:book_reading_app/services/dbFuture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'local_widgets/secondCard.dart';
import 'local_widgets/topCard.dart';
import '../../services/auth.dart';

class InGroup extends StatefulWidget {
  const InGroup({Key? key}) : super(key: key);

  @override
  InGroupState createState() => InGroupState();
}

class InGroupState extends State<InGroup> {
  final key = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _signOut(BuildContext context) async {
    String _returnString = await Auth().signOut();
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const OurRoot(),
          ),
          (route) => false);
    }
  }

  void _leaveGroup(BuildContext context) async {
    GroupModel group = Provider.of<GroupModel>(context, listen: false);
    UserModel user = Provider.of<UserModel>(context, listen: false);
    String _returnString = await DBFuture().leaveGroup(group.id!, user);
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const OurRoot(),
        ),
        (route) => false,
      );
    }
  }

  void _copyGroupId(BuildContext context) {
    GroupModel group = Provider.of<GroupModel>(context, listen: false);
    Clipboard.setData(ClipboardData(text: group.id));
    key.currentState!.showSnackBar(const SnackBar(
      content: Text("Copied!"),
    ));
  }

  void _goToBookHistory() {
    GroupModel group = Provider.of<GroupModel>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookHistory(
          groupId: group.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: IconButton(
                  onPressed: () => _signOut(context),
                  icon: const Icon(Icons.exit_to_app),
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: TopCard(),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: SecondCard(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: RaisedButton(
              child: const Text(
                "Book Club History",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => _goToBookHistory(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: RaisedButton(
              onPressed: () => _copyGroupId(context),
              color: Theme.of(context).canvasColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(
                  color: Theme.of(context).secondaryHeaderColor,
                  width: 2,
                ),
              ),
              child: const Text("Copy Group Id"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
            child: FlatButton(
              onPressed: () => _leaveGroup(context),
              color: Theme.of(context).canvasColor,
              child: const Text("Leave Group"),
            ),
          ),
        ],
      ),
    );
  }
}
