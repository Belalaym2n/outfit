


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_proj/core/utils/app_constants.dart';

import '../../core/cahsing/app_storage_service.dart';
import '../../core/utils/app_colors.dart';
final _storage = AppStorageService.instance;

class  DrawerUserCard extends StatelessWidget {
    DrawerUserCard();
  final name = _storage.getName();
  final email = _storage.getEmail();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color:AppColors.surfaceAlt,
            shape: BoxShape.circle,
            border: Border.all(color:AppColors.divider, width: 2),
          ),
          child: Icon(Icons.person_rounded, color:AppColors.textLow, size: 24),
        ),

        const SizedBox(width: 12),

        // Name + email
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1, // 👈 مهم
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textHigh,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 2),
              Text(
                email,
                maxLines: 1, // 👈 مهم
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textLow,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
