import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // bool isdotscale = true;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    Duration(milliseconds: 1000);
    // Future.delayed(
    //   Duration(milliseconds: 1000),
    //   () => Navigator.pushNamedAndRemoveUntil(
    //     context,
    //     AppRoutes.welcomeScreen1,
    //     (route) => false,
    //   ),
    // );
    // setState(() {
    //   isdotscale = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: .center,
                children: [Row(mainAxisAlignment: .center, children: [])],
              ),
              // Positioned(
              //   right: MediaQuery.of(context).size.width * 0.496,
              //   top: MediaQuery.of(context).size.height * 0.469,
              //   // child: AnimatedScale(
              //   //   duration: Duration(milliseconds: 500),
              //   //   scale: 1,
              //   //   child: Container(
              //   //     height: 4,
              //   //     width: 4,

              //   //     decoration: BoxDecoration(
              //   //       color: Color(0xffFFB766),
              //   //       shape: BoxShape.circle,
              //   //     ),
              //   //   ),
              //   // ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
