// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
//
// import '../../core/sharedWidgets/text_styles.dart';
// import '../../core/utils/app_colors.dart';
// import 'buttons.dart';
// import 'on_board_model.dart';
// import 'on_gurved.dart';
// import 'page_indicator.dart';
//
// class OnboardingPageWidget extends StatelessWidget {
//   final OnboardingPageModel data;
//   final int pageIndex;
//   final int totalPages;
//   final PageController pageController;
//   final VoidCallback onNext;
//
//   const OnboardingPageWidget({
//     super.key,
//     required this.data,
//     required this.pageIndex,
//     required this.totalPages,
//     required this.pageController,
//     required this.onNext,
//   });
//
//   // ── Core math ──────────────────────────────────────────────────────────────
//   // Returns how far this page is from the viewport center.
//   // Active page  → 0.0
//   // Left/right   → ±1.0
//   double _delta() {
//     if (!pageController.hasClients || pageController.page == null) return 0.0;
//     return (pageController.page! - pageIndex).clamp(-1.0, 1.0);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.sizeOf(context);
//     final imageHeight = size.height * 0.58;
//     const cardOverlap = 30.0;
//
//     // AnimatedBuilder is the ONLY rebuild trigger for this entire widget tree.
//     return AnimatedBuilder(
//
//       animation: pageController,
//       builder: (context, _) {
//         final delta = _delta();          // –1.0 … 0.0 … +1.0
//         final abs  = delta.abs();        //  0.0 … 1.0  (proximity score)
//
//         // ── Derived values ─────────────────────────────────────────────────
//         //
//         // 1. PARALLAX — image travels at 35% of scroll speed.
//         //    When delta = +1 (page is to the right), image shifts left slightly,
//         //    creating the illusion of depth.
//         final double imageParallax = delta * size.width * 0.35;
//
//         // 2. CONTENT CARD — lifts toward the viewer when active.
//         //    Active (abs=0) → translateY = 0, scale = 1.0
//         //    Offscreen (abs=1) → translateY = +18px, scale = 0.97
//         final double cardTranslateY = abs * 18.0;
//         final double cardScale      = 1.0 - (abs * 0.03);
//
//         // 3. DEPTH OVERLAY — a very subtle dark scrim over non-active pages.
//         //    Keeps the active page feeling "in focus".
//         final double scrimOpacity = abs * 0.18;
//
//         // 4. CONTENT FADE — text/buttons fade as the page scrolls away.
//         //    Stays fully visible until 30% scroll, then fades.
//         final double contentOpacity = (1.0 - (abs * 1.6)).clamp(0.0, 1.0);
//
//         return Scaffold(
//           appBar: AppBar(
//             backgroundColor:Colors.black,
//
//
//
//             toolbarHeight: 0,
//           ),
//           backgroundColor:Colors.black,
//           body: Stack(
//             children: [
//               // ── Hero image — parallax layer ─────────────────────────────────
//               Positioned(
//                 top: 0,
//                 left: 0,
//                 right: 0,
//                 height: imageHeight,
//                 child: Transform.translate(
//                   offset: Offset(imageParallax, 0),
//                   child: ClipPath(
//                     clipper: const CurvedBottomClipper(curveDepth: 36),
//                     child: _buildImage(imageHeight),
//                   ),
//                 ),
//               ),
//
//               // ── Depth scrim over image ──────────────────────────────────────
//               Positioned(
//                 top: 0,
//                 left: 0,
//                 right: 0,
//                 height: imageHeight,
//                 child: IgnorePointer(
//                   child: ColoredBox(
//                     color: Colors.black.withOpacity(scrimOpacity),
//                   ),
//                 ),
//               ),
//
//               // ── White content card ──────────────────────────────────────────
//               Positioned(
//                 top: imageHeight - cardOverlap,
//                 left: 0,
//                 right: 0,
//                 bottom: 0,
//                 child: Transform(
//                   alignment: Alignment.topCenter,
//                   transform: Matrix4.identity()
//                     ..translate(0.0, cardTranslateY)
//                     ..scale(cardScale),
//                   child: Opacity(
//                     opacity: contentOpacity,
//                     child: _buildContentCard(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // ── Helpers ────────────────────────────────────────────────────────────────
//
//   Widget _buildImage(double height) {
//     return Image.asset(
//       data.imageAsset,
//       fit: BoxFit.contain,
//       height: height,
//       width: double.infinity,
//       errorBuilder: (_, __, ___) => SizedBox(
//         height: height,
//         child: const Icon(Icons.person_outline, size: 80, color: Colors.white54),
//       ),
//     );
//   }
//
//   Widget _buildContentCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.cardBackground,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.shadowColor,
//             blurRadius: 24,
//             offset: const Offset(0, -4),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.fromLTRB(28, 36, 28, 0),
//       child: Scaffold(
//         appBar: AppBar(
//           toolbarHeight: 0,
//         ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(data.title, style: AppTextStyles.headline),
//             const SizedBox(height: 12),
//             Text(data.subtitle, style: AppTextStyles.body),
//             const SizedBox(height: 32),
//             AnimatedNextButton(
//               label: data.buttonLabel,
//               color: AppColors.primaryColor,
//               onTap: onNext,
//             ),
//             const SizedBox(height: 24),
//             Center(
//               child: AnimatedPageIndicator(
//                 pageCount: totalPages,
//                 currentPage: pageIndex,
//                 activeColor: AppColors.indicatorActive,
//                 inactiveColor: AppColors.indicatorInactive,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }