import 'package:livria_user/features/book/domain/entities/book.dart';
import 'dart:convert';

class CartItem {
  final int id;
  final Book book;
  final int quantity;
  final int userClientId;

  const CartItem({
    required this.id,
    required this.book,
    required this.quantity,
    required this.userClientId,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) => CartItem(
    id: map['id'] ?? 0,
    book: Book.fromMap(map['book'] ?? {}),
    quantity: map['quantity'] ?? 0,
    userClientId: map['userClientId'] ?? 0,
  );

  static List<CartItem> listFromJson(String body) {
    final raw = json.decode(body) as List<dynamic>;
    return raw.map((e) => CartItem.fromMap(e as Map<String, dynamic>)).toList();
  }

}