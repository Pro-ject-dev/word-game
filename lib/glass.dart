import 'dart:ui';

import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double opacity;
  final double blur;
  final double spreadRadius;
  final double bor_radius;
  final double c_bor_rad;

  final Color borderColor;

  GlassContainer(
      {required this.child,
      this.bor_radius = 12.0,
      this.c_bor_rad = 12.0,
      this.opacity = 0.1,
      this.blur = 3.0,
      this.spreadRadius = 1.0,
      required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(c_bor_rad),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 160, 160, 160).withOpacity(0.25),
            blurRadius: blur,
            spreadRadius: spreadRadius,
          ),
        ],
        border: Border.all(
          color: borderColor,
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(bor_radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            color: Color.fromARGB(255, 211, 211, 211).withOpacity(0.25),
            child: child,
          ),
        ),
      ),
    );
  }
}
