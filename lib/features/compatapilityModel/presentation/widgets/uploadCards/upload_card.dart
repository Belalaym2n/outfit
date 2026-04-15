import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_texts.dart';
import '../../../data/models/items_model.dart';
import '../../manager/outfit_bloc.dart';
import '../../manager/outfit_events.dart';

// ─── Single card ────────────────────────────────────────────

class UploadCard extends StatefulWidget {
  const UploadCard({
    super.key,
    required this.item,
    required this.image,
    required this.onTap,
    required this.onRemove,
  });

  final Item         item;
  final XFile?       image;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  State<UploadCard> createState() => _UploadCardState();
}

class _UploadCardState extends State<UploadCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double>   _pressScale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 120),
    );
    _pressScale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    HapticFeedback.selectionClick();
    await _pressCtrl.forward();
    await _pressCtrl.reverse();
    widget.onTap();
  }

  bool get _hasImage => widget.image != null;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pressScale,
      child: GestureDetector(
        onTap: _handleTap,
        onTapDown:   (_) => _pressCtrl.forward(),
        onTapCancel: ()  => _pressCtrl.reverse(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
          height: 150,
          decoration: BoxDecoration(
            color: _hasImage ? AppColors.surfaceAlt : AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _hasImage ? AppColors.ink : AppColors.divider,
              width: _hasImage ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_hasImage ? 0.09 : 0.05),
                blurRadius: _hasImage ? 20 : 12,
                spreadRadius: -3,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Image preview OR empty state
              _hasImage
                  ? _ImagePreview(imagePath: widget.image!.path)
                  : _EmptyState(item: widget.item),

              // Edit overlay when filled
              if (_hasImage)
                Positioned(
                  top: 10, right: 10,
                  child: GestureDetector(
                    onTap: widget.onTap, // tap badge → replace
                    child: Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.ink,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.edit_rounded, color: Colors.white, size: 13,
                      ),
                    ),
                  ),
                ),

              // Remove (×) badge
              if (_hasImage)
                Positioned(
                  top: 10, left: 10,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      widget.onRemove();
                    },
                    child: Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(
                        color: Colors.red.shade400,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.close_rounded, color: Colors.white, size: 13,
                      ),
                    ),
                  ),
                ),

              // "Tap to add" hint
              if (!_hasImage)
                Positioned(
                  bottom: 10, left: 0, right: 0,
                  child: Center(
                    child: Text(
                      'Tap to add',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textLow,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Image preview fills the card ───────────────────────────

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.imagePath});
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.file(
        File(imagePath),
        width:  double.infinity,
        height: double.infinity,
        fit:    BoxFit.cover,
      ),
    );
  }
}

// ─── Empty slot state ────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.item});
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(item.icon, color: AppColors.textLow, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            item.label,
            style: T.label.copyWith(color: AppColors.textMid),
          ),
          if (item.optional) ...[
            const SizedBox(height: 2),
            const Text(
              'Optional',
              style: TextStyle(
                fontSize: 10, color: AppColors.textLow, letterSpacing: 0.3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Mobile 2-column list ────────────────────────────────────

class MobileCardList extends StatelessWidget {
  const MobileCardList({
    super.key,
    required this.cardFades,
    required this.cardSlides,
    required this.images,
    required this.onTap,
  });

  final List<Animation<double>> cardFades;
  final List<Animation<Offset>>  cardSlides;
  final List<XFile?>             images;
  final ValueChanged<int>        onTap;

  @override
  Widget build(BuildContext context) {
    final pairs = <List<int>>[];
    for (int i = 0; i < 5; i += 2) {
      pairs.add(i + 1 < 5 ? [i, i + 1] : [i]);
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (_, rowIdx) {
          final pair = pairs[rowIdx];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: pair.map((i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left:  i.isOdd  ? 6 : 0,
                    right: i.isEven && pair.length > 1 ? 6 : 0,
                  ),
                  child: FadeSlide(
                    fade:  cardFades[i],
                    slide: cardSlides[i],
                    child: _ConnectedCard(index: i, image: images[i], onTap: onTap),
                  ),
                ),
              )).toList(),
            ),
          );
        },
        childCount: pairs.length,
      ),
    );
  }
}

// ─── Tablet 3-column grid ────────────────────────────────────

class TabletCardGrid extends StatelessWidget {
  const TabletCardGrid({
    super.key,
    required this.cardFades,
    required this.cardSlides,
    required this.images,
    required this.onTap,
  });

  final List<Animation<double>> cardFades;
  final List<Animation<Offset>>  cardSlides;
  final List<XFile?>             images;
  final ValueChanged<int>        onTap;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
            (_, i) => FadeSlide(
          fade:  cardFades[i],
          slide: cardSlides[i],
          child: _ConnectedCard(index: i, image: images[i], onTap: onTap),
        ),
        childCount: 5,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
    );
  }
}

// ─── BLoC-connected wrapper ──────────────────────────────────

class _ConnectedCard extends StatelessWidget {
  const _ConnectedCard({
    required this.index,
    required this.image,
    required this.onTap,
  });

  final int             index;
  final XFile?          image;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return UploadCard(
      item:     items[index],
      image:    image,
      onTap:    () => onTap(index),
      onRemove: () => context.read<OutfitBloc>().add(RemoveImageEvent(index)),
    );
  }
}