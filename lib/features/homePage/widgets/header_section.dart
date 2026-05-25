
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/sharedWidgets/Buttons/primary_buttons.dart';
import '../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../core/sharedWidgets/text_styles.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../compatapilityModel/presentation/pages/request_to_recommend.dart' hide T;
import 'app_name.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({
    required this.hPad,
    required this.badgeFade,
    required this.badgeSlide,
    required this.headlineFade,
    required this.headlineSlide,
    required this.subtitleFade,
    required this.subtitleSlide,
    required this.ctaFade,
    required this.ctaSlide,
    required this.buttonScale,
    required this.onCtaTap,
  });

  final double hPad;
  final Animation<double> badgeFade;
  final Animation<Offset> badgeSlide;
  final Animation<double> headlineFade;
  final Animation<Offset> headlineSlide;
  final Animation<double> subtitleFade;
  final Animation<Offset> subtitleSlide;
  final Animation<double> ctaFade;
  final Animation<Offset> ctaSlide;
  final Animation<double> buttonScale;
  final VoidCallback onCtaTap;

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, Sp.lg, hPad, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Eyebrow badge
          FadeSlide(
            fade: badgeFade,
            slide: badgeSlide,
            child: const EyebrowBadge(),
          ),

          const SizedBox(height: 22),

          // Headline
          FadeSlide(
            fade: headlineFade,
            slide: headlineSlide,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenW * 0.88),
              child:   Text(
                'Dress with\nconfidence,\npowered by AI.',
                style:  T.displayLarg,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Subtitle
          FadeSlide(
            fade: subtitleFade,
            slide: subtitleSlide,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenW * 0.75),
              child: Text(
                'Upload your outfit and receive an intelligent style score with precise, actionable feedback — in seconds.',
                style:  T.body,
              ),
            ),
          ),

          SizedBox(height: Sp.lg),


          FadeSlide(
            fade: ctaFade, slide: ctaSlide,
            child: PrimaryBtn(
              label: 'Start OutFix AI Analysis',
              scale: buttonScale,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadScreen()),
                );
              },            ),
          ),


          // Trust micro-copy
         ],
      ),
    );
  }
}


