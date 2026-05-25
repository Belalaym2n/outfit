
import 'dart:ui' show Image;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_proj/core/utils/app_constants.dart';

class BuildOutfitImage extends StatelessWidget {
    BuildOutfitImage({super.key,required this.images});
List<String>images;
  @override
  Widget build(BuildContext context) {
    return   Image.network(
      height:AppConstants.h*0.3,
      width: double.infinity,
       images[0],
      fit: BoxFit.cover,
       loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: const Color(0xFFF0EEE9),
          child: Center(
            child: CircularProgressIndicator(
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded /
                  progress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              color: const Color(0xFF9B8F82),
            ),
          ),
        );
      },
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xFFF0EEE9),
        child: const Icon(
          Icons.checkroom_outlined,
          size: 48,
          color: Color(0xFFCCC4BB),
        ),
      ),
    );
  }
}
