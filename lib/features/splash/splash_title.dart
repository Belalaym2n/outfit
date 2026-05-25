
import 'package:flutter/material.dart';
import '../../core/sharedWidgets/text_styles.dart';
import '../../core/utils/app_colors.dart';

class SplashTitle extends StatelessWidget {
  const SplashTitle({
    super.key,
    required this.fadeAnim,
    required this.slideAnim,
  });

  final Animation<double> fadeAnim;
  final Animation<Offset> slideAnim;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnim,
      child: SlideTransition(
        position: slideAnim,
        child: const _TitleContent(),
      ),
    );
  }
}

class _TitleContent extends StatelessWidget {
  const _TitleContent();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          'Outfix',
          style: T.display.copyWith(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.2,
            color: AppColors.textHigh,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.ink,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'AI',
            style: T.caption.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
              color: AppColors.bg,
            ),
          ),
        ),
      ],
    );
  }
}