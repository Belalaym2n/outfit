

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Colors;
import '../../../../core/utils/app_colors.dart';

class  Wordmark extends StatelessWidget {
  const Wordmark();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28, height: 28,
          decoration: BoxDecoration(
            color: AppColors.ink,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.auto_awesome_rounded,
              color: Colors.white, size: 14),
        ),
        const SizedBox(width: 8),
        const Text(
          'OutFix AI',
          style: TextStyle(
            fontSize: 17, fontWeight: FontWeight.w700,
            color: AppColors.textHigh, letterSpacing: -0.4,
          ),
        ),
      ],
    );
  }
}
