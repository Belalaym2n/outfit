
import 'package:flutter/material.dart';
import 'package:graduation_proj/core/utils/app_colors.dart';
import 'package:graduation_proj/core/utils/app_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  SHIMMER CORE
//  Self-contained — no third-party shimmer package needed.
// ─────────────────────────────────────────────────────────────────────────────

class _ShimmerBox extends StatefulWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    this.radius = 8,
  });
  final double width;
  final double height;
  final double radius;

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>   _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _anim = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        return Container(
          width:  widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end:   Alignment.centerRight,
              stops: const [0.0, 0.5, 1.0],
              colors: [
                AppColors.surfaceAlt,
                AppColors.divider.withOpacity(0.6),
                AppColors.surfaceAlt,
              ],
              transform: _SlidingGradient(_anim.value),
            ),
          ),
        );
      },
    );
  }
}

class _SlidingGradient extends GradientTransform {
  const _SlidingGradient(this.slide);
  final double slide;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slide, 0, 0);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PROFILE SKELETON  — matches the exact layout of ProfileScreen
// ─────────────────────────────────────────────────────────────────────────────

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key, required this.hPad});
  final double hPad;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Sp.md),

              // ── Avatar placeholder ────────────────────────────
              _ShimmerBox(width: 100, height: 100, radius: 50),
              SizedBox(height: Sp.sm),

              // ── Name line ─────────────────────────────────────
              _ShimmerBox(width: 160, height: 18, radius: 6),
              const SizedBox(height: 8),

              // ── Email line ────────────────────────────────────
              _ShimmerBox(width: 220, height: 13, radius: 5),
              const SizedBox(height: 12),

              // ── Badge pill ────────────────────────────────────
              _ShimmerBox(width: 120, height: 28, radius: 40),
              SizedBox(height: Sp.md),

              // ── Stats row ─────────────────────────────────────
              _SkeletonStatsRow(),
              SizedBox(height: Sp.md),

              // ── Journey card ──────────────────────────────────
              _SkeletonCard(height: 160),
              SizedBox(height: Sp.md),

              // ── Settings label ────────────────────────────────
              Align(
                alignment: Alignment.centerLeft,
                child: _ShimmerBox(width: 80, height: 12, radius: 4),
              ),
              const SizedBox(height: 8),

              // ── Settings tiles ────────────────────────────────
              _SkeletonCard(height: 120),
              SizedBox(height: Sp.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonStatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (i) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: i > 0 ? 8 : 0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:        AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border:       Border.all(color: AppColors.divider),
              ),
              child: Column(
                children: [
                  _ShimmerBox(width: 24, height: 24, radius: 6),
                  const SizedBox(height: 8),
                  _ShimmerBox(width: 32, height: 18, radius: 5),
                  const SizedBox(height: 5),
                  _ShimmerBox(width: 48, height: 11, radius: 4),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width:  double.infinity,
      height: height,
      decoration: BoxDecoration(
        color:       Colors.white,
        borderRadius: BorderRadius.circular(18),
        border:       Border.all(color: AppColors.divider),
      ),
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _ShimmerBox(width: 34, height: 34, radius: 9),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ShimmerBox(width: 110, height: 14, radius: 5),
                    const SizedBox(height: 5),
                    _ShimmerBox(width: 80,  height: 11, radius: 4),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _ShimmerBox(width: double.infinity, height: 11, radius: 4),
            const SizedBox(height: 6),
            _ShimmerBox(width: 200, height: 11, radius: 4),
            const SizedBox(height: 16),
            _ShimmerBox(width: double.infinity, height: 7, radius: 6),
          ],
        ),
      ),
    );
  }
}