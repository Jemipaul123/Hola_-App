import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hola_app/auth/login_or_register.dart';
import 'package:hola_app/firebase_options.dart';
import 'package:hola_app/pages/register.dart';
import 'pages/loginpage.dart';
import 'package:hola_app/auth/auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:AuthPage(),


    );
  }
}
