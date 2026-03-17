import 'package:flutter/material.dart';
import 'package:sqlite_demo/screens/homescreen/homescreen.dart';
import 'package:sqlite_demo/screens/reveal_route.dart';

class TestRevealRouteScreen extends StatefulWidget {
  const TestRevealRouteScreen({super.key});

  @override
  State<TestRevealRouteScreen> createState() => _TestRevealRouteScreenState();
}

class _TestRevealRouteScreenState extends State<TestRevealRouteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .end,
            children: [
              GestureDetector(
                onTapDown: (details) {
                  Navigator.push(
                    context,
                    RevealRoute(
                      page: Homescreen(),
                      position: details.globalPosition,
                    ),
                  );
                },
                child: Container(
                  padding: .all(10),
                  color: Colors.white,
                  child: Text("Dark Mode"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
