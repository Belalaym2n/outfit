class UserModel {
  final String id;
  final String name;
  final String email;
  final String badge;
  final String? avatarUrl;
  final int analyses;
  final int avgScore;
  final int saved;
  final double journeyProgress;
  final String journeyMessage;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.badge,
    this.avatarUrl,
    required this.analyses,
    required this.avgScore,
    required this.saved,
    required this.journeyProgress,
    required this.journeyMessage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      badge: json['badge']?.toString() ?? 'AI Explorer',
      avatarUrl: json['avatar_url']?.toString(),
      analyses: (json['analyses'] as num?)?.toInt() ?? 0,
      avgScore: (json['avg_score'] as num?)?.toInt() ?? 0,
      saved: (json['saved'] as num?)?.toInt() ?? 0,
      journeyProgress:
      (json['journey_progress'] as num?)?.toDouble() ?? 0.0,
      journeyMessage: json['journey_message']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'badge': badge,
      'avatar_url': avatarUrl,
      'analyses': analyses,
      'avg_score': avgScore,
      'saved': saved,
      'journey_progress': journeyProgress,
      'journey_message': journeyMessage,
    };
  }

  // ✅ مهم جداً علشان Bloc & UI updates
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? badge,
    String? avatarUrl,
    int? analyses,
    int? avgScore,
    int? saved,
    double? journeyProgress,
    String? journeyMessage,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      badge: badge ?? this.badge,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      analyses: analyses ?? this.analyses,
      avgScore: avgScore ?? this.avgScore,
      saved: saved ?? this.saved,
      journeyProgress: journeyProgress ?? this.journeyProgress,
      journeyMessage: journeyMessage ?? this.journeyMessage,
    );
  }

  // ✅ optional (بس بروفيشنال)
  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email)';
  }
}