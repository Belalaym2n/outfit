

import 'package:flutter/cupertino.dart';

import '../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../data/models/feature_models.dart';
import 'feature_cards.dart';

class  FeaturesSection extends StatelessWidget {
  const FeaturesSection({
    required this.hPad,
    required this.cardFades,
    required this.cardSlides,
    required this.isTablet,
  });

  final double hPad;
  final List<Animation<double>> cardFades;
  final List<Animation<Offset>> cardSlides;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    if (isTablet) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: hPad),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            featuresData.length,
                (i) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: i < featuresData.length - 1 ? 12 : 0,
                ),
                child: FadeSlide(
                  fade: cardFades[i],
                  slide: cardSlides[i],
                  child:  FeatureCard(data: featuresData[i]),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Column(
        children: List.generate(
          featuresData.length,
              (i) => Padding(
            padding: EdgeInsets.only(bottom: i < featuresData.length - 1 ? 12 : 0),
            child: FadeSlide(
              fade: cardFades[i],
              slide: cardSlides[i],
              child: FeatureCard(data: featuresData[i]),
            ),
          ),
        ),
      ),
    );
  }
}
