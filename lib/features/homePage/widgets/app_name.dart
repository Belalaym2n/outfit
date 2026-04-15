import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/sharedWidgets/Buttons/primary_buttons.dart';
import '../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../core/sharedWidgets/text_styles.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../compatapilityModel/presentation/pages/request_to_recommend.dart' hide T;

class EyebrowBadge extends StatelessWidget {
  const EyebrowBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: AppColors.whiteBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'AI STYLE ENGINE — ACTIVE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textMid,
              letterSpacing: 1.2,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
