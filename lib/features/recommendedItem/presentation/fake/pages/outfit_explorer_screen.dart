// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:graduation_proj/features/recommendedItem/presentation/manager/events.dart';
//
//    import '../../../../../core/intialization/init_di.dart';
// import '../../../data/models/outfit_statiic_data.dart';
// import '../../../domain/entities/outfit_entity.dart';
// import '../../manager/outfit_bloc.dart';
// import '../../manager/outfit_states.dart';
//
// import '../widgets/category_filter_bar.dart';
// import '../widgets/outfit_error_view.dart';
// import '../widgets/outfit_item_card.dart';
// import '../widgets/pagination_loader.dart';
// import '../widgets/shimmer_loading.dart';
//
// class OutfitExplorerScreen extends StatefulWidget {
//   const OutfitExplorerScreen({super.key});
//
//   @override
//   State<OutfitExplorerScreen> createState() => _OutfitExplorerScreenState();
// }
//
// class _OutfitExplorerScreenState extends State<OutfitExplorerScreen> {
//   final ScrollController _scrollCtrl = ScrollController();
//   String? _selectedCategory;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollCtrl.addListener(_onScroll);
//   }
//
//   @override
//   void dispose() {
//     _scrollCtrl
//       ..removeListener(_onScroll)
//       ..dispose();
//     super.dispose();
//   }
//
//   void _onScroll() {
//     final bloc = context.read<OutfitBloc>();
//     final isBottom = _scrollCtrl.position.pixels >=
//         _scrollCtrl.position.maxScrollExtent - 200;
//
//     if (isBottom &&
//         bloc.state.status == OutfitStatus.success &&
//         bloc.state.hasMore) {
//       bloc.add(const LoadMoreOutfitsEvent());
//     }
//   }
//
//   List<OutfitItemModel> _filteredItems(List<OutfitItemModel> items) {
//     if (_selectedCategory == null) return items;
//     return items
//         .where((e) => e.categories.contains(_selectedCategory))
//         .toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => getIt<OutfitBloc>()..add(const LoadOutfitsEvent()),
//       child: Scaffold(
//         backgroundColor: const Color(0xFFFAF8F5),
//         body: SafeArea(
//           child: BlocBuilder<OutfitBloc, OutfitState>(
//             builder: (context, state) {
//               return NestedScrollView(
//                 controller: _scrollCtrl,
//                 headerSliverBuilder: (context, _) => [
//                   _OutfitAppBar(),
//                   _CategoryHeader(
//                     selected: _selectedCategory,
//                     onChanged: (cat) =>
//                         setState(() => _selectedCategory = cat),
//                   ),
//                 ],
//                 body: _buildBody(context, state),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBody(BuildContext context, OutfitState state) {
//     // ── Initial loading ──────────────────────────────────────
//     if (state.isInitialLoading) {
//       return const SingleChildScrollView(
//         physics: NeverScrollableScrollPhysics(),
//         child: OutfitGridSkeleton(),
//       );
//     }
//
//     // ── Error (no data at all) ───────────────────────────────
//     if (state.status == OutfitStatus.error && state.items.isEmpty) {
//       return OutfitErrorView(
//         message: state.errorMessage,
//         onRetry: () =>
//             context.read<OutfitBloc>().add(const LoadOutfitsEvent()),
//       );
//     }
//
//     // ── Success / Pagination ─────────────────────────────────
//     final displayed = _filteredItems(state.items);
//
//     return RefreshIndicator(
//       onRefresh: () async {
//         context.read<OutfitBloc>().add(const RefreshOutfitsEvent());
//         // Wait until state is no longer loading
//         await Future.delayed(const Duration(milliseconds: 900));
//       },
//       color: const Color(0xFF2C2C2C),
//       child: CustomScrollView(
//         physics: const BouncingScrollPhysics(
//           parent: AlwaysScrollableScrollPhysics(),
//         ),
//         slivers: [
//           // Grid
//           SliverPadding(
//             padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
//             sliver: SliverGrid(
//               delegate: SliverChildBuilderDelegate(
//                 (context, i) {
//                   final item = displayed[i];
//                   return OutfitItemCard(
//                     item: item,
//                     saveStatus: state.saveStatusFor(item.id),
//                     onSave: () => context.read<OutfitBloc>().add(
//                           SaveItemEvent(
//                             itemId: item.id,
//                             category: item.categories.first,
//                           ),
//                         ),
//                     onUnsave: () => context.read<OutfitBloc>().add(
//                           UnsaveItemEvent(itemId: item.id),
//                         ),
//                     onTap: () {
//                       // Navigate to item detail — wire up your router here
//                     },
//                   );
//                 },
//                 childCount: displayed.length,
//               ),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 childAspectRatio: 0.60,
//               ),
//             ),
//           ),
//
//           // Pagination loader
//           if (state.isPaginationLoading)
//             const SliverToBoxAdapter(child: PaginationLoader()),
//
//           // Pagination error banner
//           if (state.status == OutfitStatus.success &&
//               state.errorMessage != null)
//             SliverToBoxAdapter(
//               child: _PaginationErrorBanner(
//                 onRetry: () => context
//                     .read<OutfitBloc>()
//                     .add(const LoadMoreOutfitsEvent()),
//               ),
//             ),
//
//           // End of list indicator
//           if (!state.hasMore && displayed.isNotEmpty)
//             const SliverToBoxAdapter(
//               child: _EndOfListBanner(),
//             ),
//
//           const SliverToBoxAdapter(child: SizedBox(height: 32)),
//         ],
//       ),
//     );
//   }
// }
//
// // ── App Bar ───────────────────────────────────────────────────
// class _OutfitAppBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SliverAppBar(
//       backgroundColor: const Color(0xFFFAF8F5),
//       elevation: 0,
//       pinned: true,
//       expandedHeight: 80,
//       flexibleSpace: FlexibleSpaceBar(
//         titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Explore',
//               style: TextStyle(
//                 fontSize: 26,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF1E1C1A),
//                 letterSpacing: -0.8,
//               ),
//             ),
//             BlocBuilder<OutfitBloc, OutfitState>(
//               buildWhen: (prev, curr) =>
//                   prev.items.where((e) => e.isSaved).length !=
//                   curr.items.where((e) => e.isSaved).length,
//               builder: (context, state) {
//                 final saved = state.items.where((e) => e.isSaved).length;
//                 return Stack(
//                   children: [
//                     IconButton(
//                       onPressed: () {
//                         // Navigate to saved items screen
//                       },
//                       icon: const Icon(
//                         Icons.bookmark_border_rounded,
//                         color: Color(0xFF1E1C1A),
//                         size: 24,
//                       ),
//                     ),
//                     if (saved > 0)
//                       Positioned(
//                         top: 6,
//                         right: 6,
//                         child: Container(
//                           width: 16,
//                           height: 16,
//                           decoration: const BoxDecoration(
//                             color: Color(0xFF2C2C2C),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Center(
//                             child: Text(
//                               '$saved',
//                               style: const TextStyle(
//                                 fontSize: 9,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                   ],
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ── Category header sliver ────────────────────────────────────
// class _CategoryHeader extends StatelessWidget {
//   final String? selected;
//   final ValueChanged<String?> onChanged;
//
//   const _CategoryHeader({required this.selected, required this.onChanged});
//
//   @override
//   Widget build(BuildContext context) {
//     final categories = OutfitStaticData.allCategories;
//
//     return SliverPersistentHeader(
//       pinned: true,
//       delegate: _StickyFilterDelegate(
//         child: Container(
//           color: const Color(0xFFFAF8F5),
//           padding: const EdgeInsets.only(top: 8, bottom: 12),
//           child: CategoryFilterBar(
//             categories: categories,
//             selected: selected,
//             onChanged: onChanged,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _StickyFilterDelegate extends SliverPersistentHeaderDelegate {
//   final Widget child;
//   const _StickyFilterDelegate({required this.child});
//
//   @override
//   double get minExtent => 60;
//   @override
//   double get maxExtent => 60;
//
//   @override
//   Widget build(_, __, ___) => child;
//
//   @override
//   bool shouldRebuild(_) => true;
// }
//
// // ── Pagination error banner ───────────────────────────────────
// class _PaginationErrorBanner extends StatelessWidget {
//   final VoidCallback onRetry;
//   const _PaginationErrorBanner({required this.onRetry});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             'Failed to load more.',
//             style: TextStyle(fontSize: 13, color: Color(0xFF9B9490)),
//           ),
//           const SizedBox(width: 8),
//           GestureDetector(
//             onTap: onRetry,
//             child: const Text(
//               'Retry',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF2C2C2C),
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ── End of list ───────────────────────────────────────────────
// class _EndOfListBanner extends StatelessWidget {
//   const _EndOfListBanner();
//
//   @override
//   Widget build(BuildContext context) {
//     return const Padding(
//       padding: EdgeInsets.symmetric(vertical: 20),
//       child: Center(
//         child: Text(
//           '— You\'ve seen everything —',
//           style: TextStyle(
//             fontSize: 12,
//             color: Color(0xFFBBB7B2),
//             letterSpacing: 0.5,
//           ),
//         ),
//       ),
//     );
//   }
// }
