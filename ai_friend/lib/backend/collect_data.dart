import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String userId;
  final String name;
  final String? email;
  final int age;
  final String pronouns;
  final String bio;
  final List<String> interests;
  final String movieType;
  final String freeTime;
  final String aiName;
  final String aiGender;
  final Timestamp? createdAt;
  final DateTime? birthday;
  final bool profileComplete;

  UserData({
    required this.userId,
    required this.name,
    this.email,
    required this.age,
    required this.pronouns,
    this.bio = '',
    this.interests = const [],
    required this.movieType,
    required this.freeTime,
    required this.aiName,
    required this.aiGender,
    this.createdAt,
    this.birthday,
    this.profileComplete = true,
  });

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'name': name,
        if (email != null) 'email': email,
        'age': age,
        'pronouns': pronouns,
        'bio': bio,
        'interests': interests,
        'movieType': movieType,
        'freeTime': freeTime,
        'aiName': aiName,
        'aiGender': aiGender,
        if (createdAt != null) 'createdAt': createdAt,
        if (birthday != null) 'birthday': Timestamp.fromDate(birthday!),
        'profileComplete': profileComplete,
      };

  factory UserData.fromFirestore(String userId, Map<String, dynamic> data) {
    return UserData(
      userId: userId,
      name: data['name'] as String? ?? '',
      email: data['email'] as String?,
      age: data['age'] as int? ?? 0,
      pronouns: data['pronouns'] as String? ?? '',
      bio: data['bio'] as String? ?? '',
      interests: List<String>.from(data['interests'] as List? ?? []),
      movieType: data['movieType'] as String? ?? '',
      freeTime: data['freeTime'] as String? ?? '',
      aiName: data['aiName'] as String? ?? '',
      aiGender: data['aiGender'] as String? ?? '',
      createdAt: data['createdAt'] as Timestamp?,
      birthday: data['birthday'] != null
          ? (data['birthday'] as Timestamp).toDate()
          : null,
      profileComplete: data['profileComplete'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        if (email != null) 'email': email,
        'age': age,
        'pronouns': pronouns,
        'bio': bio,
        'interests': interests,
        'movieType': movieType,
        'freeTime': freeTime,
        'aiName': aiName,
        'aiGender': aiGender,
        'createdAt': createdAt?.millisecondsSinceEpoch,
        'birthday': birthday?.millisecondsSinceEpoch,
        'profileComplete': profileComplete,
      };

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['userId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String?,
      age: json['age'] as int? ?? 0,
      pronouns: json['pronouns'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      interests: List<String>.from(json['interests'] as List? ?? []),
      movieType: json['movieType'] as String? ?? '',
      freeTime: json['freeTime'] as String? ?? '',
      aiName: json['aiName'] as String? ?? '',
      aiGender: json['aiGender'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(json['createdAt'] as int)
          : null,
      birthday: json['birthday'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['birthday'] as int)
          : null,
      profileComplete: json['profileComplete'] as bool? ?? true,
    );
  }

  UserData copyWith({
    String? name,
    int? age,
    String? pronouns,
    String? bio,
    List<String>? interests,
    String? movieType,
    String? freeTime,
    String? aiName,
    String? aiGender,
    DateTime? birthday,
    bool? profileComplete,
  }) {
    return UserData(
      userId: userId,
      name: name ?? this.name,
      email: email,
      age: age ?? this.age,
      pronouns: pronouns ?? this.pronouns,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      movieType: movieType ?? this.movieType,
      freeTime: freeTime ?? this.freeTime,
      aiName: aiName ?? this.aiName,
      aiGender: aiGender ?? this.aiGender,
      createdAt: createdAt,
      birthday: birthday ?? this.birthday,
      profileComplete: profileComplete ?? this.profileComplete,
    );
  }
}
