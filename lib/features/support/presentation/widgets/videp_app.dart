import 'package:flutter/material.dart';
import 'dart:math' as math;

// ─────────────────────────────────────────────
//  ENTRY POINT

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/app_colors.dart';
class HelpVideoCard extends StatefulWidget {
  const HelpVideoCard();

  @override
  State<HelpVideoCard> createState() => _HelpVideoCardState();
}

class _HelpVideoCardState extends State<HelpVideoCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;

  late final AnimationController _playPulseCtrl;
  late final Animation<double> _playPulse;

  @override
  void initState() {
    super.initState();
    _playPulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _playPulse = Tween<double>(
      begin: 0.94,
      end: 1.06,
    ).animate(CurvedAnimation(parent: _playPulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _playPulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..translate(0.0, _pressed ? 2.0 : 0.0),
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_pressed ? 0.04 : 0.07),
              blurRadius: 18,
              spreadRadius: -4,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Thumbnail placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: AppColors.surfaceAlt),
                child: const Center(
                  child: Icon(Icons.movie_outlined, size: 48, color: AppColors.divider),
                ),
              ),
            ),

            // Label
            Positioned(
              bottom: 14,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'How to Use StyleAI',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textHigh,
                  ),
                ),
              ),
            ),

            // Play button — pulses gently
            AnimatedBuilder(
              animation: _playPulse,
              builder: (_, __) => Transform.scale(
                scale: _playPulse.value,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.ink,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.ink.withOpacity(0.25),
                        blurRadius: 20,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 28,
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
