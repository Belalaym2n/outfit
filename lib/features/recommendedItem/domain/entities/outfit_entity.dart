import 'package:equatable/equatable.dart';

enum Gender { male, female, unisex }

class OutfitItemEntity extends Equatable {
  final String id;
  final String title;
  final Gender gender;
  final List<String> categories;
  final List<String> colors;
  final List<String> images;
  final bool isSaved;

  const OutfitItemEntity({
    required this.id,
    required this.title,
    required this.gender,
    required this.categories,
    required this.colors,
    required this.images,
    this.isSaved = false,
  });

  OutfitItemEntity copyWith({
    String? id,
    String? title,
    Gender? gender,
    List<String>? categories,
    List<String>? colors,
    List<String>? images,
    bool? isSaved,
  }) {
    return OutfitItemEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      gender: gender ?? this.gender,
      categories: categories ?? this.categories,
      colors: colors ?? this.colors,
      images: images ?? this.images,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  List<Object?> get props => [id, title, gender, categories, colors, images, isSaved];
}