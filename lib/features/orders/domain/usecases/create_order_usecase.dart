
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<Order> call({
    required int userClientId,
    required String userEmail,
    required String userPhone,
    required String userFullName,
    required String recipientName,
    required bool isDelivery,
    String status = "pending",
    ShippingDetails? shippingDetails,
  }) async {
    return await repository.createOrder(
      userClientId: userClientId,
      userEmail: userEmail,
      userPhone: userPhone,
      userFullName: userFullName,
      recipientName: recipientName,
      isDelivery: isDelivery,
      status: status,
      shippingDetails: shippingDetails,
    );
  }
}