import 'package:flutter/cupertino.dart';
import 'package:graduation_proj/features/recommendedItem/presentation/widgets/recommended/recommend_items.dart';

import '../../../data/models/outfit_item_model.dart';

class FakeRecommendedSection extends StatelessWidget {
  const FakeRecommendedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return RecommendedItemsRow(
      onNavigate:(item) =>  null,
      items: getFakeItems(),
      savedIds: const {},
      saveStatuses: const {},
      onSaveToggle: (_) {},
    );
  }
}

List<OutfitItemModel> getFakeItems() {
  return List.generate(
    6,
        (index) => OutfitItemModel(
      id: 'fake_$index',
      title: 'Loading outfit item',
      description: 'This is a placeholder description',
      gender: 'female',
      categories: ['casual'],
      colors: ['beige'],
          images: ['https://tse4.mm.bing.net/th/id/OIP.EaOJAYmi7g7595H1WUMzCAHaHa?pid=ImgDet&w=187&h=187&c=7&dpr=1.3&o=7&rm=3'],
      aiScore: 0,
      isSaved: false, tags: [],
    ),
  );
}