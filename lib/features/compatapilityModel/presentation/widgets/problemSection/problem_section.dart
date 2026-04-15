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
  });

  final String? base64Image;
  final double hPad;
  final String itemLabel;
  final String suggestion;

  IconData _iconFor(String key) {
    switch (key.toLowerCase()) {
      case 'shoe':
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
    final Uint8List? decodedImage = _decodeBase64(base64Image);

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 24, hPad, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.ink.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.ink.withOpacity(0.15)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        size: 13, color: AppColors.textHigh),
                    SizedBox(width: 5),
                    Text(
                      'Issue Detected',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textHigh,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
                    label: 'Current',
                    icon: _iconFor(itemLabel),
                    caption: 'Current $itemLabel',
                    highlighted: false,
                    imageBytes: null,
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