

import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../pages/saved_items_presentation.dart';
// ─────────────────────────────────────────────────────────────
//  SAVE BUTTON  — heart with particle burst
// ─────────────────────────────────────────────────────────────
class  EmptyState extends StatefulWidget {
  const EmptyState({required this.dark});
  final bool dark;

  @override
  State<EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<EmptyState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  late final Animation<double>   _floatY;
  late final Animation<double>   _glowPulse;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
    _floatY = Tween<double>(begin: -12, end: 12).animate(
        CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
    _glowPulse = Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _floatCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final textHigh = widget.dark ? AppColors.textHigh : LT.textHigh;
    final textMid  = widget.dark ? AppColors.textMid  : LT.textMid;
    final accent   = widget.dark ? AppColors.accent   : LT.accent;

    return Center(
      child: AnimatedBuilder(
        animation: _floatCtrl,
        builder: (_, child) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // Floating mannequin icon
            Transform.translate(
              offset: Offset(0, _floatY.value),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glow behind icon
                  Opacity(
                    opacity: _glowPulse.value * 0.4,
                    child: Container(
                      width: 130, height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(
                          color: accent.withOpacity(0.4),
                          blurRadius: 60, spreadRadius: 20,
                        )],
                      ),
                    ),
                  ),

                  // Icon container
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.dark
                          ? AppColors.glassWhite
                          : LT.glassWhite,
                      border: Border.all(
                        color: widget.dark
                            ? AppColors.glassBorder
                            : LT.glassBorder,
                      ),
                    ),
                    child: Icon(
                      Icons.dry_cleaning_outlined,
                      size: 44,
                      color: textMid,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Text('No saved outfits yet',
                style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w700,
                  color: textHigh, letterSpacing: -0.5,
                )),
            const SizedBox(height: 8),
            Text('Explore and curate your style',
                style: TextStyle(fontSize: 15, color: textMid)),

            const SizedBox(height: 36),

            // CTA with glow
            GlowingCTA(dark: widget.dark, glowPulse: _glowPulse),
          ],
        ),
      ),
    );
  }
}

class GlowingCTA extends StatelessWidget {
  const GlowingCTA({required this.dark, required this.glowPulse});
  final bool dark;
  final Animation<double> glowPulse;

  @override
  Widget build(BuildContext context) {
    final accent = dark ? AppColors.accent : LT.accent;
    return AnimatedBuilder(
      animation: glowPulse,
      builder: (_, __) => GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(glowPulse.value * 0.45),
                blurRadius: 30,
                spreadRadius: -4,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Text(
            'Discover Recommendations',
            style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w600,
              color: dark ? AppColors.bg1 : Colors.white,
              letterSpacing: -0.1,
            ),
          ),
        ),
      ),
    );
  }
}
