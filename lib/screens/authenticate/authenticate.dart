import 'package:diabeater/screens/authenticate/register.dart';
import 'package:diabeater/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  final bool isSignIn;

  const Authenticate({super.key, required this.isSignIn});

  @override
  _AuthenticateState createState() => _AuthenticateState(showSignIn: isSignIn);
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn;

  _AuthenticateState({required this.showSignIn});

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
