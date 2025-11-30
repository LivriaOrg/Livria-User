import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationService {
  final NotificationRepository _repository;

  const NotificationService(this._repository);

  Future<List<Notification>> getNotifications() {
    return _repository.getAllNotifications();
  }

  Future<void> hideAllNotifications() async {
    await _repository.hideAllNotifications();
  }
}