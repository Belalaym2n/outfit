

// ─────────────────────────────────────────────────────────────
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_proj/features/bottom_nav/bottom_nav.dart';

import '../../../../core/sharedWidgets/Buttons/bacl_button.dart';
import '../../../../core/sharedWidgets/animations/bg_animation.dart';
import '../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../core/sharedWidgets/fields/text_form_field.dart';
import '../../../../core/sharedWidgets/text_styles.dart';
import '../../../../core/sharedWidgets/widgets/app_name.dart';
import '../../../../core/utils/app_colors.dart';

class PrimaryBtn extends StatelessWidget {
  const PrimaryBtn({
    required this.label,
    required this.scale,
    required this.onTap,
    this.loading = false,
  });
  final String            label;
  final Animation<double> scale;
  final VoidCallback      onTap;
  final bool              loading;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color:         AppColors.ink,
            borderRadius:  BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color:       AppColors.inkShadow,
                blurRadius:  24,
                spreadRadius: -4,
                offset:      const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: loading
                ? const SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            )
                : Text(label, style: T.btn),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SHARED: OR DIVIDER
// ─────────────────────────────────────────────────────────────
