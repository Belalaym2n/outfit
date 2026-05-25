

import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../../../../../core/utils/app_colors.dart';

class  GlassHeader extends StatelessWidget {
  const GlassHeader({
    required this.count,
    required this.badgeScale,
    required this.hPad,
  });

  final int count;
  final Animation<double> badgeScale;
  final double hPad;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.18),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.border.withOpacity(0.4),
                width: 1.0,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saved Outfits',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                          letterSpacing: -1.0,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Your curated fashion collection',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                ScaleTransition(
                  scale: badgeScale,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: AppColors.accent.withOpacity(0.25),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accent,
                            letterSpacing: -0.5,
                            height: 1.0,
                          ),
                        ),
                        Text(
                          'Items',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.accent.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
