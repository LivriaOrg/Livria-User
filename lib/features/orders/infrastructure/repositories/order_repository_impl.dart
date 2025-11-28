import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasource/order_remote_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<Order> createOrder({
    required int userClientId,
    required String userEmail,
    required String userPhone,
    required String userFullName,
    required String recipientName,
    required bool isDelivery,
    required String status,
    ShippingDetails? shippingDetails,
  }) async {
    return await remoteDataSource.createOrder(
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

  @override
  Future<List<Order>> getOrdersByUser(int userId) async {
    return await remoteDataSource.getOrdersByUser(userId);
  }
}