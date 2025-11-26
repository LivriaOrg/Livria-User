import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livria_user/common/config/env.dart';
import '../../domain/entities/cart_item.dart';

class CartRemoteDataSource {
  static const String _base = Env.apiBase;
  static const String _cartPath = '/api/v1/cart-items';

  final http.Client _client;

  CartRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  // OBTENER EL CARRITO (GET)
  Future<List<CartItem>> getCartItems(int userId) async {
    final uri = Uri.parse('$_base$_cartPath/users/$userId');

    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      return CartItem.listFromJson(response.body);
    } else {
      throw Exception('Error while loading cart: ${response.statusCode}');
    }
  }

  // AGREGAR ITEM (POST)
  Future<void> addToCart(int bookId, int quantity, int userId) async {
    final uri = Uri.parse('$_base$_cartPath');

    final body = json.encode({
      "bookId": bookId,
      "quantity": quantity,
      "userClientId": userId
    });

    final response = await _client.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error while adding to cart: ${response.body}');
    }
  }

  // ACTUALIZAR CANTIDAD (PUT)
  Future<void> updateQuantity(int cartItemId, int userId, int newQuantity) async {
    final uri = Uri.parse('$_base$_cartPath/$cartItemId/users/$userId');

    final body = json.encode({"newQuantity": newQuantity});

    final response = await _client.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Error while updating cart');
    }
  }

  // ELIMINAR ITEM (DELETE)
  Future<void> deleteItem(int cartItemId, int userId) async {
    final uri = Uri.parse('$_base$_cartPath/$cartItemId/users/$userId');

    final response = await _client.delete(uri);

    if (response.statusCode != 200) {
      throw Exception('Error while deleting item');
    }
  }
}