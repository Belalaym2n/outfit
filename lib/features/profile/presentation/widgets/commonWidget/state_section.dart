

import 'package:flutter/material.dart';
import 'package:graduation_proj/features/profile/data/models/user_data.dart';

import '../../../../../core/sharedWidgets/widgets/states_cards.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({
    super.key,
    required this.hPad,
    required this.userModel,
  });

  final double hPad;
  final UserModel userModel;

  List<({String value, String label, IconData icon})> getStats() {
    return [
      (
      value: userModel.analyses.toString(),
      label: 'Analyses',
      icon: Icons.bar_chart_rounded
      ),
      (
      value: userModel.avgScore.toString(),
      label: 'Avg. Score',
      icon: Icons.auto_awesome_rounded
      ),
      // (
      // value: userModel.saved.toString(),
      // label: 'Saved',
      // icon: Icons.bookmark_rounded
      // ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final stats = getStats(); // ✅ الحل هنا

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Row(
        children: List.generate(stats.length, (i) {
          final s = stats[i];

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: i > 0 ? 8 : 0,
              ),
              child: StatCard(
                value: s.value,
                label: s.label,
                icon: s.icon,
              ),
            ),
          );
        }),
      ),
    );
  }
}