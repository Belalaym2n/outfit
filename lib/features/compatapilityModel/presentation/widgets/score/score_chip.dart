import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_proj/core/utils/app_colors.dart';
import 'package:graduation_proj/core/utils/app_constants.dart';

import '../../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../../core/sharedWidgets/text_styles.dart';

class ScoreChip extends StatelessWidget {
  const ScoreChip({required this.label, required this.score, this.warning = false});
  final String label;
  final String score;
  final bool   warning;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: warning ? AppColors.ink.withOpacity(0.07) : AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: warning ? AppColors.ink.withOpacity(0.2) : AppColors.divider,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: warning ? AppColors.textHigh : AppColors.textMid,
              )),
          const SizedBox(width: 6),
          Text(score,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: warning ? AppColors.ink : AppColors.textMid,
              )),
        ],
      ),
    );
  }
}
