
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/intialization/init_di.dart';
import '../../../../core/sharedWidgets/animations/bg_animation.dart';
import '../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../core/sharedWidgets/animations/slide_naviagation.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart' show Sp;
import '../../../../core/utils/app_texts.dart';
class  ErrorState extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;
  const ErrorState({this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(Sp.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.scoreLow.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.wifi_off_rounded,
              color: AppColors.scoreLow,
              size: 32,
            ),
          ),
          const SizedBox(height: Sp.md),
          Text(
            message?.contains('401') == true
                ? 'Session Expired'
                : 'Something Went Wrong',
            style: T.heading,
          ),
          const SizedBox(height: Sp.xs),
          Text(
            message?.contains('401') == true
                ? 'Please log in again to continue.'
                : 'Check your connection and try again.',
            style: T.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Sp.md),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Sp.md, vertical: Sp.xs),
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Retry',
                style: T.label.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
