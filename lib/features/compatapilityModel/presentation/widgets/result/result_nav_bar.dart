import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_proj/core/utils/app_colors.dart';
import 'package:graduation_proj/core/utils/app_constants.dart';

import '../../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../../core/sharedWidgets/text_styles.dart';


class  ResultNavBar extends StatelessWidget {
  const ResultNavBar({required this.hPad});
  final double hPad;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: Sp.sm),
      child: Row(
        children: [
          RoundBtn(icon: Icons.arrow_back_ios_new_rounded, onTap: () => Navigator.pop(context)),
          const Spacer(),
          const Text(
            'Analysis Result',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textHigh,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          RoundBtn(icon: Icons.share_rounded, onTap: () {}),
        ],
      ),
    );
  }
}



// ─────────────────────────────────────────────────────────────
//  ROUND ICON BUTTON
// ─────────────────────────────────────────────────────────────
class  RoundBtn extends StatelessWidget {
  const RoundBtn({required this.icon, required this.onTap});
  final IconData     icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 40, height: 40,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: AppColors.textMid, size: 18),
    ),
  );
}
