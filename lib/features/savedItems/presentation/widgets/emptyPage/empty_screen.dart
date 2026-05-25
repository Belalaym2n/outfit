

import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../pages/saved_items_presentation.dart';
// ─────────────────────────────────────────────────────────────
//  SAVE BUTTON  — heart with particle burst
// ─────────────────────────────────────────────────────────────
class  EmptySavedState extends StatefulWidget {
  EmptySavedState({required this.dark});
  final bool dark;

  @override
  State<EmptySavedState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<EmptySavedState>
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
    final textHigh =   AppColors.textHigh  ;
    final textMid  =   AppColors.textMid ;
    final accent   =   AppColors.accent    ;

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
                  Container(
                   width: 130, height: 130,
                   decoration: BoxDecoration(
                     shape: BoxShape.circle,
                    color: AppColors.primaryColor
                   ),
                                      ),

                  // Icon container
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                    ),
                    child: Icon(
                      Icons.dry_cleaning_outlined,
                      size: 44,

                      color: Colors.white,
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

            ],
        ),
      ),
    );
  }
}

