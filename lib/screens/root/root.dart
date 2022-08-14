// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers, unnecessary_null_comparison

import 'package:book_reading_app/models/authModel.dart';
import 'package:book_reading_app/models/groupModel.dart';
import 'package:book_reading_app/models/userModel.dart';
import 'package:book_reading_app/screens/inGroup/inGroup.dart';
import 'package:book_reading_app/screens/noGroup/noGroup.dart';
import 'package:book_reading_app/services/dbStream.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login/login.dart';
import '../splashScreen/splashScreen.dart';

enum AuthStatus { unknown, notLoggedIn, loggedIn }

class OurRoot extends StatefulWidget {
  const OurRoot({Key? key}) : super(key: key);

  @override
  State<OurRoot> createState() => _OurRootState();
}

class _OurRootState extends State<OurRoot> {
  AuthStatus _authStatus = AuthStatus.unknown;
  String? currentUid;
  // ignore: unused_field
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        print('onMessage: $message');
      },
    );
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        print('onLaunch: $message');
      },
    );
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        print('onResume: $message');
      },
    );
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    AuthModel? _authStream = Provider.of<AuthModel?>(context);
    if (_authStream != null) {
      setState(() {
        _authStatus = AuthStatus.loggedIn;
        currentUid = _authStream.uid;
      });
    } else {
      setState(() {
        _authStatus = AuthStatus.notLoggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    late Widget retVal;

    switch (_authStatus) {
      case AuthStatus.unknown:
        retVal = const SplashScreen();
        break;
      case AuthStatus.notLoggedIn:
        retVal = const Login();
        break;
      case AuthStatus.loggedIn:
        retVal = StreamProvider<UserModel?>.value(
          value: DBStream().getCurrentUser(currentUid!),
          initialData: null,
          child: const LoggedIn(),
        );
        break;
      default:
    }
    return retVal;
  }
}

class LoggedIn extends StatelessWidget {
  const LoggedIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? _userStream = Provider.of<UserModel?>(context);
    Widget retVal;
    if (_userStream != null) {
      if (_userStream.groupId != null) {
        retVal = StreamProvider<GroupModel?>.value(
          value: DBStream().getCurrentGroup(_userStream.groupId!),
          initialData: null,
          child: const InGroup(),
        );
      } else {
        retVal = const NoGroup();
      }
    } else {
      retVal = const SplashScreen();
    }
    return retVal;
  }
}
