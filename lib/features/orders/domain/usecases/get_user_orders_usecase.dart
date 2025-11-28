import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetUserOrdersUseCase {
  final OrderRepository repository;

  GetUserOrdersUseCase(this.repository);

  Future<List<Order>> call(int userId) async {
    return await repository.getOrdersByUser(userId);
  }
}