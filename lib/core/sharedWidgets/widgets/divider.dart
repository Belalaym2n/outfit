
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

import 'package:flutter/cupertino.dart' show StatelessWidget;
import 'package:flutter/material.dart';

class  OrDivider extends StatelessWidget {
  const OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Text('OR', style: T.caption),
      ),
      const Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
    ]);
  }
}
