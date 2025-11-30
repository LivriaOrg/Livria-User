import '../entities/notification.dart';

abstract class NotificationRepository {
  /// Obtiene todas las notificaciones para el usuario autenticado.
  Future<List<Notification>> getAllNotifications();

  // Nuevo método: Ocultar todas las notificaciones
  Future<void> hideAllNotifications();
}