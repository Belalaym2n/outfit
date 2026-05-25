// features/history/data/outfit_history_remote_ds.dart

import '../../../../core/apiManager/api_manager.dart';
import '../../../../core/apiManager/end_points.dart';
import '../../../../core/handleErrors/result_pattern.dart';
import '../models/outfit_history_model.dart';
import '../models/pagination_repsonse.dart';
import 'outfit_history_remote_ds.dart';

final items = [
  OutfitHistoryModel(
    id: 1,
    originalScore: 6.5,
    improvedScore: 8.2,
    isCompatible: true,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    topImagePath: "https://i.imgur.com/1.png",
    bottomImagePath: "https://i.imgur.com/2.png",
    shoeImagePath: "https://i.imgur.com/3.png",
    accessoryImagePath: null,
    bagImagePath: null,
    replacements: {"top": "White Shirt", "shoes": "Sneakers"},
  ),

  OutfitHistoryModel(
    id: 2,
    originalScore: 4.0,
    improvedScore: 7.5,
    isCompatible: false,
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    topImagePath: "https://i.imgur.com/4.png",
    bottomImagePath: "https://i.imgur.com/5.png",
    shoeImagePath: null,
    accessoryImagePath: "https://i.imgur.com/6.png",
    bagImagePath: null,
    replacements: {"bottom": "Blue Jeans", "accessory": "Watch"},
  ),

  OutfitHistoryModel(
    id: 3,
    originalScore: 5.5,
    improvedScore: 9.0,
    isCompatible: true,
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
    topImagePath: "https://i.imgur.com/7.png",
    bottomImagePath: null,
    shoeImagePath: "https://i.imgur.com/8.png",
    accessoryImagePath: null,
    bagImagePath: "https://i.imgur.com/9.png",
    replacements: {"bag": "Leather Bag"},
  ),
];


class OutfitHistoryRDSImpl implements OutfitHistoryRDS {
  const OutfitHistoryRDSImpl();

  @override
  Future<Result> fetchHistory({
    required int pageIndex,
    required int pageSize,
  }) async {
    final response = await ApiService.request(
      endpoint:
      '${AppEndPoints.history}?pageIndex=$pageIndex&pageSize=$pageSize',
      method: 'GET',
    );

    // ApiService returns a Result on network/auth errors
    if (response is Result) return response;

    // response is the decoded JSON map
    final paginated = PaginatedResponse.fromJson(
      response as Map<String, dynamic>,
      OutfitHistoryModel.fromJson,
    );


    return Result.success(paginated);
  }

  @override
  Future<Result> deleteHistory(int id) async {
    final response = await ApiService.request(
      endpoint: '${AppEndPoints.history}/$id',
      method: 'DELETE',
    );

    if (response is Result) return response;
    return Result.success(true);
  }
}