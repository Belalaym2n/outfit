
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/utils/app_colors.dart';
// ─────────────────────────────────────────────────────────────
//  SAVE BUTTON  — heart with particle burst
// ─────────────────────────────────────────────────────────────
class  SaveButton extends StatefulWidget {
  const  SaveButton({
    required this.isSaved,
    required this.dark,
    required this.onToggle,
  });
  final bool         isSaved;
  final bool         dark;
  final VoidCallback onToggle;

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _heartCtrl;
  late final Animation<double>   _heartScale;
  late final Animation<double>   _particleAnim;

  @override
  void initState() {
    super.initState();
    _heartCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _heartScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.35, end: 0.90), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.90, end: 1.0),  weight: 30),
    ]).animate(CurvedAnimation(parent: _heartCtrl, curve: Curves.easeOutBack));
    _particleAnim = CurvedAnimation(
        parent: _heartCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _heartCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onToggle();
        _heartCtrl.forward(from: 0);
      },
      child: AnimatedBuilder(
        animation: _heartCtrl,
        builder: (_, __) => Stack(
          alignment: Alignment.center,
          children: [
            // Particle burst
            if (_heartCtrl.value > 0 && _heartCtrl.value < 0.9)
              ...List.generate(6, (i) {
                final angle = i * math.pi / 3;
                final dist  = _particleAnim.value * 22;
                return Transform.translate(
                  offset: Offset(
                    math.cos(angle) * dist,
                    math.sin(angle) * dist,
                  ),
                  child: Opacity(
                    opacity: (1 - _particleAnim.value).clamp(0, 1),
                    child: Container(
                      width: 4, height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.savedRed,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),

            // Heart container
            ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.30),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                    ),
                  ),
                  child: ScaleTransition(
                    scale: _heartScale,
                    child: Icon(
                      widget.isSaved
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 16,
                      color: widget.isSaved
                          ? AppColors.savedRed
                          : Colors.white70,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}