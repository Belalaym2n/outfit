
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





class  ReplacementsSection extends StatelessWidget {
  final double hPad;
  final OutfitHistoryModel item;

  const ReplacementsSection({required this.hPad, required this.item});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(hPad, 0, hPad, Sp.sm),
    child:  SectionCard(
      label: 'AI SUGGESTIONS',
      child: Column(
        children: item.replacements.entries
            .map((e) => _ReplacementTile(itemLabel: e.key, suggestion: e.value))
            .toList(),
      ),
    ),
  );
}

class _ReplacementTile extends StatelessWidget {
  final String itemLabel;
  final String suggestion;

  const _ReplacementTile({required this.itemLabel, required this.suggestion});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Sp.xs),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 6, right: 10),
          decoration: const BoxDecoration(
            color: AppColors.ink,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: '$itemLabel: ', style: T.cardTitle),
                TextSpan(text: suggestion, style: T.cardBody),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}