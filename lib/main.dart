import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() {
  runApp(const ClaraApp());
}

class ClaraApp extends StatelessWidget {
  const ClaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clara',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const LoginScreen(),
    );
  }
}
