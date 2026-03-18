import 'package:flutter/material.dart';
import 'package:sqlite_demo/screens/add_student/add_student.dart';
import 'package:sqlite_demo/screens/homescreen/homescreen.dart';
import 'package:sqlite_demo/screens/test_animation_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      // initialRoute: "/home",
      home: SplashScreen(),
      routes: {
        "/home": (context) => Homescreen(),
        "/addStudent": (context) => AddStudent(),
      },
    );
  }
}
