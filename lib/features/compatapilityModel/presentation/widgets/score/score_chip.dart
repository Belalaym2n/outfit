import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';

/// A semantic status chip that communicates item-level feedback.
///
/// Replaces the old score-based chip with a label-only design that
/// carries a [warning] state and an optional leading icon.
/// Animates in with a combined fade + scale micro-interaction.
class ScoreChip extends StatefulWidget {
  const ScoreChip({
    super.key,
    required this.label,
    this.warning = false,
    this.animationDelay = Duration.zero,
  });

  /// The human-readable item label (e.g. "Top", "Shoe").
  final String label;

  /// When true the chip renders in its warning (mismatch) style.
  final bool warning;

  /// Optional stagger delay so chips can cascade into view.
  final Duration animationDelay;

  @override
  State<ScoreChip> createState() => _ScoreChipState();
}

class _ScoreChipState extends State<ScoreChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _scale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    // Honour stagger delay before playing.
    Future.delayed(widget.animationDelay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── colours ───────────────────────────────────────────────────────────────

  Color get _background =>
      widget.warning
          ? AppColors.ink.withOpacity(0.07)
          : AppColors.surfaceAlt;

  Color get _border =>
      widget.warning
          ? AppColors.ink.withOpacity(0.20)
          : AppColors.divider;

  Color get _labelColor =>
      widget.warning ? AppColors.textHigh : AppColors.textMid;

  Color get _statusColor =>
      widget.warning ? AppColors.ink : AppColors.textMid;

  // ── status text ───────────────────────────────────────────────────────────

  String get _statusLabel => widget.warning ? 'Mismatch' : 'OK';

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _background,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: _border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Leading warning icon – only visible in warning state.
              if (widget.warning) ...[
                Icon(
                  Icons.warning_amber_rounded,
                  size: 13,
                  color: _statusColor,
                ),
                const SizedBox(width: 4),
              ],

              // Item label.
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _labelColor,
                ),
              ),

              const SizedBox(width: 6),

              // Semantic status label.
              Text(
                _statusLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _statusColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}