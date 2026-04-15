import 'package:flutter/material.dart';

import '../../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_texts.dart';

class ResultHeader extends StatelessWidget {
  const ResultHeader({
    super.key,
    required this.hPad,
    required this.headerFade,
    required this.headerSlide,
    required this.isCompatible,
  });

  final double hPad;
  final Animation<double> headerFade;
  final Animation<Offset> headerSlide;
  final bool isCompatible;

  @override
  Widget build(BuildContext context) {
    return FadeSlide(
      fade: headerFade,
      slide: headerSlide,
      child: Padding(
        padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text('AI EVALUATION COMPLETE', style: T.label),
            ),
            const SizedBox(height: 12),
            Text(
              isCompatible
                  ? 'Great Look!\nYour Outfit Works'
                  : 'Your Style\nScore is Ready',
              style: T.display,
            ),
            const SizedBox(height: 8),
            Text(
              isCompatible
                  ? 'Your outfit is well-coordinated — colour harmony, fit and trend alignment all score high.'
                  : 'Based on 5 outfit items — colour harmony, fit quality and trend alignment.',
              style: T.body,
            ),
          ],
        ),
      ),
    );
  }
}
