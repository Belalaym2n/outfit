

import 'package:flutter/material.dart';
 import '../../core/utils/app_colors.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({
    super.key,
    required this.scaleAnim,
    required this.fadeAnim,
    required this.glowAnim,
  });

  final Animation<double> scaleAnim;
  final Animation<double> fadeAnim;
  final Animation<double> glowAnim;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnim,
      child: ScaleTransition(
        scale: scaleAnim,
        child: AnimatedBuilder(
          animation: glowAnim,
          builder: (_, __) => Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.ink,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: AppColors.inkShadow,
                  blurRadius: 32 + glowAnim.value * 16,
                  spreadRadius: glowAnim.value * 4,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: AppColors.inkShadow.withOpacity(0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: const Center(
              child: _LogoMark(),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: CustomPaint(
        painter: _OutfixLogoPainter(),
      ),
    );
  }
}

class _OutfixLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.bg
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.2;

    final fillPaint = Paint()
      ..color = AppColors.bg
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Hanger arc (top)
    final hangerPath = Path()
      ..moveTo(cx - 8, cy - 14)
      ..quadraticBezierTo(cx, cy - 22, cx + 8, cy - 14);
    canvas.drawPath(hangerPath, paint);

    // Hook line going down
    canvas.drawLine(
      Offset(cx, cy - 18),
      Offset(cx, cy - 12),
      paint..strokeWidth = 2.2,
    );

    // Hanger shoulders
    final shoulderPath = Path()
      ..moveTo(cx - 8, cy - 14)
      ..lineTo(cx - 16, cy - 4)
      ..lineTo(cx + 16, cy - 4)
      ..lineTo(cx + 8, cy - 14);
    canvas.drawPath(shoulderPath, paint..strokeWidth = 2.0);

    // Small AI chip dots — 2×2 grid
    final dotPaint = Paint()
      ..color = AppColors.bg
      ..style = PaintingStyle.fill;

    const dotR = 1.8;
    final positions = [
      Offset(cx - 5, cy + 3),
      Offset(cx + 5, cy + 3),
      Offset(cx - 5, cy + 11),
      Offset(cx + 5, cy + 11),
    ];
    for (final p in positions) {
      canvas.drawCircle(p, dotR, dotPaint);
    }

    // Connecting lines between dots (grid)
    final linePaint = Paint()
      ..color = AppColors.bg.withOpacity(0.4)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(cx - 5, cy + 3), Offset(cx + 5, cy + 3), linePaint);
    canvas.drawLine(Offset(cx - 5, cy + 11), Offset(cx + 5, cy + 11), linePaint);
    canvas.drawLine(Offset(cx - 5, cy + 3), Offset(cx - 5, cy + 11), linePaint);
    canvas.drawLine(Offset(cx + 5, cy + 3), Offset(cx + 5, cy + 11), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}