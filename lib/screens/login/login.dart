import 'package:book_reading_app/screens/login/localwidgets/loginForm.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

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
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Image.asset("assets/logo.png"),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const LoginForm(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
