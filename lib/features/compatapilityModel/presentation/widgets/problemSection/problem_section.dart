import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_texts.dart';
import 'comparsion_card.dart';

class ProblemSection extends StatelessWidget {
  const ProblemSection({
    super.key,
    required this.hPad,
    required this.itemLabel,
    required this.base64Image,
    required this.suggestion,
      this.currentImage,  this.currentImageUrl, // 🔥

  });
  final String? currentImageUrl; // 🔥 جديد
  final Uint8List? currentImage;
  final String? base64Image;
  final double hPad;
  final String itemLabel;
  final String suggestion;

  IconData _iconFor(String key) {
    switch (key.toLowerCase()) {
      case 'shoe':
        return Icons.directions_walk_rounded;
      case 'shoes':
        return Icons.directions_walk_rounded;
      case 'top':
        return Icons.checkroom_rounded;
      case 'bottom':
        return Icons.airline_seat_legroom_normal_rounded;
      case 'bag':
        return Icons.shopping_bag_rounded;
      default:
        return Icons.watch_rounded;
    }
  }

  Uint8List? _decodeBase64(String? base64) {
    if (base64 == null) return null;

    try {
      return base64Decode(base64);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("widget labe; ${itemLabel}");
    final Uint8List? decodedImage = _decodeBase64(base64Image);

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 24, hPad, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ),


          const SizedBox(height: 10),

          Text(itemLabel, style: T.heading),

          const SizedBox(height: 4),

          Text(
            "The current $itemLabel clashes with the outfit's overall formality level.",
            style: T.body,
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.divider),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 14,
                  spreadRadius: -3,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ComparisonCard(

                    imageUrl: currentImageUrl,
                    label: 'Current',
                    icon: _iconFor(itemLabel),
                    caption: 'Current $itemLabel',

                    highlighted: false,
                    imageBytes: currentImage,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: AppColors.ink,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Swap',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textLow,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ComparisonCard(
                    label: 'Suggested',
                    icon: Icons.business_center_rounded,
                    caption: suggestion,
                    highlighted: true,
                    imageBytes: decodedImage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}