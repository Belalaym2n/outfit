
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import '../../features/drawer/buildMenus.dart';
import 'app_colors.dart';

abstract final class T {
  static final display = TextStyle(
    fontSize: 26, fontWeight: FontWeight.w700,
    color:AppColors.textHigh, letterSpacing: -0.9, height: 1.12,
  );
  static const heading = TextStyle(
    fontSize: 17, fontWeight: FontWeight.w600,
    color:AppColors.textHigh, letterSpacing: -0.3,
  );
  static const body = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400,
    color:AppColors.textMid, letterSpacing: 0.0, height: 1.6,
  );
  static const caption = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w600,
    color:AppColors.textLow, letterSpacing: 1.4,
  );
  static const label = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w500,
    color:AppColors.textMid, letterSpacing: 0.1,
  );
  static const drawerItem = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w500,
    color:AppColors.textHigh, letterSpacing: -0.1,
  );
  static const cardTitle = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600,
    color:AppColors.textHigh, letterSpacing: -0.1,
  );
  static const cardBody = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w400,
    color:AppColors.textMid, letterSpacing: 0.0, height: 1.5,
  );
  static const headline = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
    letterSpacing: -0.6,
    height: 1.15,
  );

}