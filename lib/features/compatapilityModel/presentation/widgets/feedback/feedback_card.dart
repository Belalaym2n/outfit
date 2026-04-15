import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_texts.dart';
import '../score/score_chip.dart';

class FeedbackCard extends StatelessWidget {
  const FeedbackCard({
    super.key,
    required this.hPad,
    required this.highlights,
    required this.isCompatible,
  });

  final double   hPad;
  final List<double> highlights;
  final bool      isCompatible;

  String get _feedbackText {
    if (isCompatible) {
      return 'Your outfit demonstrates strong coordination between all pieces. '
          'The colour palette is cohesive and the formality levels match well. '
          'Keep up this great styling sense!';
    }
    return 'Your outfit shows some coordination between pieces, however certain '
        'items introduce inconsistencies in formality or colour harmony. '
        'Review the suggestions below to elevate your overall look.';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.divider),
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
            Row(
              children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    size: 16, color: AppColors.textHigh,
                  ),
                ),
                const SizedBox(width: 10),
                Text('AI Feedback', style: T.heading),
              ],
            ),
            const SizedBox(height: 14),
            Text(_feedbackText, style: T.body),
            if (highlights.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: highlights.asMap().entries.map((e) {
                  final labels = ['Top', 'Bottom', 'Shoe', 'Bag', 'Accessory'];
                  final label  = e.key < labels.length ? labels[e.key] : 'Item ${e.key + 1}';
                  final score  = e.value.toString();
                  final warn   = e.value < 70;
                  return ScoreChip(label: label, score: score, warning: warn);
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}