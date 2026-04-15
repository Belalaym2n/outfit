import 'package:flutter/material.dart';

import '../../../core/sharedWidgets/text_styles.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';

class  TopBar extends StatelessWidget {
  const TopBar({required this.hPad});
  final double hPad;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: Sp.sm),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.divider),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.ink,
                size: 20,
              ),
            ),
          ),
          const Spacer(),
          Text('OUTFIT AI', style: T.caption),
        ],
      ),
    );
  }
}
