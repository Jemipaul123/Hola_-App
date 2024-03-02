import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hola_app/auth/login_or_register.dart';
import 'package:hola_app/pages/home_page.dart';
import 'package:hola_app/pages/loginpage.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User is logged in
          if (snapshot.hasData) {
            return const HomePage();
          }
          // User is not logged in
          else {
            return LoginPage(
              onTap: () {
                // Navigate to the sign-up page or handle sign-in logic here
                // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                // Or call sign-in logic directly
                //_signIn(); // You can define this function to handle sign-in logic
              },
            );
          }
        },
      ),
    );
  }
}
