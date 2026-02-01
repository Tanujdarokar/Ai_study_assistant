import 'package:ai_study_assist/splashScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Ai Study Assistant",
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
