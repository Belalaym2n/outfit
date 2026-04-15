
// core/sharedWidgets/loading/app_loader.dart
//
// AppLoader — Ambient AI thinking animation.
// Floating orbs breathe and orbit around a center point,
// evoking calm intelligence. Designed for luxury minimal
// AI fashion applications.
//
// Usage:
//   AppLoader()                          // default 48px
//   AppLoader(size: 64)                  // custom size
//   AppLoader(color: Color(0xFF1A1917))  // custom tint

import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A soft, ambient loader using floating orb animations.
/// Mimics the "AI thinking" aesthetic of Arc / Linear / Apple.
class AppLoader extends StatefulWidget {
  const AppLoader({
    super.key,
    this.size = 48.0,
    this.color,
  });

  /// Diameter of the bounding canvas for the orbs.
  final double size;

  /// Tint color for the orbs. Defaults to [Color(0xFF1A1917)].
  final Color? color;

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      // 6-second loop — slow, meditative, premium.
      duration: const Duration(milliseconds: 6000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color inkColor =
        widget.color ?? const Color(0xFF1A1917);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _OrbsPainter(
              progress: _controller.value,
              color: inkColor,
              size: widget.size,
            ),
          );
        },
      ),
    );
  }
}

/// Paints 4 soft orbs on independent orbital paths.
/// Each orb has its own phase offset, radius, scale curve,
/// and opacity envelope — creating organic, non-repeating motion.
class _OrbsPainter extends CustomPainter {
  _OrbsPainter({
    required this.progress,
    required this.color,
    required this.size,
  });

  final double progress;
  final Color color;
  final double size;

  // ─── Orb configuration ───────────────────────────────────
  // Each entry: [phaseOffset, orbitRadius, orbSize, baseOpacity]
  static const List<List<double>> _orbs = [
    [0.00, 0.28, 0.22, 0.10], // top-right — primary
    [0.25, 0.24, 0.18, 0.08], // bottom-right
    [0.50, 0.26, 0.20, 0.09], // bottom-left
    [0.75, 0.22, 0.16, 0.07], // top-left — ghost
  ];

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final scale = size;

    for (final orb in _orbs) {
      final double phase = orb[0];
      final double orbitFraction = orb[1];
      final double orbFraction = orb[2];
      final double baseOpacity = orb[3];

      // ── Orbital position ──────────────────────────────────
      // Each orb travels a slightly elliptical path at its own
      // phase offset, giving an organic, non-synchronised feel.
      final double t = (progress + phase) % 1.0;
      final double angle = t * 2 * math.pi;

      // Slight ellipse: x-radius is 110% of y-radius
      final double orbitR = scale * orbitFraction;
      final double ox = center.dx + orbitR * 1.1 * math.cos(angle);
      final double oy = center.dy + orbitR * math.sin(angle);

      // ── Breathing scale ───────────────────────────────────
      // Sin wave at 2× the orbital speed creates gentle pulses
      // that are out-of-phase with movement.
      final double breathT = (progress * 2 + phase * 1.5) % 1.0;
      final double breath =
          0.85 + 0.15 * _easeInOut(math.sin(breathT * math.pi * 2) * 0.5 + 0.5);
      final double orbR = (scale * orbFraction * 0.5) * breath;

      // ── Opacity envelope ──────────────────────────────────
      // Fades slightly in sync with position in orbit so orbs
      // feel like they're emerging and receding.
      final double opacityWave =
          0.7 + 0.3 * _easeInOut(math.sin(angle * 0.5) * 0.5 + 0.5);
      final double opacity = (baseOpacity * opacityWave).clamp(0.04, 0.14);

      // ── Draw ──────────────────────────────────────────────
      // Radial gradient gives each orb a soft, blurred look
      // without needing actual ImageFilter blur (cheaper).
      final Paint paint = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withOpacity(opacity),
            color.withOpacity(opacity * 0.6),
            color.withOpacity(0.0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(
          center: Offset(ox, oy),
          radius: orbR,
        ));

      canvas.drawCircle(Offset(ox, oy), orbR, paint);
    }

    // ── Center pulse dot ──────────────────────────────────────
    // A tiny anchoring dot breathes independently — signals
    // "something is happening here".
    final double centerBreath =
        0.9 + 0.1 * math.sin(progress * 2 * math.pi * 1.3);
    final double centerR = scale * 0.035 * centerBreath;

    final Paint centerPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withOpacity(0.18),
          color.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(
        center: center,
        radius: centerR * 2.5,
      ));

    canvas.drawCircle(center, centerR * 2.5, centerPaint);
    canvas.drawCircle(
      center,
      centerR,
      Paint()..color = color.withOpacity(0.25),
    );
  }

  /// Smooth cubic ease-in-out for organic motion.
  double _easeInOut(double t) {
    return t < 0.5 ? 4 * t * t * t : 1 - math.pow(-2 * t + 2, 3) / 2;
  }

  @override
  bool shouldRepaint(_OrbsPainter old) =>
      old.progress != progress ||
          old.color != color ||
          old.size != size;
}