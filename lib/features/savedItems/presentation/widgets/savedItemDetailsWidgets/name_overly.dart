//
//
// import 'dart:math' as math;
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:graduation_proj/core/sharedWidgets/animations/bg_animation.dart';
//
// import '../../../../../core/utils/app_colors.dart';
// import '../../../../recommendedItem/data/models/outfit_item_model.dart';
// import '../../pages/saved_items_presentation.dart';
//
//
// class  NameOverlay extends StatelessWidget {
//   const NameOverlay({required this.outfit, required this.dark});
//   final OutfitItemModel outfit;
//   final bool        dark;
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: const BorderRadius.vertical(bottom: Radius.circular(22)),
//       child: Container(
//         padding: const EdgeInsets.fromLTRB(14, 32, 14, 14),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end:   Alignment.bottomCenter,
//             colors: [Colors.transparent, Colors.black.withOpacity(0.68)],
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               outfit.gender,
//               style: const TextStyle(
//                 fontSize: 10, fontWeight: FontWeight.w600,
//                 color: Colors.white54, letterSpacing: 1.2,
//               ),
//             ),
//             const SizedBox(height: 2),
//             Text(
//               outfit.title,
//               style: const TextStyle(
//                 fontSize: 14, fontWeight: FontWeight.w600,
//                 color: Colors.white, letterSpacing: -0.2,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
