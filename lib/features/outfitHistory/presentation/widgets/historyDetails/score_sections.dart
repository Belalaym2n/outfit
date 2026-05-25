
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/sharedWidgets/text_styles.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../../data/models/outfit_history_model.dart';
import '../../pages/outfit_details_screen.dart';



class   ScoresSection extends StatelessWidget {
  final double hPad;
  final OutfitHistoryModel item;

  const ScoresSection({required this.hPad, required this.item});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(hPad, 0, hPad, Sp.sm),
    child:  SectionCard(
      label: 'SCORE COMPARISON',
      child: Row(
        children: [
          Expanded(
            child: _ScoreGauge(
              label: 'Original',
              score: item.originalScore*100,
              isHighlighted: false,
            ),
          ),
          Container(
            width: 1,
            height: 80,
            margin: const EdgeInsets.symmetric(horizontal: Sp.sm),
            color: AppColors.divider,
          ),
          Expanded(
            child: _ScoreGauge(
              label: 'AI Improved',
              score: item.improvedScore*100,
              isHighlighted: true,
            ),
          ),
        ],
      ),
    ),
  );
}
class _ScoreGauge extends StatelessWidget {
  final String label;
  final double score;
  final bool isHighlighted;

  const _ScoreGauge({
    required this.label,
    required this.score,
    required this.isHighlighted,
  });

  Color get _scoreColor {
    if (score >= 75) return AppColors.scoreHigh;
    if (score >= 50) return AppColors.scoreMid;
    return AppColors.scoreLow;
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        score.toStringAsFixed(0),
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w800,
          color: isHighlighted ? _scoreColor : AppColors.textMid,
          letterSpacing: -1.5,
          height: 1.0,
        ),
      ),
      Text(
        '%',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isHighlighted ? _scoreColor : AppColors.textLow,
        ),
      ),
      const SizedBox(height: Sp.xs),
      Text(label, style: T.caption),
      const SizedBox(height: 8),
      ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: LinearProgressIndicator(
          value: score / 100,
          minHeight: 6,
          backgroundColor: AppColors.surfaceAlt,
          valueColor: AlwaysStoppedAnimation<Color>(
            isHighlighted ? _scoreColor : AppColors.textLow,
          ),
        ),
      ),
    ],
  );
}
