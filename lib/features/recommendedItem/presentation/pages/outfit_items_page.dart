import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_proj/core/cahsing/app_storage_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/intialization/init_di.dart';
import '../../../savedItems/data/models/saved_item_model.dart';
import '../../data/models/outfit_item_model.dart';
import '../fake/widgets/outfit_error_view.dart';
import '../manager/events.dart';
import '../manager/outfit_bloc.dart';
 import '../manager/outfit_states.dart';
import '../widgets/recommended/loading.dart';
import '../widgets/recommended/section_header.dart';
 import 'recommend_items.dart'; // RecommendedSection

class OutfitItemsPage extends StatelessWidget {
  const OutfitItemsPage({super.key});

  @override
  Widget build(BuildContext context) {


    return BlocProvider(
      create: (_) => getIt<OutfitBloc>()
        ..add(LoadOutfitsEvent(
          userId: AppStorageService.instance.getEmail(),
        )),
      child: BlocBuilder<OutfitBloc, OutfitState>(
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              label: 'CURATED FOR YOU',
              title: 'Recommended\nItems',
            ),
            _buildBody(context, state),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, OutfitState state) {
    // ── Full-screen skeleton while loading the very first page ───────────────
    if (state.isInitialLoading) {
      return Skeletonizer(
         enabled: true,
         effect: const ShimmerEffect(
          baseColor: Colors.white10,
          highlightColor: Colors.white30,
        ),

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const FakeRecommendedSection(),
        ),
      );
    }

     if (state.status == OutfitStatus.error && state.items.isEmpty) {
      return OutfitErrorView(
        message: state.errorMessage,
        onRetry: () => context.read<OutfitBloc>().add(
          LoadOutfitsEvent(
            userId: AppStorageService.instance.getEmail(),
          ),
        ),
      );
    }

    // ── Normal view: pass items + toggle handler via BlocBuilder ─────────────
    return RecommendedSection(
      onSaveToggle: (item) => _handleSaveToggle(context, item),
    );
  }

  /// Dispatches SaveItemEvent or UnsaveItemEvent depending on current state.
  /// The item already has the correct [isSaved] value from the Bloc state,
  /// so we just read it here — no local flag needed.
  void _handleSaveToggle(BuildContext context, OutfitItemModel item) {
    final userId = AppStorageService.instance.getEmail();
    final bloc = context.read<OutfitBloc>();

    // Guard: ignore taps while this item is mid-request.
    final saveStatus = bloc.state.saveStatusFor(item.id);
    if (saveStatus == SaveStatus.loading) return;

    final savedItem = SavedItemModel(
      userId: userId,
      itemId: item.id,
      category: 'outfit',
      outfitModel: item,
      timestamp: DateTime.now(),
    );

    if (item.isSaved) {
      bloc.add(UnsaveItemEvent(outfit: savedItem));
    } else {
      bloc.add(SaveItemEvent(outfit: savedItem));
    }
  }
}