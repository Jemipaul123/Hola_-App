import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hola_app/components/button.dart';
import 'package:hola_app/components/text_field.dart';


class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({Key? key, required this.onTap}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  // sign user
  void signIn() async {
    showDialog(
      context:context,
      builder:(context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      // Navigate to the next screen after successful sign-in if needed
      if (context.mounted) Navigator.pop(context);
    }on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      // Handle sign-in errors
      displayMessage(e.code);
      // Display a snackbar or any other error handling mechanism
    }
  }
  void displayMessage(String message){
    showDialog(context: context,
      builder: (context)=> AlertDialog(
      title:Text(message,
        style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
      ),
    ),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(height: 1),
                Text(
                  "Long time, no see!",
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 23),

                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: emailTextController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: passwordTextController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                MyButton(
                  onTap: signIn, // Call signIn method when button is tapped
                  text: 'Sign In',
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Still not a member?",
                      style: TextStyle(color: Colors.black),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
