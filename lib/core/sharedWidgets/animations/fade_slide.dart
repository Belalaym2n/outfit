

import 'package:flutter/cupertino.dart';

class  FadeSlide extends StatelessWidget {
  const FadeSlide({
    required this.fade,
    required this.slide,
    required this.child,
  });
  final Animation<double> fade;
  final Animation<Offset>  slide;
  final Widget             child;

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: fade,
    child: SlideTransition(position: slide, child: child),
  );
}