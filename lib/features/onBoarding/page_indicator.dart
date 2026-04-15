// import 'package:flutter/material.dart';
// import '../../core/utils/app_colors.dart';
//
// class AnimatedPageIndicator extends StatelessWidget {
//   final int pageCount;
//   final int currentPage;
//   final Color activeColor;
//   final Color inactiveColor;
//
//   const AnimatedPageIndicator({
//     super.key,
//     required this.pageCount,
//     required this.currentPage,
//     this.activeColor = AppColors.indicatorActive,
//     this.inactiveColor = AppColors.indicatorInactive,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: List.generate(pageCount, (index) {
//         final isActive = index == currentPage;
//         return AnimatedContainer(
//           duration: const Duration(milliseconds: 350),
//           curve: Curves.easeInOutCubic,
//           margin: const EdgeInsets.symmetric(horizontal: 4),
//           width: isActive ? 24 : 8,
//           height: 8,
//           decoration: BoxDecoration(
//             color: isActive ? activeColor : inactiveColor,
//             borderRadius: BorderRadius.circular(4),
//           ),
//         );
//       }),
//     );
//   }
// }
