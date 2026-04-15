import 'package:flutter/material.dart';

class SlideAnimator {
  final AnimationController controller;
  late final Animation<Offset> fromLeft;
  late final Animation<Offset> fromRight;
  late final Animation<Offset> fromBottom;

  SlideAnimator(this.controller) {
    fromLeft = Tween<Offset>(
      begin: const Offset(-1.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutBack,
    ));

    fromRight = Tween<Offset>(
      begin: const Offset(1.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutBack,
    ));

    fromBottom = Tween<Offset>(
      begin: const Offset(0, 1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutBack,
    ));
  }
}
