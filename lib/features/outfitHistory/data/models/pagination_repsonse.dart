// features/history/data/models/paginated_response.dart

/// Generic wrapper that matches the API envelope:
/// { pageIndex, pageSize, totalCount, data: [...] }
class PaginatedResponse<T> {
  final int pageIndex;
  final int pageSize;
  final int totalCount;
  final List<T> data;

  const PaginatedResponse({
    required this.pageIndex,
    required this.pageSize,
    required this.totalCount,
    required this.data,
  });

  /// True when this page contains the last items — no more pages exist.
  bool get isLastPage => pageIndex * pageSize >= totalCount;

  factory PaginatedResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    return PaginatedResponse<T>(
      pageIndex: json['pageIndex'] as int,
      pageSize: json['pageSize'] as int,
      totalCount: json['totalCount'] as int,
      data: (json['data'] as List<dynamic>)
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
    );
  }
}