// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:graduation_proj/features/recommendedItem/presentation/manager/events.dart';
// import 'package:graduation_proj/features/recommendedItem/presentation/widgets/fullOutfit/save_button.dart';
// import 'package:skeletonizer/skeletonizer.dart';
//
// import '../../../../../core/intialization/init_di.dart';
// import '../../../../../core/sharedWidgets/text_styles.dart';
// import '../../../../../core/utils/app_colors.dart';
// import '../../../../../core/utils/app_constants.dart';
// import '../../../data/models/full_outfit_model.dart';
//
// import 'dart:math' as math;
// import 'package:flutter/material.dart';
//
// import '../../../data/models/outfit_item_model.dart';
// import '../../fake/widgets/outfit_error_view.dart';
// import '../../manager/outfit_bloc.dart';
// import '../../manager/outfit_states.dart';
// import '../../pages/recommend_items.dart';
// import 'full_outfit_card.dart';
//
// class FullOutfitShowcase extends StatefulWidget {
//   final List<OutfitItemModel> outfits;
//   final ValueChanged<String> onSaveToggle;
//
//   const FullOutfitShowcase({required this.outfits, required this.onSaveToggle});
//
//   @override
//   State<FullOutfitShowcase> createState() => _FullOutfitShowcaseState();
// }
//
// class _FullOutfitShowcaseState extends State<FullOutfitShowcase> {
//   final PageController _pageCtrl = PageController(viewportFraction: 0.88);
//   int _currentPage = 0;
//
//   @override
//   void dispose() {
//     _pageCtrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final w = AppConstants.w;
//     final h = AppConstants.h;
//
//     return BlocProvider(
//       create: (_) =>
//       getIt<OutfitBloc>()
//         ..add(OnLoadSavedItems(userId: "..add"))..add(const LoadOutfitsEvent()),
//       child: BlocBuilder<OutfitBloc, OutfitState>(
//         builder: (context, state) {
//           return _buildBody(context, state, h);
//         },
//       ),
//     );
//   }
//
//   Widget _buildBody(BuildContext context, OutfitState state, double h) {
//     if (state.isInitialLoading) {
//       return SingleChildScrollView(
//         physics: NeverScrollableScrollPhysics(),
//         child: Skeletonizer(child: RecommendedSection()),
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
//     return Padding(
//       padding: const EdgeInsets.all(8.0)
//       ,
//       child
//           :
//       Column
//         (
//         crossAxisAlignment
//             :
//         CrossAxisAlignment
//             .
//         start
//         ,
//         children
//             :
//         [
//           // ── Part 2: Full Outfit Showcase ─────────────
//           SectionHeader
//             (
//               label
//                   :
//               'FULL LOOKS'
//               ,
//               title
//                   :
//               'Complete\nOutfits'
//           )
//           ,
//           SizedBox
//             (
//               height
//                   :
//               h * 0.022),
//           // ── PageView ────────────────────────────────────────
//           SizedBox(
//             height: h * 0.54,
//             child: PageView.builder(
//               controller: _pageCtrl,
//               physics: const BouncingScrollPhysics(),
//               onPageChanged: (i) => setState(() => _currentPage = i),
//               itemCount: state.items.length,
//               // ✅
//               itemBuilder: (context, i) {
//                 final item = state.items[i]; // ✅
//                 final isSaved = item.isSaved;
//
//
//                 return AnimatedBuilder(
//                     animation: _pageCtrl,
//                     builder: (_, child) {
//                       // Parallax scale effect: current page = 1.0, others = 0.94
//                       double page = 0;
//                       try {
//                         page = _pageCtrl.page ?? i.toDouble();
//                       } catch (_) {
//                         page = i.toDouble();
//                       }
//                       final diff = (page - i).abs();
//                       final scale = (1 - diff * 0.06).clamp(0.9, 1.0);
//                       final opacity = (1 - diff * 0.4).clamp(0.6, 1.0);
//                       return Transform.scale(
//                         scale: scale,
//                         child: Opacity(opacity: opacity, child: child),
//                       );
//                     },
//                     child: Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: AppConstants.w * 0.02,
//                         ),
//                         child: FullOutfitCard(
//                           outfit: item,
//                           onUnsave: () {},
//
//
//                           saveStatus: isSaved,
//
//                           onSaveToggle: () {
//                             if (isSaved) {
//                               context.read<OutfitBloc>().add(
//                                 UnsaveItemEvent(itemId: item.id),
//                               );
//                             } else {
//                               context.read<OutfitBloc>().add(
//                                 SaveItemEvent(
//                                   itemId: item.id,
//                                   category: item.categories.first,
//                                 ),
//                               );
//                             }
//                           },
//
//                           isActive: _currentPage == i,
//                           entranceDelay: Duration(milliseconds: 200 + i * 100),
//                         )));
//               },
//
//             )
//
//             ,
//
//
//           )
//
//           ,
//
//           // ── Page dots ───────────────────────────────────────
//           SizedBox
//
//             (
//
//               height: h * 0.018),
//           Center(
//             child: SizedBox(
//               width: AppConstants.w / 2,
//               height: 10,
//               child: Center(
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: widget.outfits.length,
//                   itemBuilder: (context, index) {
//                     final active = index == _currentPage;
//
//                     return AnimatedContainer(
//                       duration: const Duration(milliseconds: 280),
//                       margin: const EdgeInsets.symmetric(horizontal: 3),
//                       width: active ? 20 : 6,
//                       height: 6,
//                       decoration: BoxDecoration(
//                         color: active
//                             ? AppColors.accent
//                             : AppColors.inkSubtle.withOpacity(0.4),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ],
//
//       )
//
//       ,
//
//     );
//   }
// }
