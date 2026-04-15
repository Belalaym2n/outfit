


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_constants.dart';

class  ProfileNavBar extends StatelessWidget {
  const ProfileNavBar({required this.hPad});
  final double hPad;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: Sp.sm),
      child: Row(
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color:AppColors.textHigh,
              letterSpacing: -0.4,
            ),
          ),
          const Spacer(),
          // Wordmark mark
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color:AppColors.ink,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white, size: 15,
            ),
          ),
        ],
      ),
    );
  }
}
