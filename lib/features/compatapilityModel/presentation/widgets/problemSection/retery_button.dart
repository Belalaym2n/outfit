import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_proj/core/utils/app_colors.dart';
import 'package:graduation_proj/core/utils/app_constants.dart';

import '../../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../../core/sharedWidgets/text_styles.dart';

class  RetryButton extends StatelessWidget {
  const RetryButton({
    required this.hPad,
    required this.scale,
    required this.onTap,
    required this.safeBot,
  });

  final double            hPad;
  final Animation<double> scale;
  final VoidCallback      onTap;
  final double            safeBot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, Sp.lg, hPad, safeBot > 0 ? safeBot : Sp.sm),
      child: Column(
        children: [
          // Secondary: Share result
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.divider),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.share_rounded, size: 16, color: AppColors.textMid),
                SizedBox(width: 8),
                Text(
                  'Share Result',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMid,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Primary: Try another outfit
          ScaleTransition(
            scale: scale,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.ink,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.ink.withOpacity(0.20),
                      blurRadius: 20,
                      spreadRadius: -4,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Try Another Outfit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: -0.1,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}