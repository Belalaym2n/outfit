// ═══════════════════════════════════════════════════════════════
//  recommended_section.dart
//  AI Outfit Recommendation System — "Recommended" Section
//
//  Contains:
//    • RecommendedSection          (root widget, drop into any screen)
//    • _RecommendedItemsRow        (horizontal carousel — Part 1)
//    • _FullOutfitShowcase         (large swipeable cards — Part 2)
//    • RecommendedItemCard         (single-piece card)
//    • FullOutfitCard              (full-look card)
//    • SaveButtonWidget            (animated bookmark)
//    • _FloatingBackground         (decorative blobs)
//
//  No external packages required.
//  All sizes via AppConstants (w / h). Swap in your real asset paths.
// ═══════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_proj/core/cahsing/app_storage_service.dart';
import 'package:graduation_proj/features/savedItems/data/models/saved_item_model.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
 import '../../data/models/outfit_item_model.dart';
import '../manager/events.dart';
import '../manager/outfit_bloc.dart';
import '../manager/outfit_states.dart';
import '../widgets/fullOutfit/full_outfit_item.dart';
import '../widgets/recommended/recommend_items.dart';
import '../widgets/recommended/section_header.dart';
import 'outfit_details_screen.dart';

// ─────────────────────────────────────────────────────────────

// ═══════════════════════════════════════════════════════════════
//  ROOT WIDGET  —  RecommendedSection
//  Drop this directly into any screen's Column / CustomScrollView.
// ═══════════════════════════════════════════════════════════════
class RecommendedSection extends StatefulWidget {
  RecommendedSection({super.key, required this.onSaveToggle});

  final Function(OutfitItemModel item) onSaveToggle;

  @override
  State<RecommendedSection> createState() => _RecommendedSectionState();
}

class _RecommendedSectionState extends State<RecommendedSection>
    with SingleTickerProviderStateMixin {
  // Master controller — drives section-level fade + slide entrance
  late final AnimationController _sectionCtrl;
  late final Animation<double> _sectionOpacity;
  late final Animation<Offset> _sectionSlide;

  @override
  void initState() {
    super.initState();
    _sectionCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _sectionOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _sectionCtrl, curve: Curves.easeOut));
    _sectionSlide =
        Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(
          CurvedAnimation(parent: _sectionCtrl, curve: Curves.easeOutCubic),
        );

    WidgetsBinding.instance.addPostFrameCallback((_) => _sectionCtrl.forward());
  }

  @override
  void dispose() {
    _sectionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _navigateToDetails(BuildContext context,OutfitItemModel item) {
      print("df");
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<OutfitBloc>(),
            child: OutfitItemDetailsScreen(item:  item),
          ),
        ),
      );
    }
    final w = AppConstants.w;
    final h = AppConstants.h;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedBuilder(
        animation: _sectionCtrl,
        builder: (_, child) => FractionalTranslation(
          translation: _sectionSlide.value,
          child: Opacity(opacity: _sectionOpacity.value, child: child),
        ),
        child:
            // ── Scrollable content ────────────────────────────
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Part 1: Individual Items ─────────────────

                  SizedBox(height: h * 0.022),
                  BlocBuilder<OutfitBloc, OutfitState>(
                    builder: (context, state) {
                      return RecommendedItemsRow(
                        onNavigate: (item) => _navigateToDetails(context, item), // ✅
                        savedIds: state.savedIds,
                        // state:state,
                        items: state.items,

                        onSaveToggle: (id) {
                          final item = state.items.firstWhere(
                            (e) => e.id == id.id,
                          );

                          print("d");
                          print("${item.isSaved}}");
                          if (item.isSaved) {
                            print("object");
                            context.read<OutfitBloc>().add(
                              UnsaveItemEvent(
                                outfit: SavedItemModel(
                                  userId: AppStorageService.instance.getEmail(),
                                  itemId: item.id,
                                  category: item.categories[0],
                                  outfitModel: item,
                                  timestamp: DateTime.now(),
                                ),
                              ),
                            );
                          } else {
                            print("got to save ");
                            context.read<OutfitBloc>().add(
                              SaveItemEvent(
                                outfit: SavedItemModel(
                                  userId: AppStorageService.instance.getEmail(),
                                  itemId: item.id,
                                  category: item.categories[0],
                                  outfitModel: item,
                                  timestamp: DateTime.now(),
                                ),
                              ),
                            );
                          }
                        },

                        saveStatuses: state.saveStatuses,
                      );
                    },
                  ),

                  SizedBox(height: h * 0.048),

                  // ── Part 2: Full Outfit Showcase ─────────────
                  // SectionHeader(
                  //   label: 'FULL LOOKS',
                  //   title: 'Complete\nOutfits',
                  // ),
                  // SizedBox(height: h * 0.022),

                  // FullOutfitShowcase(
                  //   outfits: _outfits,
                  //   onSaveToggle: (id) => setState(() {
                  //     final idx = _outfits.indexWhere((e) => e.id == id);
                  //     if (idx != -1) _outfits[idx].saved = !_outfits[idx].saved;
                  //   }),
                  // ),
                  SizedBox(height: h * 0.04),
                ],
              ),
            ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SECTION HEADER
// ─────────────────────────────────────────────────────────────

// ═══════════════════════════════════════════════════════════════
//  PART 1 — RECOMMENDED ITEMS ROW  (horizontal carousel)
// ═══════════════════════════════════════════════════════════════

//  Floating decorative background
// ─────────────────────────────────────────────────────────────
class _FloatingBackground extends StatefulWidget {
  const _FloatingBackground();

  @override
  State<_FloatingBackground> createState() => _FloatingBackgroundState();
}

class _FloatingBackgroundState extends State<_FloatingBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  late final Animation<double> _float;

  @override
  void initState() {
    super.initState();
    // Gentle 4-second float loop
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);
    _float = Tween<double>(
      begin: -12,
      end: 12,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = AppConstants.w;
    final h = AppConstants.h;

    return AnimatedBuilder(
      animation: _float,
      builder: (_, __) => Stack(
        children: [
          Positioned(
            top: h * 0.05 + _float.value,
            right: -w * 0.18,
            child: _Blob(size: w * 0.65, opacity: 0.06),
          ),
          Positioned(
            bottom: h * 0.28 - _float.value * 0.6,
            left: -w * 0.22,
            child: _Blob(size: w * 0.55, opacity: 0.05),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final double opacity;

  const _Blob({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: opacity,
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.accent,
      ),
    ),
  );
}
