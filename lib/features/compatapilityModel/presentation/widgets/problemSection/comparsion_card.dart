import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:graduation_proj/core/utils/app_colors.dart';

class ComparisonCard extends StatelessWidget {
  const ComparisonCard({
    super.key,
    required this.label,
    required this.imageBytes,
    required this.caption,
    required this.icon,
    required this.highlighted,
  });

  final String label;
  final Uint8List? imageBytes;
  final IconData icon;
  final String caption;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.ink : AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlighted ? AppColors.ink : AppColors.divider,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 72,
            decoration: BoxDecoration(
              color: highlighted
                  ? Colors.white.withOpacity(0.12)
                  : AppColors.divider,
              borderRadius: BorderRadius.circular(10),
            ),
            child: imageBytes != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                      imageBytes!,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      filterQuality: FilterQuality.medium,
                      errorBuilder: (context, error, stackTrace) {
                        print("error ${error.toString()}");
                        return Icon(
                          Icons.broken_image,
                          color: highlighted ? Colors.white : AppColors.textLow,
                        );
                      },
                    ),
                  )
                : Icon(
                    icon,
                    color: highlighted ? Colors.white : AppColors.textLow,
                    size: 28,
                  ),
          ),

          const SizedBox(height: 10),

          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: highlighted
                  ? Colors.white.withOpacity(0.6)
                  : AppColors.textLow,
              letterSpacing: 0.8,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            caption,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: highlighted ? Colors.white : AppColors.textHigh,
            ),
          ),
        ],
      ),
    );
  }
}
