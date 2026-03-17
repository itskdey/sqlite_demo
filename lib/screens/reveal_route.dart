import 'dart:math';

import 'package:flutter/material.dart';

class RevealRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Offset position;
  final Duration duration;

  final dynamic setting;

  RevealRoute({
    required this.page,
    required this.position,
    this.setting,
    this.duration = const Duration(milliseconds: 600),
  }) : super(
         transitionDuration: duration,
         pageBuilder: (_, __, ___) => page,
         transitionsBuilder: (context, animation, _, child) {
           return ClipPath(
             clipper: CircularRevealClipper(
               fraction: animation.value,
               center: position,
               screenSize: MediaQuery.of(context).size,
             ),
             child: child,
           );
         },
         settings: RouteSettings(arguments: setting),
       );
}

class CircularRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Offset center;
  final Size screenSize;

  CircularRevealClipper({
    required this.fraction,
    required this.center,
    required this.screenSize,
  });

  @override
  Path getClip(Size size) {
    final maxRadius = sqrt(
      pow(screenSize.width, 2) + pow(screenSize.height, 2),
    );
    final radius = fraction * maxRadius;
    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(CircularRevealClipper oldClipper) =>
      oldClipper.fraction != fraction || oldClipper.center != center;
}
