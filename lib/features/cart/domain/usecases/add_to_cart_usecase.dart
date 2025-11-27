import '../repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<void> call(int bookId, int quantity, int userId) async {
    return await repository.addItem(bookId, quantity, userId);
  }
}