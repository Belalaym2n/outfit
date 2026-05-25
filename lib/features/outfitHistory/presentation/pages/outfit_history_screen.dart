// features/history/presentation/screens/outfit_history_screen.dart
//
// CHANGES vs original:
//   • BlocProvider fires FetchFirstPageEvent (not the old FetchOutfitHistoryEvent).
//   • _buildBody handles the full new OutfitHistoryStatus enum.
//   • _buildList attaches a ScrollController that fires FetchNextPageEvent
//     when the user scrolls within 200 px of the bottom.
//   • Bottom of list shows a loader, a retry button, or a "no more" indicator.
//   • Pull-to-refresh dispatches FetchFirstPageEvent.

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
import '../../data/models/outfit_history_model.dart';
import '../manager/events.dart';
import '../manager/outfit_history_bloc.dart';
import '../manager/states.dart';
import '../widgets/delete_dailog.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_state.dart';
import '../widgets/history_card.dart';
import '../widgets/shimmer_list_state.dart';
import 'outfit_details_screen.dart';

extension ResponsiveContext on BuildContext {
  double get _w => MediaQuery.of(this).size.width;
  bool get isMobile => _w < 600;
  bool get isTablet => _w >= 600 && _w < 1024;
  bool get isDesktop => _w >= 1024;
  double get hPad => isDesktop ? 80 : isTablet ? 48 : 20;
}

class OutfitHistoryScreen extends StatefulWidget {
  const OutfitHistoryScreen({super.key});

  @override
  State<OutfitHistoryScreen> createState() => _OutfitHistoryScreenState();
}

class _OutfitHistoryScreenState extends State<OutfitHistoryScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final AnimationController _pulseCtrl;
  late final Animation<double> _bg1;
  late final Animation<double> _bg2;

  /// Single scroll controller shared across ListView / GridView.
  /// Disposed in [dispose].
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();

    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _bg1 = Tween<double>(begin: -14, end: 14).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _bg2 = Tween<double>(begin: 10, end: -10).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // Attach infinite-scroll listener once; the Bloc guards against
    // redundant requests internally (hasReachedMax / status checks).
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _pulseCtrl.dispose();
    _scrollCtrl
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  // ── Infinite scroll trigger ───────────────────────────────────────────────

  void _onScroll() {
    if (!_scrollCtrl.hasClients) return;
    final pos = _scrollCtrl.position;
    // Fire when within 200 px of the bottom.
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      // `read` is safe here — this is a callback, not build().
      context.read<OutfitHistoryBloc>().add(const FetchNextPageEvent());
    }
  }

  // ── Staggered card entrance animations (unchanged) ────────────────────────

  Animation<double> _cardFade(int index) => CurvedAnimation(
    parent: _entranceCtrl,
    curve: Interval(
      (0.05 * index).clamp(0.0, 0.7),
      (0.35 + 0.05 * index).clamp(0.3, 1.0),
      curve: Curves.easeOut,
    ),
  );

  Animation<Offset> _cardSlide(int index) =>
      Tween<Offset>(begin: const Offset(0, 0.14), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _entranceCtrl,
          curve: Interval(
            (0.05 * index).clamp(0.0, 0.7),
            (0.35 + 0.05 * index).clamp(0.3, 1.0),
            curve: Curves.easeOutCubic,
          ),
        ),
      );

  // ── Helpers ───────────────────────────────────────────────────────────────

  void _confirmDelete(BuildContext context, OutfitHistoryModel item) async {
    HapticFeedback.mediumImpact();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const DeleteDialog(),
    );
    if (confirmed != true) return;
    context.read<OutfitHistoryBloc>().add(DeleteOutfitHistoryEvent(item.id));
  }

  void _navigateToDetails(BuildContext context, OutfitHistoryModel item) {
    Navigator.of(context).push(
      SlideRoute(
        page: BlocProvider.value(
          value: context.read<OutfitHistoryBloc>(),
          child: OutfitDetailsScreen(item: item),
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(backgroundColor: AppColors.bg, toolbarHeight: 0),
        body: Stack(
          children: [
            AmbientBg(float1: _bg1, float2: _bg2),
            BlocConsumer<OutfitHistoryBloc, OutfitHistoryState>(
              listenWhen: (prev, curr) =>
              prev.status != curr.status,
              listener: (context, state) {
                // Restart entrance animation whenever fresh data arrives.
                if (state.status == OutfitHistoryStatus.loaded ||
                    state.status == OutfitHistoryStatus.empty ||
                    state.status == OutfitHistoryStatus.noMoreData) {
                  _entranceCtrl.forward(from: 0);
                }
              },
              // buildWhen prevents unnecessary rebuilds on status-only changes
              // that don't affect the visible list (e.g. paginationLoading is
              // shown as a footer, not a full rebuild).
              buildWhen: (prev, curr) =>
              prev.status != curr.status || prev.items != curr.items,
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(hPad: context.hPad),
                    Expanded(child: _buildBody(context, state)),
                  ],
                );
              },
            ),
          ],
        ),

    );
  }

  // ── Body routing ──────────────────────────────────────────────────────────

  Widget _buildBody(BuildContext context, OutfitHistoryState state) {
    final hPad = context.hPad;

    switch (state.status) {
      case OutfitHistoryStatus.initial:
      case OutfitHistoryStatus.firstPageLoading:
        return ShimmerList(hPad: hPad);

      case OutfitHistoryStatus.firstPageError:
        return ErrorState(
          message: state.error,
          onRetry: () => context
              .read<OutfitHistoryBloc>()
              .add(const FetchFirstPageEvent()),
        );

      case OutfitHistoryStatus.empty:
        return EmptyState(

        );

      case OutfitHistoryStatus.loaded:
      case OutfitHistoryStatus.paginationLoading:
      case OutfitHistoryStatus.paginationError:
      case OutfitHistoryStatus.noMoreData:
        return _buildList(context, state, hPad);
    }
  }

  // ── List / Grid ───────────────────────────────────────────────────────────

  Widget _buildList(
      BuildContext context,
      OutfitHistoryState state,
      double hPad,
      ) {
    final crossCount =
    context.isDesktop ? 3 : context.isTablet ? 2 : 1;

    // Total item count = real items + 1 footer slot.
    final itemCount = state.items.length + 1;

    Widget buildCard(int i) {
      // Footer slot: loader, retry, or end-of-list indicator.
      if (i == state.items.length) {
        return _PaginationFooter(state: state);
      }
      return FadeSlide(
        fade: _cardFade(i),
        slide: _cardSlide(i),
        child: HistoryCard(
          item: state.items[i],
          onTap: () => _navigateToDetails(context, state.items[i]),
          onDelete: () => _confirmDelete(context, state.items[i]),
        ),
      );
    }

    Future<void> onRefresh() async {
      context.read<OutfitHistoryBloc>().add(const FetchFirstPageEvent());
      // Wait until the Bloc has left firstPageLoading before the
      // RefreshIndicator spinner disappears.
      await context
          .read<OutfitHistoryBloc>()
          .stream
          .firstWhere((s) =>
      s.status != OutfitHistoryStatus.firstPageLoading &&
          s.status != OutfitHistoryStatus.initial);
    }

    if (crossCount == 1) {
      return RefreshIndicator(
        color: AppColors.ink,
        backgroundColor: AppColors.surface,
        onRefresh: onRefresh,
        child: ListView.separated(
          controller: _scrollCtrl,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          padding: EdgeInsets.fromLTRB(hPad, 0, hPad, Sp.xl),
          itemCount: itemCount,
          separatorBuilder: (_, i) =>
          // Don't add a separator before the footer.
          i < state.items.length - 1
              ? const SizedBox(height: Sp.sm)
              : const SizedBox.shrink(),
          itemBuilder: (_, i) => buildCard(i),
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.ink,
      backgroundColor: AppColors.surface,
      onRefresh: onRefresh,
      child: GridView.builder(
        controller: _scrollCtrl,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.fromLTRB(hPad, 0, hPad, Sp.xl),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossCount,
          crossAxisSpacing: Sp.sm,
          mainAxisSpacing: Sp.sm,
          childAspectRatio: 1.5,
        ),
        itemCount: itemCount,
        itemBuilder: (_, i) => buildCard(i),
      ),
    );
  }
}

// ─── Pagination footer widget ─────────────────────────────────────────────────
// Shown at the bottom of the list — not a separate screen-level widget —
// so it never causes a full list rebuild.

class _PaginationFooter extends StatelessWidget {
  final OutfitHistoryState state;
  const _PaginationFooter({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sp.md),
      child: switch (state.status) {
        OutfitHistoryStatus.paginationLoading => const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        OutfitHistoryStatus.paginationError => Center(
          child: TextButton.icon(
            onPressed: () => context
                .read<OutfitHistoryBloc>()
                .add(const FetchNextPageEvent()),
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Retry'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
            ),
          ),
        ),
        OutfitHistoryStatus.noMoreData => Center(
          child: Text('No more outfits', style: T.caption),
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

// ─── Header (unchanged) ───────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final double hPad;
  const _Header({required this.hPad});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(hPad, Sp.sm, hPad, Sp.md),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Sp.sm),
        Text('Outfit History', style: T.display),
        const SizedBox(height: 4),
        Text('Your past outfit analyses', style: T.body),
      ],
    ),
  );
}