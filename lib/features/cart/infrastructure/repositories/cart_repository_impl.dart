import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasource/cart_remote_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  // Inyección del DataSource
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CartItem>> getCartItems(int userId) async {
    return await remoteDataSource.getCartItems(userId);
  }

  @override
  Future<void> addItem(int bookId, int quantity, int userId) async {
    await remoteDataSource.addToCart(bookId, quantity, userId);
  }

  @override
  Future<void> updateQuantity(int cartItemId, int userId, int newQuantity) async {
    await remoteDataSource.updateQuantity(cartItemId, userId, newQuantity);
  }

  @override
  Future<void> deleteItem(int cartItemId, int userId) async {
    await remoteDataSource.deleteItem(cartItemId, userId);
  }
}