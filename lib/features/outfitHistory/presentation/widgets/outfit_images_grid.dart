// features/history/widgets/outfit_images_grid.dart

import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../data/models/images_model.dart';

class OutfitImagesGrid extends StatelessWidget {
  final String? topImagePath;
  final String? bottomImagePath;
  final String? shoeImagePath;
  final String? accessoryImagePath;
  final String? bagImagePath;
  final double itemSize;

  const OutfitImagesGrid({
    super.key,
    this.topImagePath,
    this.bottomImagePath,
    this.shoeImagePath,
    this.accessoryImagePath,
    this.bagImagePath,
    this.itemSize = 56,
  });

  @override
  Widget build(BuildContext context) {

    final images = <ImageSlot>[
      ImageSlot(label: 'Top', path: topImagePath),
      ImageSlot(label: 'Bottom', path: bottomImagePath),
      ImageSlot(label: 'Shoes', path: shoeImagePath),
      ImageSlot(label: 'Accessory', path: accessoryImagePath),
      ImageSlot(label: 'Bag', path: bagImagePath),
    ];
    return Wrap(
      direction: Axis.horizontal,
      spacing: Sp.xs,
      runSpacing: Sp.xs,
      children: images
          .map((slot) => _ImageTile(slot: slot, size: itemSize))
          .toList(),
    );
  }
}



class _ImageTile extends StatelessWidget {
  final ImageSlot slot;
  final double size;

  const _ImageTile({required this.slot, required this.size});

  @override
  Widget build(BuildContext context) {
    final hasImage = slot.path != null && slot.path!.isNotEmpty;
    print("image ${slot.path}");
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.divider),
          ),
          clipBehavior: Clip.hardEdge,
          child: hasImage
              ? Image.network(
            slot.path!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _Placeholder(label: slot.label),
          )
              : _Placeholder(label: slot.label),
        ),
        const SizedBox(height: 4),
        Text(
          slot.label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            color: AppColors.textLow,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String label;
  const _Placeholder({required this.label});

  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      label[0],
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textLow,
      ),
    ),
  );
}