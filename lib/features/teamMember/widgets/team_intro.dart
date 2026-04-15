import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/sharedWidgets/text_styles.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../data/team_data.dart';

class TeamIntroHeroSection extends StatelessWidget {
  const TeamIntroHeroSection({
    required this.hPad,
    required this.headerFade,
    required this.headerSlide,
    required this.subtitleFade,
    required this.subtitleSlide,
    required this.dividerFade,
  });

  final double hPad;
  final Animation<double> headerFade;
  final Animation<Offset> headerSlide;
  final Animation<double> subtitleFade;
  final Animation<Offset> subtitleSlide;
  final Animation<double> dividerFade;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, Sp.lg, hPad, Sp.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          FadeTransition(
            opacity: headerFade,
            child: Text('THE PEOPLE', style: T.caption),
          ),
          const SizedBox(height: Sp.xs),

          // Display headline
          FadeTransition(
            opacity: headerFade,
            child: SlideTransition(
              position: headerSlide,
              child: Text('Our Team', style: T.display),
            ),
          ),
          const SizedBox(height: Sp.xs),

          // Subtitle
          FadeTransition(
            opacity: subtitleFade,
            child: SlideTransition(
              position: subtitleSlide,
              child: Text(
                'Meet the people behind Outfit AI.',
                style: T.body,
              ),
            ),
          ),
          SizedBox(height: Sp.md),

          // Divider
          FadeTransition(
            opacity: dividerFade,
            child: Container(height: 1, color: AppColors.divider),
          ),
          const SizedBox(height: Sp.md),

          // Section label
          FadeTransition(
            opacity: dividerFade,
            child: Text('${TeamData.members.length} MEMBERS', style: T.caption),
          ),
          const SizedBox(height: Sp.sm),
        ],
      ),
    );
  }
}
