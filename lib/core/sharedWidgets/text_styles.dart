import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';

abstract final class T {
  static final display = TextStyle(
    fontSize: 30, fontWeight: FontWeight.w700,
    color: AppColors.textHigh, letterSpacing: -1.0, height: 1.12,
  );
  static final subtitle = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w400,
    color: AppColors.textMid,  letterSpacing: 0.0,  height: 1.6,
  );
  static final fieldLabel = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w500,
    color: AppColors.textMid, letterSpacing: 0.2,
  );
  static  final fieldText = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w400,
    color: AppColors.textHigh, letterSpacing: 0.0,
  );
  static final btn = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600,
    color: Colors.white, letterSpacing: -0.1,
  );
  static final link = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w500,
    color: AppColors.textLink, letterSpacing: 0.0,
    decoration: TextDecoration.underline,
    decorationColor: Color(0xFF6B6861),
  );
  static final caption = TextStyle(


    fontSize: 12, fontWeight: FontWeight.w500,
    color: AppColors.textLow, letterSpacing: 1.3,
  );
  static final bodySmall = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w400,
    color: AppColors.textMid, letterSpacing: 0.0, height: 1.5,
  );



  static const TextStyle displayLarg = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryColor,
    letterSpacing: -1.8,
    height: 1.08,
  );
  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: 0.1,
    height: 1.65,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.3,
  );
  static const TextStyle cardBody = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: 0.1,
    height: 1.6,
  );
}
