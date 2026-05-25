import 'package:flutter/material.dart';

import '../../core/sharedWidgets/text_styles.dart';
import '../../core/utils/app_colors.dart';
class SplashBottomBar extends StatelessWidget {
  const SplashBottomBar({
    super.key,
    required this.fadeAnim,
    required this.progressAnim,
  });

  final Animation<double> fadeAnim;
  final Animation<double> progressAnim;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnim,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ProgressBar(progressAnim: progressAnim),
          const SizedBox(height: 16),
          Text(
            'Powered by Outfix Intelligence',
            style: T.caption.copyWith(
              fontSize: 10,
              letterSpacing: 1.2,
              color: AppColors.textLow,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progressAnim});

  final Animation<double> progressAnim;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progressAnim,
      builder: (_, __) => Container(
        width: 120,
        height: 2,
        decoration: BoxDecoration(
          color: AppColors.divider,
          borderRadius: BorderRadius.circular(1),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: progressAnim.value,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}