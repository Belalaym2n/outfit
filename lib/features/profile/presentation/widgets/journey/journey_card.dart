
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/sharedWidgets/text_styles.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../data/models/user_data.dart';


class JourneyCard extends StatelessWidget {
    JourneyCard({
    super.key,
    required this.hPad,
    required this.progressValue,
    required this.user,
  });
  final double            hPad;

  UserModel user;
  final Animation<double> progressValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color:AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color:AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16, spreadRadius: -3,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Header row
            Row(
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color:AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.trending_up_rounded,
                    color:AppColors.textMid, size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your AI Journey', style: T.cardTitle.copyWith(
                      color: AppColors.primaryColor
                    ) ),
                    Text('Style mastery progress', style: T.fieldLabel.copyWith(
                      fontSize: 10
                    )),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:   Text(user.avgScore.toString(), style: T.fieldLabel),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Motivational message
            Text(
              user.avgScore > 60
                  ? "You're developing strong colour coordination skills. Focus on accessory-outfit balance to elevate your score further."
                  : "Keep improving your colour coordination skills. Try experimenting with different combinations to boost your score.",
              style: T.body,
            ),
            const SizedBox(height: 16),

            // Animated progress bar
            AnimatedBuilder(
              animation: progressValue,
              builder: (_, __) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Track
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Stack(
                        children: [
                          // Background track
                          Container(
                            height: 7,
                            decoration: BoxDecoration(
                              color:AppColors.surfaceAlt,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          // Filled portion
                          FractionallySizedBox(
                            widthFactor:user.avgScore.toDouble()/100,
                            child: Container(
                              height: 7,
                              decoration: BoxDecoration(
                                color:AppColors.ink,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Level indicators
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text(getLevel(user.avgScore), style: T.fieldLabel),
                Text('Style Expert', style: T.fieldLabel),
                ],
                ),
                ]);
              },
            ),

          ],
        ),
      ),
    );
  }

    String getLevel(int score) {
      if (score < 40) {
        return "Beginner";
      } else if (score < 70) {
        return "Intermediate";
      } else {
        return "Style Expert";
      }
    }
}
