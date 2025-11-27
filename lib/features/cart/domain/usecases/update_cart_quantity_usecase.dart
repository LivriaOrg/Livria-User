import '../repositories/cart_repository.dart';

class UpdateCartQuantityUseCase {
  final CartRepository repository;

  UpdateCartQuantityUseCase(this.repository);

  Future<void> call(int cartItemId, int userId, int newQuantity) async {
    return await repository.updateQuantity(cartItemId, userId, newQuantity);
  }
}