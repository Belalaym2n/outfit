
import 'package:equatable/equatable.dart';
import '../../domain/entities/outfit_entity.dart';

class OutfitItemModel extends Equatable {
  final String id;
  final String title;
  final String gender; // stored as string: 'male' | 'female' | 'unisex'
  final List<String> categories;
  final List<String> colors;
  final List<String> images;
  final bool isSaved;

  const OutfitItemModel({
    required this.id,
    required this.title,
    required this.gender,
    required this.categories,
    required this.colors,
    required this.images,
    this.isSaved = false,
  });

  // ── From JSON (Firestore / API) ───────────────────────────
  factory OutfitItemModel.fromJson(Map<String, dynamic> json) {
    return OutfitItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      gender: json['gender'] as String,
      categories: List<String>.from(json['categories'] as List),
      colors: List<String>.from(json['colors'] as List),
      images: List<String>.from(json['images'] as List),
      isSaved: json['isSaved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'gender': gender,
    'categories': categories,
    'colors': colors,
    'images': images,
    'isSaved': isSaved,
  };

  // ── Domain ↔ Data conversion ──────────────────────────────
  factory OutfitItemModel.fromEntity(OutfitItemEntity entity) {
    return OutfitItemModel(
      id: entity.id,
      title: entity.title,
      gender: entity.gender.name,
      categories: entity.categories,
      colors: entity.colors,
      images: entity.images,
      isSaved: entity.isSaved,
    );
  }

  OutfitItemEntity toEntity() {
    return OutfitItemEntity(
      id: id,
      title: title,
      gender: _parseGender(gender),
      categories: categories,
      colors: colors,
      images: images,
      isSaved: isSaved,
    );
  }

  OutfitItemModel copyWith({bool? isSaved}) => OutfitItemModel(
    id: id,
    title: title,
    gender: gender,
    categories: categories,
    colors: colors,
    images: images,
    isSaved: isSaved ?? this.isSaved,
  );

  static Gender _parseGender(String value) {
    switch (value) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      default:
        return Gender.unisex;
    }
  }

  @override
  List<Object?> get props => [id, title, gender, categories, colors, images, isSaved];
}