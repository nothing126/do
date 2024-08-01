import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/main_page.dart';
import 'package:flutter_application_1/screens/all_tasks.dart';
import 'package:flutter_application_1/services/firebase_auth.dart';
import 'package:flutter_application_1/theme/theme.dart';


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
// ignore: unused_field
final AuthenticationService _authService =
   AuthenticationService(); // Initialize your AuthService
  late User? user;

  @override
  Widget build(BuildContext context) {
    user = _authService.getCurrentUser();
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: DoDidDoneTheme.lightTheme,
      home: user == null ? const LoginPage() : const MainPage(),
    );
  }
}
