
import 'package:flutter/material.dart';

/// Clips the image section with a smooth concave arc at the bottom,
/// mimicking the soft wave seen in the design.
class CurvedBottomClipper extends CustomClipper<Path> {
  /// [curveDepth] controls how deep the inward arc dips (in logical pixels).
  final double curveDepth;

  const CurvedBottomClipper({this.curveDepth = 40});

  @override
  Path getClip(Size size) {
    final path = Path();

    // Top-left → top-right → straight down the sides
    path.lineTo(0, size.height - curveDepth);

    // Control point sits at the horizontal center, and at the very bottom
    // of the widget, pulling the curve *inward* (upward).
    path.quadraticBezierTo(
      size.width / 2, // control x – midpoint
      size.height + curveDepth, // control y – below the bottom edge
      size.width,
      size.height - curveDepth,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CurvedBottomClipper oldClipper) =>
      oldClipper.curveDepth != curveDepth;
}