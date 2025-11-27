import '../entities/order.dart';

abstract class OrderRepository {
  Future<Order> createOrder({
    required int userClientId,
    required String userEmail,
    required String userPhone,
    required String userFullName,
    required String recipientName,
    required bool isDelivery,
    required String status,
    ShippingDetails? shippingDetails,
  });
}