import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_proj/core/utils/app_colors.dart';
import 'package:graduation_proj/core/utils/app_constants.dart';

class ScoreSection extends StatelessWidget {
  const ScoreSection({
    required this.hPad,
    required this.circleScale,
    required this.progress,
    required this.counter,
    required this.pulseScale,
    // ── NEW ──────────────────────────────────────────────────
    required this.originalScore,
    required this.improvedScore,
    // ─────────────────────────────────────────────────────────
  });

  final double hPad;
  final Animation<double> circleScale;
  final Animation<double> progress;
  final Animation<int> counter;
  final Animation<double> pulseScale;

  /// Raw 0–1 scores from the API
  final double originalScore;
  final double improvedScore;

  bool get _hasImprovement => improvedScore > originalScore;
  int get _originalPct => (originalScore * 100).round();
  int get _improvedPct => (improvedScore * 100).round();
  int get _delta => _improvedPct - _originalPct;

  @override
  Widget build(BuildContext context) {
    print(_improvedPct);
    print(_originalPct);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: Sp.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Existing animated circle (untouched) ──────────────
          Center(
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
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.divider.withOpacity(0.5),
                          ),
                        ),
                      ),
                      // Arc painter
                      SizedBox(
                        width: 188,
                        height: 188,
                        child: CustomPaint(
                          painter: _ArcPainter(progress: progress.value),
                        ),
                      ),
                      // Inner circle
                      Container(
                        width: 152,
                        height: 152,
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
          if(_originalPct.toDouble()!=_improvedPct.toDouble())

          // ── NEW: Score comparison row ──────────────────────────
          const SizedBox(height: 20),
          if(_originalPct.toDouble()!=_improvedPct.toDouble())

            _ScoreComparisonRow(
            originalPct: _originalPct,
            improvedPct: _improvedPct,
            delta: _delta,
            hasImprovement: _hasImprovement,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SCORE COMPARISON ROW
//  Shows original vs improved score with delta badge.
// ─────────────────────────────────────────────────────────────
class _ScoreComparisonRow extends StatelessWidget {
  const _ScoreComparisonRow({
    required this.originalPct,
    required this.improvedPct,
    required this.delta,
    required this.hasImprovement,
  });

  final int originalPct;
  final int improvedPct;
  final int delta;
  final bool hasImprovement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Original score chip
          _ScorePill(
            label: 'Original',
            value: originalPct,
            highlighted: false,
          ),

          // Divider
          Container(width: 1, height: 36, color: AppColors.divider),

          // Improved score chip + delta badge
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ScorePill(
                label: 'Improved',
                value: improvedPct,
                highlighted: hasImprovement,
              ),
              if (hasImprovement) ...[
                const SizedBox(height: 5),
                _DeltaBadge(delta: delta),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SCORE PILL
// ─────────────────────────────────────────────────────────────
class _ScorePill extends StatelessWidget {
  const _ScorePill({
    required this.label,
    required this.value,
    required this.highlighted,
  });

  final String label;
  final int value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textMid,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (highlighted)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.trending_up_rounded,
                  size: 14,
                  color: AppColors.scoreHigh,
                ),
              ),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: highlighted ?                   AppColors.scoreHigh
                : AppColors.textHigh,
                letterSpacing: -1,
                height: 1.1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  DELTA BADGE  — e.g.  +12 improvement
// ─────────────────────────────────────────────────────────────
class _DeltaBadge extends StatelessWidget {
  const _DeltaBadge({required this.delta});
  final int delta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.ink.withOpacity(0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.ink.withOpacity(0.15)),
      ),
      child: Text(
        '+$delta improvement',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  ARC PAINTER  (unchanged)
// ─────────────────────────────────────────────────────────────
class _ArcPainter extends CustomPainter {
  const _ArcPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const strokeWidth = 7.0;
    const startAngle = -1.5708; // -90 deg (12 o'clock)
    const fullSweep = 6.2832; // 360 deg

    // Track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      fullSweep,
      false,
      Paint()
        ..color = AppColors.divider
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Progress fill
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      fullSweep * progress,
      false,
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