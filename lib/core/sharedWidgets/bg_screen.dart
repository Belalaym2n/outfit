



// ─────────────────────────────────────────────────────────────
import 'package:flutter/cupertino.dart';

import '../../features/compatapilityModel/presentation/pages/request_to_recommend.dart';
import '../../features/drawer/buildMenus.dart';

class  AmbientBg extends StatelessWidget {
  const AmbientBg({required this.float1, required this.float2});
  final Animation<double> float1;
  final Animation<double> float2;

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.sizeOf(context);
    return AnimatedBuilder(
      animation: Listenable.merge([float1, float2]),
      builder: (_, __) => Stack(children: [
        Positioned(
          top: -s.width * 0.35 + float1.value,
          right: -s.width * 0.22,
          child: _Blob(diameter: s.width * 0.90, opacity: 0.040),
        ),
        Positioned(
          bottom: -s.width * 0.28 + float2.value,
          left: -s.width * 0.28,
          child: _Blob(diameter: s.width * 0.75, opacity: 0.032),
        ),
      ]),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.diameter, required this.opacity});
  final double diameter;
  final double opacity;

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: opacity,
    child: Container(
      width: diameter, height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle, color: C.textHigh,
      ),
    ),
  );
}