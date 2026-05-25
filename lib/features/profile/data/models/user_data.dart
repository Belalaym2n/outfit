class UserModel {
   final String name;
  final String email;

  final int analyses;
  final int avgScore;
   final String journeyMessage;

  const UserModel({
     required this.name,
    required this.email,
     required this.analyses,
    required this.avgScore,
     required this.journeyMessage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
       name: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
        analyses: (json['totalAnalyses'] as num?)?.toInt() ?? 0,
      avgScore: (json['averageScore'] as num?)?.toInt() ?? 0,

      journeyMessage: json['journey_message']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
       'name': name,
      'email': email,

      'analyses': analyses,
      'avg_score': avgScore,
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
       name: name ?? this.name,
      email: email ?? this.email,
      analyses: analyses ?? this.analyses,
      avgScore: avgScore ?? this.avgScore,
       journeyMessage: journeyMessage ?? this.journeyMessage,
    );
  }

  // ✅ optional (بس بروفيشنال)
  @override
  String toString() {
    return 'UserModel(id:  , name: $name, email: $email)';
  }
}