class OutfitResponseModel {
  final double originalScore;
  final double improvedScore;
  final bool isCompatible;
  final List<double> highlights;
  final Map<String, String> replacements;

  const OutfitResponseModel({
    required this.originalScore,
    required this.improvedScore,
    required this.isCompatible,
    required this.highlights,
    required this.replacements,
  });

  factory OutfitResponseModel.fromJson(Map<String, dynamic> json) {
    return OutfitResponseModel(
      originalScore: (json['original_score'] ?? 0).toDouble(),
      improvedScore: (json['improved_score'] ?? 0).toDouble(),
      isCompatible: json['is_compatible'] ?? false,
      highlights: (json['highlights'] as List? ?? [])
          .map((e) => (e as num).toDouble())
          .toList(),      replacements: (json['replacements'] as Map<String, dynamic>? ?? {})
          .map((k, v) => MapEntry(k, v.toString())),
    );
  }

  Map<String, dynamic> toJson() => {
    'original_score': originalScore,
    'improved_score': improvedScore,
    'is_compatible': isCompatible,
    'highlights': highlights,
    'replacements': replacements,
  };
}