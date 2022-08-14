// ignore_for_file: file_names, deprecated_member_use, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, avoid_print

import 'package:flutter/material.dart';
import '../../../services/auth.dart';
import '../../../widgets/shadowContainer.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _signUpUser(String email, String password, BuildContext context,
      String fullName) async {
    try {
      String _returnString = await Auth().signUpUser(email, password, fullName);
      if (_returnString == "success") {
        Navigator.pop(context);
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(_returnString),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: Text(
              "Sign Up",
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextFormField(
            controller: _fullNameController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline),
              hintText: "Full Name",
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.alternate_email),
              hintText: "Email",
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock_outline),
              hintText: "Password",
            ),
            obscureText: true,
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock_open),
              hintText: "Confirm Password",
            ),
            obscureText: true,
          ),
          const SizedBox(
            height: 20.0,
          ),
          RaisedButton(
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 100),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              onPressed: () {
                if (_passwordController.text ==
                    _confirmPasswordController.text) {
                  _signUpUser(_emailController.text, _passwordController.text,
                      context, _fullNameController.text);
                } else {
                  Scaffold.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Passwords do not match"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }
}
