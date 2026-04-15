import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_proj/core/utils/app_colors.dart';
import 'package:graduation_proj/core/utils/app_constants.dart';


class  ScoreSection extends StatelessWidget {
  const ScoreSection({
    required this.hPad,
    required this.circleScale,
    required this.progress,
    required this.counter,
    required this.pulseScale,
  });

  final double             hPad;
  final Animation<double>  circleScale;
  final Animation<double>  progress;
  final Animation<int>     counter;
  final Animation<double>  pulseScale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: Sp.lg),
      child: Center(
        child: ScaleTransition(
          scale: circleScale,
          child: AnimatedBuilder(
            animation: Listenable.merge([progress, counter, pulseScale]),
            builder: (_, __) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Outer breathing ring
                  Transform.scale(
                    scale: pulseScale.value,
                    child: Container(
                      width: 200, height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.divider.withOpacity(0.5),
                      ),
                    ),
                  ),
                  // Arc painter
                  SizedBox(
                    width: 188, height: 188,
                    child: CustomPaint(
                      painter: _ArcPainter(progress: progress.value),
                    ),
                  ),
                  // Inner circle
                  Container(
                    width: 152, height: 152,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 20,
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${counter.value}',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textHigh,
                            letterSpacing: -2,
                            height: 1.0,
                          ),
                        ),
                        const Text(
                          'out of 100',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMid,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  ARC PAINTER
//  Draws a clean progress arc around the score circle.
//  Uses a track (light grey) + filled arc (dark ink).
// ─────────────────────────────────────────────────────────────
class _ArcPainter extends CustomPainter {
  const _ArcPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const strokeWidth = 7.0;
    const startAngle  = -1.5708; // -90 deg (12 o'clock)
    const fullSweep   = 6.2832;  // 360 deg

    // Track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle, fullSweep, false,
      Paint()
        ..color = AppColors.divider
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Progress fill
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle, fullSweep * progress, false,
      Paint()
        ..color = AppColors.ink
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.progress != progress;
}