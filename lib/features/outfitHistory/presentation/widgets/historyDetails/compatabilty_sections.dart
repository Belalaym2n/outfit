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




class CompatSection extends StatelessWidget {
  final double hPad;
  final OutfitHistoryModel item;

  const CompatSection({required this.hPad, required this.item});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(hPad, 0, hPad, Sp.sm),
    child:  SectionCard(
      label: 'COMPATIBILITY',
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.isCompatible
                  ? AppColors.scoreHigh.withOpacity(0.12)
                  : AppColors.scoreLow.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.isCompatible
                  ? Icons.check_circle_outline_rounded
                  : Icons.cancel_outlined,
              color: item.isCompatible
                  ? AppColors.scoreHigh
                  : AppColors.scoreLow,
              size: 24,
            ),
          ),
          SizedBox(width: Sp.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.isCompatible ? 'Compatible' : 'Not Compatible',
                  style: T.cardTitle.copyWith(
                    color: item.isCompatible
                        ? AppColors.scoreHigh
                        : AppColors.scoreLow,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.isCompatible
                      ? 'This outfit works well together.'
                      : 'Some pieces may clash in style or tone.',
                  style: T.cardBody,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
