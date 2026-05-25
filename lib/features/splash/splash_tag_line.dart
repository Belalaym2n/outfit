
import 'package:flutter/material.dart';

import '../../core/sharedWidgets/text_styles.dart';
import '../../core/utils/app_colors.dart';

class SplashTagline extends StatelessWidget {
  const SplashTagline({
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
        child: const _TaglineContent(),
      ),
    );
  }
}

class _TaglineContent extends StatelessWidget {
  const _TaglineContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Style, Analyzed by Intelligence.',
          style: T.body.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textMid,
            letterSpacing: 0.1,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        _DividerDots(),
      ],
    );
  }
}

class _DividerDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Container(
          width: i == 1 ? 16 : 4,
          height: 4,
          decoration: BoxDecoration(
            color: i == 1 ? AppColors.ink : AppColors.divider,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      )),
    );
  }
}