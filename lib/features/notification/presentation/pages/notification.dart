//
// // ═══════════════════════════════════════════════════════════════
// //  NOTIFICATION DATA MODEL
// // ═══════════════════════════════════════════════════════════════
// enum NotifType { score, tip, system }
//
// class NotifModel {
//   const NotifModel({
//     required this.id,
//     required this.type,
//     required this.title,
//     required this.preview,
//     required this.fullBody,
//     required this.time,
//     required this.isUnread,
//   });
//
//   final int id;
//   final NotifType type;
//   final String title;
//   final String preview;
//   final String fullBody;
//   final String time;
//   final bool isUnread;
//
//   IconData get icon {
//     switch (type) {
//       case NotifType.score:
//         return Icons.analytics_outlined;
//       case NotifType.tip:
//         return Icons.tips_and_updates_outlined;
//       case NotifType.system:
//         return Icons.info_outline_rounded;
//     }
//   }
//
//   static const List<NotifModel> samples = [
//     NotifModel(
//       id: 1,
//       type: NotifType.score,
//       isUnread: true,
//       title: 'Your outfit scored 92!',
//       preview: 'Outstanding result — your colour coordination is excellent.',
//       fullBody:
//       'Congratulations! Your latest outfit submission received a score of 92/100. Our AI detected outstanding colour harmony between your top and bottom pieces. The accessories complemented the overall look without overpowering it. To push your score even higher, consider experimenting with a textured outer layer.',
//       time: '2 min ago',
//     ),
//     NotifModel(
//       id: 2,
//       type: NotifType.tip,
//       isUnread: true,
//       title: 'Style Tip: Shoe Selection',
//       preview: 'Shoes are the #1 factor that impact your style score.',
//       fullBody:
//       'Our AI has analysed your last 5 submissions and identified a pattern: shoe choice is reducing your average score by up to 12 points. Clean silhouette shoes (Oxford, Derby, minimalist sneakers) consistently outperform chunky or heavily branded options in our scoring model. Try swapping footwear on your next upload.',
//       time: '1 hr ago',
//     ),
//     NotifModel(
//       id: 3,
//       type: NotifType.system,
//       isUnread: false,
//       title: 'New Feature: Side-by-Side Comparison',
//       preview: 'Compare two outfits directly in the Results screen.',
//       fullBody:
//       'We\'ve shipped a major update to the Results screen. You can now place two scored outfits side by side to directly compare feedback, item scores, and AI suggestions. Open any previous analysis result and tap the Compare button to get started.',
//       time: '3 hr ago',
//     ),
//     NotifModel(
//       id: 4,
//       type: NotifType.score,
//       isUnread: false,
//       title: 'Weekly Recap Ready',
//       preview: 'Your average score improved by 8 points this week.',
//       fullBody:
//       'This week you submitted 4 outfits with an average score of 79/100 — up from 71 last week. Your top-scoring day was Wednesday (score: 88). Keep consistent and aim for 5 submissions next week to unlock the Style Analyst badge.',
//       time: 'Yesterday',
//     ),
//     NotifModel(
//       id: 5,
//       type: NotifType.tip,
//       isUnread: false,
//       title: 'Seasonal Trend Alert',
//       preview: 'Earth tones are dominating the AI scoring model this month.',
//       fullBody:
//       'Our trend engine has detected that outfits featuring warm earth tones (camel, terracotta, olive, sand) are receiving significantly higher scores in the AI model this season. Consider incorporating at least one earth-tone piece into your next submission for a potential 6–10 point boost.',
//       time: '2 days ago',
//     ),
//   ];
// }
//
// // ═══════════════════════════════════════════════════════════════
// //  NOTIFICATIONS SCREEN
// // ═══════════════════════════════════════════════════════════════
// //
// //  ANIMATION:
// //  _masterCtrl (1600ms):
// //    nav  → Interval(0.00, 0.25)
// //    header → Interval(0.08, 0.36)
// //    cards → each card Interval(0.24 + i*0.06, ...) — staggered slide-up
// // ═══════════════════════════════════════════════════════════════
// class NotificationsScreen extends StatefulWidget {
//   const NotificationsScreen({super.key});
//
//   @override
//   State<NotificationsScreen> createState() => _NotificationsScreenState();
// }
//
// class _NotificationsScreenState extends State<NotificationsScreen>
//     with TickerProviderStateMixin {
//   late final AnimationController _masterCtrl;
//   late final AnimationController _bgCtrl;
//
//   late final Animation<double> _navFade;
//   late final Animation<Offset> _navSlide;
//   late final Animation<double> _headerFade;
//   late final Animation<Offset> _headerSlide;
//   late final List<Animation<double>> _cardFades;
//   late final List<Animation<Offset>> _cardSlides;
//
//   late final Animation<double> _bgAnim;
//
//   final _notifs = NotifModel.samples;
//
//   @override
//   void initState() {
//     super.initState();
//     _masterCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1600),
//     )..forward();
//     _bgCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 8000),
//     )..repeat(reverse: true);
//
//     _bgAnim = Tween<double>(
//       begin: -14,
//       end: 14,
//     ).animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut));
//
//     Animation<double> fade(double s, double e) => CurvedAnimation(
//       parent: _masterCtrl,
//       curve: Interval(s, e, curve: Curves.easeOut),
//     );
//     Animation<Offset> slide(
//         double s,
//         double e, {
//           Offset from = const Offset(0, 0.16),
//         }) => Tween<Offset>(begin: from, end: Offset.zero).animate(
//       CurvedAnimation(
//         parent: _masterCtrl,
//         curve: Interval(s, e, curve: Curves.easeOutCubic),
//       ),
//     );
//
//     _navFade = fade(0.00, 0.24);
//     _navSlide = slide(0.00, 0.24, from: const Offset(0, 0.08));
//     _headerFade = fade(0.08, 0.34);
//     _headerSlide = slide(0.08, 0.34, from: const Offset(0, 0.12));
//
//     _cardFades = List.generate(
//       _notifs.length,
//           (i) => fade(0.22 + i * 0.07, (0.50 + i * 0.07).clamp(0, 1)),
//     );
//     _cardSlides = List.generate(
//       _notifs.length,
//           (i) => slide(0.22 + i * 0.07, (0.50 + i * 0.07).clamp(0, 1)),
//     );
//   }
//
//   @override
//   void dispose() {
//     _masterCtrl.dispose();
//     _bgCtrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final mq = MediaQuery.of(context);
//     final hPad = mq.size.width >= 600 ? 40.0 : 20.0;
//
//     return Scaffold(
//       backgroundColor: C.bg,
//       body: Stack(
//         children: [
//           _AmbientBg(anim: _bgAnim),
//           SafeArea(
//             child: Column(
//               children: [
//                 // Nav bar
//                 _FadeSlide(
//                   fade: _navFade,
//                   slide: _navSlide,
//                   child: _NavBar(
//                     title: 'Notifications',
//                     hPad: hPad,
//                     onBack: () => Navigator.pop(context),
//                     trailing: TextButton(
//                       onPressed: () {},
//                       child: const Text(
//                         'Mark all read',
//                         style: TextStyle(fontSize: 13, color: C.textMid),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 // Header
//                 _FadeSlide(
//                   fade: _headerFade,
//                   slide: _headerSlide,
//                   child: Padding(
//                     padding: EdgeInsets.fromLTRB(hPad, Sp.xs, hPad, Sp.md),
//                     child: Row(
//                       children: [
//                         Text('Recent', style: T.display),
//                         const SizedBox(width: 10),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 10,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: C.ink,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(
//                             '${_notifs.where((n) => n.isUnread).length}',
//                             style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w700,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 // List
//                 Expanded(
//                   child: ListView.builder(
//                     physics: const BouncingScrollPhysics(),
//                     padding: EdgeInsets.fromLTRB(
//                       hPad,
//                       0,
//                       hPad,
//                       mq.padding.bottom + Sp.lg,
//                     ),
//                     itemCount: _notifs.length,
//                     itemBuilder: (_, i) {
//                       final n = _notifs[i];
//                       if (i >= _cardFades.length) {
//                         return _NotifCard(
//                           notif: n,
//                           onTap: () => _openDetail(n),
//                         );
//                       }
//                       return _FadeSlide(
//                         fade: _cardFades[i],
//                         slide: _cardSlides[i],
//                         child: _NotifCard(
//                           notif: n,
//                           onTap: () => _openDetail(n),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _openDetail(NotifModel n) {
//     Navigator.push(
//       context,
//       FadeScaleRoute(page: NotificationDetailsScreen(notif: n)),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────
// //  NOTIFICATION CARD
// // ─────────────────────────────────────────────────────────────
// class _NotifCard extends StatefulWidget {
//   const _NotifCard({required this.notif, required this.onTap});
//
//   final NotifModel notif;
//   final VoidCallback onTap;
//
//   @override
//   State<_NotifCard> createState() => _NotifCardState();
// }
//
// class _NotifCardState extends State<_NotifCard> {
//   bool _pressed = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final n = widget.notif;
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: GestureDetector(
//         onTapDown: (_) => setState(() => _pressed = true),
//         onTapUp: (_) {
//           setState(() => _pressed = false);
//           widget.onTap();
//         },
//         onTapCancel: () => setState(() => _pressed = false),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 160),
//           curve: Curves.easeOut,
//           transform: Matrix4.identity()..translate(0.0, _pressed ? 1.5 : 0.0),
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: n.isUnread ? C.surface : C.surfaceAlt,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: _pressed ? C.divider.withOpacity(0.6) : C.divider,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(n.isUnread ? 0.06 : 0.03),
//                 blurRadius: 14,
//                 spreadRadius: -3,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Icon block
//               Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: C.surfaceAlt,
//                   borderRadius: BorderRadius.circular(11),
//                   border: Border.all(color: C.divider),
//                 ),
//                 child: Icon(n.icon, size: 18, color: C.textMid),
//               ),
//
//               const SizedBox(width: 12),
//
//               // Content
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             n.title,
//                             style: T.cardTitle,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           n.time,
//                           style: const TextStyle(
//                             fontSize: 11,
//                             color: C.textLow,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       n.preview,
//                       style: T.cardBody,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//
//               if (n.isUnread) ...[
//                 const SizedBox(width: 10),
//                 Container(
//                   width: 7,
//                   height: 7,
//                   margin: const EdgeInsets.only(top: 4),
//                   decoration: const BoxDecoration(
//                     color: C.unreadDot,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════
// //  NOTIFICATION DETAILS SCREEN
// // ═══════════════════════════════════════════════════════════════
// //
// //  ANIMATION:
// //  _detailCtrl (1200ms):
// //    Header (back + nav) → Interval(0.00, 0.30)
// //    Meta (icon + type)  → Interval(0.10, 0.40)
// //    Title               → Interval(0.20, 0.50) easeOutBack
// //    Time badge          → Interval(0.30, 0.55)
// //    Body                → Interval(0.40, 0.70)
// //    Action button       → Interval(0.62, 0.90)
// // ═══════════════════════════════════════════════════════════════
// class NotificationDetailsScreen extends StatefulWidget {
//   const NotificationDetailsScreen({super.key, required this.notif});
//
//   final NotifModel notif;
//
//   @override
//   State<NotificationDetailsScreen> createState() =>
//       _NotificationDetailsScreenState();
// }
//
// class _NotificationDetailsScreenState extends State<NotificationDetailsScreen>
//     with TickerProviderStateMixin {
//   late final AnimationController _detailCtrl;
//   late final AnimationController _btnCtrl;
//
//   late final Animation<double> _navFade;
//   late final Animation<Offset> _navSlide;
//   late final Animation<double> _metaFade;
//   late final Animation<Offset> _metaSlide;
//   late final Animation<double> _titleFade;
//   late final Animation<Offset> _titleSlide;
//   late final Animation<double> _timeFade;
//   late final Animation<double> _bodyFade;
//   late final Animation<Offset> _bodySlide;
//   late final Animation<double> _actionFade;
//   late final Animation<Offset> _actionSlide;
//
//   late final Animation<double> _btnScale;
//
//   @override
//   void initState() {
//     super.initState();
//     _detailCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     )..forward();
//     _btnCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 220),
//     );
//
//     Animation<double> fade(double s, double e) => CurvedAnimation(
//       parent: _detailCtrl,
//       curve: Interval(s, e, curve: Curves.easeOut),
//     );
//     Animation<Offset> slide(
//         double s,
//         double e, {
//           Offset from = const Offset(0, 0.14),
//         }) => Tween<Offset>(begin: from, end: Offset.zero).animate(
//       CurvedAnimation(
//         parent: _detailCtrl,
//         curve: Interval(s, e, curve: Curves.easeOutCubic),
//       ),
//     );
//
//     _navFade = fade(0.00, 0.28);
//     _navSlide = slide(0.00, 0.28, from: const Offset(0, 0.08));
//     _metaFade = fade(0.10, 0.38);
//     _metaSlide = slide(0.10, 0.38);
//     _titleFade = fade(0.20, 0.50);
//     _titleSlide = Tween<Offset>(begin: const Offset(0, 0.20), end: Offset.zero)
//         .animate(
//       CurvedAnimation(
//         parent: _detailCtrl,
//         curve: const Interval(0.20, 0.52, curve: Curves.easeOutBack),
//       ),
//     );
//     _timeFade = fade(0.30, 0.55);
//     _bodyFade = fade(0.40, 0.70);
//     _bodySlide = slide(0.40, 0.70);
//     _actionFade = fade(0.62, 0.90);
//     _actionSlide = slide(0.62, 0.90, from: const Offset(0, 0.10));
//
//     _btnScale = TweenSequence<double>([
//       TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.95), weight: 30),
//       TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.02), weight: 40),
//       TweenSequenceItem(tween: Tween(begin: 1.02, end: 1.0), weight: 30),
//     ]).animate(CurvedAnimation(parent: _btnCtrl, curve: Curves.easeInOut));
//   }
//
//   @override
//   void dispose() {
//     _detailCtrl.dispose();
//     _btnCtrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final mq = MediaQuery.of(context);
//     final hPad = mq.size.width >= 600 ? 40.0 : 20.0;
//     final n = widget.notif;
//
//     return Scaffold(
//       backgroundColor: C.bg,
//       body: SafeArea(
//         child: CustomScrollView(
//           physics: const BouncingScrollPhysics(),
//           slivers: [
//             // Nav
//             SliverToBoxAdapter(
//               child: _FadeSlide(
//                 fade: _navFade,
//                 slide: _navSlide,
//                 child: _NavBar(
//                   title: '',
//                   hPad: hPad,
//                   onBack: () => Navigator.pop(context),
//                 ),
//               ),
//             ),
//
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(hPad, Sp.md, hPad, 0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Meta (icon + type label)
//                     _FadeSlide(
//                       fade: _metaFade,
//                       slide: _metaSlide,
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 44,
//                             height: 44,
//                             decoration: BoxDecoration(
//                               color: C.surfaceAlt,
//                               borderRadius: BorderRadius.circular(13),
//                               border: Border.all(color: C.divider),
//                             ),
//                             child: Icon(n.icon, size: 20, color: C.textMid),
//                           ),
//                           const SizedBox(width: 12),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 10,
//                               vertical: 5,
//                             ),
//                             decoration: BoxDecoration(
//                               color: C.divider,
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             child: Text(
//                               n.type.name.toUpperCase(),
//                               style: T.caption,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // Title
//                     _FadeSlide(
//                       fade: _titleFade,
//                       slide: _titleSlide,
//                       child: Text(
//                         n.title,
//                         style: const TextStyle(
//                           fontSize: 26,
//                           fontWeight: FontWeight.w700,
//                           color: C.textHigh,
//                           letterSpacing: -0.9,
//                           height: 1.15,
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 12),
//
//                     // Time
//                     FadeTransition(
//                       opacity: _timeFade,
//                       child: Row(
//                         children: [
//                           const Icon(
//                             Icons.access_time_rounded,
//                             size: 13,
//                             color: C.textLow,
//                           ),
//                           const SizedBox(width: 5),
//                           Text(
//                             n.time,
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: C.textLow,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(height: Sp.md),
//
//                     // Divider
//                     FadeTransition(
//                       opacity: _bodyFade,
//                       child: Container(height: 1, color: C.divider),
//                     ),
//
//                     const SizedBox(height: Sp.md),
//
//                     // Full body text
//                     _FadeSlide(
//                       fade: _bodyFade,
//                       slide: _bodySlide,
//                       child: Container(
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           color: C.surface,
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(color: C.divider),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.04),
//                               blurRadius: 14,
//                               spreadRadius: -3,
//                               offset: const Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Text(n.fullBody, style: T.body),
//                       ),
//                     ),
//
//                     const SizedBox(height: Sp.md),
//
//                     // Action button
//                     _FadeSlide(
//                       fade: _actionFade,
//                       slide: _actionSlide,
//                       child: ScaleTransition(
//                         scale: _btnScale,
//                         child: GestureDetector(
//                           onTap: () async {
//                             HapticFeedback.lightImpact();
//                             await _btnCtrl.forward();
//                             _btnCtrl.reset();
//                           },
//                           child: Container(
//                             height: 52,
//                             decoration: BoxDecoration(
//                               color: C.ink,
//                               borderRadius: BorderRadius.circular(14),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: C.ink.withOpacity(0.18),
//                                   blurRadius: 20,
//                                   spreadRadius: -4,
//                                   offset: const Offset(0, 7),
//                                 ),
//                               ],
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 'Mark As Read',
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     SizedBox(height: mq.padding.bottom + Sp.lg),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
