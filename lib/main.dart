import 'package:book_reading_app/models/authModel.dart';
import 'package:book_reading_app/screens/root/root.dart';
import 'package:book_reading_app/services/auth.dart';
import 'package:book_reading_app/utils/ourTheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/authModel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: const FirebaseOptions(
      apiKey: "AIzaSyDmcanaaGp5Mt7u_FZ_4fr7tOi0QMswqjY",
      appId: "1:677774989810:android:283f98255bde81fd0b736b",
      messagingSenderId: "677774989810",
      projectId: "bookread-2aa54",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AuthModel?>.value(
      initialData: null,
      value: Auth().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: OurTheme().buildTheme(),
        home: const OurRoot(),
      ),
    );
  }
}
