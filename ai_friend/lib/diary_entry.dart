import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryEntry {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final String? sentiment; // sentiment analysis result
  final String? occasion; // special occasion tag

  DiaryEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.sentiment,
    this.occasion,
  });

  // Proper copyWith implementation including all fields
  DiaryEntry copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? date,
    String? sentiment,
    String? occasion,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      sentiment: sentiment ?? this.sentiment,
      occasion: occasion ?? this.occasion,
    );
  }

  // Enhanced fromMap factory with null checks
  factory DiaryEntry.fromMap(String id, Map<String, dynamic> map) {
    return DiaryEntry(
      id: id,
      title: map['title']?.toString() ?? '',
      content: map['content']?.toString() ?? '',
      date: (map['date'] as Timestamp).toDate(),
      sentiment: map['sentiment']?.toString(),
      occasion: map['occasion']?.toString(),
    );
  }

  // Safe toMap conversion with null checks
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'date': Timestamp.fromDate(date),
      if (sentiment != null) 'sentiment': sentiment,
      if (occasion != null) 'occasion': occasion,
    };
  }

  // Optional: Override toString for debugging
  @override
  String toString() {
    return 'DiaryEntry{id: $id, title: $title, date: $date, '
        'sentiment: $sentiment, occasion: $occasion}';
  }

  // Optional: Add equality comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiaryEntry &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          content == other.content &&
          date == other.date &&
          sentiment == other.sentiment &&
          occasion == other.occasion;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      content.hashCode ^
      date.hashCode ^
      sentiment.hashCode ^
      occasion.hashCode;
}
