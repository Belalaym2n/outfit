
// ═══════════════════════════════════════════════════════════════
//  AI OUTFIT RECOMMENDATION SYSTEM
//  Premium Minimal Home Page
//  Theme: Dark Luxury · Apple × Linear × AI SaaS
// ═══════════════════════════════════════════════════════════════
//
//  ANIMATION OVERVIEW
//  ──────────────────────────────────────────────────────────────
//  _entranceController (1800ms) — orchestrates the entire page
//    entrance. Each element is assigned a unique Interval() window
//    within this single timeline, producing a natural staggered
//    cascade without managing multiple controllers.
//
//  _pulseController (4000ms, repeat) — drives the slow breathing
//    of the ambient background circle. Runs independently so it
//    never interrupts the entrance sequence.
//
//  _buttonController (260ms) — a TweenSequence that mimics a
//    physical press: compress -> slight overshoot -> settle.
//    Resets automatically so every tap feels fresh.
//
//  All curves use easeInOut / easeOutCubic family for that
//  "heavy, confident" motion that premium apps favour.
// ═══════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:graduation_proj/core/sharedWidgets/Buttons/primary_buttons.dart';
import 'package:graduation_proj/core/sharedWidgets/widgets/app_name.dart';



// ─────────────────────────────────────────────────────────────
import 'package:flutter/cupertino.dart';

import '../../../../core/sharedWidgets/text_styles.dart';
import '../../../../core/utils/app_colors.dart';
import '../../data/models/feature_models.dart';

class FeatureCard extends StatefulWidget {
  const FeatureCard({required this.data});

  final FeatureData data;

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..translate(0.0, _pressed ? 1.5 : 0.0),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: _pressed ? AppColors.surface2 : AppColors.surface1,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.whiteBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 16,
              spreadRadius: -4,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon block
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.whiteFaint,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: AppColors.whiteBorder),
              ),
              child: Icon(widget.data.icon, color: AppColors.white, size: 20),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.data.title, style:  T.cardTitle),
                      Text(
                        widget.data.tag,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(widget.data.body, style:  T.cardBody),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
