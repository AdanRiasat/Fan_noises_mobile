import 'dart:math' as math;
import 'package:flutter/material.dart';

class FanWidget extends StatelessWidget {
  final AnimationController controller;
  final double size;

  const FanWidget({super.key, required this.controller, this.size = 800});

  static const _hubAlignment = Alignment(0.005, -0.325);

  @override
  Widget build(BuildContext context) {
    final double w = size;
    final double h = size * (723 / 723); // preserve image aspect ratio

    return SizedBox(
      width: w,
      height: h,
      child: Stack(
        children: [
          Image.asset(
            'assets/images/fan_base.png',
            width: w,
            height: h,
            fit: BoxFit.fill,
          ),

          AnimatedBuilder(
            animation: controller,
            builder: (_, child) => Transform.rotate(
              angle: controller.value * -4 * math.pi,
              alignment: _hubAlignment,
              child: child,
            ),
            child: Image.asset(
              'assets/images/fan_blades.png',
              width: w,
              height: h,
              fit: BoxFit.fill,
            ),
          ),

          Image.asset(
            'assets/images/fan_top.png',
            width: w,
            height: h,
            fit: BoxFit.fill,
          ),
          Align(
            alignment: _hubAlignment,
            child: Container(
              width: 1,
              height: 1,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
