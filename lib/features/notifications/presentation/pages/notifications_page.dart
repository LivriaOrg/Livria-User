import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/notification.dart' as app_notification;
import '../../application/services/notification_service.dart';
import '../../infrastructure/datasource/notification_remote_datasource.dart';
import '../../infrastructure/repositories/notification_repository_impl.dart';
import '../../../auth/infrastructure/datasource/auth_local_datasource.dart';
import '../widgets/notification_card.dart';
import '../../../../common/theme/app_colors.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<app_notification.Notification> _items = [];
  bool _isLoading = true;
  bool _isMarkingAllRead = false;
  int? _currentUserId;
  bool _isLoadingUser = true;

  late final NotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadUserData();
    if (_currentUserId != null) {
      final client = http.Client();
      final authDs = AuthLocalDataSource();
      final dataSource = NotificationRemoteDataSource(client: client, authDs: authDs);
      final repository = NotificationRepositoryImpl(dataSource, authDs);
      _notificationService = NotificationService(repository);
      _loadData();
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadUserData() async {
    final authLocal = AuthLocalDataSource();
    final userId = await authLocal.getUserId();
    if (mounted) {
      setState(() {
        _currentUserId = userId;
        _isLoadingUser = false;
      });
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final items = await _notificationService.getNotifications();
      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading notifications: $e");
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al cargar notificaciones"), backgroundColor: AppColors.errorRed),
        );
      }
    }
  }

  Future<void> _hideAll() async {
    setState(() => _isMarkingAllRead = true);
    try {
      await _notificationService.hideAllNotifications();
      if (mounted) {
        setState(() {
          _items = [];
        });
      }
    } catch (e) {
      debugPrint("Error hiding all notifications: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al ocultar todas las notificaciones"), backgroundColor: AppColors.errorRed),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isMarkingAllRead = false);
      }
    }
  }
  void _onNotificationDismiss(int itemId) async {
    setState(() {
      _items.removeWhere((item) => item.id == itemId);
    });
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = AppColors.darkBlue;
    const accentColor = AppColors.vibrantBlue;
    const lightBlueBtn = AppColors.softTeal;
    const double verticalPadding = 20.0;
    const double horizontalPadding = 16.0;

    if (_isLoadingUser) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange));
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: verticalPadding),
            const Text(
              "NOTIFICATIONS",
              style: TextStyle(
                fontFamily: 'AsapCondensed',
                color: AppColors.accentGold,
                fontSize: 32,
                fontWeight: FontWeight.w500,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 8.0),

              ElevatedButton(
              onPressed: (_isLoading ) ? null : _hideAll,
              style: ElevatedButton.styleFrom(
                backgroundColor: lightBlueBtn,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                disabledBackgroundColor: AppColors.softTeal.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              ),
              child: _isMarkingAllRead
                  ? const SizedBox(
                width: 12, height: 12,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.vibrantBlue),
              )
                  : const Text(
                "HIDE ALL",
                style: TextStyle(
                    color: AppColors.vibrantBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12
                ),
              ),
            ),

            const SizedBox(height: verticalPadding),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: accentColor))
                  : _items.isEmpty
                  ? const Center(
                  child: Text(
                      "No tienes notificaciones",
                      style: TextStyle(color: Colors.white70)
                  )
              )
                  : ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: NotificationCard(
                      notification: item,
                      onDismiss: () => _onNotificationDismiss(item.id),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}