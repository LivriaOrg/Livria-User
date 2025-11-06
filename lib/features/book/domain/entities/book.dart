import 'dart:convert';

class Book {
  final int id;
  final String title;
  final String description;
  final String author;
  final double salePrice;
  final double purchasePrice;
  final int stock;
  final String cover;
  final String genre;
  final String language;

  const Book({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.salePrice,
    required this.purchasePrice,
    required this.stock,
    required this.cover,
    required this.genre,
    required this.language,
  });

  factory Book.fromMap(Map<String, dynamic> map) => Book(
    id: map['id'] ?? 0,
    title: map['title'] ?? '',
    description: map['description'] ?? '',
    author: map['author'] ?? '',
    salePrice: (map['salePrice'] as num?)?.toDouble() ?? 0.0,
    purchasePrice: (map['purchasePrice'] as num?)?.toDouble() ?? 0.0,
    stock: map['stock'] ?? 0,
    cover: map['cover'] ?? '',
    genre: map['genre'] ?? '',
    language: map['language'] ?? '',
  );

  static List<Book> listFromJson(String body) {
    final raw = json.decode(body) as List<dynamic>;
    return raw.map((e) => Book.fromMap(e as Map<String, dynamic>)).toList();
  }
}
