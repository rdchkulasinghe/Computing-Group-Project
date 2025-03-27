class UserData {
  final String name;
  final int age;
  final String pronouns;
  final String movieType;
  final String freeTime;
  final String aiName;
  final String aiGender;
  final String email;
  final String password;

  UserData({
    required this.name,
    required this.age,
    required this.pronouns,
    required this.movieType,
    required this.freeTime,
    required this.aiName,
    required this.aiGender,
    this.email = '', // Default empty string
    this.password = '', // Default empty string
  });

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'pronouns': pronouns,
      'movieType': movieType,
      'freeTime': freeTime,
      'aiName': aiName,
      'aiGender': aiGender,
      'email': email, // Included in JSON output
      'password': password, // Included in JSON output
    };
  }

  // Create from JSON
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      pronouns: json['pronouns'] ?? '',
      movieType: json['movieType'] ?? '',
      freeTime: json['freeTime'] ?? '',
      aiName: json['aiName'] ?? '',
      aiGender: json['aiGender'] ?? '',
      email: json['email'] ?? '', // Default empty if missing
      password: json['password'] ?? '', // Default empty if missing
    );
  }
}
