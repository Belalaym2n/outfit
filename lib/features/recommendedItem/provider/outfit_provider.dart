// // ─────────────────────────────────────────────────────────────
// //  outfit_provider.dart  —  InheritedWidget DI for OutfitNotifier
// //  Place above MaterialApp (or the subtree that needs it).
// //  Consumers call OutfitProvider.of(context) for the notifier.
// // ─────────────────────────────────────────────────────────────
//
// import 'package:flutter/widgets.dart';
// import 'outfit_provider_state.dart';
//
// class OutfitProvider extends InheritedNotifier<OutfitNotifier> {
//   const OutfitProvider({
//     super.key,
//     required OutfitNotifier notifier,
//     required super.child,
//   }) : super(notifier: notifier);
//
//   /// Returns the notifier WITHOUT subscribing to rebuilds.
//   /// Use this when you only want to call methods (toggle, loadMore, etc.)
//   static OutfitNotifier of(BuildContext context) {
//     final provider =
//     context.getInheritedWidgetOfExactType<OutfitProvider>();
//     assert(provider != null, 'No OutfitProvider found in widget tree');
//     return provider!.notifier!;
//   }
//
//   /// Use this when you need the full list to rebuild (e.g. the list scaffold).
//   /// Prefer per-item ValueListenableBuilder for fine-grained rebuilds.
//   static OutfitNotifier watch(BuildContext context) {
//     final provider =
//     context.dependOnInheritedWidgetOfExactType<OutfitProvider>();
//     assert(provider != null, 'No OutfitProvider found in widget tree');
//     return provider!.notifier!;
//   }
// }