// ═══════════════════════════════════════════════════════════════
//  saved_items_screen.dart  —  COMPLETE & BLOC-CONNECTED
//  Reads saved items from OutfitBloc. Single source of truth.
//  Navigates to OutfitItemDetailsScreen with full OutfitItemModel.
// ═══════════════════════════════════════════════════════════════

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_proj/core/cahsing/app_storage_service.dart';
import 'package:graduation_proj/core/sharedWidgets/animations/bg_animation.dart';
import 'package:graduation_proj/features/compatapilityModel/data/models/items_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/intialization/init_di.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../outfitHistory/presentation/widgets/empty_state.dart';
import '../../../recommendedItem/data/models/outfit_item_model.dart';
import '../../../recommendedItem/presentation/fake/widgets/outfit_error_view.dart';
import '../../../recommendedItem/presentation/manager/events.dart';
import '../../../recommendedItem/presentation/manager/outfit_bloc.dart';
import '../../../recommendedItem/presentation/manager/outfit_states.dart';
import '../../../recommendedItem/presentation/pages/outfit_details_screen.dart';
import '../../../recommendedItem/presentation/widgets/recommended/loading.dart';
import '../../../savedItems/data/models/saved_item_model.dart';
import '../widgets/emptyPage/empty_screen.dart';
import '../widgets/saveitemScreenWidgets/header.dart';
import '../widgets/saveitemScreenWidgets/outfit_card.dart';

// ─────────────────────────────────────────────────────────────
//  ENTRY POINT — drop into your navigation stack.
//  Requires OutfitBloc to already be provided above in the tree
//  (it is, via OutfitItemsPage's BlocProvider).
// ─────────────────────────────────────────────────────────────
class SavedItemsScreen extends StatefulWidget {
  const SavedItemsScreen({super.key});

  @override
  State<SavedItemsScreen> createState() => _SavedItemsScreenState();
}

class _SavedItemsScreenState extends State<SavedItemsScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bgCtrl;
  late final AnimationController _entranceCtrl;
  late final AnimationController _badgeCtrl;

  late final Animation<double> _bg1, _bg2;
  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _badgeScale;

  @override
  void initState() {
    super.initState();

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _badgeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _bg1 = Tween<double>(
      begin: -14,
      end: 14,
    ).animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut));
    _bg2 = Tween<double>(
      begin: 10,
      end: -10,
    ).animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut));

    _headerFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
    );

    _headerSlide =
        Tween<Offset>(begin: const Offset(0, -0.12), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceCtrl,
            curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
          ),
        );

    _badgeScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _badgeCtrl, curve: Curves.easeOutBack));

    _entranceCtrl.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _badgeCtrl.forward();
    });
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _entranceCtrl.dispose();
    _badgeCtrl.dispose();
    super.dispose();
  }
  void _openDetails(BuildContext context, OutfitItemModel item) {
    Navigator.push(
        context,
        MaterialPageRoute(
        builder: (_) => BlocProvider.value(
      value: context.read<OutfitBloc>(), // 👈 reuse نفس البلوك
      child: OutfitItemDetailsScreen(item: item),
    ))
    );
  }
  @override
  Widget build(BuildContext context) {
    AppConstants.initSize(context);
    final mq = MediaQuery.of(context);
    final hPad = mq.size.width >= 600 ? 32.0 : 18.0;

    Widget showData(List<OutfitItemModel> savedItems, OutfitState state) {
      return SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            // ── Glass header ──────────────────────
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _headerFade,
                child: SlideTransition(
                  position: _headerSlide,
                  child: GlassHeader(
                    count: savedItems.length,
                    badgeScale: _badgeScale,
                    hPad: hPad,
                  ),
                ),
              ),
            ),
            savedItems.isEmpty
                ? SliverFillRemaining(child: EmptySavedState(dark: false))
                : SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      hPad,
                      0,
                      hPad,
                      mq.padding.bottom + 32,
                    ),
                    sliver: _SavedGrid(
                      items: savedItems,
                      saveStatuses: state.saveStatuses,
                      onUnsave: (item) => _unsave(context, item),
                      onTap: (item) => _openDetails(context, item),
                    ),
                  ),
          ],
        ),
      );
    }

    Widget _buildBody(
      BuildContext context,
      OutfitState state,
      List<OutfitItemModel> items,
    ) {
      if (state.isInitialLoading) {
        return Skeletonizer(
          enabled: true,
          effect: const ShimmerEffect(
            baseColor: Colors.white10,
            highlightColor: Colors.white30,
          ),

          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _headerFade,
                  child: SlideTransition(
                    position: _headerSlide,
                    child: GlassHeader(
                      count: 1,
                      badgeScale: _badgeScale,
                      hPad: hPad,
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  hPad,
                  8,
                  hPad,
                  mq.padding.bottom + 32,
                ),
                sliver: _SavedGrid(
                  isLoading: true
                  ,
                  items: fakeOutfits,
                  saveStatuses: state.saveStatuses,
                  onUnsave: (item) => _unsave(context, item),
                  onTap: (item) => _openDetails(context, item),
                ),
              ),
            ],
          ),
        );
      }

      if(state.status==OutfitStatus.initial){
        return SizedBox.shrink();
      }

      if (state.status == OutfitStatus.error && state.items.isEmpty) {
        return OutfitErrorView(
          message: state.errorMessage,
          onRetry: () => context.read<OutfitBloc>().add(
            LoadOutfitsEvent(userId: AppStorageService.instance.getEmail()),
          ),
        );
      }

      // ── Normal view: pass items + toggle handler via BlocBuilder ─────────────
      return showData(items, state);
    }

    return BlocBuilder<OutfitBloc, OutfitState>(
      builder: (context, state) {
        // Derive saved items by filtering the master list with savedIds.
        final savedItems = state.items
            .where((item) => state.savedIds.contains(item.id))
            .toList();

        return Scaffold(
          backgroundColor: AppColors.bg,
          body: Stack(
            children: [
              // ── Ambient background ──────────────────────
              AmbientBg(float1: _bg1, float2: _bg2),

              _buildBody(context, state, savedItems),
            ],
          ),
        );
      },
    );
  }

  void _unsave(BuildContext context, OutfitItemModel item) {
    HapticFeedback.lightImpact();
    final userId = AppStorageService.instance.getEmail();
    context.read<OutfitBloc>().add(
      UnsaveItemEvent(
        outfit: SavedItemModel(
          userId: userId,
          itemId: item.id,
          category: item.categories.isNotEmpty
              ? item.categories.first
              : 'outfit',
          outfitModel: item,
          timestamp: DateTime.now(),
        ),
      ),
    );
  }


}

class _SavedGrid extends StatelessWidget {
    _SavedGrid({
    required this.items,
    required this.saveStatuses,
    required this.onUnsave,
    required this.onTap,
    this.isLoading=false
  });

  bool isLoading;
  final List<OutfitItemModel> items;
  final Map<String, SaveStatus> saveStatuses;
  final ValueChanged<OutfitItemModel> onUnsave;
  final ValueChanged<OutfitItemModel> onTap;

  @override
  Widget build(BuildContext context) {
    final left = <OutfitItemModel>[];
    final right = <OutfitItemModel>[];
    for (var i = 0; i < items.length; i++) {
      (i.isEven ? left : right).add(items[i]);
    }

    return SliverToBoxAdapter(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _GridColumn(
              items: left,
              saveStatuses: saveStatuses,
              onUnsave: onUnsave,
              onTap: onTap,              isLoading: isLoading,

              altHeight: false,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _GridColumn(
              isLoading: isLoading,
              items: right,
              saveStatuses: saveStatuses,
              onUnsave: onUnsave,
              onTap: onTap,
              altHeight: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _GridColumn extends StatelessWidget {
    _GridColumn({
    required this.items,
    required this.saveStatuses,
    required this.onUnsave,
    required this.onTap,
    required this.altHeight,
      this.isLoading=false,
  });
bool isLoading;
  final List<OutfitItemModel> items;
  final Map<String, SaveStatus> saveStatuses;
  final ValueChanged<OutfitItemModel> onUnsave;
  final ValueChanged<OutfitItemModel> onTap;
  final bool altHeight;

  @override
  Widget build(BuildContext context) {
    const heights = [210.0, 260.0, 230.0, 280.0, 220.0, 250.0];

    return Column(
      children: [
        if (altHeight) const SizedBox(height: 20),
        ...items.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: SavedItemCard(
              item: item,
              isLoading: isLoading,
              cardHeight: heights[i % heights.length],
              saveStatus: saveStatuses[item.id] ?? SaveStatus.idle,
              onUnsave: () => onUnsave(item),
              onTap: () => onTap(item),
            ),
          );
        }),
      ],
    );
  }
}
