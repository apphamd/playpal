import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:playpal/pages/navigation/nav_frame.dart';
import 'package:playpal/pages/login/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user logged in
          if (snapshot.hasData) {
            return const NavigationFrame();
          }

          // user not logged in
          else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
