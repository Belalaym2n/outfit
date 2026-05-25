import 'package:flutter/cupertino.dart';

import '../../../../../core/utils/app_constants.dart';
import '../../../../../core/utils/app_texts.dart';

class SectionHeader extends StatelessWidget {
  final String label;
  final String title;

  const SectionHeader({required this.label, required this.title});

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.055),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: T.label),
          const SizedBox(height: 6),
          Text(title, style: T.headline),
        ],
      ),
    );
  }
}
