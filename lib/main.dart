import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FacultyApp());
}

class FacultyApp extends StatelessWidget {
  const FacultyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Faculty Manager',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomeScreen(),
    );
  }
}
