import 'dart:convert';

class Review {
  final int id;
  final int bookId;
  final String username;
  final String content;
  final int stars;

  const Review({
    required this.id,
    required this.bookId,
    required this.username,
    required this.content,
    required this.stars
  });

  factory Review.fromMap(Map<String, dynamic> map) => Review(
      id: map['id'] ?? 0,
      bookId: map['bookId'] ?? 0,
      username: map['username'] ?? '',
      content: map['content'] ?? '',
      stars: map['stars'] ?? 0
  );

  static List<Review> listFromJson(String body) {
    final raw = json.decode(body) as List<dynamic>;
    return raw.map((e) => Review.fromMap(e as Map<String, dynamic>)).toList();
  }

}