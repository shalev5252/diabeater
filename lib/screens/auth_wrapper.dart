import 'package:diabeater/screens/authenticate/authenticate.dart';
import 'package:diabeater/screens/authenticate/email_verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const VerifyEmailPage();
            } else {
              return const Authenticate(isSignIn: true);
            }
          },
        ),
      );
}
