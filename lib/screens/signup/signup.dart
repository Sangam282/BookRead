import 'package:book_reading_app/screens/signup/localwidgets/signUpForm.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const <Widget>[
                    BackButton(),
                  ],
                ),
                const SizedBox(
                  height: 40.0,
                ),
                const SignUpForm()
              ],
            ),
          )
        ],
      ),
    );
  }
}
