import 'package:equatable/equatable.dart';

class OutfitItemModel extends Equatable {
  final String id;
  final String title;
  final String gender;
  final List<String> categories;
  final List<String> colors;
  final List<String> images;
  final String description;
  final double aiScore;
  final List<String> tags;
  final bool isSaved;

  const OutfitItemModel({
    required this.id,
    required this.title,
    required this.gender,
    required this.categories,
    required this.colors,
    required this.images,
    required this.description,
    required this.aiScore,
    required this.tags,
    this.isSaved = false,
  });

  OutfitItemModel copyWith({
    String? id,
    String? title,
    String? gender,
    List<String>? categories,
    List<String>? colors,
    List<String>? images,
    String? description,
    double? aiScore,
    List<String>? tags,
    bool? isSaved,
  }) {
    return OutfitItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      gender: gender ?? this.gender,
      categories: categories ?? this.categories,
      colors: colors ?? this.colors,
      images: images ?? this.images,
      description: description ?? this.description,
      aiScore: aiScore ?? this.aiScore,
      tags: tags ?? this.tags,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  factory OutfitItemModel.fromJson(Map<String, dynamic> json) {
    return OutfitItemModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      gender: json['gender'] ?? '',
      categories: List<String>.from(json['categories'] ?? []),
      colors: List<String>.from(json['colors'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      description: json['description'] ?? '',
      aiScore: (json['aiScore'] ?? 0).toDouble(),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "gender": gender,
      "categories": categories,
      "colors": colors,
      "images": images,
      "description": description,
      "aiScore": aiScore,
      "tags": tags,
    };
  }
  @override
  List<Object?> get props => [
    id,
    title,
    gender,
    categories,
    colors,
    images,
    description,
    aiScore,
    tags,
    isSaved,
  ];
}

// ---------------------------------------------------------------------------
// Seed / fake data — used until real API is wired
// ---------------------------------------------------------------------------
final List<OutfitItemModel> fakeOutfits = [
  const OutfitItemModel(
    id: '1',
    title: 'Casual Summer Outfit',
    gender: 'male',
    categories: ['casual', 'summer'],
    colors: ['white', 'blue'],
    images: ['https://tse4.mm.bing.net/th/id/OIP.EaOJAYmi7g7595H1WUMzCAHaHa?pid=ImgDet&w=187&h=187&c=7&dpr=1.3&o=7&rm=3'],
    description: 'A fresh and breathable summer outfit designed for maximum comfort during hot days. This look combines lightweight fabrics with a relaxed fit, making it perfect for daily outings, casual meetups, or a walk by the beach. The clean color palette adds a refreshing vibe while keeping the style simple, modern, and effortlessly cool.',
    aiScore: 8.5,
    tags: ['cool', 'daily', 'simple'],
  ),

  const OutfitItemModel(
    id: '3',
    title: 'Streetwear Vibes',
    gender: 'female',
    categories: ['streetwear', 'casual'],
    colors: ['black', 'red'],
    images: ['https://img-1.kwcdn.com/thumbnail/s/51f5acc2cc252b8c9593388fcf1d05ee_412f9d410638.jpg?imageView2/2/w/800/q/70/format/avif'],
    description: 'A bold and trendy streetwear outfit that captures the essence of urban fashion. Featuring edgy color combinations and modern silhouettes, this look is perfect for expressing confidence and individuality. Ideal for everyday wear, hangouts, or city walks, it delivers a stylish balance between comfort and attitude.',
    aiScore: 8.9,
    tags: ['trendy', 'urban'],
  ),

  const OutfitItemModel(
    id: '2',
    title: 'Formal Classic Suit',
    gender: 'male',
    categories: ['formal', 'casual'],
    colors: ['black', 'gray'],
    images: ['https://i.pinimg.com/1200x/69/d3/3b/69d33b82b0ec0b0f7fee15010417e870.jpg'],
    description: 'A timeless formal suit crafted for elegance and confidence. This outfit is perfect for business meetings, formal events, and special occasions where making a strong impression matters. The classic color combination and tailored fit provide a sharp, polished look that never goes out of style.',
    aiScore: 9.2,
    tags: ['elegant', 'office', 'classic'],
  ),

  const OutfitItemModel(
    id: '4',
    title: 'Elegant Modest Winter Hijab Look',
    gender: 'female',
    categories: ['winter', 'casual', 'modest'],
    colors: ['brown', 'beige'],
    images: ['https://i.pinimg.com/736x/5b/2a/ab/5b2aab4a2291d41902765a63e7ba66c8.jpg'],
    description: 'A beautifully styled modest winter outfit tailored for hijabi women who value both elegance and comfort. This look features warm, layered pieces with soft neutral tones that create a calm and sophisticated aesthetic. Designed to provide full coverage while maintaining a modern and fashionable appearance, it is perfect for daily wear, outings, or cozy winter gatherings.',
    aiScore: 8.3,
    tags: ['modest', 'hijab-friendly', 'warm', 'cozy', 'elegant'],
  ),
];