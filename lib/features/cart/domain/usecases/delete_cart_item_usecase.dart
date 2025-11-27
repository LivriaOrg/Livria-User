import '../repositories/cart_repository.dart';

class DeleteCartItemUseCase {
  final CartRepository repository;

  DeleteCartItemUseCase(this.repository);

  Future<void> call(int cartItemId, int userId) async {
    return await repository.deleteItem(cartItemId, userId);
  }
}