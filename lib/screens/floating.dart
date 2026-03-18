import 'package:flutter/material.dart';

class FloatingCircle extends StatefulWidget {
  const FloatingCircle({super.key});

  @override
  State<FloatingCircle> createState() => _FloatingCircleState();
}

class _FloatingCircleState extends State<FloatingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> floatY;
  late Animation<double> floatX;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    floatY = Tween(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    floatX = Tween(
      begin: -5.0,
      end: 5.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    scale = Tween(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(floatX.value, floatY.value),
          child: Transform.scale(scale: scale.value, child: child),
        );
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
      ),
    );
  }
}
