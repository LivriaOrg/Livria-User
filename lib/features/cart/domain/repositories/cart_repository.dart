import '../entities/cart_item.dart';

abstract class CartRepository {
  // Obtener carrito
  Future<List<CartItem>> getCartItems(int userId);

  // Agregar item
  Future<void> addItem(int bookId, int quantity, int userId);

  // Actualizar cantidad
  Future<void> updateQuantity(int cartItemId, int userId, int newQuantity);

  // Eliminar item
  Future<void> deleteItem(int cartItemId, int userId);
}


