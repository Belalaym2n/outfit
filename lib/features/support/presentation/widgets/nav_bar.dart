import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';

class  NavBar extends StatelessWidget {
  const NavBar({
    required this.title,
    required this.hPad,
    required this.onBack,
    this.trailing,
  });

  final String title;
  final double hPad;
  final VoidCallback onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 12),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: AppColors.divider),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textMid,
                size: 15,
              ),
            ),
          ),

          if (title.isNotEmpty) ...[
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textHigh,
                letterSpacing: -0.3,
              ),
            ),
            const Spacer(),
            SizedBox(width: trailing != null ? 0 : 38),
          ],

          if (trailing != null) ...[const Spacer(), trailing!],
        ],
      ),
    );
  }
}
