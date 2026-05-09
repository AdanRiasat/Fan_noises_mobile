import 'dart:math' as math;
import 'package:flutter/material.dart';

class FanWidget extends StatelessWidget {
  final AnimationController controller;
  final double
  size; // controls the width; height is derived from the image ratio

  const FanWidget({super.key, required this.controller, this.size = 800});

  // All three images are 1980×1080 — same canvas, so they stack perfectly.
  //
  // Rotation pivot: measure the hub centre in pixels in your images, then:
  //   alignX = (hub_x − 990) / 990    (990 = half of 1980)
  //   alignY = (hub_y − 540) / 540    (540 = half of 1080)
  //
  // Adjust the two numbers below until the blades spin around the hub.
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
          // Layer 1 — full fan without blades (stand, base, ring, grill, hub)
          Image.asset(
            'assets/images/fan_base.png',
            width: w,
            height: h,
            fit: BoxFit.fill,
          ),

          // Layer 2 — rotating blades (same 1980×1080 canvas, aligns automatically)
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

          // Layer 3 — grill/ring/hub rendered in front of the blades
          // (same image as layer 1; transparent blade areas let layer 2 show through)
          Image.asset(
            'assets/images/fan_top.png',
            width: w,
            height: h,
            fit: BoxFit.fill,
          ),
          // Add this as the last child in the Stack (draws on top of everything)
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
