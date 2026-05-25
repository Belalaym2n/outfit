// features/history/outfit_details_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/intialization/init_di.dart';
import '../../../../core/sharedWidgets/animations/bg_animation.dart';
import '../../../../core/sharedWidgets/animations/fade_slide.dart';
import '../../../../core/sharedWidgets/animations/slide_naviagation.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart' show Sp;
import '../../../../core/utils/app_texts.dart';
import '../../../compatapilityModel/presentation/widgets/problemSection/comparsion_card.dart';
import '../../../compatapilityModel/presentation/widgets/problemSection/problem_section.dart';
import '../../data/models/outfit_history_model.dart';
import '../manager/events.dart';
import '../manager/outfit_history_bloc.dart';
import '../manager/states.dart';
import '../widgets/delete_dailog.dart';
import '../widgets/historyDetails/compatabilty_sections.dart';
import '../widgets/historyDetails/replacement_sections.dart';
import '../widgets/historyDetails/score_sections.dart';
import '../widgets/history_card.dart';
import '../widgets/outfit_images_grid.dart';
import 'outfit_details_screen.dart';
import 'outfit_history_screen.dart' show ResponsiveContext;

class OutfitDetailsScreen extends StatefulWidget {
  final OutfitHistoryModel item;

  // ✅ Removed: repository param — Bloc handles this now

  const OutfitDetailsScreen({super.key, required this.item});

  @override
  State<OutfitDetailsScreen> createState() => _OutfitDetailsScreenState();
}

class _OutfitDetailsScreenState extends State<OutfitDetailsScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final AnimationController _pulseCtrl;
  late final Animation<double> _bg1;
  late final Animation<double> _bg2;

  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _scoresFade;
  late final Animation<Offset> _scoresSlide;
  late final Animation<double> _replFade;
  late final Animation<Offset> _replSlide;
  late final Animation<double> _imgFade;
  late final Animation<Offset> _imgSlide;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _bg1 = Tween<double>(
      begin: -14,
      end: 14,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _bg2 = Tween<double>(
      begin: 10,
      end: -10,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _headerFade = _fade(0.0, 0.4);
    _headerSlide = _slide(0.0, 0.4);
    _imgFade = _fade(0.15, 0.5);
    _imgSlide = _slide(0.15, 0.5);
    _scoresFade = _fade(0.3, 0.65);
    _scoresSlide = _slide(0.3, 0.65);
    _replFade = _fade(0.5, 0.85);
    _replSlide = _slide(0.5, 0.85);

    _entranceCtrl.forward();
  }

  Animation<double> _fade(double s, double e) => CurvedAnimation(
    parent: _entranceCtrl,
    curve: Interval(s, e, curve: Curves.easeOut),
  );

  Animation<Offset> _slide(double s, double e) =>
      Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _entranceCtrl,
          curve: Interval(s, e, curve: Curves.easeOutCubic),
        ),
      );

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _delete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const DeleteDialog(),
    );
    if (confirmed != true || !mounted) return;
    context.read<OutfitHistoryBloc>().add(
      DeleteOutfitHistoryEvent(widget.item.id),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    print("widget ${widget.item.id}");
    print("widget ${widget.item.createdAt}");
    final hPad = context.hPad;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(backgroundColor: AppColors.bg, toolbarHeight: 0),
      body: Stack(
        children: [
          AmbientBg(float1: _bg1, float2: _bg2),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: FadeSlide(
                  fade: _headerFade,
                  slide: _headerSlide,
                  child: _TopBar(
                    hPad: hPad,
                    date: widget.item.formattedDate,
                    isDeleting: false,
                    onDelete: () => _delete(context),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: FadeSlide(
                  fade: _imgFade,
                  slide: _imgSlide,
                  child: _ImagesSection(hPad: hPad, item: widget.item),
                ),
              ),
              SliverToBoxAdapter(
                child: FadeSlide(
                  fade: _scoresFade,
                  slide: _scoresSlide,
                  child: ScoresSection(hPad: hPad, item: widget.item),
                ),
              ),
              SliverToBoxAdapter(
                child: FadeSlide(
                  fade: _scoresFade,
                  slide: _scoresSlide,
                  child: CompatSection(hPad: hPad, item: widget.item),
                ),
              ),
              if (widget.item.replacements.isNotEmpty)
                ...widget.item.replacements.entries.map(
                      (entry) => SliverToBoxAdapter(
                    child: FadeSlide(
                      fade: _replFade,
                      slide: _replSlide,
                      child: ProblemSection(
                        currentImageUrl: _getImageUrlFromHistory(entry.key),                        hPad: hPad,
                        itemLabel: entry.key == "shoe" ? "Shoes" : entry.key,
                        base64Image: entry.value,
                        suggestion: "Outfix AI Suggestion",
                      ),
                    ),
                  ),
                ),
                // SliverToBoxAdapter(
                //   child: FadeSlide(
                //     fade: _replFade,
                //     slide: _replSlide,
                //     child: ReplacementsSection(hPad: hPad, item: widget.item),
                //   ),
                // ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ],
      ),
    );
  }

  String? _getImageUrlFromHistory(String label) {
    final key = label.toLowerCase().trim();

    switch (key) {
      case 'top':
        return widget.item.topImagePath;
      case 'bottom':
        return widget.item.bottomImagePath;
      case 'shoe':
      case 'shoes':
        return widget.item.shoeImagePath;
      case 'bag':
        return widget.item.bagImagePath;
      default:
        return widget.item.accessoryImagePath;
    }
  }}
// ─── All section widgets below are UNCHANGED from original ────────────────

class _TopBar extends StatelessWidget {
  final double hPad;
  final String date;
  final bool isDeleting;
  final VoidCallback onDelete;

  const _TopBar({
    required this.hPad,
    required this.date,
    required this.isDeleting,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(hPad, Sp.sm, hPad, Sp.sm),
    child: Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.white,
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: Sp.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Outfit Details', style: T.heading),
              Text(date, style: T.caption),
            ],
          ),
        ),
        GestureDetector(
          onTap: isDeleting ? null : onDelete,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.scoreLow.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.scoreLow.withOpacity(0.2)),
            ),
            child: isDeleting
                ? const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.scoreLow,
                    ),
                  )
                : const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.scoreLow,
                    size: 18,
                  ),
          ),
        ),
      ],
    ),
  );
}

class _ImagesSection extends StatelessWidget {
  final double hPad;
  final OutfitHistoryModel item;

  const _ImagesSection({required this.hPad, required this.item});

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet || context.isDesktop;
    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, Sp.sm, hPad, Sp.sm),
      child: SectionCard(
        label: 'OUTFIT PIECES',
        child: OutfitImagesGrid(
          topImagePath: item.topImagePath,
          bottomImagePath: item.bottomImagePath,
          shoeImagePath: item.shoeImagePath,
          accessoryImagePath: item.accessoryImagePath,
          bagImagePath: item.bagImagePath,
          itemSize: isTablet ? 80 : 64,
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String label;
  final Widget child;

  const SectionCard({required this.label, required this.child});

  @override
  Widget build(BuildContext context) => Container(
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
        Text(label, style: T.caption),
        const SizedBox(height: Sp.sm),
        child,
      ],
    ),
  );
}
