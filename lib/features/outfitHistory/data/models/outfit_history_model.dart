// features/history/models/outfit_history_model.dart

class OutfitHistoryModel {
  final int id; // ✅ بدل String
  final double originalScore;
  final double improvedScore;
  final bool isCompatible;
  final DateTime createdAt;

  final String? topImagePath;
  final String? bottomImagePath;
  final String? shoeImagePath;
  final String? accessoryImagePath;
  final String? bagImagePath;

  final Map<String, String> replacements;

  const OutfitHistoryModel({
    required this.id,
    required this.originalScore,
    required this.improvedScore,
    required this.isCompatible,
    required this.createdAt,
    this.topImagePath,
    this.bottomImagePath,
    this.shoeImagePath,
    this.accessoryImagePath,
    this.bagImagePath,
    required this.replacements,
  });

  factory OutfitHistoryModel.fromJson(Map<String, dynamic> json) {
    String? _parseNullableString(dynamic value) {
      if (value == null || value.toString().trim().isEmpty) return null;
      return value.toString();
    }

    return OutfitHistoryModel(
      id: json['id'] as int, // ✅ مطابق للـ API

      originalScore: (json['originalScore'] as num).toDouble(),
      improvedScore: (json['improvedScore'] as num).toDouble(),

      isCompatible: json['isCompatible'] as bool,

      createdAt: DateTime.parse(json['createdAt']),

      // ✅ handle empty string => null
      topImagePath: _parseNullableString(json['topImagePath']),
      bottomImagePath: _parseNullableString(json['bottomImagePath']),
      shoeImagePath: _parseNullableString(json['shoeImagePath']),
      accessoryImagePath: _parseNullableString(json['accessoryImagePath']),
      bagImagePath: _parseNullableString(json['bagImagePath']),

      // ✅ safe map parsing
      replacements: (json['replacements'] as Map<String, dynamic>? ?? {})
          .map((k, v) => MapEntry(k, v.toString())),
    );
  }

  /// ✅ كل الصور
  List<String?> get allImages => [
    topImagePath,
    bottomImagePath,
    shoeImagePath,
    accessoryImagePath,
    bagImagePath,
  ];

  /// ✅ الصور اللي مش null
  List<String> get nonNullImages =>
      allImages.whereType<String>().toList();

  /// ✅ formatted date
  String get formattedDate {
    final d = createdAt;
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}