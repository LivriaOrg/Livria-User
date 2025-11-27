import '../repositories/cart_repository.dart';
import '../entities/cart_item.dart';

class GetCartItemsUseCase {
  final CartRepository repository;

  GetCartItemsUseCase(this.repository);

  Future<List<CartItem>> call(int userId) async {
    return await repository.getCartItems(userId);
  }
}