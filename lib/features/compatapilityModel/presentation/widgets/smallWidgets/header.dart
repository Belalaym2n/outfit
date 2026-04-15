import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_proj/core/utils/app_colors.dart';
import 'package:graduation_proj/core/utils/app_constants.dart';

import '../../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../../core/sharedWidgets/text_styles.dart';

 class PageHeader extends StatelessWidget {
  const PageHeader({
    required this.hPad,
    required this.headerFade,
    required this.headerSlide,
    required this.subtitleFade,
    required this.subtitleSlide,
  });

  final double            hPad;
  final Animation<double> headerFade;
  final Animation<Offset>  headerSlide;
  final Animation<double> subtitleFade;
  final Animation<Offset>  subtitleSlide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, Sp.md, hPad, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step indicator pill
           FadeSlide(
            fade: headerFade, slide: headerSlide,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(40),
              ),
              child:   Text('STEP 1 OF 2', style: T.fieldLabel),
            ),
          ),
          const SizedBox(height: 14),
          // Main title
          FadeSlide(
            fade: headerFade, slide: headerSlide,
            child:   Text(
              'Prepare Your\nOutfit Analysis',
              style: T.display,
            ),
          ),
          const SizedBox(height: 10),
          // Subtitle
           FadeSlide(
            fade: subtitleFade, slide: subtitleSlide,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.8,
              ),
              child: const Text(
                'Add all 5 outfit items below. Our AI model analyses each piece together to generate your personalised style score.',
                style: T.body,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
