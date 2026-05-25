// import 'package:flutter/material.dart';
// import '../../../data/models/outfit_item_model.dart';
// import '../../../domain/entities/outfit_entity.dart';
//  import '../../manager/outfit_states.dart';
//  import 'outfit_image_slider.dart';
// import 'outfit_save_button.dart';
//
// class OutfitItemCard extends StatelessWidget {
//   final OutfitItemModel item;
//   final SaveStatus saveStatus;
//   final VoidCallback onSave;
//   final VoidCallback onUnsave;
//   final VoidCallback onTap;
//
//   const OutfitItemCard({
//     super.key,
//     required this.item,
//     required this.saveStatus,
//     required this.onSave,
//     required this.onUnsave,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;
//     final cardW = (w - 48) / 2;
//     final imgH = cardW * 1.15;
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: const Color(0xFFEEECE8), width: 0.8),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.055),
//               blurRadius: 16,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Image slider ────────────────────────────────
//             Stack(
//               children: [
//                 OutfitImageSlider(
//                   images: item.images,
//                   height: imgH,
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(16),
//                     topRight: Radius.circular(16),
//                   ),
//                 ),
//
//                 // Save button
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: OutfitSaveButton(
//                     isSaved: item.isSaved,
//                     saveStatus: saveStatus,
//                     onTap: item.isSaved ? onUnsave : onSave,
//                   ),
//                 ),
//
//                 // Gender badge
//                 Positioned(
//                   top: 8,
//                   left: 8,
//                   child: _GenderBadge(gender: item.gender),
//                 ),
//               ],
//             ),
//
//             // ── Info ────────────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     item.title,
//                     style: const TextStyle(
//                       fontSize: 13.5,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF1E1C1A),
//                       letterSpacing: -0.2,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//
//                   // Primary category
//                   Text(
//                     item.categories.first,
//                     style: const TextStyle(
//                       fontSize: 11.5,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xFF9B9490),
//                       letterSpacing: 0.1,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//
//                   // Color swatches
//                   _ColorSwatches(colors: item.colors),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ── Gender badge ──────────────────────────────────────────────
// class _GenderBadge extends StatelessWidget {
//   final Gender gender;
//   const _GenderBadge({required this.gender});
//
//   @override
//   Widget build(BuildContext context) {
//     String label;
//     Color bg;
//     switch (gender) {
//       case Gender.male:
//         label = 'M';
//         bg = const Color(0xFF4A6FA5);
//         break;
//       case Gender.female:
//         label = 'F';
//         bg = const Color(0xFFB5607B);
//         break;
//       case Gender.unisex:
//         label = 'U';
//         bg = const Color(0xFF7B8B6F);
//         break;
//     }
//
//     return Container(
//       width: 22,
//       height: 22,
//       decoration: BoxDecoration(
//         color: bg,
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(
//             color: bg.withOpacity(0.4),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Center(
//         child: Text(
//           label,
//           style: const TextStyle(
//             fontSize: 10,
//             fontWeight: FontWeight.w700,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ── Color swatches ────────────────────────────────────────────
// class _ColorSwatches extends StatelessWidget {
//   final List<String> colors;
//   const _ColorSwatches({required this.colors});
//
//   static const Map<String, Color> _colorMap = {
//     'black': Color(0xFF1A1A1A),
//     'white': Color(0xFFF5F5F5),
//     'grey': Color(0xFF9E9E9E),
//     'charcoal': Color(0xFF4A4A4A),
//     'heather grey': Color(0xFFB0B0B0),
//     'navy': Color(0xFF1B2A4A),
//     'dark blue': Color(0xFF1A3050),
//     'blue': Color(0xFF3B6AC4),
//     'light blue': Color(0xFF7EB8D4),
//     'indigo': Color(0xFF3D3580),
//     'midnight': Color(0xFF1A1F3A),
//     'midnight blue': Color(0xFF1A1F4A),
//     'red': Color(0xFFCC3333),
//     'burgundy': Color(0xFF6D1E2A),
//     'wine': Color(0xFF5C1B2A),
//     'pink': Color(0xFFE8A0B0),
//     'blush': Color(0xFFEFC5C5),
//     'dusty rose': Color(0xFFD4A0A0),
//     'coral': Color(0xFFE87060),
//     'rust': Color(0xFFB85533),
//     'orange': Color(0xFFE87030),
//     'terracotta': Color(0xFFC05840),
//     'yellow': Color(0xFFE8C740),
//     'neon yellow': Color(0xFFD4E840),
//     'neon green': Color(0xFF80E840),
//     'neon orange': Color(0xFFFF6820),
//     'green': Color(0xFF4A8A4A),
//     'sage': Color(0xFF8A9E80),
//     'olive': Color(0xFF7A7A40),
//     'khaki': Color(0xFFC4B07A),
//     'forest green': Color(0xFF2D5A2D),
//     'brown': Color(0xFF7A5030),
//     'tan': Color(0xFFC49A6C),
//     'beige': Color(0xFFE0D4B8),
//     'camel': Color(0xFFCCA060),
//     'sand': Color(0xFFDDC890),
//     'cream': Color(0xFFF5EFE0),
//     'ivory': Color(0xFFFFF8F0),
//     'oatmeal': Color(0xFFE8DCC8),
//     'natural': Color(0xFFE0D4B0),
//     'off-white': Color(0xFFF0EDE0),
//     'stone': Color(0xFFBEB8A8),
//     'gold': Color(0xFFD4A830),
//     'silver': Color(0xFFB0B8C8),
//     'multicolor': Color(0xFFE8D0B8),
//     'floral': Color(0xFFE8C8D0),
//     'earthy': Color(0xFFC0A880),
//     'camo': Color(0xFF6E7040),
//     'plaid': Color(0xFF8A5A3A),
//     'check': Color(0xFF9A9090),
//     'marl': Color(0xFFA8A8A8),
//     'caramel': Color(0xFFC08040),
//     'cognac': Color(0xFFB06030),
//     'espresso': Color(0xFF4A2818),
//     'tortoise': Color(0xFF805030),
//     'purple': Color(0xFF7A4098),
//     'lime': Color(0xFF98C840),
//   };
//
//   Color _resolve(String name) {
//     final key = name.toLowerCase().trim();
//     return _colorMap[key] ?? const Color(0xFFD0CCC8);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final shown = colors.take(4).toList();
//     return Row(
//       children: shown.map((c) {
//         return Container(
//           margin: const EdgeInsets.only(right: 5),
//           width: 14,
//           height: 14,
//           decoration: BoxDecoration(
//             color: _resolve(c),
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: Colors.black.withOpacity(0.12),
//               width: 0.8,
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
