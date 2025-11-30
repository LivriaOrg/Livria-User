import 'package:flutter/material.dart';

import '../../domain/entities/notification.dart' as app_notification;
import '../../../../common/theme/app_colors.dart';

class NotificationCard extends StatelessWidget {
  final app_notification.Notification notification;
  final VoidCallback onDismiss;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onDismiss,
  });

  IconData _getIconForType(int type) {
    switch (type) {
      case 1:
        return Icons.shopping_bag_rounded;
      case 2:
        return Icons.people_alt_rounded;
      case 3:
        return Icons.local_offer_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    const cardColor = AppColors.white;
    final titleColor = notification.isRead ? AppColors.darkBlue : AppColors.vibrantBlue;

    return InkWell(
      child: Container(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkBlue.withOpacity(notification.isRead ? 0.05 : 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.primaryOrange,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),

            InkWell(
              onTap: onDismiss,
              child: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}