
import 'package:flutter/material.dart';

class HeroScaleRoute extends PageRouteBuilder {
  HeroScaleRoute({required Widget page})
      : super(
    pageBuilder: (_, __, ___) => page,
    transitionDuration:        const Duration(milliseconds: 520),
    reverseTransitionDuration: const Duration(milliseconds: 380),
    transitionsBuilder: (_, anim, __, child) {
      final curved = CurvedAnimation(
          parent: anim, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
    barrierColor: Colors.black54,
    opaque: false,
  );
}
