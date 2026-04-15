import 'dart:math';
import 'package:flutter/material.dart';

/// Drop-in AI analysis loader widget.
/// Can be used standalone or is embedded automatically by AppLoadingController.
class AIAnalysisLoader extends StatefulWidget {
  const AIAnalysisLoader({super.key});

  @override
  State<AIAnalysisLoader> createState() => _AIAnalysisLoaderState();
}

class _AIAnalysisLoaderState extends State<AIAnalysisLoader>
    with TickerProviderStateMixin {

  // ── Animation controllers ──────────────────────────────────────────────────
  late final AnimationController _rotateCtrl;  // Arc sweep
  late final AnimationController _scanCtrl;    // Scan line
  late final AnimationController _pulseCtrl;   // Ring pulse
  late final AnimationController _nodeCtrl;    // Node chase

  // ── Message cycling ────────────────────────────────────────────────────────
  static const _messages = [
    'Scanning garments',
    'Reading color palette',
    'Analyzing silhouette',
    'Matching style patterns',
    'Generating insights',
  ];
  int _msgIndex = 0;
  late final AnimationController _msgCtrl;
  late final Animation<double>   _msgFade;

  @override
  void initState() {
    super.initState();

    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();

    _scanCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat();

    _nodeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _msgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    )..repeat();

    _msgFade = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 12),
      TweenSequenceItem(tween: ConstantTween(1.0),           weight: 68),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_msgCtrl);

    _msgCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _msgIndex = (_msgIndex + 1) % _messages.length);
      }
    });
  }

  @override
  void dispose() {
    _rotateCtrl.dispose();
    _scanCtrl.dispose();
    _pulseCtrl.dispose();
    _nodeCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        // ── Animated canvas ────────────────────────────────────────────────
        AnimatedBuilder(
          animation: Listenable.merge([
            _rotateCtrl, _scanCtrl, _pulseCtrl, _nodeCtrl,
          ]),
          builder: (_, __) => CustomPaint(
            size: const Size(136, 136),
            painter: _AIRadarPainter(
              rotation:     _rotateCtrl.value * 2 * pi,
              scanPosition: _scanCtrl.value,
              pulse:        sin(_pulseCtrl.value * 2 * pi) * 0.5 + 0.5,
              nodePhase:    _nodeCtrl.value,
            ),
          ),
        ),

        const SizedBox(height: 22),

        // ── Static label ──────────────────────────────────────────────────
        const Text(
          'ANALYZING OUTFIT',
          style: TextStyle(
            color:       Color(0xCCF5F5F5),
            fontSize:    10,
            letterSpacing: 0.18,
            fontWeight:  FontWeight.w500,
          ),
        ),

        const SizedBox(height: 10),

        // ── Cycling status message ─────────────────────────────────────────
        AnimatedBuilder(
          animation: _msgFade,
          builder: (_, __) => Opacity(
            opacity: _msgFade.value,
            child: Text(
              _messages[_msgIndex],
              style: const TextStyle(
                color:       Color(0x55F5F5F5),
                fontSize:    11,
                letterSpacing: 0.06,
                fontWeight:  FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

// ── CustomPainter ─────────────────────────────────────────────────────────────
class _AIRadarPainter extends CustomPainter {
  final double rotation;
  final double scanPosition;
  final double pulse;
  final double nodePhase;

  const _AIRadarPainter({
    required this.rotation,
    required this.scanPosition,
    required this.pulse,
    required this.nodePhase,
  });

  static const _white = Color(0xFFF5F5F5);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final R = size.width * 0.40; // main ring radius

    _drawOuterRings(canvas, center, R);
    _drawCornerBrackets(canvas, center, R);
    _drawInnerDashedRing(canvas, center, R * 0.68);
    _drawCrosshair(canvas, center, R * 1.14);
    _drawRotatingArc(canvas, center, R);
    _drawScanLine(canvas, center, R);
    _drawDataNodes(canvas, center, R * 1.14);
    _drawCenterOrb(canvas, center);
  }

  // 1. Outer pulsing rings
  void _drawOuterRings(Canvas canvas, Offset c, double R) {
    _stroke(canvas, c, R * 1.24,
        opacity: 0.06 + pulse * 0.10, width: 0.5);

    // Expanding ghost ring
    _stroke(canvas, c, R * 1.24 + pulse * 8,
        opacity: (1 - pulse) * 0.10, width: 0.5);
  }

  // 2. Four corner viewfinder brackets
  void _drawCornerBrackets(Canvas canvas, Offset c, double R) {
    final s   = R * 1.20;
    const bl  = 11.0;
    final corners = [
      (Offset(c.dx - s, c.dy - s),  1.0,  1.0),
      (Offset(c.dx + s, c.dy - s), -1.0,  1.0),
      (Offset(c.dx - s, c.dy + s),  1.0, -1.0),
      (Offset(c.dx + s, c.dy + s), -1.0, -1.0),
    ];

    final paint = Paint()
      ..color      = _white.withOpacity(0.40)
      ..style      = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap  = StrokeCap.square;

    for (final (pt, dx, dy) in corners) {
      final path = Path()
        ..moveTo(pt.dx + dx * bl, pt.dy)
        ..lineTo(pt.dx, pt.dy)
        ..lineTo(pt.dx, pt.dy + dy * bl);
      canvas.drawPath(path, paint);
    }
  }

  // 3. Inner counter-rotating dashed ring
  void _drawInnerDashedRing(Canvas canvas, Offset c, double r) {
    const dashCount = 14;
    final paint = Paint()
      ..color      = _white.withOpacity(0.12)
      ..style      = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..strokeCap  = StrokeCap.butt;

    const sweep = (2 * pi / dashCount) * 0.55;
    for (int i = 0; i < dashCount; i++) {
      final start = -rotation * 0.55 + (i / dashCount) * 2 * pi;
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        start, sweep, false, paint,
      );
    }
  }

  // 4. Subtle crosshair
  void _drawCrosshair(Canvas canvas, Offset c, double extent) {
    final paint = Paint()
      ..color      = _white.withOpacity(0.07)
      ..strokeWidth = 0.5;
    canvas.drawLine(Offset(c.dx - extent, c.dy), Offset(c.dx + extent, c.dy), paint);
    canvas.drawLine(Offset(c.dx, c.dy - extent), Offset(c.dx, c.dy + extent), paint);
  }

  // 5. Main rotating arc with bright leading dot
  void _drawRotatingArc(Canvas canvas, Offset c, double R) {
    const sweep = pi * 1.55;

    // Main arc
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: R),
      rotation, sweep, false,
      Paint()
        ..color      = _white.withOpacity(0.72)
        ..style      = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeCap  = StrokeCap.round,
    );

    // Trailing ghost arc
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: R),
      rotation + sweep, 2 * pi - sweep, false,
      Paint()
        ..color      = _white.withOpacity(0.07)
        ..style      = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // Bright leading dot at arc tip
    final tipAngle = rotation + sweep;
    final tip = Offset(c.dx + cos(tipAngle) * R, c.dy + sin(tipAngle) * R);
    canvas.drawCircle(tip, 2.8,
        Paint()..color = _white.withOpacity(0.95));
  }

  // 6. Horizontal scan line sweeping top→bottom→top
  void _drawScanLine(Canvas canvas, Offset c, double R) {
    final extent = R * 1.10;
    final yOffset = sin(scanPosition * 2 * pi) * (R * 1.04);
    final y  = c.dy + yOffset;
    final x0 = c.dx - extent;
    final x1 = c.dx + extent;

    // Scan line
    canvas.drawLine(
      Offset(x0, y), Offset(x1, y),
      Paint()
        ..color      = _white.withOpacity(0.38)
        ..strokeWidth = 0.5,
    );

    // Soft trail above
    canvas.drawRect(
      Rect.fromLTRB(x0, y - 16, x1, y),
      Paint()..color = _white.withOpacity(0.04),
    );
  }

  // 7. Chase-sequence data nodes around ring
  void _drawDataNodes(Canvas canvas, Offset c, double r) {
    const count = 8;
    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 2 * pi - pi / 2;
      final pt    = Offset(c.dx + cos(angle) * r, c.dy + sin(angle) * r);

      final dist   = ((nodePhase * count) - i + count) % count;
      final bright = max(0.0, 1.0 - dist / 2.3);

      canvas.drawCircle(
        pt,
        bright > 0.5 ? 2.2 : 1.3,
        Paint()
          ..color = _white.withOpacity(0.10 + bright * 0.85)
          ..style = PaintingStyle.fill,
      );
    }
  }

  // 8. Breathing center orb
  void _drawCenterOrb(Canvas canvas, Offset c) {
    canvas.drawCircle(
      c,
      3.5 + pulse * 1.8,
      Paint()
        ..color = _white.withOpacity(0.58 + pulse * 0.42)
        ..style = PaintingStyle.fill,
    );
  }

  // Helper: draw a circle stroke
  void _stroke(Canvas canvas, Offset c, double r,
      {required double opacity, required double width}) {
    canvas.drawCircle(c, r,
      Paint()
        ..color      = _white.withOpacity(opacity)
        ..style      = PaintingStyle.stroke
        ..strokeWidth = width,
    );
  }

  @override
  bool shouldRepaint(_AIRadarPainter old) =>
      old.rotation     != rotation     ||
          old.scanPosition != scanPosition ||
          old.pulse        != pulse        ||
          old.nodePhase    != nodePhase;
}