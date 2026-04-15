import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';


class TeamMemberTopBar   extends StatelessWidget {
  const TeamMemberTopBar({
    required this.shareKey,
    required this.onShare,
    required this.hPad,
  });

  final GlobalKey shareKey;
  final VoidCallback onShare;
  final double hPad;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: Sp.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          GestureDetector(
            key: shareKey,
            onTap: onShare,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.divider),
              ),
              child: const Icon(
                Icons.ios_share_rounded,
                color: AppColors.ink,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
