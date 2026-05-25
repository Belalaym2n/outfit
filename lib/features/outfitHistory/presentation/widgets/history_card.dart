// features/history/widgets/history_card.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_proj/features/outfitHistory/presentation/widgets/score_row.dart' show ScoreRow;
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_texts.dart';
import '../../data/models/outfit_history_model.dart';
import 'compatable_padge.dart';
import 'outfit_images_grid.dart';

class HistoryCard extends StatefulWidget {
  final OutfitHistoryModel item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const HistoryCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _pressScale;
  double _dragOffset = 0;
  bool _showDeleteHint = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _pressScale = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _pressController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _pressController.forward();

  void _onTapUp(TapUpDetails _) async {
    await _pressController.reverse();
    widget.onTap();
  }

  void _onTapCancel() => _pressController.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onLongPress: () {
        HapticFeedback.mediumImpact();
        widget.onDelete();
      },
      onHorizontalDragUpdate: (d) {
        setState(() {
          _dragOffset += d.delta.dx;
          _showDeleteHint = _dragOffset < -40;
        });
      },
      onHorizontalDragEnd: (_) {
        if (_dragOffset < -80) widget.onDelete();
        setState(() {
          _dragOffset = 0;
          _showDeleteHint = false;
        });
      },
      child: AnimatedBuilder(
        animation: _pressScale,
        builder: (_, child) =>
            Transform.scale(scale: _pressScale.value, child: child),
        child: Stack(
          children: [
            // Delete hint bg
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: _showDeleteHint ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.scoreLow.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: Sp.sm),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.scoreLow,
                    size: 22,
                  ),
                ),
              ),
            ),

            // Card body
            Transform.translate(
              offset: Offset(_dragOffset.clamp(-80.0, 0.0), 0),
              child: _CardBody(item: widget.item),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardBody extends StatelessWidget {
  final OutfitHistoryModel item;

  const _CardBody({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sp.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: const [
          BoxShadow(
            color: AppColors.inkShadow,
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Images stack
          OutfitImagesGrid(
            topImagePath: item.topImagePath,
            bottomImagePath: item.bottomImagePath,
            shoeImagePath: item.shoeImagePath,
            accessoryImagePath: item.accessoryImagePath,
            bagImagePath: item.bagImagePath,
            itemSize: 48,
          ),

          const SizedBox(height: Sp.sm),

          SingleChildScrollView(
            child: Row(
              children: [
                CompatBadge(isCompatible: item.isCompatible),
                const Spacer(),
                Expanded(
                  child: Text(
                    item.formattedDate,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: T.caption,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Sp.xs),
          ScoreRow(label: 'Original', score: item.originalScore*100),
          const SizedBox(height: 4),
          ScoreRow(
            label: 'Improved',
            score: item.improvedScore*100,
            highlight: true,
          ),
          if (item.replacements.isNotEmpty) ...[
            const SizedBox(height: Sp.xs),
            Text(
              '${item.replacements.length} AI suggestion${item.replacements.length > 1 ? 's' : ''}',
              style: T.label.copyWith(color: AppColors.textLow),
            ),
          ],

          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textLow,
            size: 18,
          ),
        ],
      ),
    );
  }
}


