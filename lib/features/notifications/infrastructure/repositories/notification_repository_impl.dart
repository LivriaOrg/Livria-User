import 'package:http/http.dart' as http;

import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasource/notification_remote_datasource.dart';
import 'package:livria_user/features/auth/infrastructure/datasource/auth_local_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDs;
  final AuthLocalDataSource _authDs;
  const NotificationRepositoryImpl(this._remoteDs, this._authDs);

  Future<int> _getUserClientId() async {
    final int? userId = await _authDs.getUserId();
    if (userId == null) {
      throw Exception('Usuario no autenticado. ID de cliente no disponible.');
    }
    return userId;
  }

  @override
  Future<List<Notification>> getAllNotifications() async {
    final int userClientId = await _getUserClientId();
    final http.Response res = await _remoteDs.getAllNotifications(userClientId);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return Notification.listFromJson(res.body);
    }
    throw Exception('HTTP ${res.statusCode}: Fallo al obtener notificaciones. ${res.reasonPhrase}');
  }

  @override
  Future<void> hideAllNotifications() async {
    final int userClientId = await _getUserClientId();
    await _remoteDs.hideAllNotifications(userClientId);
  }
}