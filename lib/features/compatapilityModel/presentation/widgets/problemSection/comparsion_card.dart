import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:graduation_proj/core/utils/app_colors.dart';

class ComparisonCard extends StatelessWidget {
    ComparisonCard({
    super.key,
    required this.label,
      this.imageBytes,
      this.imageUrl,
    required this.caption,
    required this.icon,
    required this.highlighted,
  });

  final String label;
  final Uint8List? imageBytes;
  final IconData icon;
  final String caption;
  final bool highlighted;
  final String? imageUrl; // 🔥 جديد
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.white : AppColors.surfaceAlt,
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
            child:   ClipRRect(
          borderRadius: BorderRadius.circular(10),
      child: _buildImage(),
    ),
          ),

          const SizedBox(height: 10),

          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: highlighted
                  ? AppColors.surface3
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
              color: highlighted ?AppColors.primaryColor : AppColors.textHigh,
            ),
          ),
        ],
      ),
    );
  }
    Widget _buildImage() {
      // 🔥 أولاً: لو bytes
      if (imageBytes != null) {
        return Image.memory(
          imageBytes!,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          filterQuality: FilterQuality.medium,
          errorBuilder: (_, __, ___) => _errorIcon(),
        );
      }

      // 🔥 ثانياً: لو URL
      if (imageUrl != null && imageUrl!.isNotEmpty) {
        return Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (_, __, ___) => _errorIcon(),
        );
      }

      // 🔥 fallback
      return Center(child: Icon(icon, size: 28));
    }
    Widget _errorIcon() {
      return Icon(
        Icons.broken_image,
        color: highlighted ? Colors.white : AppColors.textLow,
      );
    }
}
