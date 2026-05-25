

// ═══════════════════════════════════════════════════════════════
//  save_button_widget.dart
//  Animated bookmark button.
//
//  • Plays bounce animation on save.
//  • Shows a small CircularProgressIndicator while [isLoading].
//  • Ignores taps while [isLoading] to prevent duplicate requests.
// ═══════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_constants.dart';

class SaveButtonWidget extends StatefulWidget {
  const SaveButtonWidget({
    super.key,
    required this.saved,
    required this.onTap,
    this.isLoading = false,
    this.large = false,
  });

  final bool saved;
  final VoidCallback onTap;

  /// When true, shows a spinner and ignores additional taps.
  final bool isLoading;

  final bool large;

  @override
  State<SaveButtonWidget> createState() => _SaveButtonWidgetState();
}

class _SaveButtonWidgetState extends State<SaveButtonWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounceCtrl;
  late final Animation<double> _bounceScale;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _bounceScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.35)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.35, end: 0.90)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.90, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(_bounceCtrl);
  }

  @override
  void dispose() {
    _bounceCtrl.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.isLoading) return; // guard against double-tap
    widget.onTap();
    _bounceCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    final size = widget.large ? w * 0.106 : w * 0.092;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _bounceScale,
        builder: (_, child) =>
            Transform.scale(scale: _bounceScale.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.saved
                ? AppColors.accent
                : AppColors.surface.withOpacity(0.88),
            boxShadow: [
              BoxShadow(
                color: (widget.saved ? AppColors.accent : AppColors.ink)
                    .withOpacity(widget.saved ? 0.24 : 0.10),
                blurRadius: widget.saved ? 14 : 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: widget.isLoading
          // Spinner replaces icon while request is in-flight.
              ? Padding(
            padding: EdgeInsets.all(size * 0.22),
            child: CircularProgressIndicator(
              strokeWidth: 1.8,
              color: widget.saved
                  ? AppColors.surface
                  : AppColors.inkMuted,
            ),
          )
              : Icon(
            widget.saved
                ? Icons.bookmark_rounded
                : Icons.bookmark_outline_rounded,
            size: size * 0.48,
            color:
            widget.saved ? AppColors.surface : AppColors.inkMuted,
          ),
        ),
      ),
    );
  }
}