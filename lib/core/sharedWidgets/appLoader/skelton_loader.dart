
// core/sharedWidgets/loading/skeleton_loader.dart
//
// SkeletonLoader — Shimmer-free, breathing placeholder blocks.
// Uses a gentle opacity pulse instead of a shimmer sweep —
// consistent with the luxury minimal language (no harsh motion).
//
// Usage:
//   SkeletonLoader(width: double.infinity, height: 20)
//   SkeletonLoader.text(lines: 3)
//   SkeletonLoader.card()
//   SkeletonLoader.outfitTile()

import 'dart:math' as math;
import 'package:flutter/material.dart';

// ─── Base skeleton block ───────────────────────────────────

/// A single skeleton placeholder block with a soft breathing pulse.
class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
    this.phaseOffset = 0.0,
  });

  final double width;
  final double height;
  final double borderRadius;

  /// Stagger the pulse phase (0.0–1.0) for multi-block layouts.
  final double phaseOffset;

  // ── Named constructors for common patterns ─────────────────

  /// A stack of text-line skeletons.
  static Widget text({
    int lines = 3,
    double lineHeight = 14,
    double spacing = 10,
    double lastLineWidth = 0.6,
  }) {
    return _SkeletonTextBlock(
      lines: lines,
      lineHeight: lineHeight,
      spacing: spacing,
      lastLineWidth: lastLineWidth,
    );
  }

  /// A card-shaped placeholder (image + text lines).
  static Widget card({double? width, double height = 240}) {
    return _SkeletonCard(width: width, height: height);
  }

  /// An outfit tile placeholder matching typical fashion card proportions.
  static Widget outfitTile() => const _SkeletonOutfitTile();

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  static const _baseOpacity = 0.07;
  static const _peakOpacity = 0.13;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _anim = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeInOut,
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
        // Apply phase offset so staggered blocks feel organic
        final t = (_anim.value + widget.phaseOffset) % 1.0;
        final opacity = _baseOpacity +
            (_peakOpacity - _baseOpacity) *
                (math.sin(t * math.pi * 2) * 0.5 + 0.5);

        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1917).withOpacity(opacity),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}

// ─── Text lines skeleton ───────────────────────────────────

class _SkeletonTextBlock extends StatelessWidget {
  const _SkeletonTextBlock({
    required this.lines,
    required this.lineHeight,
    required this.spacing,
    required this.lastLineWidth,
  });

  final int lines;
  final double lineHeight;
  final double spacing;
  final double lastLineWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(lines, (i) {
        final isLast = i == lines - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: i < lines - 1 ? spacing : 0),
          child: FractionallySizedBox(
            widthFactor: isLast ? lastLineWidth : 1.0,
            child: SkeletonLoader(
              width: double.infinity,
              height: lineHeight,
              borderRadius: 4,
              phaseOffset: i * 0.08,
            ),
          ),
        );
      }),
    );
  }
}

// ─── Card skeleton ─────────────────────────────────────────

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({this.width, required this.height});

  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E6E1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image area
          SkeletonLoader(
            width: double.infinity,
            height: height * 0.65,
            borderRadius: 14,
            phaseOffset: 0.0,
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(
                  width: double.infinity,
                  height: 13,
                  borderRadius: 4,
                  phaseOffset: 0.1,
                ),
                const SizedBox(height: 8),
                SkeletonLoader(
                  width: 120,
                  height: 11,
                  borderRadius: 4,
                  phaseOffset: 0.18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Outfit tile skeleton ──────────────────────────────────

class _SkeletonOutfitTile extends StatelessWidget {
  const _SkeletonOutfitTile();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Thumbnail
        SkeletonLoader(
          width: 64,
          height: 80,
          borderRadius: 10,
          phaseOffset: 0.0,
        ),
        const SizedBox(width: 14),
        // Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLoader(
                width: double.infinity,
                height: 13,
                borderRadius: 4,
                phaseOffset: 0.08,
              ),
              const SizedBox(height: 7),
              SkeletonLoader(
                width: 100,
                height: 11,
                borderRadius: 4,
                phaseOffset: 0.15,
              ),
              const SizedBox(height: 7),
              SkeletonLoader(
                width: 64,
                height: 11,
                borderRadius: 4,
                phaseOffset: 0.22,
              ),
            ],
          ),
        ),
      ],
    );
  }
}